import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:collection_agent/app/routes/app_routes.dart';
import 'package:collection_agent/modules/auth/viewmodel/auth_viewmodel.dart';
import 'package:collection_agent/modules/auth/views/login_screen.dart';
import 'package:collection_agent/modules/collection_history/viewmodel/collection_history_viewmodel.dart';
import 'package:collection_agent/modules/collection_history/views/collection_history_screen.dart';
import 'package:collection_agent/modules/room_management/viewmodel/room_management_viewmodel.dart';
import 'package:collection_agent/modules/room_management/views/room_management_screen.dart';

/// GetPage Route Bindings with Provider ViewModels
class AppPages {
  AppPages._();

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => ChangeNotifierProvider(
        create: (_) => AuthViewModel(),
        child: const LoginScreen(),
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.roomManagement,
      page: () => ChangeNotifierProvider(
        create: (_) => RoomManagementViewModel(),
        child: const RoomManagementScreen(),
      ),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.collectionHistory,
      page: () => ChangeNotifierProvider(
        create: (_) => CollectionHistoryViewModel(),
        child: const CollectionHistoryScreen(),
      ),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
