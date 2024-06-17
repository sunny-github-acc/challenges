import 'package:bloc/bloc.dart';
import 'package:challenges/logic/bloc/collections/collections_error.dart';
import 'package:challenges/logic/bloc/collections/collections_events.dart';
import 'package:challenges/logic/bloc/collections/collections_state.dart';
import 'package:challenges/services/cloud/cloud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

CloudService cloudService = CloudService();

class CollectionsBloc extends Bloc<CollectionsEvent, CollectionsState> {
  CollectionsBloc()
      : super(
          const CollectionsStateInitial(),
        ) {
    on<CollectionsEventAddCollection>(
      (event, emit) async {
        emit(
          const CollectionsStateAdding(),
        );

        try {
          final title = event.title;
          final document = event.document;

          await cloudService.setCollection(title, document);

          emit(
            const CollectionsStateAdded(),
          );
        } on FirebaseException catch (e) {
          if (kDebugMode) {
            print('CollectionsEventAddCollection FirebaseException error 🚀');
            print(e);
          }

          emit(
            CollectionsStateAddingError(
              collectionsError: CollectionsError.from(e),
            ),
          );
        } catch (e) {
          if (kDebugMode) {
            print('CollectionsEventAddCollection error 🚀');
            print(e);
          }

          emit(
            CollectionsStateAddingError(
              collectionsError: CollectionsError.from(FirebaseException(
                code: null,
                plugin: 'collections',
              )),
            ),
          );
        }
      },
    );

    on<CollectionsEventGetCollection>(
      (event, emit) async {
        emit(
          const CollectionsStateGetting(),
        );

        try {
          List<Map<String, dynamic>> data =
              await cloudService.getCollectionWithQuery('challenges', {
            'endDateIsGreater': DateTime.now(),
            'isUnlimited': true,
          });
          List<Map<String, dynamic>> sortedData = data
            ..sort((a, b) {
              DateTime dateTimeA = (a['createdAt'] as Timestamp).toDate();
              DateTime dateTimeB = (b['createdAt'] as Timestamp).toDate();

              return dateTimeB.compareTo(dateTimeA);
            });

          emit(
            CollectionsStateGot(collectionsData: sortedData),
          );
        } on FirebaseException catch (e) {
          if (kDebugMode) {
            print('CollectionsEventLogIn error 🚀');
            print(e);
          }

          emit(
            CollectionsStateAddingError(
              collectionsError: CollectionsError.from(e),
            ),
          );
        } catch (e) {
          if (kDebugMode) {
            print('CollectionsEventLogIn error 🚀');
            print(e);
          }

          emit(
            CollectionsStateAddingError(
              collectionsError: CollectionsError.from(FirebaseException(
                code: null,
                plugin: 'collections',
              )),
            ),
          );
        }
      },
    );

    on<CollectionsEventInitiateStream>(
      (event, emit) async {
        emit(
          const CollectionsStateGetting(),
        );

        try {
          cloudService.getCollectionStream('challenges', {
            'endDateIsAfter': DateTime.now(),
            'isUnlimited': true,
          }).listen((data) {
            List<Map<String, dynamic>> sortedData = data
              ..sort((a, b) {
                DateTime dateTimeA = (a['createdAt'] as Timestamp).toDate();
                DateTime dateTimeB = (b['createdAt'] as Timestamp).toDate();

                return dateTimeB.compareTo(dateTimeA);
              });

            add(CollectionsEventStream(sortedData: sortedData));
          });
        } on FirebaseException catch (e) {
          if (kDebugMode) {
            print('CollectionsEventLogIn error 🚀');
            print(e);
          }

          emit(
            CollectionsStateAddingError(
              collectionsError: CollectionsError.from(e),
            ),
          );
        } catch (e) {
          if (kDebugMode) {
            print('CollectionsEventLogIn error 🚀');
            print(e);
          }

          emit(
            CollectionsStateAddingError(
              collectionsError: CollectionsError.from(
                FirebaseException(
                  code: null,
                  plugin: 'collections',
                ),
              ),
            ),
          );
        }
      },
    );

    on<CollectionsEventStream>(
      (event, emit) async {
        emit(
          CollectionsStateGot(collectionsData: event.sortedData),
        );
      },
    );
  }
}
