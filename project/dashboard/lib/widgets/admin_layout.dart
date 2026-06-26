import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_strings.dart';

class AdminLayout extends StatefulWidget {
  final int currentIndex;
  final Widget body;

  const AdminLayout({
    super.key,
    required this.currentIndex,
    required this.body,
  });

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _hoveredIndex = -1;
  final SettingsProvider _settings = SettingsProvider();

  List<_NavItem> get _navItems => [
    _NavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
      label: S.home,
    ),
    _NavItem(
      icon: Icons.category_outlined,
      activeIcon: Icons.category_rounded,
      label: S.categories,
    ),
    _NavItem(
      icon: Icons.people_outline,
      activeIcon: Icons.people_rounded,
      label: S.users,
    ),
    _NavItem(
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag_rounded,
      label: S.orders,
    ),
    _NavItem(
      icon: Icons.delivery_dining_outlined,
      activeIcon: Icons.delivery_dining,
      label: S.drivers,
    ),
    _NavItem(
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront,
      label: S.restaurants,
    ),
    _NavItem(
      icon: Icons.local_offer_outlined,
      activeIcon: Icons.local_offer,
      label: S.offers,
    ),
  ];

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

  void _navigateTo(int index) {
    if (index == widget.currentIndex) return;
    String route;
    switch (index) {
      case 0:
        route = '/';
        break;
      case 1:
        route = '/categories';
        break;
      case 2:
        route = '/users';
        break;
      case 3:
        route = '/orders';
        break;
      case 4:
        route = '/drivers';
        break;
      case 5:
        route = '/restaurants';
        break;
      case 6:
        route = '/offers';
        break;
      default:
        return;
    }
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCollapsed = screenWidth < 900;
    final isMobile = screenWidth < 600;

    if (isMobile) return _buildMobileLayout();
    return _buildDesktopLayout(isCollapsed);
  }

  Widget _buildDesktopLayout(bool isCollapsed) {
    final sidebarWidth = isCollapsed ? 70.0 : 240.0;
    final isRtl = _settings.isArabic;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: sidebarWidth,
            decoration: BoxDecoration(
              color: AppTheme.bgSidebar,
              border: Border(
                left: isRtl
                    ? BorderSide(color: AppTheme.borderColor, width: 1)
                    : BorderSide.none,
                right: isRtl
                    ? BorderSide.none
                    : BorderSide(color: AppTheme.borderColor, width: 1),
              ),
            ),
            child: Column(
              children: [
                _buildSidebarHeader(isCollapsed),
                Divider(color: AppTheme.borderColor, height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spaceM,
                    ),
                    itemCount: _navItems.length,
                    itemBuilder: (context, index) =>
                        _buildNavItem(index, isCollapsed),
                  ),
                ),
                Divider(color: AppTheme.borderColor, height: 1),
                _buildSettingsSection(isCollapsed),
                Divider(color: AppTheme.borderColor, height: 1),
                _buildSidebarFooter(isCollapsed),
              ],
            ),
          ),
          Expanded(child: widget.body),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgCard,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hexagon_outlined, color: AppTheme.primary, size: 24),
            const SizedBox(width: AppTheme.spaceS),
            Text(S.appTitle, style: AppTheme.sectionTitle),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: AppTheme.bgSidebar,
        child: Column(
          children: [
            _buildSidebarHeader(false),
            Divider(color: AppTheme.borderColor, height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceM),
                itemCount: _navItems.length,
                itemBuilder: (context, index) => _buildNavItem(index, false),
              ),
            ),
            Divider(color: AppTheme.borderColor, height: 1),
            _buildSettingsSection(false),
          ],
        ),
      ),
      body: widget.body,
    );
  }

  Widget _buildSidebarHeader(bool isCollapsed) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 12 : 20,
        vertical: 20,
      ),
      child: Row(
        mainAxisAlignment: isCollapsed
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Icon(Icons.hexagon_rounded, color: AppTheme.textPrimary, size: 28),
          if (!isCollapsed) ...[
            const SizedBox(width: AppTheme.spaceM),
            Expanded(
              child: Text(
                S.appTitle,
                style: AppTheme.cardTitle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, bool isCollapsed) {
    final item = _navItems[index];
    final isSelected = widget.currentIndex == index;
    final isHovered = _hoveredIndex == index;
    final isRtl = _settings.isArabic;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _navigateTo(index),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 0 : 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isHovered && !isSelected
                ? AppTheme.bgHover
                : Colors.transparent,
            border: Border(
              right: (!isRtl && isSelected)
                  ? BorderSide(color: AppTheme.textPrimary, width: 3)
                  : BorderSide.none,
              left: (isRtl && isSelected)
                  ? BorderSide(color: AppTheme.textPrimary, width: 3)
                  : BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(
                isSelected ? item.activeIcon : item.icon,
                color: isSelected
                    ? AppTheme.textPrimary
                    : (isHovered
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary),
                size: 20,
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: AppTheme.spaceM),
                Text(
                  item.label,
                  style: AppTheme.bodyText.copyWith(
                    color: isSelected
                        ? AppTheme.textPrimary
                        : (isHovered
                              ? AppTheme.textPrimary
                              : AppTheme.textSecondary),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(bool isCollapsed) {
    if (isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceM),
        child: Column(
          children: [
            IconButton(
              onPressed: () => _settings.toggleTheme(),
              icon: Icon(
                _settings.isDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                size: 18,
              ),
              color: AppTheme.textSecondary,
              splashRadius: 20,
            ),
            IconButton(
              onPressed: () => _settings.toggleLanguage(),
              icon: const Icon(Icons.translate, size: 18),
              color: AppTheme.textSecondary,
              splashRadius: 20,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: AppTheme.spaceM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.darkMode, style: AppTheme.smallText),
              SizedBox(
                height: 24,
                child: Switch(
                  value: _settings.isDark,
                  onChanged: (_) => _settings.toggleTheme(),
                  activeTrackColor: AppTheme.textPrimary.withValues(alpha: 0.2),
                  activeThumbColor: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.language, style: AppTheme.smallText),
              InkWell(
                onTap: () => _settings.toggleLanguage(),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    _settings.isArabic ? 'EN' : 'AR',
                    style: AppTheme.smallText.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarFooter(bool isCollapsed) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 12 : 20,
        vertical: 20,
      ),
      child: Row(
        mainAxisAlignment: isCollapsed
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.borderColor,
            child: Icon(
              Icons.person_outline,
              color: AppTheme.textPrimary,
              size: 16,
            ),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: AppTheme.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.admin,
                    style: AppTheme.bodyText.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    S.adminEmail,
                    style: AppTheme.smallText,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
