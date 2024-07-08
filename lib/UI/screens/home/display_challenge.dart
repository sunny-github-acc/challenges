import 'package:challenges/UI/router/router.dart';
import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/challenge.dart';
import 'package:challenges/logic/bloc/collection/collection_bloc.dart';
import 'package:challenges/logic/bloc/collection/collection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayChallenge extends StatelessWidget {
  const DisplayChallenge({super.key});

  void _openUpdateChallenge(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.updateChallenge);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionBloc, CollectionState>(
        builder: (context, state) {
      if (state.collection.isEmpty) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Scaffold(
        appBar: CustomAppBar(
          actions: [
            state.isOwner
                ? GestureDetector(
                    onTap: () => _openUpdateChallenge(context),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 2.0,
                      ),
                      width: 50,
                      height: 10,
                      child: const Icon(
                        Icons.edit,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        body: Challenge(
          collection: state.collection,
        ),
      );
    });
  }
}
