import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:collection_agent/app/routes/app_routes.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/modules/auth/viewmodel/auth_viewmodel.dart';
import 'package:collection_agent/shared/models/collector_model.dart';
import 'package:collection_agent/shared/repositories/collector_repository.dart';

/// Side Navigation Drawer for Collector Details & Session Control
class CollectorDrawerWidget extends StatefulWidget {
  const CollectorDrawerWidget({super.key});

  @override
  State<CollectorDrawerWidget> createState() => _CollectorDrawerWidgetState();
}

class _CollectorDrawerWidgetState extends State<CollectorDrawerWidget> {
  CollectorModel? _localCollector;

  @override
  void initState() {
    super.initState();
    _loadLocalProfile();
  }

  Future<void> _loadLocalProfile() async {
    final cached = await CollectorRepository.instance.getCachedCollector();
    if (mounted && cached != null) {
      setState(() {
        _localCollector = cached;
      });
    }
    try {
      if (mounted) {
        context.read<AuthViewModel>().loadCachedCollector();
      }
    } catch (_) {}
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.logout, color: Colors.red.shade600, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              'Sign Out',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to log out from TitanStay Collection Agent?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () async {
              Navigator.of(dialogCtx).pop(); // Close dialog
              Navigator.of(context).pop(); // Close drawer
              try {
                await context.read<AuthViewModel>().logout();
              } catch (_) {
                await CollectorRepository.instance.logout();
                Get.offAllNamed(AppRoutes.login);
              }
            },
            child: Text(
              'Log Out',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthViewModel? authVM;
    try {
      authVM = context.watch<AuthViewModel>();
    } catch (_) {}

    final collector = authVM?.authenticatedCollector ?? _localCollector;
    final phone = collector?.phone ?? authVM?.phoneNumber ?? '';
    final name = collector?.name ?? 'Collection Agent';
    final email = collector?.email ?? '';

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // 1. Header Profile Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A), // Dark Slate
                border: Border(
                  bottom: BorderSide(color: Color(0xFF1E293B)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo / App Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'TiTANSTAY',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: const Color(0xFF38BDF8),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified,
                                size: 12, color: AppColors.success),
                            const SizedBox(width: 4),
                            Text(
                              'Active',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Avatar & Name
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color(0xFF1E293B),
                        child: Text(
                          name.isNotEmpty
                              ? name.substring(0, 1).toUpperCase()
                              : 'A',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Collection Staff',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF94A3B8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Logged-in Phone Number Pill
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.phone_android_rounded,
                          size: 16,
                          color: Color(0xFF38BDF8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LOGGED IN PHONE NUMBER',
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                phone.isNotEmpty ? phone : 'Not available',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Body Details
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                children: [
                  if (email.isNotEmpty) ...[
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.email_outlined,
                          size: 20, color: AppColors.textSecondary),
                      title: Text(
                        'Email Address',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      subtitle: Text(
                        email,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Divider(height: 16),
                  ],

                  // ListTile(
                  //   dense: true,
                  //   contentPadding: EdgeInsets.zero,
                  //   leading: const Icon(Icons.admin_panel_settings_outlined,
                  //       size: 20, color: AppColors.textSecondary),
                  //   title: Text(
                  //     'Portal Mode',
                  //     style: GoogleFonts.inter(
                  //       fontSize: 12,
                  //       color: AppColors.textMuted,
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     'Field Rent Collection Agent',
                  //     style: GoogleFonts.inter(
                  //       fontSize: 13,
                  //       fontWeight: FontWeight.w600,
                  //       color: AppColors.textPrimary,
                  //     ),
                  //   ),
                  // ),
                  // const Divider(height: 16),

                  // ListTile(
                  //   dense: true,
                  //   contentPadding: EdgeInsets.zero,
                  //   leading: const Icon(Icons.sync_outlined,
                  //       size: 20, color: AppColors.textSecondary),
                  //   title: Text(
                  //     'Sync Status',
                  //     style: GoogleFonts.inter(
                  //       fontSize: 12,
                  //       color: AppColors.textMuted,
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     'Real-time Connected',
                  //     style: GoogleFonts.inter(
                  //       fontSize: 13,
                  //       fontWeight: FontWeight.w600,
                  //       color: AppColors.success,
                  //     ),
                  //   ),
                  // ),
                  // const Divider(height: 16),

                  // ListTile(
                  //   dense: true,
                  //   contentPadding: EdgeInsets.zero,
                  //   leading: const Icon(Icons.info_outline,
                  //       size: 20, color: AppColors.textSecondary),
                  //   title: Text(
                  //     'App Version',
                  //     style: GoogleFonts.inter(
                  //       fontSize: 12,
                  //       color: AppColors.textMuted,
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     '1.0.0 (TitanStay Collector)',
                  //     style: GoogleFonts.inter(
                  //       fontSize: 13,
                  //       fontWeight: FontWeight.w600,
                  //       color: AppColors.textPrimary,
                  //     ),
                  //   ),
                  // ),
              
              
                ],
              ),
            ),

            // 3. Footer Logout Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade600,
                    side: BorderSide(color: Colors.red.shade300, width: 1.2),
                    backgroundColor: Colors.red.shade50.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _showLogoutConfirmation(context),
                  icon: Icon(Icons.logout_rounded,
                      size: 18, color: Colors.red.shade600),
                  label: Text(
                    'Log Out',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.red.shade600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
