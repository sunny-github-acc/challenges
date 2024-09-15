import 'dart:async';
import 'package:challenges/UI/router/router.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/card.dart';
import 'package:challenges/components/challenge.dart';
import 'package:challenges/components/circular_progress_indicator.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/logic/bloc/collection/collection_bloc.dart';
import 'package:challenges/logic/bloc/collection/collection_events.dart';
import 'package:challenges/logic/bloc/collections/collections_bloc.dart';
import 'package:challenges/logic/bloc/collections/collections_events.dart';
import 'package:challenges/logic/bloc/collections/collections_state.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_bloc.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  Future<void> _loadCollectionData(context, Map<String, bool> query) async {
    BlocProvider.of<CollectionsBloc>(context).add(
      CollectionsEventGetCollection(
        query: query,
      ),
    );
  }

  void navigateToUpdateChallenge(
      BuildContext context, Map<String, dynamic> collection) {
    if (authService.getUser()['email'] == collection['email']) {
      BlocProvider.of<CollectionBloc>(context).add(
        CollectionEventSetCollection(
          collection: collection,
        ),
      );

      Navigator.of(context).pushNamed(Routes.updateChallenge);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionsBloc, CollectionsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.error != null) {
          print('beautify');

          FilterSettingsState filterSettingsBlocState =
              BlocProvider.of<FilterSettingsBloc>(context).state;
          bool isIncludeFinished =
              filterSettingsBlocState.filterSettings['isIncludeFinished'];
          bool isFinished =
              filterSettingsBlocState.filterSettings['isFinished'];
          bool isPrivate = filterSettingsBlocState.filterSettings['isPrivate'];
          Map<String, bool> filterSettingsQuery = {
            'isPrivate': isPrivate,
            'isIncludeFinished': isIncludeFinished,
            'isFinished': isFinished,
          };

          return Scaffold(
            body: CustomColumn(
              children: [
                CustomText(text: state.error!.dialogTitle),
                CustomText(text: state.error!.dialogText),
                CustomButton(
                  onPressed: () => _loadCollectionData(
                    context,
                    filterSettingsQuery,
                  ),
                  text: 'Refresh',
                ),
              ],
            ),
          );
        }

        final List<Map<String, dynamic>> collections = state.collections;

        if (collections.isEmpty) {
          FilterSettingsState filterSettingsBlocState =
              BlocProvider.of<FilterSettingsBloc>(context).state;

          return Scaffold(
            body: CustomContainer(
              isSingleChildScrollView: !filterSettingsBlocState.isLoading,
              isFull: true,
              child: CustomColumn(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  filterSettingsBlocState.isLoading
                      ? const CustomCircularProgressIndicator()
                      : const CustomCard(
                          child: CustomText(
                            fontSize: FontSizeType.large,
                            text:
                                'No challenges found, try changing the filter settings or press the add (+) button to create a new challenge',
                          ),
                        ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: ListView.builder(
            itemCount: collections.length,
            itemBuilder: (context, index) {
              return CustomCard(
                onPressed: () => navigateToUpdateChallenge(
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
