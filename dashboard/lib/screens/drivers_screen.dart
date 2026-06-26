import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/driver_model.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_layout.dart';
import '../widgets/driver_detail_drawer.dart';
import '../providers/settings_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_image.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({super.key});

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  final FirebaseService _fs = FirebaseService();
  final SettingsProvider _settings = SettingsProvider();
  String _search = '';
  String? _selectedDriverId;

  @override
  void initState() {
    super.initState();
    _settings.addListener(_refresh);
  }

  @override
  void dispose() {
    _settings.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentIndex: 4,
      body: Row(
        children: [
          Expanded(
            flex: _selectedDriverId != null ? 55 : 100,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spaceL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppTheme.spaceL),
                  Expanded(child: _buildDriversList()),
                ],
              ),
            ),
          ),

          if (_selectedDriverId != null) ...[
            Container(width: 1, color: AppTheme.borderColor),
            SizedBox(
              width: 420,
              child: DriverDetailDrawer(
                key: ValueKey(_selectedDriverId),
                driverId: _selectedDriverId!,
                onClose: () => setState(() => _selectedDriverId = null),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('إدارة السائقين', style: AppTheme.pageTitle),
              const SizedBox(height: 4),
              Text(
                'عرض وإدارة واعتماد حسابات السائقين',
                style: AppTheme.bodyText.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 280,
          height: 40,
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            style: AppTheme.bodyText,
            decoration: InputDecoration(
              hintText: 'بحث بالاسم أو الإيميل أو الهاتف...',
              prefixIcon: Icon(
                Icons.search,
                size: 18,
                color: AppTheme.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriversList() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMain),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: StreamBuilder<List<DriverModel>>(
        stream: _fs.streamDrivers(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delivery_dining,
                    size: 48,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  Text(
                    'لا يوجد سائقين حتى الآن',
                    style: AppTheme.bodyText.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            );
          }

          var drivers = snap.data!;
          if (_search.isNotEmpty) {
            final q = _search.toLowerCase();
            drivers = drivers
                .where(
                  (d) =>
                      d.name.toLowerCase().contains(q) ||
                      d.email.toLowerCase().contains(q) ||
                      d.phone.toLowerCase().contains(q),
                )
                .toList();
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.bgSurface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  border: Border(
                    bottom: BorderSide(color: AppTheme.borderColor),
                  ),
                ),
                child: Row(
                  children: [
                    _headerCell('السائق', flex: 3),
                    _headerCell('الهاتف', flex: 2),
                    _headerCell('حالة الاتصال', flex: 2),
                    _headerCell('الاعتماد', flex: 2),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: drivers.length,
                  itemBuilder: (context, index) =>
                      _buildDriverRow(drivers[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _headerCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: AppTheme.smallText.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.textMuted,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDriverRow(DriverModel driver) {
    final isSelected = _selectedDriverId == driver.id;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () =>
            setState(() => _selectedDriverId = isSelected ? null : driver.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary.withValues(alpha: 0.06)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(color: AppTheme.borderColor, width: 0.5),
              right: isSelected
                  ? BorderSide(color: AppTheme.primary, width: 3)
                  : BorderSide.none,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.bgSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: ClipOval(
                        child: driver.profileImage.isNotEmpty
                            ? AppImage(
                                imageUrl: driver.profileImage,
                                fit: BoxFit.cover,
                                errorWidget: Icon(
                                  Icons.person_outline,
                                  color: AppTheme.textMuted,
                                ),
                              )
                            : Icon(
                                Icons.person_outline,
                                color: AppTheme.textMuted,
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.name.isNotEmpty ? driver.name : 'بدون اسم',
                            style: AppTheme.bodyText.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            driver.email.isNotEmpty
                                ? driver.email
                                : 'لا يوجد بريد',
                            style: AppTheme.smallText.copyWith(
                              color: AppTheme.textSecondary,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 2,
                child: Text(
                  driver.phone.isNotEmpty ? driver.phone : '-',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),

              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: driver.isOnline
                            ? const Color(0xFF3B82F6)
                            : AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      driver.isOnline ? 'Online' : 'Offline',
                      style: AppTheme.smallText.copyWith(
                        color: driver.isOnline
                            ? const Color(0xFF3B82F6)
                            : AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (driver.isApproved ? AppTheme.success : AppTheme.error)
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          (driver.isApproved
                                  ? AppTheme.success
                                  : AppTheme.error)
                              .withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    driver.isApproved ? 'Approved' : 'Not Approved',
                    style: AppTheme.smallText.copyWith(
                      color: driver.isApproved
                          ? AppTheme.success
                          : AppTheme.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
