import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:komu_chatapp/controllers/profile_controller.dart';
import 'package:komu_chatapp/theme/app_theme.dart';

class ProfilePages extends GetView<ProfileController> {
  const ProfilePages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primaryColor,
        automaticallyImplyLeading: true,
        actions: [
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
              // ===== PROFILE HEADER =====
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
                              Get.snackbar('Info', 'Photo upload coming soon');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return controller.isEditingName.value
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller:
                                            controller.displayNameController,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: 'Enter name',
                                          hintStyle: TextStyle(
                                            color: Colors.white38,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.greenAccent,
                                      ),
                                      onPressed: controller.updateDisplayName,
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: controller.cancelEditName,
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Text(
                                      user.displayName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white70,
                                      ),
                                      onPressed: controller.startEditName,
                                    ),
                                  ],
                                );
                        }),
                        const SizedBox(height: 4),
                        Text(
                          controller.getJoinedData(),
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ===== SETTINGS =====
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
                      onTap: controller.changePassword,
                    ),
                    _navTile(
                      icon: Icons.photo_camera_outlined,
                      title: 'Change Photo',
                      onTap: () =>
                          Get.snackbar('Info', 'Photo upload coming soon'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== DANGER ZONE =====
              Text(
                'Danger Zone',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
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
