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
          List<Map<String, dynamic>> data = await cloud.getCollection('tribes');
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

          await cloud.setCollection('tribes', {
            'name': event.tribe,
            'members': [...data['members'], event.user!.uid],
          });

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
  }
}
