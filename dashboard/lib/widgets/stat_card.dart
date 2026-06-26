import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final String? trend;
  final bool isTrendUp;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.trend,
    this.isTrendUp = true,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 220,
        padding: const EdgeInsets.all(AppTheme.spaceM),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMain),
          border: Border.all(
            color: _isHovered ? AppTheme.accent : AppTheme.borderColor,
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: AppTheme.smallText.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(
                    widget.icon,
                    color: AppTheme.textSecondary,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceM),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    widget.value,
                    style: AppTheme.pageTitle.copyWith(
                      fontSize: 24,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                if (widget.trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color:
                          (widget.isTrendUp ? AppTheme.success : AppTheme.error)
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.isTrendUp
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 10,
                          color: widget.isTrendUp
                              ? AppTheme.success
                              : AppTheme.error,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          widget.trend!,
                          style: AppTheme.smallText.copyWith(
                            fontSize: 10,
                            color: widget.isTrendUp
                                ? AppTheme.success
                                : AppTheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
