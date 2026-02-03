import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:komu_chatapp/controllers/change_password_controller.dart';
import 'package:komu_chatapp/theme/app_theme.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());
    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.security_rounded,
                        size: 40,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Update your Password',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Do you want to change your current password? Please enter your new password and make sure it has not been used multiple times on any website.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 20),
                  Obx(
                    () => TextFormField(
                      controller: controller.newPasswordController,
                      obscureText: controller.obscureNewPassword,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        suffix: IconButton(
                          onPressed: controller.toggleNewPasswordVisibility,
                          icon: Icon(
                            controller.obscureNewPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                        hintText: 'Enter your New Password',
                      ),
                      validator: controller.validateNewPassword,
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(
                    () => TextFormField(
                      controller: controller.confirmPasswordController,
                      obscureText: controller.obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        suffix: IconButton(
                          onPressed: controller.toggleConfirmPasswordVisibility,
                          icon: Icon(
                            controller.obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                        hintText: 'Confirm your New Password',
                      ),
                      validator: controller.validateConfirmPassword,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Enter your current password in order to confirm this changes.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 20),

                  Obx(
                    () => TextFormField(
                      controller: controller.currentPasswordController,
                      obscureText: controller.obscureCurrentPassword,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        suffix: IconButton(
                          onPressed: controller.toggleCurrentPasswordVisibility,
                          icon: Icon(
                            controller.obscureCurrentPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                        hintText: 'Enter your current Password',
                      ),
                      validator: controller.validateCurrentPassword,
                    ),
                  ),
                  SizedBox(height: 40),
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: controller.isLoading
                            ? null
                            : controller.changePassword,
                        icon: controller.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(Icons.security),
                        label: Text(
                          controller.isLoading
                              ? 'Updating...'
                              : 'Update Password',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
