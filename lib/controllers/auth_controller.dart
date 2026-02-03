import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:komu_chatapp/models/user_model.dart';
import 'package:komu_chatapp/routes/app_routes.dart';
import 'package:komu_chatapp/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final Rx<User?> _user = Rx<User?>(null);
  final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxBool _isinitialized = false.obs;
  User? get user => _user.value;
  UserModel? get userModel => _userModel.value;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get isAuthenticated => _user.value != null;
  bool get isInitialized => _isinitialized.value;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_authService.authStateChanges);
    ever(_user, _handleAuthStateChange);
  }

  void _handleAuthStateChange(User? user) {
    if (user == null) {
      if (Get.currentRoute != AppRoutes.login) {
        Get.offAllNamed(AppRoutes.login);
      }
    } else {
      if (Get.currentRoute != AppRoutes.main) {
        Get.offAllNamed(AppRoutes.main);
      }
    }

    if (!_isinitialized.value) {
      _isinitialized.value = true;
    }
  }

  Future<void> login(String email, String password) async {
    await signInWithEmailAndPassword(email, password);
  }

  void checkInitialAuthState() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _user.value = currentUser;
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }

    _isinitialized.value = true;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      UserModel? userModel = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );

      if (userModel != null) {
        _userModel.value = userModel;
        Get.offAllNamed(AppRoutes.main);
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          _error.value = 'Account does not exist';
          break;
        case 'wrong-email-password':
          _error.value = 'Incorrect email or password';
          break;
        case 'invalid-email':
          _error.value = 'Invalid email address';
          break;
        case 'user-disabled':
          _error.value = 'This account has been disabled';
          break;
        default:
          _error.value = 'Failed to login. Please try again.';
      }

      Get.snackbar(
        'Login Failed',
        _error.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _error.value = 'Unexpected error occurred';
      Get.snackbar('Error', _error.value);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      _isLoading.value = true;
      _error.value = '';
      UserModel? userModel = await _authService.registerWithEmailAndPassword(
        email,
        password,
        displayName,
      );
      if (userModel != null) {
        _userModel.value = userModel;
        Get.offAllNamed(AppRoutes.main);
      }
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar('Error', 'Failed to Create Account: ${_error.value}');
      print(e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      await _authService.signOut();
      _userModel.value = null;
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar('Error', 'Failed to Sign Out: ${_error.value}');
      print(e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      _isLoading.value = true;
      _error.value = '';
      await _authService.sendPasswordResetEmail(email);
      Get.snackbar('Success', 'Password reset email sent to $email');
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to send password reset email: ${_error.value}',
      );
      print(e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> clearError() async {
    _error.value = '';
  }

  Future<void> deleteAccount() async {
    try {
      _isLoading.value = true;
      await _authService.deleteAccount();
      _userModel.value = null;
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar('Error', 'Failed to Delete Account: ${_error.value}');
      print(e);
    } finally {
      _isLoading.value = false;
    }
  }
}
