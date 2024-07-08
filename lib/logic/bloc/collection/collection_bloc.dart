import 'package:bloc/bloc.dart';
import 'package:challenges/logic/bloc/collection/collection_error.dart';
import 'package:challenges/logic/bloc/collection/collection_events.dart';
import 'package:challenges/logic/bloc/collection/collection_state.dart';
import 'package:challenges/services/auth/auth.dart';
import 'package:challenges/services/cloud/cloud.dart';
import 'package:flutter/foundation.dart';

CloudService cloudService = CloudService();
AuthService authService = AuthService();

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  CollectionBloc()
      : super(
          const CollectionStateEmpty(),
        ) {
    on<CollectionEventSetCollection>(
      (event, emit) {
        Map<String, dynamic> collection = event.collection;
        Map user = authService.getUser();
        bool isOwner = user['email'] == collection['email'];

        emit(
          CollectionStateSet(
            collection: collection,
            isOwner: isOwner,
          ),
        );
      },
    );

    on<CollectionEventUpdateCollection>(
      (event, emit) async {
        emit(
          CollectionStateSet(
            collection: state.collection,
            isOwner: state.isOwner,
            isLoading: true,
          ),
        );

        try {
          Map<String, dynamic> updatedCollection = {
            ...state.collection,
            ...event.collection,
          };

          await cloudService.updateCollection(
            'challenges',
            updatedCollection,
            updatedCollection['id'],
          );

          emit(
            CollectionStateSet(
              collection: updatedCollection,
              isOwner: state.isOwner,
            ),
          );
        } catch (e) {
          if (kDebugMode) {
            print('CollectionEventUpdateCollection error 🚀: $e');
          }

          emit(
            CollectionStateSet(
              collection: state.collection,
              isOwner: state.isOwner,
              error: CollectionError.from(
                e.toString(),
              ),
            ),
          );
        }
      },
    );

    on<CollectionEventDeleteCollection>(
      (event, emit) async {
        try {
          await cloudService.deleteDocument('challenges', event.collectionId);

          emit(
            const CollectionStateSet(
              collection: {},
              isOwner: false,
              success: 'Collection deleted successfully 🎉',
            ),
          );
        } catch (e) {
          if (kDebugMode) {
            print('CollectionEventDeleteCollection error 🚀');
            print(e);
          }

          emit(
            CollectionStateSet(
              collection: state.collection,
              isOwner: state.isOwner,
              error: CollectionError.from(
                e.toString(),
              ),
            ),
          );
        }
      },
    );
  }
}
