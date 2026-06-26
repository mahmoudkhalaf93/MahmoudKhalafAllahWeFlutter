import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

String statusLabelAr(String status) {
  switch (status) {
    case 'pending':
      return 'قيد الانتظار';
    case 'accepted':
      return 'تم قبول الطلب';
    case 'preparing':
      return 'جاري التجهيز';
    case 'readyForPickup':
      return 'جاهز للاستلام';
    case 'driverAssigned':
      return 'تم تعيين سائق';
    case 'completed':
      return 'مكتمل';
    case 'cancelledByRestaurant':
      return 'أُلغي بواسطة المطعم';
    default:
      return status;
  }
}

Color statusColor(String status) {
  switch (status) {
    case 'pending':
      return AppTheme.warning;
    case 'accepted':
      return const Color(0xFF3B82F6);
    case 'preparing':
      return const Color(0xFFF97316);
    case 'readyForPickup':
      return const Color(0xFF8B5CF6);
    case 'driverAssigned':
      return const Color(0xFF06B6D4);
    case 'completed':
      return AppTheme.success;
    case 'cancelledByRestaurant':
      return AppTheme.error;
    default:
      return AppTheme.textMuted;
  }
}

IconData statusIcon(String status) {
  switch (status) {
    case 'pending':
      return Icons.schedule_rounded;
    case 'accepted':
      return Icons.check_circle_outline;
    case 'preparing':
      return Icons.restaurant_rounded;
    case 'readyForPickup':
      return Icons.inventory_2_outlined;
    case 'driverAssigned':
      return Icons.delivery_dining;
    case 'completed':
      return Icons.done_all_rounded;
    case 'cancelledByRestaurant':
      return Icons.cancel_outlined;
    default:
      return Icons.help_outline;
  }
}

class OrderDetailDrawer extends StatefulWidget {
  final String orderId;
  final VoidCallback onClose;
  const OrderDetailDrawer({
    super.key,
    required this.orderId,
    required this.onClose,
  });
  @override
  State<OrderDetailDrawer> createState() => _OrderDetailDrawerState();
}

