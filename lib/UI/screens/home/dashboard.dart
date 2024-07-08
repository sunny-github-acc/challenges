import 'dart:async';
import 'package:challenges/UI/router/router.dart';
import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/card.dart';
import 'package:challenges/components/challenge.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/logic/bloc/collection/collection_bloc.dart';
import 'package:challenges/logic/bloc/collection/collection_events.dart';
import 'package:challenges/logic/bloc/collections/collections_bloc.dart';
import 'package:challenges/logic/bloc/collections/collections_events.dart';
import 'package:challenges/logic/bloc/collections/collections_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  Future<void> _loadCollectionData(context) async {
    BlocProvider.of<CollectionsBloc>(context).add(
      const CollectionsEventGetCollection(),
    );
  }

  void _openChallenge(BuildContext context, Map<String, dynamic> collection) {
    BlocProvider.of<CollectionBloc>(context).add(
      CollectionEventSetCollection(
        collection: collection,
      ),
    );

    Navigator.of(context).pushNamed(Routes.displayChallenge);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionsBloc, CollectionsState>(
      builder: (context, state) {
        if (kDebugMode) {
          print('🚀 CollectionsBloc state: $state');
        }

        if (state.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.error != null) {
          return Scaffold(
            body: CustomColumn(
              children: [
                Text(state.error!.dialogTitle),
                Text(state.error!.dialogText),
                CustomButton(
                  onPressed: () => _loadCollectionData(context),
                  text: 'Refresh',
                ),
              ],
            ),
          );
        }

        final List<Map<String, dynamic>> collections = state.collections;

        if (collections.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text(
                'No challenges available',
              ),
            ),
          );
        }

        return Scaffold(
          appBar: const CustomAppBar(
            title: 'Ongoing global challenges',
            fontSize: 20,
          ),
          body: ListView.builder(
            itemCount: collections.length,
            itemBuilder: (context, index) {
              return CustomCard(
                onPressed: () => _openChallenge(
                  context,
                  collections[index],
                ),
                child: Challenge(
                  collection: collections[index],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
