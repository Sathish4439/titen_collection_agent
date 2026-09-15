import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:collection_agent/app/routes/app_pages.dart';
import 'package:collection_agent/app/routes/app_routes.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/theme/app_theme.dart';

import 'package:provider/provider.dart';
import 'package:collection_agent/modules/auth/viewmodel/auth_viewmodel.dart';

/// Root App Widget using GetMaterialApp and ScreenUtilInit
class NestPilotApp extends StatelessWidget {
  const NestPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthViewModel()..loadCachedCollector()),
          ],
          child: GetMaterialApp(
            title: AppStrings.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.login,
            getPages: AppPages.routes,
          ),
        );
      },
    );
  }
}
