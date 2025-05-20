import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/text.dart';
import 'package:flutter/material.dart';

class TermsOfUse extends StatefulWidget {
  const TermsOfUse({super.key});

  @override
  State<TermsOfUse> createState() => _TermsOfUse();
}

class _TermsOfUse extends State<TermsOfUse> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Terms of Use',
      ),
      body: SingleChildScrollView(
        child: CustomContainer(
          paddingHorizontal: 12,
          paddingVertical: 16,
          child: CustomText(
              text:
                  'Terms of Use\nLast Updated: 2024-10-10\nWelcome to Challenges! These terms govern your use of the app, and by accessing or using the app, you agree to comply with these terms.\n1. Acceptance of Terms By creating an account and using Challenges, you agree to be bound by these terms. If you do not agree, you should not use the app.\n2. Use of the App\nThe app is designed for personal use to set and track challenges, join groups, and share goals.\nYou are responsible for any activity that occurs under your account. You must keep your login credentials secure.\nYou agree not to use the app for any illegal or unauthorized purposes, including violating intellectual property rights or engaging in harmful behavior toward other users.\n3. Content Sharing\nYou can create and share challenges in groups. However, you are solely responsible for the content you post.\nChallenges reserves the right to remove any content that is inappropriate, offensive, or violates these terms.\nBy submitting content, you grant Challenges a non-exclusive, worldwide, royalty-free license to use, display, and distribute this content as part of the app’s features (e.g., sharing in groups).\n4. Account Termination\nYou may stop using the app at any time. Challenges reserves the right to terminate or suspend your account if you violate these terms.\nAny data associated with your account may be removed if your account is terminated.\n5. Limitation of Liability\nThe app is provided "as is" without warranties of any kind. Challenges is not responsible for any issues arising from the use of the app, including, but not limited to, data loss, technical issues, or disruptions in service.\nIn no event shall Challenges be liable for any indirect, incidental, or consequential damages resulting from the use of the app.\n6. Changes to the Terms\nThese terms may be updated over time. If any changes are made, you will be notified, and your continued use of the app will constitute acceptance of the updated terms.\n7. Contact\nIf you have questions about these terms, you can reach us at karolis.kazak@gmail.com.\n8. Governing Law\nThese terms will be governed by and interpreted in accordance with the laws of Lithuania.'),
        ),
      ),
    );
  }
}
