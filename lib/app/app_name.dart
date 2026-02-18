import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'injection_container.dart';
import '../core/router/app_router.dart';
import '../core/services/notifications/notification_service.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider from GetIt
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => getIt<AuthProvider>(),
        ),
      ],
      child: MaterialApp.router(
        // Device Preview Settings
        builder: kDebugMode ? DevicePreview.appBuilder : null,
        locale: kDebugMode ? DevicePreview.locale(context) : null,
        useInheritedMediaQuery: kDebugMode,
        scaffoldMessengerKey: getIt<NotificationService>().messengerKey,

        // App Configuration
        title: 'Facebook Auth',
        debugShowCheckedModeBanner: false,

        // Theme
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // Routing
        routerConfig: AppRouter.router,
      ),
    );
  }
}

