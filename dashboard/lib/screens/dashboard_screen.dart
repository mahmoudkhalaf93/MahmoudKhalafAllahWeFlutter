import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/firebase_service.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../models/category_model.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_layout.dart';
import '../widgets/stat_card.dart';
import '../l10n/app_strings.dart';
import '../providers/settings_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseService _fs = FirebaseService();
  final SettingsProvider _settings = SettingsProvider();

  late Future<int> _usersCount;
  late Future<int> _categoriesCount;
  late Future<int> _ordersCount;
  late Future<double> _totalRevenue;

  late Future<List<OrderModel>> _recentOrders;
  late Future<List<UserModel>> _recentUsers;
  late Future<List<CategoryModel>> _categories;
  late Future<Map<String, CategoryStats>> _categoryAnalytics;

  @override
  void initState() {
    super.initState();
    _loadData();
    _settings.addListener(_onSettingsChanged);
  }

  void _loadData() {
    setState(() {
      _usersCount = _fs.getUsersCount();
      _categoriesCount = _fs.getCategoriesCount();
      _ordersCount = _fs.getOrdersCount();
      _totalRevenue = _fs.getTotalRevenue();

      _recentOrders = _fs.getOrders();
      _recentUsers = _fs.getUsers();
      _categories = _fs.getCategories();
      _categoryAnalytics = _fs.getCategoryAnalytics();
    });
  }

  void _onSettingsChanged() => setState(() {});

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentIndex: 0,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppTheme.spaceL),
            _buildStatsRow(),
            const SizedBox(height: AppTheme.spaceL),
            _buildChartsRow(),
            const SizedBox(height: AppTheme.spaceL),
            _buildBottomRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.welcomeMsg, style: AppTheme.pageTitle),
            const SizedBox(height: 4),
            Text(
              S.overviewMsg,
              style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            _loadData();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  S.welcomeMsg.contains('مرحبا')
                      ? 'جاري التحديث...'
                      : 'Refreshing...',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Refresh'),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Wrap(
      spacing: AppTheme.spaceM,
      runSpacing: AppTheme.spaceM,
      children: [
        FutureBuilder<double>(
          future: _totalRevenue,
          builder: (context, snap) => StatCard(
            title: S.totalRevenue,
            value: snap.hasData
                ? '${snap.data!.toStringAsFixed(0)} EGP'
                : '...',
            icon: Icons.attach_money_rounded,
          ),
        ),
        FutureBuilder<int>(
          future: _ordersCount,
          builder: (context, snap) => StatCard(
            title: S.totalOrders,
            value: snap.hasData ? snap.data.toString() : '...',
            icon: Icons.shopping_bag_outlined,
          ),
        ),
        FutureBuilder<int>(
          future: _usersCount,
          builder: (context, snap) => StatCard(
            title: S.totalUsers,
            value: snap.hasData ? snap.data.toString() : '...',
            icon: Icons.people_outline,
          ),
        ),
        FutureBuilder<int>(
          future: _categoriesCount,
          builder: (context, snap) => StatCard(
            title: S.availableCategories,
            value: snap.hasData ? snap.data.toString() : '...',
            icon: Icons.category_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildChartsRow() {
    return FutureBuilder<List<OrderModel>>(
      future: _recentOrders,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const SizedBox(
            height: 320,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final orders = snap.data!;
        final now = DateTime.now();
        final spots = <FlSpot>[];
        double maxY = 0;

        for (int i = 0; i < 7; i++) {
          final day = now.subtract(Duration(days: 6 - i));
          final count = orders.where((o) {
            if (o.date == null) return false;
            return o.date!.year == day.year &&
                o.date!.month == day.month &&
                o.date!.day == day.day;
          }).length;

          final c = count.toDouble();
          if (c > maxY) maxY = c;
          spots.add(FlSpot(i.toDouble(), c));
        }

        if (maxY < 5) maxY = 5;

        return Container(
          height: 320,
          padding: const EdgeInsets.all(AppTheme.spaceL),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(AppTheme.radiusMain),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.ordersActivity, style: AppTheme.sectionTitle),
                  Text(S.last7Days, style: AppTheme.smallText),
                ],
              ),
              const SizedBox(height: AppTheme.spaceL),
              Expanded(
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: maxY + 2,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: AppTheme.borderColor.withValues(alpha: 0.5),
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      ),
                    ),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) => Text(
                            value.toInt().toString(),
                            style: AppTheme.smallText,
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx >= 0 && idx < 7) {
                              final day = DateTime.now().subtract(
                                Duration(days: 6 - idx),
                              );
                              final days = [
                                'إثنين',
                                'ثلاثاء',
                                'أربعاء',
                                'خميس',
                                'جمعة',
                                'سبت',
                                'أحد',
                              ];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  days[day.weekday - 1],
                                  style: AppTheme.smallText,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: AppTheme.textPrimary,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppTheme.textPrimary.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) => AppTheme.bgSurface,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((LineBarSpot touchedSpot) {
                            return LineTooltipItem(
                              touchedSpot.y.toString(),
                              AppTheme.bodyText.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildRecentOrders()),
              const SizedBox(width: AppTheme.spaceL),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildLatestUsers(),
                    const SizedBox(height: AppTheme.spaceL),
                    _buildCategoryAnalytics(),
                  ],
                ),
              ),
            ],
          );
        }
        return Column(
          children: [
            _buildRecentOrders(),
            const SizedBox(height: AppTheme.spaceL),
            _buildLatestUsers(),
            const SizedBox(height: AppTheme.spaceL),
            _buildCategoryAnalytics(),
          ],
        );
      },
    );
  }

  Widget _buildRecentOrders() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMain),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.recentOrders, style: AppTheme.sectionTitle),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/orders'),
                child: Text(S.viewAll),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),
          FutureBuilder<List<OrderModel>>(
            future: _recentOrders,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snap.hasData || snap.data!.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spaceL),
                    child: Text(
                      S.noOrdersYet,
                      style: AppTheme.bodyText.copyWith(
                        color: AppTheme.textMuted,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }
              final orders = snap.data!.take(5).toList();
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                separatorBuilder: (context, index) =>
                    Divider(color: AppTheme.borderColor, height: 1),
                itemBuilder: (context, index) {
                  final o = orders[index];
                  Color sc = AppTheme.warning;
                  if (o.status == S.completed ||
                      o.status == 'مكتمل' ||
                      o.status == 'completed') {
                    sc = AppTheme.success;
                  }
                  if (o.status == S.delivering ||
                      o.status == 'قيد التوصيل' ||
                      o.status == 'delivering') {
                    sc = AppTheme.info;
                  }
                  if (o.status == S.cancelled ||
                      o.status == 'ملغي' ||
                      o.status == 'cancelled') {
                    sc = AppTheme.error;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spaceS,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppTheme.bgSurface,
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            size: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spaceM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.orderNum(
                                  o.id.length > 6 ? o.id.substring(0, 6) : o.id,
                                ),
                                style: AppTheme.bodyText.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                o.userId.length > 8
                                    ? o.userId.substring(0, 8)
                                    : o.userId,
                                style: AppTheme.smallText,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${o.total.toStringAsFixed(0)} EGP',
                              style: AppTheme.bodyText.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: sc.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                o.status,
                                style: AppTheme.smallText.copyWith(
                                  color: sc,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLatestUsers() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMain),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Latest Users', style: AppTheme.sectionTitle),
          const SizedBox(height: AppTheme.spaceM),
          FutureBuilder<List<UserModel>>(
            future: _recentUsers,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snap.hasData || snap.data!.isEmpty) {
                return Text(S.noUsersYet, style: AppTheme.smallText);
              }
              final users = snap.data!.take(4).toList();
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                separatorBuilder: (context, index) =>
                    Divider(color: AppTheme.borderColor, height: 1),
                itemBuilder: (context, index) {
                  final u = users[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spaceS,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppTheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: Text(
                            u.name.isNotEmpty ? u.name[0].toUpperCase() : '?',
                            style: AppTheme.smallText.copyWith(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spaceS),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                u.name,
                                style: AppTheme.bodyText.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                u.email,
                                style: AppTheme.smallText,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryAnalytics() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMain),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.categoryAnalytics, style: AppTheme.sectionTitle),
          const SizedBox(height: AppTheme.spaceM),
          FutureBuilder<List<CategoryModel>>(
            future: _categories,
            builder: (context, catSnap) {
              if (catSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!catSnap.hasData || catSnap.data!.isEmpty) {
                return Text(S.noCategoriesYet, style: AppTheme.smallText);
              }

              return FutureBuilder<Map<String, CategoryStats>>(
                future: _categoryAnalytics,
                builder: (context, statsSnap) {
                  final analytics = statsSnap.data ?? {};
                  final cats = catSnap.data!;

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cats.length > 5 ? 5 : cats.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: AppTheme.borderColor, height: 1),
                    itemBuilder: (context, index) {
                      final c = cats[index];
                      final stats = analytics[c.id];
                      final mealsCount = stats?.mealsCount ?? 0;
                      final completedOrders = stats?.completedOrders ?? 0;
                      final revenue = stats?.revenue ?? 0;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spaceS,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.label_outline,
                                  color: AppTheme.textSecondary,
                                  size: 18,
                                ),
                                const SizedBox(width: AppTheme.spaceS),
                                Expanded(
                                  child: Text(
                                    c.name,
                                    style: AppTheme.bodyText.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const SizedBox(width: 26),
                                _buildMiniStat(
                                  Icons.restaurant_menu_outlined,
                                  '${S.mealsCount}: $mealsCount',
                                ),
                                const SizedBox(width: AppTheme.spaceM),
                                _buildMiniStat(
                                  Icons.check_circle_outline,
                                  '$completedOrders',
                                ),
                                const SizedBox(width: AppTheme.spaceM),
                                _buildMiniStat(
                                  Icons.attach_money,
                                  '${revenue.toStringAsFixed(0)} EGP',
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppTheme.textMuted),
        const SizedBox(width: 4),
        Text(text, style: AppTheme.smallText.copyWith(fontSize: 11)),
      ],
    );
  }
}
