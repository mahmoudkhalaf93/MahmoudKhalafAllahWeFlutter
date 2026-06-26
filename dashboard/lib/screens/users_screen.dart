import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_layout.dart';
import '../l10n/app_strings.dart';
import '../providers/settings_provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final FirebaseService _fs = FirebaseService();
  final SettingsProvider _settings = SettingsProvider();
  String _search = '';
  UserModel? _selectedUser;

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
      currentIndex: 2,
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppTheme.spaceL),
            _buildGlobalStats(),
            const SizedBox(height: AppTheme.spaceL),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildDataTable()),
                  if (_selectedUser != null) ...[
                    const SizedBox(width: AppTheme.spaceL),
                    SizedBox(
                      width: 380,
                      child: _buildUserStatsPanel(_selectedUser!),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Wrap(
      spacing: AppTheme.spaceM,
      runSpacing: AppTheme.spaceM,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.manageUsers, style: AppTheme.pageTitle),
            const SizedBox(height: 4),
            Text(
              S.manageUsersSub,
              style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
        SizedBox(
          width: 300,
          height: 40,
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            style: AppTheme.bodyText,
            decoration: InputDecoration(
              hintText: S.searchUsers,
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

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMain),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: StreamBuilder<List<UserModel>>(
        stream: _fs.streamUsers(),
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
                    Icons.people_outline,
                    size: 48,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  Text(
                    S.noUsersYet,
                    style: AppTheme.bodyText.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            );
          }

          var users = snap.data!;
          if (_search.isNotEmpty) {
            final q = _search.toLowerCase();
            users = users
                .where(
                  (u) =>
                      u.name.toLowerCase().contains(q) ||
                      u.email.toLowerCase().contains(q),
                )
                .toList();
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                headingTextStyle: AppTheme.smallText.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                dataTextStyle: AppTheme.bodyText,
                dividerThickness: 1,
                columnSpacing: 32,
                headingRowHeight: 48,
                dataRowMinHeight: 56,
                dataRowMaxHeight: 56,
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: AppTheme.borderColor,
                    width: 1,
                  ),
                ),
                columns: const [
                  DataColumn(label: Expanded(child: Text('المستخدم'))),
                  DataColumn(label: Text('تاريخ الانضمام')),
                  DataColumn(label: Text('رقم الهاتف')),
                  DataColumn(label: Text('الإجراءات')),
                ],
                rows: users.map((u) => _buildDataRow(u)).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  DataRow _buildDataRow(UserModel u) {
    return DataRow(
      onSelectChanged: (selected) => setState(() => _selectedUser = u),
      selected: _selectedUser?.id == u.id,
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                child: Text(
                  u.name.isNotEmpty ? u.name[0].toUpperCase() : '?',
                  style: AppTheme.smallText.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spaceS),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    u.name,
                    style: AppTheme.bodyText.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(u.email, style: AppTheme.smallText),
                ],
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            u.createdAt != null
                ? DateFormat('dd MMM yyyy').format(u.createdAt!)
                : '-',
            style: AppTheme.bodyText,
          ),
        ),
        DataCell(
          Text(u.phone.isNotEmpty ? u.phone : '-', style: AppTheme.bodyText),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.bar_chart_rounded, size: 16),
                label: Text(
                  'الإحصائيات',
                  style: AppTheme.smallText.copyWith(color: AppTheme.info),
                ),
                style: TextButton.styleFrom(foregroundColor: AppTheme.info),
                onPressed: () => setState(() => _selectedUser = u),
              ),
              const SizedBox(width: AppTheme.spaceS),
              TextButton.icon(
                icon: const Icon(Icons.delete_outline, size: 16),
                label: Text(
                  'الحذف',
                  style: AppTheme.smallText.copyWith(color: AppTheme.error),
                ),
                style: TextButton.styleFrom(foregroundColor: AppTheme.error),
                onPressed: () => _confirmDelete(u),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlobalStats() {
    return FutureBuilder<UserStats>(
      future: _fs.getGlobalOrderStats(),
      builder: (context, snap) {
        final stats = snap.data ?? UserStats();
        return Row(
          children: [
            Expanded(
              child: _globalStatCard(
                icon: Icons.check_circle_outline,
                label: 'الطلبات المكتملة',
                value: '${stats.completedOrders}',
                color: AppTheme.success,
              ),
            ),
            const SizedBox(width: AppTheme.spaceL),
            Expanded(
              child: _globalStatCard(
                icon: Icons.shopping_bag_outlined,
                label: 'إجمالي الطلبات',
                value: '${stats.totalOrders}',
                color: AppTheme.info,
              ),
            ),
            const SizedBox(width: AppTheme.spaceL),
            Expanded(
              child: _globalStatCard(
                icon: Icons.payments_outlined,
                label: 'إجمالي المصروفات',
                value: 'EGP ${stats.totalSpent.toStringAsFixed(0)}',
                color: AppTheme.warning,
              ),
            ),
            const SizedBox(width: AppTheme.spaceL),
            Expanded(
              child: _globalStatCard(
                icon: Icons.cancel_outlined,
                label: 'الطلبات الملغية',
                value: '${stats.cancelledOrders}',
                color: AppTheme.error,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _globalStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppTheme.radiusMain),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.2),
              child: Icon(icon, color: color, size: 24),
            ),
          ),
          const SizedBox(height: AppTheme.spaceM),
          Text(
            value,
            style: AppTheme.pageTitle.copyWith(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatsPanel(UserModel u) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMain),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: FutureBuilder<UserStats>(
        future: _fs.getUserStats(u.id),
        builder: (context, snap) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.accent.withValues(alpha: 0.15),
                      child: Text(
                        u.name.isNotEmpty ? u.name[0].toUpperCase() : '?',
                        style: AppTheme.sectionTitle.copyWith(
                          color: AppTheme.accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u.name, style: AppTheme.sectionTitle),
                          const SizedBox(height: 2),
                          Text(u.email, style: AppTheme.smallText),
                          if (u.phone.isNotEmpty && u.phone != 'غير متوفر')
                            Text(u.phone, style: AppTheme.smallText),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: AppTheme.textMuted,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _selectedUser = null),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceL),
                Divider(color: AppTheme.borderColor, height: 1),
                const SizedBox(height: AppTheme.spaceL),

                if (snap.connectionState == ConnectionState.waiting)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spaceXL,
                    ),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: AppTheme.spaceM),
                        Text(S.loadingStats, style: AppTheme.smallText),
                      ],
                    ),
                  )
                else ...[
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          icon: Icons.shopping_bag_outlined,
                          label: S.totalOrdersUser,
                          value: '${snap.data?.totalOrders ?? 0}',
                          color: AppTheme.info,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceM),
                      Expanded(
                        child: _statCard(
                          icon: Icons.check_circle_outline,
                          label: S.completedOrdersUser,
                          value: '${snap.data?.completedOrders ?? 0}',
                          color: AppTheme.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          icon: Icons.cancel_outlined,
                          label: S.cancelledOrdersUser,
                          value: '${snap.data?.cancelledOrders ?? 0}',
                          color: AppTheme.error,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceM),
                      Expanded(
                        child: _statCard(
                          icon: Icons.payments_outlined,
                          label: S.totalSpent,
                          value:
                              '${snap.data?.totalSpent.toStringAsFixed(0) ?? '0'} EGP',
                          color: AppTheme.warning,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: AppTheme.spaceL),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => setState(() => _selectedUser = null),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spaceS,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusSmall,
                        ),
                        side: BorderSide(color: AppTheme.borderColor),
                      ),
                    ),
                    child: Text(
                      S.close,
                      style: AppTheme.bodyText.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: AppTheme.spaceS),
          Text(
            value,
            style: AppTheme.sectionTitle.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTheme.smallText.copyWith(fontSize: 11)),
        ],
      ),
    );
  }

  void _confirmDelete(UserModel u) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          S.confirmDelete,
          style: AppTheme.sectionTitle.copyWith(color: AppTheme.error),
        ),
        content: Text(S.deleteUserMsg(u.name), style: AppTheme.bodyText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              S.cancel,
              style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () async {
              final ok = await _fs.deleteUser(u.id);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(content: Text(ok ? S.successDelete : S.errorOccurred)),
              );
            },
            child: Text(S.delete),
          ),
        ],
      ),
    );
  }
}
