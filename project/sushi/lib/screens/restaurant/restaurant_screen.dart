import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/app_colors.dart';
import '../../models/restaurant_model.dart';
import '../../models/branch_model.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  RestaurantModel? _restaurant;
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRestaurantData();
    _determinePosition();
  }

  void _loadRestaurantData() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('restaurants').doc('sushir12').get();
      if (doc.exists && mounted) {
        setState(() {
          _restaurant = RestaurantModel.fromJson(doc.data()!);
          _setMarkers();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading restaurant data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _setMarkers() {
    if (_restaurant?.branches == null) return;
    for (var branch in _restaurant!.branches!) {
      if (branch.location != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(branch.name ?? ''),
            position: LatLng(branch.location!.latitude, branch.location!.longitude),
            infoWindow: InfoWindow(title: branch.name, snippet: branch.status),
          ),
        );
      }
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _markers.add(
        Marker(
          markerId: const MarkerId('my_location'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: const InfoWindow(title: 'My Location'),
        ),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Locations'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.lightOrange,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.lightOrange))
          : Column(
              children: [
                Expanded(
                  flex: 3,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(30.0444, 31.2357), // Default Cairo
                      zoom: 10,
                    ),
                    markers: _markers,
                    onMapCreated: (controller) => _mapController = controller,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _restaurant == null
                      ? const Center(child: Text('No branches found'))
                      : ListView.builder(
                          itemCount: _restaurant!.branches?.length ?? 0,
                          itemBuilder: (context, index) {
                            final branch = _restaurant!.branches![index];
                            return ListTile(
                              leading: const Icon(Icons.location_on, color: AppColors.lightOrange),
                              title: Text(branch.name ?? ''),
                              subtitle: Text(branch.status ?? ''),
                              trailing: const Icon(Icons.directions, color: AppColors.lightOrange),
                              onTap: () {
                                if (branch.location != null) {
                                  _mapController?.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                      LatLng(branch.location!.latitude, branch.location!.longitude),
                                      16,
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
