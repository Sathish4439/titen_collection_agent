import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:collection_agent/app/routes/app_routes.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/modules/room_management/viewmodel/room_management_viewmodel.dart';
import 'package:collection_agent/modules/room_management/views/widgets/block_filter_dropdown.dart';
import 'package:collection_agent/modules/room_management/views/widgets/block_header_widget.dart';
import 'package:collection_agent/modules/room_management/views/widgets/collector_drawer_widget.dart';
import 'package:collection_agent/modules/room_management/views/widgets/customer_details_bottom_sheet.dart';
import 'package:collection_agent/modules/room_management/views/widgets/kpi_card_widget.dart';
import 'package:collection_agent/modules/room_management/views/widgets/payment_bottom_sheet.dart';
import 'package:collection_agent/modules/room_management/views/widgets/room_card_widget.dart';
import 'package:collection_agent/modules/room_management/views/widgets/room_search_bar_widget.dart';
import 'package:collection_agent/shared/models/bed_model.dart';
import 'package:collection_agent/shared/models/room_model.dart';
import 'package:collection_agent/shared/models/tenant_model.dart';
import 'package:collection_agent/shared/widgets/mobile_frame_wrapper.dart';

/// Screen 2: Room & Bed Management Dashboard
/// STRICT RULES: Public StatelessWidget, NO setState(), observed with Selector
class RoomManagementScreen extends StatelessWidget {
  const RoomManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const CollectorDrawerWidget(),
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: MobileFrameWrapper(
          child: RefreshIndicator(
            color: AppColors.success,
            backgroundColor: Colors.white,
            onRefresh: () => context.read<RoomManagementViewModel>().loadData(isRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Top App Header
                Row(
                  children: [
                    InkWell(
                      onTap: () => scaffoldKey.currentState?.openDrawer(),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border, width: 1.2),
                        ),
                        child: const Icon(
                          Icons.menu_rounded,
                          size: 20,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppStrings.adminHeaderTitle,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    // History Navigation Button
                    InkWell(
                      onTap: () => Get.toNamed(AppRoutes.collectionHistory),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border, width: 1.2),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          size: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Top KPI Summary Cards Row
                Selector<RoomManagementViewModel, (int, double)>(
                  selector: (_, vm) => (vm.totalRooms, vm.todayCollected),
                  builder: (context, data, _) {
                    final totalRooms = data.$1;
                    final todayCollected = data.$2;
                    final formattedCollected = '${AppStrings.currencySymbol}${todayCollected.toStringAsFixed(0).replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        )}';

                    return Row(
                      children: [
                        Expanded(
                          child: KpiCardWidget(
                            label: AppStrings.totalRooms,
                            value: totalRooms.toString(),
                            icon: Icons.domain,
                            iconColor: AppColors.primary,
                            iconBgColor: AppColors.primaryLight,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: KpiCardWidget(
                            label: AppStrings.todayCollected,
                            value: formattedCollected,
                            icon: Icons.payments_outlined,
                            iconColor: AppColors.bedGreen,
                            iconBgColor: AppColors.bedGreenLight,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Search Bar and Block Filter Dropdown Row
                const Row(
                  children: [
                    Expanded(
                      child: RoomSearchBarWidget(),
                    ),
                    SizedBox(width: 10),
                    BlockFilterDropdown(),
                  ],
                ),
                const SizedBox(height: 12),
                // Block Header Section
                const BlockHeaderWidget(),
                const SizedBox(height: 16),
                // Room Cards List
                Selector<RoomManagementViewModel, List<RoomModel>>(
                  selector: (_, vm) => vm.rooms,
                  builder: (context, rooms, _) {
                    if (rooms.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No rooms found',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: rooms.map((room) {
                        return RoomCardWidget(
                          room: room,
                          onPayTap: (RoomModel r, BedModel b) {
                            context.read<RoomManagementViewModel>().selectBedForPayment(r, b);
                            PaymentBottomSheet.show(context);
                          },
                          onTenantTap: (TenantModel tenant) {
                            context.read<RoomManagementViewModel>().selectTenantForDetails(tenant);
                            CustomerDetailsBottomSheet.show(context, tenant);
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
