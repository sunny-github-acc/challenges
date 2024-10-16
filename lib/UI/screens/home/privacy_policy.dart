import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/text.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _Profile();
}

class _Profile extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Privacy Policy',
      ),
      body: SingleChildScrollView(
        child: CustomContainer(
          paddingHorizontal: 12,
          paddingVertical: 16,
          child: CustomText(
            text:
                'Privacy Policy\nLast Updated: 2024-10-10\nWelcome to Challenges, a self-development app designed to help you achieve your goals and connect with others. We value your privacy, and this policy outlines how we handle your data. By using our app, you agree to the terms outlined below.\n1. Data Collection\nPersonal Information: When you sign up, we collect your email address for account creation and login purposes. This information is managed through Firebase Authentication.\nChallenge Data: The challenges you create, update, and complete are stored in Firebase to ensure a seamless experience.\nGroups and Sharing: If you create or join groups within the app, the information you share there (such as challenges) is stored in Firebase.\n2. Data Usage\nYour email address is used solely for authentication and account management. It is not shared with any third parties.\nChallenge data and group information are stored to enable the core functionalities of the app, such as tracking progress and facilitating group interactions.\nThe data you provide is not used for any marketing or advertising purposes in this version of the app.\n3. Data Security\nWe use Firebase services, which follow industry-standard security practices to protect your data.\nWhile we strive to use commercially acceptable means to protect your data, we cannot guarantee its absolute security.\n4. Contact\nIf you have any questions or concerns about this privacy policy or how your data is handled, please contact us at karolis.kazak@gmail.com.\n5. Changes to This Policy\nThis privacy policy may be updated as the app evolves. Any changes will be reflected here, and you are encouraged to review this policy periodically.\n6. No Monetization\nThis version of the app is free to use, and we do not collect any payment information. In the future, if the app evolves to include monetization features, this privacy policy will be updated accordingly.',
            // fontSize: 24,
          ),
        ),
      ),
    );
  }
}
