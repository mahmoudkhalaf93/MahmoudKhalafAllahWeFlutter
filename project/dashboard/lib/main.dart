import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'providers/settings_provider.dart';
import 'l10n/app_strings.dart';
import 'screens/dashboard_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/users_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/drivers_screen.dart';
import 'screens/restaurants_screen.dart';
import 'screens/offers_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SettingsProvider _settings = SettingsProvider();

  @override
  void initState() {
    super.initState();
    _settings.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {
      AppTheme.setDark(_settings.isDark);
      S.setArabic(_settings.isArabic);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _settings.isDark ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) {
        return Directionality(
          textDirection: _settings.textDirection,
          child: child!,
        );
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/categories': (context) => const CategoriesScreen(),
        '/users': (context) => const UsersScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/drivers': (context) => const DriversScreen(),
        '/restaurants': (context) => const RestaurantsScreen(),
        '/offers': (context) => const OffersScreen(),
      },
    );
  }
}
