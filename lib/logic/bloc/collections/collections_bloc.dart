import 'dart:async';
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
          const CollectionsStateEmpty(),
        ) {
    StreamSubscription? streamSubscription;

    on<CollectionsEventInitiateStream>(
      (event, emit) async {
        streamSubscription?.cancel();

        emit(
          const CollectionsStateUpdated(
            isLoading: true,
            collections: [],
          ),
        );

        try {
          streamSubscription = cloudService
              .getCollectionWithFilterSettingsStream('challenges', event.query)
              .listen(
            (data) {
              List<Map<String, dynamic>> sortedData = data
                ..sort((a, b) {
                  DateTime dateTimeA = (a['createdAt'] as Timestamp).toDate();
                  DateTime dateTimeB = (b['createdAt'] as Timestamp).toDate();

                  return dateTimeB.compareTo(dateTimeA);
                });

              add(
                CollectionsEventStream(
                  sortedData: sortedData,
                ),
              );
            },
          );
        } on FirebaseException catch (e) {
          if (kDebugMode) {
            print('CollectionsEventInitiateStream FirebaseException error 🚀');
            print(e);
          }

          emit(
            CollectionsStateUpdated(
              collections: state.collections,
              error: CollectionsError.from(e),
            ),
          );
        } catch (e) {
          if (kDebugMode) {
            print('CollectionsEventInitiateStream error 🚀');
            print(e);
          }

          emit(
            CollectionsStateUpdated(
              collections: state.collections,
              error: CollectionsError.from(
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
          CollectionsStateUpdated(
            collections: event.sortedData,
          ),
        );
      },
    );

    on<CollectionsEventAddCollection>(
      (event, emit) async {
        emit(
          CollectionsStateUpdated(
            collections: state.collections,
            isLoading: true,
          ),
        );

        try {
          final title = event.title;
          final document = event.document;

          await cloudService.setCollection(title, document);

          emit(
            CollectionsStateUpdated(
              collections: state.collections,
              success: 'Collection added successfully 🎉',
            ),
          );
        } on FirebaseException catch (e) {
          if (kDebugMode) {
            print('CollectionsEventAddCollection FirebaseException error 🚀');
            print(e);
          }

          emit(
            CollectionsStateUpdated(
              collections: state.collections,
              error: CollectionsError.from(e),
            ),
          );
        } catch (e) {
          if (kDebugMode) {
            print('CollectionsEventAddCollection error 🚀');
            print(e);
          }

          emit(
            CollectionsStateUpdated(
              collections: state.collections,
              error: CollectionsError.from(FirebaseException(
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
          CollectionsStateUpdated(
            isLoading: true,
            collections: state.collections,
          ),
        );

        try {
          List<Map<String, dynamic>> data = await cloudService.getCollection(
            'challenges',
            event.query,
            queryType: QueryType.filter,
          );
          List<Map<String, dynamic>> sortedData = data
            ..sort((a, b) {
              DateTime dateTimeA = (a['createdAt'] as Timestamp).toDate();
              DateTime dateTimeB = (b['createdAt'] as Timestamp).toDate();

              return dateTimeB.compareTo(dateTimeA);
            });

          emit(
            CollectionsStateUpdated(
              collections: sortedData,
            ),
          );
        } on FirebaseException catch (e) {
          if (kDebugMode) {
            print('CollectionsEventGetCollection FirebaseException error 🚀');
            print(e);
          }

          emit(
            CollectionsStateUpdated(
              collections: state.collections,
              error: CollectionsError.from(e),
            ),
          );
        } catch (e) {
          if (kDebugMode) {
            print('CollectionsEventGetCollection error 🚀');
            print(e);
          }

          emit(
            CollectionsStateUpdated(
              collections: state.collections,
              error: CollectionsError.from(
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
  }
}
