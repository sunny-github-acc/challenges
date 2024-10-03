import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/input.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
import 'package:challenges/logic/bloc/tribes/tribes_bloc.dart';
import 'package:challenges/logic/bloc/tribes/tribes_events.dart';
import 'package:challenges/logic/bloc/tribes/tribes_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTribe extends StatefulWidget {
  const AddTribe({super.key});

  @override
  AddTribeStateClass createState() => AddTribeStateClass();
}

class AddTribeStateClass extends State<AddTribe> {
  bool isAddTribe = true;

  late final TextEditingController addTribeController;

  @override
  void initState() {
    addTribeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    addTribeController.dispose();
    super.dispose();
  }

  Future<void> addTribe(context) async {
    String tribe = addTribeController.text.trim();

    setState(() {
      isAddTribe = tribe.isNotEmpty;
    });

    if (tribe.isEmpty) {
      return Modal.show(context, 'Oops', 'The tribe name cannot be empty');
    } else if (tribe.length < 3) {
      return Modal.show(
        context,
        'Oops',
        'The tribe name must be at least 3 characters long',
      );
    } else if (tribe.length > 20) {
      return Modal.show(
        context,
        'Oops',
        'The tribe name must be at most 20 characters long',
      );
    } else if (tribe == 'public' || tribe == 'private') {
      return Modal.show(
        context,
        'Oops',
        '"$tribe" is a reserved name. Please choose another name',
      );
    }

    User? user = BlocProvider.of<AuthBloc>(context).state.user;

    BlocProvider.of<TribesBloc>(context).add(
      TribesEventAddTribe(
        tribe: tribe.trim().toLowerCase(),
        user: user,
      ),
    );
  }

  void openHint() {
    Modal.show(
      context,
      'Start by creating your own tribe!',
      "Start your journey by creating your own tribe! As the creator, you will automatically be the first member. Once your tribe is established, you can share challenges and engage with your tribe members. \nOther members can easily join by searching for your tribe's name, and you can also explore and join other tribes that interest you.\nWhen you create challenges, you can choose to share them with all tribes or keep them exclusive to your tribe. Plus, you can filter challenges by tribe in the Settings to find what matters most to you!",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Create Tribe',
      ),
      body: BlocListener<TribesBloc, TribesState>(
        listener: (context, state) {
          if (state is TribesStateAdded) {
            Navigator.of(context).pop();
            Modal.show(
              context,
              'Congrats!',
              state.success!,
            );
          } else if (state is TribesStateError) {
            Modal.show(
              context,
              state.error!.dialogTitle,
              state.error!.dialogText,
            );
          }
        },
        child: CustomContainer(
          isFullWidth: true,
          child: CustomColumn(
            spacing: SpacingType.medium,
            children: [
              const CustomText(
                text: 'Start by creating your own tribe!',
                fontSize: FontSizeType.large,
              ),
              CustomInput(
                hintText: 'Tribe Name',
                labelText: 'Enter the name of your tribe',
                controller: addTribeController,
                isDisabled: !isAddTribe,
              ),
              BlocBuilder<TribesBloc, TribesState>(
                builder: (context, state) {
                  return CustomButton(
                    text: 'Create Tribe',
                    onPressed: () {
                      addTribe(context);
                    },
                    isLoading: state.isLoading,
                    disabled: state.isLoading,
                  );
                },
              ),
              CustomButton(
                onPressed: () => openHint(),
                text: 'Read More',
                type: ButtonType.secondary,
                size: ButtonSize.small,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