class _OrderDetailDrawerState extends State<OrderDetailDrawer> {
  final FirebaseService _fs = FirebaseService();
  Map<String, dynamic>? _customer;
  Map<String, dynamic>? _driver;
  bool _loadingCustomer = true;
  bool _loadingDriver = true;
  bool _actionLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _loadRelatedData(OrderModel order) {
    if (_loadingCustomer && order.userId.isNotEmpty) {
      _fs.getUserById(order.userId).then((data) {
        if (mounted) {
          setState(() {
            _customer = data;
            _loadingCustomer = false;
          });
        }
      });
    }
    if (_loadingDriver &&
        order.driverId != null &&
        order.driverId!.isNotEmpty &&
        order.driverId != 'null') {
      _fs.getDriverById(order.driverId!).then((data) {
        if (mounted) {
          setState(() {
            _driver = data;
            _loadingDriver = false;
          });
        }
      });
    } else if (_loadingDriver) {
      _loadingDriver = false;
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _doAction(Future<void> Function() action) async {
    setState(() => _actionLoading = true);
    try {
      await action();
    } catch (_) {}
    if (mounted) setState(() => _actionLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderModel>(
      stream: _fs.streamOrder(widget.orderId),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final order = snap.data!;
        _loadRelatedData(order);

        return Container(
          color: AppTheme.bgCard,
          child: Column(
            children: [
              _header(order),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _sectionOrderInfo(order),
                    const SizedBox(height: 20),
                    _sectionCustomer(),
                    const SizedBox(height: 20),
                    _sectionDriver(order),
                    const SizedBox(height: 20),
                    _sectionDelivery(order),
                    const SizedBox(height: 20),
                    _sectionItems(order),
                    const SizedBox(height: 20),
                    _sectionPricing(order),
                    const SizedBox(height: 24),
                    _sectionStatusControls(order),
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

  Widget _header(OrderModel order) {
    final sc = statusColor(order.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.bgSurface,
        border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: sc.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(statusIcon(order.status), color: sc, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'طلب #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                  style: AppTheme.cardTitle,
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: sc.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: sc.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    statusLabelAr(order.status),
                    style: AppTheme.smallText.copyWith(
                      color: sc,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
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
              value,
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

  Widget _sectionOrderInfo(OrderModel order) {
    return _sectionCard('معلومات الطلب', Icons.receipt_long_outlined, [
      _infoRow('رقم الطلب', order.id),
      _infoRow(
        'الحالة',
        statusLabelAr(order.status),
        valueColor: statusColor(order.status),
      ),
      _infoRow('تاريخ الإنشاء', _formatDate(order.createdAt)),
      _infoRow('آخر تحديث', _formatDate(order.updatedAt)),
      if (order.payment.isNotEmpty) _infoRow('طريقة الدفع', order.payment),
    ]);
  }

  Widget _sectionCustomer() {
    if (_loadingCustomer) {
      return _sectionCard('معلومات العميل', Icons.person_outline, [
        const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ]);
    }
    if (_customer == null) {
      return _sectionCard('معلومات العميل', Icons.person_outline, [
        Text(
          'لا توجد بيانات عميل',
          style: AppTheme.smallText.copyWith(color: AppTheme.textMuted),
        ),
      ]);
    }
    final c = _customer!;
    return _sectionCard('معلومات العميل', Icons.person_outline, [
      if (c['name'] != null) _infoRow('الاسم', c['name'].toString()),
      if (c['email'] != null) _infoRow('البريد', c['email'].toString()),
      if (c['phone'] != null) _infoRow('الهاتف', c['phone'].toString()),
      if (c['address'] != null) _infoRow('العنوان', c['address'].toString()),
    ]);
  }

  Widget _sectionDriver(OrderModel order) {
    final hasDriver =
        order.driverId != null &&
        order.driverId!.isNotEmpty &&
        order.driverId != 'null';
    if (!hasDriver) {
      return _sectionCard('معلومات السائق', Icons.delivery_dining_outlined, [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.warning.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.warning.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.warning, size: 18),
              const SizedBox(width: 8),
              Text(
                'لم يتم تعيين سائق بعد',
                style: AppTheme.bodyText.copyWith(
                  color: AppTheme.warning,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ]);
    }
    if (_loadingDriver) {
      return _sectionCard('معلومات السائق', Icons.delivery_dining_outlined, [
        const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ]);
    }
    final d = _driver;
    return _sectionCard('معلومات السائق', Icons.delivery_dining_outlined, [
      _infoRow('معرف السائق', order.driverId!),
      if (d != null) ...[
        if (d['name'] != null) _infoRow('الاسم', d['name'].toString()),
        if (d['phone'] != null) _infoRow('الهاتف', d['phone'].toString()),
      ],
    ]);
  }

  Widget _sectionDelivery(OrderModel order) {
    String locStr(Map<String, dynamic>? loc) {
      if (loc == null) return 'غير متاح';
      final lat = loc['latitude'] ?? loc['lat'];
      final lng = loc['longitude'] ?? loc['lng'];
      if (lat != null && lng != null) return '$lat, $lng';
      return loc.toString();
    }

    final hasDriverLoc = order.driverLocation != null;
    return _sectionCard('معلومات التوصيل', Icons.location_on_outlined, [
      _infoRow('موقع التوصيل', locStr(order.deliveryLocation)),
      if (hasDriverLoc)
        _infoRow('موقع السائق', locStr(order.driverLocation))
      else
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'لا يوجد موقع سائق متاح',
            style: AppTheme.smallText.copyWith(color: AppTheme.textMuted),
          ),
        ),
    ]);
  }

  Widget _sectionItems(OrderModel order) {
    if (order.items.isEmpty) {
      return _sectionCard('الأصناف المطلوبة', Icons.fastfood_outlined, [
        Text(
          'لا توجد أصناف',
          style: AppTheme.smallText.copyWith(color: AppTheme.textMuted),
        ),
      ]);
    }
    return _sectionCard(
      'الأصناف المطلوبة (${order.items.length})',
      Icons.fastfood_outlined,
      order.items.map((item) => _itemTile(item)).toList(),
    );
  }

  Widget _itemTile(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.image.isNotEmpty
                ? Image.network(
                    item.image,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _placeholderImg(),
                  )
                : _placeholderImg(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.name.isNotEmpty)
                  Text(
                    item.name,
                    style: AppTheme.bodyText.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                if (item.nameAr.isNotEmpty)
                  Text(
                    item.nameAr,
                    style: AppTheme.smallText.copyWith(fontSize: 12),
                  ),
                if (item.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.description,
                      style: AppTheme.smallText.copyWith(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (item.descriptionAr.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      item.descriptionAr,
                      style: AppTheme.smallText.copyWith(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '${item.price.toStringAsFixed(1)} EGP',
                      style: AppTheme.smallText.copyWith(
                        color: AppTheme.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('  ×  ${item.quantity}', style: AppTheme.smallText),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${item.itemTotal.toStringAsFixed(1)} EGP',
                        style: AppTheme.smallText.copyWith(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
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

  Widget _placeholderImg() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.bgSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.fastfood_outlined, color: AppTheme.textMuted, size: 24),
    );
  }

  Widget _sectionPricing(OrderModel order) {
    return _sectionCard('ملخص الأسعار', Icons.payments_outlined, [
      _priceRow('المجموع الفرعي', order.subtotal),
      if (order.discount > 0)
        _priceRow('الخصم', -order.discount, isDiscount: true),
      _priceRow('رسوم التوصيل', order.deliveryFee),
      Divider(color: AppTheme.borderColor, height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'الإجمالي',
            style: AppTheme.bodyText.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            '${order.totalAmount.toStringAsFixed(1)} EGP',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.success,
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _priceRow(String label, double amount, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTheme.smallText),
          Text(
            '${isDiscount ? "-" : ""}${amount.abs().toStringAsFixed(1)} EGP',
            style: AppTheme.bodyText.copyWith(
              fontSize: 13,
              color: isDiscount ? AppTheme.error : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionStatusControls(OrderModel order) {
    final sc = statusColor(order.status);
    final nextInfo = _getNextAction(order.status);
    final canCancel = order.status == 'pending' || order.status == 'accepted';

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: sc.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: sc.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(statusIcon(order.status), color: sc, size: 20),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    'الحالة الحالية',
                    style: AppTheme.smallText.copyWith(
                      fontSize: 11,
                      color: sc.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    statusLabelAr(order.status),
                    style: AppTheme.bodyText.copyWith(
                      color: sc,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        if (nextInfo != null)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _actionLoading
                  ? null
                  : () => _doAction(
                      nextInfo['action'] as Future<void> Function(),
                    ),
              icon: _actionLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(nextInfo['icon'] as IconData, size: 20),
              label: Text(
                nextInfo['label'] as String,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: nextInfo['color'] as Color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          )
        else if (order.status == 'readyForPickup')
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.bgSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.hourglass_top_rounded,
                  color: AppTheme.textMuted,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  'في انتظار تعيين سائق من التطبيق',
                  style: AppTheme.smallText.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        if (canCancel) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              onPressed: _actionLoading ? null : () => _confirmCancel(order),
              icon: const Icon(Icons.cancel_outlined, size: 18),
              label: Text(
                'إلغاء الطلب',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.error,
                side: BorderSide(color: AppTheme.error.withValues(alpha: 0.4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Map<String, dynamic>? _getNextAction(String status) {
    switch (status) {
      case 'pending':
        return {
          'label': 'قبول الطلب',
          'icon': Icons.check_circle_outline,
          'color': const Color(0xFF3B82F6),
          'action': () => _fs.acceptOrder(widget.orderId),
        };
      case 'accepted':
        return {
          'label': 'بدء التجهيز',
          'icon': Icons.restaurant_rounded,
          'color': const Color(0xFFF97316),
          'action': () => _fs.startPreparing(widget.orderId),
        };
      case 'preparing':
        return {
          'label': 'جاهز للاستلام',
          'icon': Icons.inventory_2_outlined,
          'color': const Color(0xFF8B5CF6),
          'action': () => _fs.markReadyForPickup(widget.orderId),
        };
      default:
        return null;
    }
  }

  void _confirmCancel(OrderModel order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppTheme.borderColor),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.error),
            const SizedBox(width: 8),
            Text(
              'تأكيد الإلغاء',
              style: AppTheme.sectionTitle.copyWith(
                color: AppTheme.error,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'هل أنت متأكد من إلغاء الطلب #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}؟',
          style: AppTheme.bodyText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'تراجع',
              style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _doAction(() => _fs.cancelOrderByRestaurant(widget.orderId));
            },
            child: Text(
              'إلغاء الطلب',
              style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
