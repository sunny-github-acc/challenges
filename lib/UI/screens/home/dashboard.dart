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
import 'package:challenges/services/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
  });

  Future<void> loadCollectionData(context, Map<String, dynamic> query) async {
    BlocProvider.of<CollectionsBloc>(context).add(
      CollectionsEventGetCollection(
        query: query,
      ),
    );
  }

  void navigateToUpdateChallenge(
      BuildContext context, Map<String, dynamic> collection) {
    AuthService auth = AuthService();
    if (auth.getUser()['email'] == collection['email']) {
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
          FilterSettingsState filterSettingsBlocState =
              BlocProvider.of<FilterSettingsBloc>(context).state;
          bool isIncludeFinished =
              filterSettingsBlocState.filterSettings['isIncludeFinished'];
          bool isFinished =
              filterSettingsBlocState.filterSettings['isFinished'];
          Map<String, dynamic> visibility =
              filterSettingsBlocState.filterSettings['visibility'];
          Map<String, dynamic> filterSettingsQuery = {
            'visibility': visibility,
            'isIncludeFinished': isIncludeFinished,
            'isFinished': isFinished,
          };

          return Scaffold(
            body: CustomColumn(
              children: [
                CustomText(text: state.error!.dialogTitle),
                CustomText(text: state.error!.dialogText),
                CustomButton(
                  onPressed: () => loadCollectionData(
                    context,
                    filterSettingsQuery,
                  ),
                  text: 'Refresh',
                ),
              ],
            ),
          );
        }

        if (state.collections.isEmpty) {
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
            itemCount: state.collections.length,
            itemBuilder: (context, index) {
              if (state.collections.length == 20 && index == 19) {
                return CustomColumn(
                  children: [
                    CustomCard(
                      onPressed: () => navigateToUpdateChallenge(
                        context,
                        state.collections[index],
                      ),
                      child: Challenge(
                        collection: state.collections[index],
                      ),
                    ),
                    const CustomCard(
                      child: CustomText(
                        text:
                            "More than 20 challenges won't be visible in this version. Stay tuned for updates!",
                      ),
                    ),
                  ],
                );
              }

              return CustomCard(
                onPressed: () => navigateToUpdateChallenge(
                  context,
                  state.collections[index],
                ),
                child: Challenge(
                  collection: state.collections[index],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
