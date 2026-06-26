import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/order_model.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_layout.dart';
import '../widgets/order_detail_drawer.dart';
import '../providers/settings_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirebaseService _fs = FirebaseService();
  final SettingsProvider _settings = SettingsProvider();
  String _search = '';
  String? _selectedOrderId;

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
      currentIndex: 3,
      body: Row(
        children: [
          Expanded(
            flex: _selectedOrderId != null ? 55 : 100,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spaceL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppTheme.spaceL),
                  Expanded(child: _buildOrdersList()),
                ],
              ),
            ),
          ),

          if (_selectedOrderId != null) ...[
            Container(width: 1, color: AppTheme.borderColor),
            SizedBox(
              width: 420,
              child: OrderDetailDrawer(
                key: ValueKey(_selectedOrderId),
                orderId: _selectedOrderId!,
                onClose: () => setState(() => _selectedOrderId = null),
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
              Text('إدارة الطلبات', style: AppTheme.pageTitle),
              const SizedBox(height: 4),
              Text(
                'متابعة وتحديث حالات الطلبات',
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
              hintText: 'بحث برقم الطلب...',
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

  Widget _buildOrdersList() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMain),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: StreamBuilder<List<OrderModel>>(
        stream: _fs.streamOrders(),
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
                    Icons.inbox_outlined,
                    size: 48,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  Text(
                    'لا يوجد طلبات حالياً',
                    style: AppTheme.bodyText.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            );
          }

          var orders = snap.data!;
          if (_search.isNotEmpty) {
            final q = _search.toLowerCase();
            orders = orders
                .where(
                  (o) =>
                      o.id.toLowerCase().contains(q) ||
                      o.userId.toLowerCase().contains(q),
                )
                .toList();
          }

          orders.sort(
            (a, b) => (b.createdAt ?? DateTime(2000)).compareTo(
              a.createdAt ?? DateTime(2000),
            ),
          );

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
                    _headerCell('رقم الطلب', flex: 2),
                    _headerCell('العميل', flex: 2),
                    _headerCell('الحالة', flex: 2),
                    _headerCell('الإجمالي', flex: 2),
                    _headerCell('التاريخ', flex: 3),
                    _headerCell('الأصناف', flex: 1),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) =>
                      _buildOrderRow(orders[index]),
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

  Widget _buildOrderRow(OrderModel order) {
    final isSelected = _selectedOrderId == order.id;
    final sc = statusColor(order.status);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () =>
            setState(() => _selectedOrderId = isSelected ? null : order.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? sc.withValues(alpha: 0.06) : Colors.transparent,
            border: Border(
              bottom: BorderSide(color: AppTheme.borderColor, width: 0.5),
              right: isSelected
                  ? BorderSide(color: sc, width: 3)
                  : BorderSide.none,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: sc.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        statusIcon(order.status),
                        color: sc,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '#${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 2,
                child: Text(
                  order.userId.length > 10
                      ? '${order.userId.substring(0, 10)}...'
                      : order.userId,
                  style: AppTheme.bodyText.copyWith(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Expanded(
                flex: 2,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: sc.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: sc.withValues(alpha: 0.25)),
                    ),
                    child: Text(
                      statusLabelAr(order.status),
                      style: AppTheme.smallText.copyWith(
                        color: sc,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 2,
                child: Text(
                  '${order.totalAmount.toStringAsFixed(0)} EGP',
                  style: AppTheme.bodyText.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),

              Expanded(
                flex: 3,
                child: Text(
                  order.createdAt != null
                      ? '${order.createdAt!.year}-${order.createdAt!.month.toString().padLeft(2, '0')}-${order.createdAt!.day.toString().padLeft(2, '0')}  ${order.createdAt!.hour.toString().padLeft(2, '0')}:${order.createdAt!.minute.toString().padLeft(2, '0')}'
                      : '-',
                  style: AppTheme.smallText.copyWith(fontSize: 12),
                ),
              ),

              Expanded(
                flex: 1,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.bgSurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${order.items.length} صنف',
                      style: AppTheme.smallText.copyWith(fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
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
