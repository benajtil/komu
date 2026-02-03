import 'package:get/get.dart';
import 'package:komu_chatapp/controllers/profile_controller.dart';
import 'package:komu_chatapp/routes/app_routes.dart';
import 'package:komu_chatapp/controllers/fogot_password_controller.dart';
import 'package:komu_chatapp/views/auth/forgot_password_pages.dart';
import 'package:komu_chatapp/views/auth/profile/change_password_page.dart';
import 'package:komu_chatapp/views/auth/profile/profile_pages.dart';
import 'package:komu_chatapp/views/auth/register_pages.dart';
import 'package:komu_chatapp/views/auth/splash_pages.dart';
import 'package:komu_chatapp/views/auth/login_pages.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = <GetPage>[
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),

    GetPage(name: AppRoutes.login, page: () => const LoginPages()),
    GetPage(name: AppRoutes.register, page: () => const RegisterPages()),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordPage(),
    ),

    //     Get.put(LoginController());
    //   }),),
    // GetPage(name: AppRoutes.register, page: () => const registerPage(), binding: BindingsBuilder(() {
    //     Get.put(RegisterController());
    //   }), ),
    // GetPage(
    //   name: AppRoutes.otpVerification,
    //   page: () => const OtpVerificationPage(),
    // binding: BindingsBuilder(() {
    //     Get.put(OtpVerificationController());
    //   }),
    //       ),
    // GetPage(
    //   name: AppRoutes.resetPassword,
    //   page: () => const ResetPasswordPage(),
    // binding: BindingsBuilder(() {
    //     Get.put(ResetPasswordController());
    //   }),
    //       ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
    ),

    //       ),
    // GetPage(
    //   name: AppRoutes.chat,
    //   page: () => const ChatPage(),
    //   binding: BindingsBuilder(() {
    //     Get.put(ChatController());
    //   }),
    // ),
    // GetPage(name: AppRoutes.calls, page: () => const CallsPage() binding: BindingsBuilder(() {
    //     Get.put(CallsController());
    //   }),
    //   ),
    // GetPage(
    //   name: AppRoutes.friendRequests,
    //   page: () => const FriendRequestsPage(),
    //   binding: BindingsBuilder(() {
    //     Get.put(FriendRequestsController());
    //   }),
    // ),
    // GetPage(name: AppRoutes.friendListPage, page: () => const FriendListPage()
    // binding: BindingsBuilder(() {
    //     Get.put(FriendListController());
    //   }),
    // ),
    // GetPage(
    //   name: AppRoutes.home,
    //   page: () => const HomePage(),
    //   binding: BindingsBuilder(() {
    //     Get.put(HomeController());
    //   }),
    // ),

    // GetPage(
    //   name: AppRoutes.notifications,
    //   page: () => const NotificationPage(),
    //   binding: BindingsBuilder(() {
    //     Get.put(NotificationController());
    //   }),
    // ),
    // GetPage(
    //   name: AppRoutes.changePassword,
    //   page: () => const ChangePasswordPage(),
    // ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePages(),
      binding: BindingsBuilder(() {
        Get.put(ProfileController());
      }),
    ),
    //     Get.put(ProfileSetupController());
    //   }),
    //     ),
    // GetPage(name: AppRoutes.profile, page: () => const ProfilePage(),binding: BindingsBuilder(() {
    //     Get.put(ProfileController());
    //   }),
    //     ),
    // GetPage(name: AppRoutes.contacts, page: () => const ContactsPage(),binding: BindingsBuilder(() {
    //     Get.put(ContactsController());
    //   }),
    //     ),
    // GetPage(name: AppRoutes.settings, page: () => const SettingsPage(), binding: BindingsBuilder(() {
    //     Get.put(SettingsController());
    //   }),
    //     ),
    // GetPage(
    //   name: AppRoutes.privacyPolicy,
    //   page: () => const PrivacyPolicyPage(),
    // ),
    // GetPage(
    //   name: AppRoutes.termsConditions,
    //   page: () => const TermsConditionsPage(),
    // ),
    // GetPage(name: AppRoutes.about, page: () => const AboutPage(), binding: BindingsBuilder(() {
    //     Get.put(AboutController());
    //   }),
    //       ),
    // GetPage(name: AppRoutes.newChat, page: () => const NewChatPage(), binding: BindingsBuilder(() {
    //     Get.put(NewChatController());
    //   }),
    // ),
    // GetPage(name: AppRoutes.newGroup, page: () => const NewGroupPage(), binding: BindingsBuilder(() {
    //     Get.put(NewGroupController());
    //   }),
    // ),
    // GetPage(name: AppRoutes.groupDetails, page: () => const GroupDetailsPage(), binding: BindingsBuilder(() {
    //     Get.put(GroupDetailsController());
    //   }),
    // ),
    // GetPage(name: AppRoutes.userList, page: () => const UserListPage(), binding: BindingsBuilder(() {
    //     Get.put(UserListController());
    //   }),
    // ),
    // GetPage(name: AppRoutes.home, page: () => HomePage(), binding: BindingsBuilder(() {
    //     Get.put(HomeController());
    //   }),),

    // Add more pages here
    //     }),
  ];
}
