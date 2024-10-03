import 'package:bloc/bloc.dart';
import 'package:challenges/logic/bloc/tribes/tribes_error.dart';
import 'package:challenges/logic/bloc/tribes/tribes_events.dart';
import 'package:challenges/logic/bloc/tribes/tribes_state.dart';
import 'package:challenges/services/cloud/cloud.dart';

class TribesBloc extends Bloc<TribesEvent, TribesState> {
  TribesBloc()
      : super(
          const TribesStateEmpty(),
        ) {
    on<TribesEventAddTribe>(
      (event, emit) async {
        emit(
          const TribesStateAdding(),
        );

        try {
          CloudService cloud = CloudService();
          List<Map<String, dynamic>> data = await cloud.getCollection(
            'tribes',
            null,
          );
          bool isTribePresent = data.any(
            (element) => element['name'] == event.tribe,
          );

          if (isTribePresent) {
            throw 'already-exists';
          }

          await cloud.setCollection(
            'tribes',
            {
              'name': event.tribe,
              'members': [event.user!.uid],
            },
            customDocumentId: event.tribe,
          );

          await cloud.updateCollection(
            'users',
            {
              'visibility.${event.tribe}': true,
            },
            event.user!.uid,
          );

          emit(
            TribesStateAdded(
              success: 'Tribe ${event.tribe} added successfully',
            ),
          );
        } catch (error) {
          emit(
            TribesStateError(
              error: TribesError.from(
                error,
              ),
            ),
          );
        }
      },
    );

    on<TribesEventJoinTribe>(
      (event, emit) async {
        emit(
          const TribesStateJoining(),
        );

        try {
          CloudService cloud = CloudService();
          Map<String, dynamic> data =
              await cloud.getDocument('tribes', event.tribe);
          bool isMemberPresent = data['members'].contains(event.user!.uid);

          if (isMemberPresent) {
            throw 'member-already-in-tribe';
          }

          await cloud.updateCollection(
            'tribes',
            {
              'name': event.tribe,
              'members': [...data['members'], event.user!.uid],
            },
            event.tribe,
          );

          await cloud.updateCollection(
            'users',
            {
              'visibility.${event.tribe}': true,
            },
            event.user!.uid,
          );

          emit(
            TribesStateJoined(
              success: 'Tribe ${event.tribe} joined successfully',
            ),
          );
        } catch (error) {
          emit(
            TribesStateError(
              error: TribesError.from(
                error,
              ),
            ),
          );
        }
      },
    );

    on<TribesEventGetTribes>(
      (event, emit) async {
        emit(
          const TribesStateGetting(),
        );

        try {
          CloudService cloud = CloudService();
          Map<String, dynamic> query = {
            'uid': event.user.uid,
          };

          List<Map<String, dynamic>> data = await cloud.getCollection(
            'tribes',
            query,
            queryType: QueryType.tribes,
          );

          List<String> tribes = data
              .map(
                (element) => element['name'] as String,
              )
              .toList();

          emit(
            TribesStateGot(
              tribes: tribes,
            ),
          );
        } catch (error) {
          emit(
            TribesStateError(
              error: TribesError.from(
                error,
              ),
            ),
          );
        }
      },
    );
  }
}
