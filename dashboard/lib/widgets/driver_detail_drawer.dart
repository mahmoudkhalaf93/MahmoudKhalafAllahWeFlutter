import 'package:flutter/material.dart';
import '../models/driver_model.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_image.dart';

class DriverDetailDrawer extends StatefulWidget {
  final String driverId;
  final VoidCallback onClose;
  const DriverDetailDrawer({
    super.key,
    required this.driverId,
    required this.onClose,
  });

  @override
  State<DriverDetailDrawer> createState() => _DriverDetailDrawerState();
}

class _DriverDetailDrawerState extends State<DriverDetailDrawer> {
  final FirebaseService _fs = FirebaseService();
  bool _actionLoading = false;

  Future<void> _doAction(Future<void> Function() action) async {
    setState(() => _actionLoading = true);
    try {
      await action();
    } catch (_) {}
    if (mounted) setState(() => _actionLoading = false);
  }

  void _showImagePreview(BuildContext context, String title, String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AppImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  errorWidget: Container(
                    width: 300,
                    height: 300,
                    color: AppTheme.bgCard,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(height: 16),
                          Text('الصورة غير متاحة', style: AppTheme.bodyText),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(ctx),
                style: IconButton.styleFrom(backgroundColor: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DriverModel>(
      stream: _fs.streamDriver(widget.driverId),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final driver = snap.data!;

        return Container(
          color: AppTheme.bgCard,
          child: Column(
            children: [
              _header(driver),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _sectionDriverInfo(driver),
                    const SizedBox(height: 20),
                    _sectionStatus(driver),
                    const SizedBox(height: 20),
                    _sectionVehicle(driver),
                    const SizedBox(height: 20),
                    _sectionImages(driver, context),
                    const SizedBox(height: 24),
                    _sectionApprovalControls(driver),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(DriverModel driver) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.bgSurface,
        border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: ClipOval(
              child: driver.profileImage.isNotEmpty
                  ? AppImage(
                      imageUrl: driver.profileImage,
                      fit: BoxFit.cover,
                      errorWidget: Icon(
                        Icons.person,
                        color: AppTheme.textMuted,
                      ),
                    )
                  : Icon(Icons.person, color: AppTheme.textMuted),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.name.isNotEmpty ? driver.name : 'سائق بدون اسم',
                  style: AppTheme.cardTitle,
                ),
                const SizedBox(height: 2),
                Text(
                  'المعرف: ${driver.id}',
                  style: AppTheme.smallText.copyWith(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close_rounded, color: AppTheme.textSecondary),
            onPressed: widget.onClose,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppTheme.textSecondary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTheme.bodyText.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppTheme.borderColor),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTheme.smallText.copyWith(color: AppTheme.textMuted),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: AppTheme.bodyText.copyWith(
                fontSize: 13,
                color: valueColor ?? AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionDriverInfo(DriverModel driver) {
    return _sectionCard(
      'بيانات السائق (Driver Information)',
      Icons.person_outline,
      [
        _infoRow('الاسم (Name)', driver.name),
        _infoRow('البريد (Email)', driver.email),
        _infoRow('الهاتف (Phone)', driver.phone),
        _infoRow('الدور (Role)', driver.role),
      ],
    );
  }

  Widget _sectionStatus(DriverModel driver) {
    return _sectionCard('حالة السائق (Driver Status)', Icons.info_outline, [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'حالة الاعتماد',
            style: AppTheme.smallText.copyWith(color: AppTheme.textMuted),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (driver.isApproved ? AppTheme.success : AppTheme.error)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (driver.isApproved ? AppTheme.success : AppTheme.error)
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              driver.isApproved ? 'Approved' : 'Not Approved',
              style: AppTheme.smallText.copyWith(
                color: driver.isApproved ? AppTheme.success : AppTheme.error,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'حالة الاتصال',
            style: AppTheme.smallText.copyWith(color: AppTheme.textMuted),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  (driver.isOnline
                          ? const Color(0xFF3B82F6)
                          : AppTheme.textMuted)
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    (driver.isOnline
                            ? const Color(0xFF3B82F6)
                            : AppTheme.textMuted)
                        .withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              driver.isOnline ? 'Online' : 'Offline',
              style: AppTheme.smallText.copyWith(
                color: driver.isOnline
                    ? const Color(0xFF3B82F6)
                    : AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _sectionVehicle(DriverModel driver) {
    return _sectionCard(
      'معلومات المركبة (Vehicle Information)',
      Icons.directions_car_outlined,
      [
        if (driver.vehicleInfo != null && driver.vehicleInfo!.isNotEmpty)
          Text(
            driver.vehicleInfo!,
            style: AppTheme.bodyText.copyWith(fontSize: 13),
          )
        else
          Text(
            'No Vehicle Information Available',
            style: AppTheme.smallText.copyWith(color: AppTheme.textMuted),
          ),
      ],
    );
  }

  Widget _sectionImages(DriverModel driver, BuildContext context) {
    return _sectionCard(
      'الصور والمستندات (Driver Images)',
      Icons.photo_library_outlined,
      [
        _imageTile(context, 'الصورة الشخصية (Profile)', driver.profileImage),
        const SizedBox(height: 10),
        _imageTile(context, 'رخصة القيادة (License)', driver.licenseImage),
        const SizedBox(height: 10),
        _imageTile(context, 'البطاقة - وجه (ID Front)', driver.nationalIdFront),
        const SizedBox(height: 10),
        _imageTile(context, 'البطاقة - ظهر (ID Back)', driver.nationalIdBack),
      ],
    );
  }

  Widget _imageTile(BuildContext context, String title, String imageUrl) {
    final hasImage = imageUrl.isNotEmpty;
    return GestureDetector(
      onTap: hasImage
          ? () => _showImagePreview(context, title, imageUrl)
          : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.bgSurface,
                borderRadius: BorderRadius.circular(6),
              ),
              child: hasImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: AppImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: Icon(
                          Icons.broken_image_outlined,
                          size: 20,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.image_not_supported_outlined,
                      size: 20,
                      color: AppTheme.textMuted,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTheme.smallText.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            if (hasImage)
              Icon(Icons.visibility_outlined, size: 18, color: AppTheme.primary)
            else
              Text(
                'غير متوفر',
                style: AppTheme.smallText.copyWith(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _sectionApprovalControls(DriverModel driver) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نظام الاعتماد (Approval System)', style: AppTheme.sectionTitle),
        const SizedBox(height: 12),
        if (driver.isApproved)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.check_circle, size: 20),
              label: Text(
                'Driver Approved',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.success.withValues(alpha: 0.5),
                disabledBackgroundColor: AppTheme.success.withValues(
                  alpha: 0.1,
                ),
                disabledForegroundColor: AppTheme.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _actionLoading
                  ? null
                  : () => _doAction(() => _fs.approveDriver(widget.driverId)),
              icon: _actionLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.verified_user_outlined, size: 20),
              label: Text(
                'Approve Driver',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
      ],
    );
  }
}
