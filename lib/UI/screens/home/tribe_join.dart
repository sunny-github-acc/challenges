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

class JoinTribe extends StatefulWidget {
  const JoinTribe({super.key});

  @override
  JoinTribeStateClass createState() => JoinTribeStateClass();
}

class JoinTribeStateClass extends State<JoinTribe> {
  bool isJoinTribe = true;
  late final TextEditingController joinTribeController;

  @override
  void initState() {
    joinTribeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    joinTribeController.dispose();
    super.dispose();
  }

  Future<void> joinTribe(context) async {
    String tribe = joinTribeController.text.trim().toLowerCase();

    setState(() {
      isJoinTribe = tribe.isNotEmpty;
    });

    if (tribe.isEmpty) {
      return Modal.show(context, 'Oops', 'The tribe name cannot be empty');
    }

    User? user = BlocProvider.of<AuthBloc>(context).state.user;

    BlocProvider.of<TribesBloc>(context).add(
      TribesEventJoinTribe(
        tribe: tribe,
        user: user,
      ),
    );
  }

  void openHint() {
    Modal.show(
      context,
      'Accomplish more together!',
      "Explore and join tribes that align with your interests! To join a tribe, simply search for its name. Once you find a tribe, you can become a member and participate in challenges shared by other members. \nJoining a tribe allows you to collaborate, share experiences, and engage with others in the community. Don't forget to check the tribe's challenges and contribute your own!",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Join Tribe',
      ),
      body: BlocListener<TribesBloc, TribesState>(
        listener: (context, state) {
          if (state is TribesStateJoined) {
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
                text: 'Accomplish more together!',
                fontSize: FontSizeType.large,
              ),
              CustomInput(
                hintText: 'Tribe Name',
                labelText: 'Enter the name of the tribe you want to join',
                controller: joinTribeController,
                isDisabled: !isJoinTribe,
              ),
              BlocBuilder<TribesBloc, TribesState>(
                builder: (context, state) {
                  return CustomButton(
                    text: 'Join Tribe',
                    onPressed: () {
                      joinTribe(context);
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
