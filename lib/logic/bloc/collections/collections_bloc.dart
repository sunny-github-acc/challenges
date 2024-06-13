import 'package:bloc/bloc.dart';
import 'package:challenges/logic/bloc/collections/collections_error.dart';
import 'package:challenges/logic/bloc/collections/collections_events.dart';
import 'package:challenges/logic/bloc/collections/collections_state.dart';
import 'package:challenges/services/cloud/cloud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CollectionsBloc extends Bloc<CollectionsEvent, CollectionsState> {
  CollectionsBloc()
      : super(
          const CollectionsStateLoaded(),
        ) {
    on<CollectionsEventAddCollection>(
      (event, emit) async {
        emit(
          const CollectionsStateLoading(),
        );

        try {
          final title = event.title;
          final document = event.document;

          CloudService cloudService = CloudService();
          await cloudService.setCollection(title, document);

          emit(
            const CollectionsStateCollectionCollected(),
          );
        } on FirebaseException catch (e) {
          if (kDebugMode) {
            print('CollectionsEventLogIn error 🚀');
            print(e);
          }

          emit(
            CollectionsStateLoaded(
              collectionsError: CollectionsError.from(e),
            ),
          );
        } catch (e) {
          if (kDebugMode) {
            print('CollectionsEventLogIn error 🚀');
            print(e);
          }

          emit(
            CollectionsStateLoaded(
              collectionsError: CollectionsError.from(FirebaseException(
                code: null,
                plugin: 'collections',
              )),
            ),
          );
        }
      },
    );
  }
}
