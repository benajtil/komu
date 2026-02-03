import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:komu_chatapp/controllers/auth_controller.dart';
import 'package:komu_chatapp/models/user_model.dart';
import 'package:komu_chatapp/services/firestore_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthController _authController = Get.find<AuthController>();

  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isEditing = false.obs;
  final RxString _error = ''.obs;
  final RxString appVersion = ''.obs;

  // ================= GETTERS =================

  UserModel? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  bool get isEditing => _isEditing.value;
  String get error => _error.value;
  final RxBool isEditingName = false.obs;

  // ================= LIFECYCLE =================

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadAppVersion();
  }

  @override
  void onClose() {
    displayNameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // ================= APP VERSION =================

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    appVersion.value = 'v${info.version} (${info.buildNumber})';
  }

  // ================= USER DATA =================

  void _loadUserData() {
    final uid = _authController.user?.uid;
    if (uid == null) return;

    _currentUser.bindStream(_firestoreService.getUserStream(uid));

    ever<UserModel?>(_currentUser, (user) {
      if (user != null) {
        displayNameController.text = user.displayName;
        emailController.text = user.email;
      }
    });
  }

  // ================= EDIT MODE =================

  void startEditName() {
    final user = _currentUser.value;
    if (user == null) return;

    displayNameController.text = user.displayName;
    isEditingName.value = true;
  }

  void cancelEditName() {
    final user = _currentUser.value;
    if (user != null) {
      displayNameController.text = user.displayName;
    }
    isEditingName.value = false;
  }

  // ================= UPDATE PROFILE =================

  Future<void> updateDisplayName() async {
    final user = _currentUser.value;
    if (user == null) return;

    final newName = displayNameController.text.trim();
    if (newName.isEmpty || newName == user.displayName) {
      isEditingName.value = false;
      return;
    }

    try {
      _isLoading.value = true;

      await _firestoreService.updateUser(user.copyWith(displayName: newName));

      isEditingName.value = false;
      Get.snackbar('Success', 'Name updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update name');
    } finally {
      _isLoading.value = false;
    }
  }

  // ================= PHOTO ACTION =================
  Future<void> changePhoto() async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.black87,
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
                // TODO: implement camera picker
                Get.snackbar('Info', 'Camera picker not implemented yet');
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
                // TODO: implement gallery picker
                Get.snackbar('Info', 'Gallery picker not implemented yet');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> changePassword() async {
    final email = _authController.user?.email;
    if (email == null) return;

    Get.defaultDialog(
      title: 'Change Password',
      middleText: 'We will send a password reset link to:\n\n$email',
      textConfirm: 'Send',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        try {
          await _authController.sendPasswordResetEmail(email);
          Get.back();
          Get.snackbar('Success', 'Password reset email sent');
        } catch (_) {
          Get.snackbar('Error', 'Failed to send reset email');
        }
      },
    );
  }

  // ================= AUTH ACTIONS =================

  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      await _authController.signOut();
    } catch (_) {
      Get.snackbar('Error', 'Failed to sign out');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        _isLoading.value = true;
        await _authController.deleteAccount();
      }
    } catch (_) {
      Get.snackbar('Error', 'Failed to delete account');
    } finally {
      _isLoading.value = false;
    }
  }

  // ================= UTIL =================

  String getJoinedData() {
    final user = _currentUser.value;
    if (user == null) return '';

    final date = user.createdAt;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return 'Joined: ${months[date.month - 1]} ${date.year}';
  }

  void clearError() {
    _error.value = '';
  }
}
