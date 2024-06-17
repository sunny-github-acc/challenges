import 'dart:async';
import 'package:challenges/UI/screens/home/display_challenge.dart';
import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/card.dart';
import 'package:challenges/components/challenge.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/logic/bloc/collections/collections_bloc.dart';
import 'package:challenges/logic/bloc/collections/collections_events.dart';
import 'package:challenges/logic/bloc/collections/collections_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<CollectionsBloc>(context).add(
      const CollectionsEventInitiateStream(),
    );
  }

  Future<void> _loadCollectionData(context) async {
    BlocProvider.of<CollectionsBloc>(context).add(
      const CollectionsEventGetCollection(),
    );
  }

  void _openChallenge(BuildContext context, Map<String, dynamic> collection) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayChallenge(
          collection: collection,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionsBloc, CollectionsState>(
      builder: (context, state) {
        if (kDebugMode) {
          print('🚀 CollectionsBloc state: $state');
        }

        if (state is CollectionsStateGetting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is CollectionsStateGettingError) {
          return Scaffold(
            body: CustomColumn(
              children: [
                Text(state.collectionsError!.dialogTitle),
                Text(state.collectionsError!.dialogText),
                CustomButton(
                    onPressed: () => _loadCollectionData(context),
                    text: 'Refresh'),
              ],
            ),
          );
        }

        final List<Map<String, dynamic>> collection = state.collectionsData;

        if (collection.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text('No challenges available'),
            ),
          );
        }

        return Scaffold(
          appBar: const CustomAppBar(
            title: 'Ongoing global challenges',
            fontSize: 20,
          ),
          body: ListView.builder(
            itemCount: collection.length,
            itemBuilder: (context, index) {
              return CustomCard(
                  onPressed: () => _openChallenge(context, collection[index]),
                  child: Challenge(
                    collection: collection[index],
                  ));
            },
          ),
        );
      },
    );
  }
}
