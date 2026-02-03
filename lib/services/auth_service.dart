import 'package:firebase_auth/firebase_auth.dart';
import 'package:komu_chatapp/models/user_model.dart';
import 'package:komu_chatapp/services/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'Authentication failed',
      );
    }
  }

  Future<UserModel?> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(displayName);
        final userModel = UserModel(
          id: user.uid,
          displayName: displayName,
          email: email,

          photoUrl: '',
          isOnline: true,
          lastActive: DateTime.now(),
          createdAt: DateTime.now(),
          friends: [],
          role: '',
          status: '',
        );
        await _firestoreService.createUser(userModel);
        return userModel;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await _firestoreService.updateUserOnlineStatus(user.uid, false);
      } catch (e) {
        print('Failed to update online status: $e');
      }
    }

    await _auth.signOut();
  }

  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestoreService.deleteUser(user.uid);
        await user.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete account: ${e.toString()}');
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await _firestoreService.updateUserDisplayName(user.uid, displayName);
      }
    } catch (e) {
      throw Exception('Failed to update display name: ${e.toString()}');
    }
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePhotoURL(photoUrl);
        await _firestoreService.updateUserPhotoUrl(user.uid, photoUrl);
      }
    } catch (e) {
      throw Exception('Failed to update photo URL: ${e.toString()}');
    }
  }
}
