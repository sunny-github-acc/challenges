import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/editable_text.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
import 'package:challenges/logic/bloc/priorities/priorities_bloc.dart';
import 'package:challenges/logic/bloc/priorities/priorities_events.dart';
import 'package:challenges/logic/bloc/priorities/priorities_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Priorities extends StatefulWidget {
  const Priorities({super.key});

  @override
  PrioritiesStateClass createState() => PrioritiesStateClass();
}

class PrioritiesStateClass extends State<Priorities> {
  @override
  void initState() {
    super.initState();

    User? user = BlocProvider.of<AuthBloc>(context).state.user;

    if (user != null) {
      BlocProvider.of<PrioritiesBloc>(context).add(
        PrioritiesEventGetPriorities(
          user: user,
        ),
      );
    }
  }

  Future<void> addPriorities(context, priorities) async {
    User? user = BlocProvider.of<AuthBloc>(context).state.user;

    BlocProvider.of<PrioritiesBloc>(context).add(
      PrioritiesEventAddPriorities(
        priorities: priorities,
        user: user,
      ),
    );
  }

  void openHint() {
    Modal.show(
      context,
      'The Importance of Priorities',
      "This section helps you focus on what's most important in your life right now. Think about the areas you want to grow in, the values you want to embody, or the type of person you aspire to become. Setting these priorities will guide you when choosing or creating challenges, helping you align your goals with your deeper aspirations.\nHow to fill it? Write down 3-5 priorities that matter most to you—whether it's health, creativity, relationships, or personal growth. This will serve as a reminder of what you're aiming for as you tackle your challenges!",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Priorities',
      ),
      body: BlocListener<PrioritiesBloc, PrioritiesState>(
        listener: (context, state) {
          if (state is PrioritiesStateError) {
            Modal.show(
              context,
              state.error.dialogTitle,
              state.error.dialogText,
            );
          }
        },
        child: CustomContainer(
          isFullWidth: true,
          child: CustomColumn(
            children: [
              CustomColumn(
                spacing: SpacingType.medium,
                children: [
                  const CustomText(
                    text: 'Define what matters to You!',
                    fontSize: FontSizeType.large,
                  ),
                  BlocBuilder<PrioritiesBloc, PrioritiesState>(
                    builder: (context, state) {
                      if (state is PrioritiesStateGetting ||
                          state is PrioritiesStateAdding) {
                        return const CircularProgressIndicator();
                      }

                      return CustomTextInput(
                        text: state.priorities ?? '',
                        hint: 'Press to add priorities',
                        onSave: (value) {
                          addPriorities(context, value);
                        },
                      );
                    },
                  ),
                ],
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
