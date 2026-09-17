import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/modules/room_management/viewmodel/room_management_viewmodel.dart';

/// Search text field placed to the left of BlockFilterDropdown
/// Searches live tenants and rooms by name, email, and phone number with 300ms debounce
class RoomSearchBarWidget extends StatefulWidget {
  const RoomSearchBarWidget({super.key});

  @override
  State<RoomSearchBarWidget> createState() => _RoomSearchBarWidgetState();
}

class _RoomSearchBarWidgetState extends State<RoomSearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String val) {
    setState(() {}); // Updates visibility of clear button
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<RoomManagementViewModel>().setSearchQuery(val);
      }
    });
  }

  void _onClear() {
    _controller.clear();
    _debounceTimer?.cancel();
    setState(() {});
    context.read<RoomManagementViewModel>().setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_rounded,
            size: 18,
            color: AppColors.textMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                hintText: AppStrings.searchRoomsTenantsHint,
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 12.5,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: _onClear,
              child: const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
