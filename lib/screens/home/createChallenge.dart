import 'package:flutter/material.dart';

import 'package:challenges/services/cloud/cloud.dart';
import 'package:challenges/services/auth/auth.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/components/input.dart';

class CreateChallenge extends StatefulWidget {
  const CreateChallenge({super.key});

  @override
  State<CreateChallenge> createState() => _CreateChallenge();
}

class _CreateChallenge extends State<CreateChallenge> {
  final TextEditingController titleController = TextEditingController();

  bool isTitle = true;

  Future<void> _save(context) async {
    AuthService authService = AuthService();

    String title = titleController.text.trim();
    Map user =  authService.getUser();

    Map<String, dynamic> document = {
      ...user,
      'title': title,
    };

    setState(() {
      isTitle = title.isNotEmpty;
    });

    if (!isTitle) {
      return Modal.show(context, 'Oops', 'Please fill out all input fields');
    }

    CloudService cloudService = CloudService();
    await cloudService.setCollection(context, 'challenges', document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Create a challenge',
        actions: [
          ButtonCustom(
            onPressed: () => _save(context),
            text: 'Save',
            size: ButtonSize.small,
          ),
        ],
      ),
      body: Column(
        children: [
          ContainerGradient(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InputCustom(
                    labelText: 'Title',
                    hintText: 'Enter the title of your challenge',
                    controller: titleController,
                    disabled: !isTitle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}