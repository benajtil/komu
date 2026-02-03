import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:komu_chatapp/controllers/profile_controller.dart';
import 'package:komu_chatapp/routes/app_routes.dart';
import 'package:komu_chatapp/theme/app_theme.dart';

class ProfilePages extends GetView<ProfileController> {
  const ProfilePages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor, // dark background
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primaryColor, // dark appbar
        automaticallyImplyLeading: true, // keeps back button
        actions: [
          // Top-right logout icon with confirmation
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              Get.defaultDialog(
                title: 'Logout',
                middleText: 'Are you sure you want to logout?',
                textConfirm: 'Yes',
                textCancel: 'Cancel',
                confirmTextColor: Colors.white,
                onConfirm: () {
                  controller.signOut();
                  Get.back();
                },
                onCancel: () => Get.back(),
              );
            },
          ),
        ],
      ),

      body: Obx(() {
        final user = controller.currentUser;

        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= PROFILE HEADER =================
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppTheme.accentColor,
                        child: user.photoUrl.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  user.photoUrl,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _buildDefaultAvatar(user.displayName),
                                ),
                              )
                            : _buildDefaultAvatar(user.displayName),
                      ),
                      if (controller.isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: AppTheme.accentColor,
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Get.snackbar(
                                  'Info',
                                  'Photo upload coming soon',
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  // Name + status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.getJoinedData(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[400]),
                        ),
                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: user.isOnline
                                    ? AppTheme.successColor
                                    : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              user.isOnline ? 'Online' : 'Offline',
                              style: TextStyle(
                                color: user.isOnline
                                    ? AppTheme.successColor
                                    : Colors.grey[400],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ================= PROFILE SECTION =================
              Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 8),

              Card(
                elevation: 0,
                color: AppTheme.cardColor.withOpacity(0.95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _SettingsDropdownTile(
                      icon: Icons.person_outline,
                      title: 'Manage Profile',
                      children: [
                        Obx(() {
                          return Row(
                            children: [
                              Expanded(
                                child: controller.isEditingName.value
                                    ? TextField(
                                        controller:
                                            controller.displayNameController,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your name',
                                          hintStyle: TextStyle(
                                            color: Colors.white38,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      )
                                    : Text(
                                        controller.displayNameController.text,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 8),
                              controller.isEditingName.value
                                  ? Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          ),
                                          onPressed: () =>
                                              controller.updateDisplayName(),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.redAccent,
                                          ),
                                          onPressed: () =>
                                              controller.cancelEditName(),
                                        ),
                                      ],
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      onPressed: () =>
                                          controller.startEditName(),
                                    ),
                            ],
                          );
                        }),
                        const Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Colors.white12,
                          indent: 16,
                          endIndent: 16,
                        ),

                        // Email (read-only)
                        SettingsRow(
                          label: 'Email',
                          value: controller.currentUser?.email ?? '',
                          helperText: 'Email cannot be changed',
                        ),
                        const Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Colors.white12,
                          indent: 16,
                          endIndent: 16,
                        ),

                        // Joined Date
                        SettingsRow(
                          label: 'Joined',
                          value: controller.getJoinedData(),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Colors.white12,
                          indent: 16,
                          endIndent: 16,
                        ),

                        // Change Photo
                        InkWell(
                          onTap: () =>
                              controller.changePhoto(), // opens bottom sheet
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.photo_camera_outlined,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 14),
                                const Expanded(
                                  child: Text(
                                    'Change Photo',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================= SETTINGS SECTION =================
              Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              Card(
                color: AppTheme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _navTile(
                      icon: Icons.security_outlined,
                      title: 'Change Password',
                      onTap: () => Get.toNamed(AppRoutes.changePassword),
                    ),
                    _navTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notification Settings',
                      onTap: () => Get.snackbar('Info', 'Coming soon'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================= DANGER ZONE =================
              Text(
                'Denger Zone',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              Card(
                color: Colors.red.shade900.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _navTile(
                      icon: Icons.delete_forever,
                      title: 'Delete Account',
                      onTap: controller.deleteAccount,
                      titleColor: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ================= HELPERS =================

  Widget _buildDefaultAvatar(String name) {
    return Text(
      name.isNotEmpty ? name[0].toUpperCase() : '?',
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _navTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: titleColor ?? AppTheme.accentColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor ?? Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

class _SettingsDropdownTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _SettingsDropdownTile({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  State<_SettingsDropdownTile> createState() => _SettingsDropdownTileState();
}

class _SettingsDropdownTileState extends State<_SettingsDropdownTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        onExpansionChanged: (value) {
          setState(() => isExpanded = value);
        },
        leading: Icon(widget.icon, color: AppTheme.accentColor),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // dark theme fix
          ),
        ),
        trailing: Icon(
          isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
          color: Colors.white70,
        ),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        children: widget.children,
      ),
    );
  }
}

class SettingsRow extends StatefulWidget {
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final Color? valueColor;
  final String? helperText;
  final bool editable;
  final TextEditingController? controller;

  const SettingsRow({
    super.key,
    required this.label,
    this.value,
    this.onTap,
    this.valueColor,
    this.helperText,
    this.editable = false,
    this.controller,
  });

  @override
  State<SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<SettingsRow> {
  bool isExpanded = false;

  void _handleTap() {
    setState(() {
      isExpanded = !isExpanded;
    });

    widget.onTap?.call();
  }

  Future<void> changePhoto() async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text(
                'Take Photo',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Get.back();
                // TODO: camera picker
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo, color: Colors.white),
              title: const Text(
                'Choose from Gallery',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Get.back();
                // TODO: gallery picker
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              if (widget.value != null)
                Text(
                  widget.value!,
                  style: TextStyle(
                    color: widget.valueColor ?? Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
            ],
          ),
          if (widget.helperText != null) ...[
            const SizedBox(height: 4),
            Column(
              children: [
                Text(
                  widget.helperText!,

                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 0, 0),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
