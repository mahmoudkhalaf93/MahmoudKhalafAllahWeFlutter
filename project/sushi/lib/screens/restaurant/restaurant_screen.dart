import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/app_colors.dart';
import '../../models/restaurant_model.dart';
import '../../models/branch_model.dart';

class RestaurantScreen extends StatefulWidget {
  final bool isShell;
  const RestaurantScreen({super.key, this.isShell = false});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  GoogleMapController? _mapController;
  RestaurantModel? _restaurant;
  Position? _userPosition;
  BranchModel? _selectedBranch;
  BitmapDescriptor? _customMarkerIcon;
  
  String? _fetchedAddressEn;
  String? _fetchedAddressAr;
  bool _isFetchingAddress = false;
  
  bool _isListVisible = false;
  bool _isLoading = true;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    _loadData();
  }

  Future<void> _loadCustomMarker() async {
    _customMarkerIcon = await _getBitmapDescriptorFromAsset('assets/images/layer_2orange.png', 60);
    if (mounted) setState(() {});
  }

  Future<BitmapDescriptor> _getBitmapDescriptorFromAsset(String assetPath, int width) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? bytes = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  void _loadData() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      _userPosition = await Geolocator.getCurrentPosition().timeout(const Duration(seconds: 5), onTimeout: () => Position(longitude: 31.2357, latitude: 30.0444, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0));

      final doc = await FirebaseFirestore.instance.collection('restaurants').doc('sushir12').get();
      if (doc.exists && mounted) {
        setState(() {
          _restaurant = RestaurantModel.fromJson(doc.data()!);
          _setMarkers();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _setMarkers() {
    if (_restaurant?.branches == null) return;
    _markers.clear();
    for (var branch in _restaurant!.branches!) {
      if (branch.location != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(branch.name ?? ''),
            position: LatLng(branch.location!.latitude, branch.location!.longitude),
            icon: _customMarkerIcon ?? BitmapDescriptor.defaultMarker,
            onTap: () => _onBranchSelected(branch),
          ),
        );
      }
    }
  }

  String _formatPlacemark(Placemark p) {
    final parts = [
      p.name, p.street, p.subLocality, p.locality, p.administrativeArea
    ].where((part) => part != null && part.isNotEmpty && part != 'unnamed road').toSet().toList();
    return parts.join(', ');
  }

  Future<void> _onBranchSelected(BranchModel branch) async {
    setState(() {
      _selectedBranch = branch;
      _fetchedAddressEn = null;
      _fetchedAddressAr = null;
      _isFetchingAddress = true;
    });

    try {
      if (branch.location != null) {
        await setLocaleIdentifier("en_US");
        List<Placemark> placemarksEn = await placemarkFromCoordinates(
          branch.location!.latitude, branch.location!.longitude,
        );
        
        await setLocaleIdentifier("ar_EG");
        List<Placemark> placemarksAr = await placemarkFromCoordinates(
          branch.location!.latitude, branch.location!.longitude,
        );

        if (mounted) {
          setState(() {
            if (placemarksEn.isNotEmpty) _fetchedAddressEn = _formatPlacemark(placemarksEn[0]);
            if (placemarksAr.isNotEmpty) _fetchedAddressAr = _formatPlacemark(placemarksAr[0]);
            _isFetchingAddress = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isFetchingAddress = false);
    }
  }

  void _makeCall(String? mobile) async {
    if (mobile == null || mobile.isEmpty) return;
    final Uri url = Uri.parse('tel:$mobile');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_customMarkerIcon != null && _markers.isNotEmpty && _markers.first.icon == BitmapDescriptor.defaultMarker) {
      _setMarkers();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.lightOrange))
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(target: LatLng(30.0444, 31.2357), zoom: 11),
                  markers: _markers,
                  onMapCreated: (c) => _mapController = c,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),

                Positioned(
                  top: 25,
                  right: 15,
                  child: GestureDetector(
                    onTap: () => setState(() => _isListVisible = !_isListVisible),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                      child: const Icon(Icons.menu, color: AppColors.lightOrange),
                    ),
                  ),
                ),

                if (_isListVisible)
                  Positioned(
                    top: 80,
                    left: 15,
                    right: 15,
                    bottom: _selectedBranch != null ? 240 : 80,
                    child: Card(
                      color: Colors.white.withOpacity(0.95),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _restaurant?.branches?.length ?? 0,
                        itemBuilder: (context, index) => _buildLocationItem(_restaurant!.branches![index]),
                      ),
                    ),
                  ),

                if (_selectedBranch != null)
                  Positioned(
                    bottom: 85,
                    left: 20,
                    right: 20,
                    child: _buildAddressCard(),
                  ),

                if (_selectedBranch != null)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: _launchNavigation,
                        icon: const Icon(Icons.directions, color: Colors.white),
                        label: const Text('GET DIRECTION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightOrange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildLocationItem(BranchModel branch) {
    double distance = 0;
    if (_userPosition != null && branch.location != null) {
      distance = Geolocator.distanceBetween(
        _userPosition!.latitude, _userPosition!.longitude,
        branch.location!.latitude, branch.location!.longitude,
      ) / 1000;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Container(
          width: 45, height: 45,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey.shade100),
          child: const Icon(Icons.store, color: AppColors.lightOrange),
        ),
        title: Row(
          children: [
            Text(branch.name ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF676073))),
            const SizedBox(width: 5),
            const Text('-', style: TextStyle(color: Colors.grey)),
            const SizedBox(width: 5),
            Text(branch.status ?? 'Open', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
        subtitle: Text('Away by ${distance.toStringAsFixed(2)} km from you', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: IconButton(
          icon: const Icon(Icons.phone, color: AppColors.lightOrange),
          onPressed: () => _makeCall(branch.mobile),
        ),
        onTap: () {
          _mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(branch.location!.latitude, branch.location!.longitude), 15));
          _onBranchSelected(branch);
          setState(() => _isListVisible = false);
        },
      ),
    );
  }

  Widget _buildAddressCard() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: AppColors.lightOrange,
            alignment: Alignment.center,
            child: Text(_selectedBranch?.name?.toUpperCase() ?? 'ADDRESS', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: _isFetchingAddress 
              ? const CircularProgressIndicator(color: AppColors.lightOrange)
              : Column(
                  children: [
                    Text(_fetchedAddressEn ?? 'Address loading...', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontFamily: 'calibri')),
                    const Divider(height: 20),
                    Text(_fetchedAddressAr ?? 'جاري تحميل العنوان...', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontFamily: 'calibri')),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone, color: AppColors.lightOrange, size: 20),
                        const SizedBox(width: 10),
                        Text(_selectedBranch?.mobile ?? 'No mobile available', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.lightOrange)),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.call, color: Colors.green),
                          onPressed: () => _makeCall(_selectedBranch?.mobile),
                        ),
                      ],
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  void _launchNavigation() async {
    if (_selectedBranch?.location == null) return;
    final lat = _selectedBranch!.location!.latitude;
    final lng = _selectedBranch!.location!.longitude;
    final url = Uri.parse('google.navigation:q=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      final webUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
      await launchUrl(webUrl);
    }
  }
}
