import 'package:bloc/bloc.dart';
import 'package:challenges/logic/bloc/priorities/priorities_error.dart';
import 'package:challenges/logic/bloc/priorities/priorities_events.dart';
import 'package:challenges/logic/bloc/priorities/priorities_state.dart';
import 'package:challenges/services/cloud/cloud.dart';

class PrioritiesBloc extends Bloc<PrioritiesEvent, PrioritiesState> {
  PrioritiesBloc()
      : super(
          const PrioritiesStateEmpty(),
        ) {
    on<PrioritiesEventAddPriorities>(
      (event, emit) async {
        emit(
          const PrioritiesStateAdding(),
        );

        try {
          CloudService cloud = CloudService();

          await cloud.updateCollection(
            'users',
            {
              'priorities': event.priorities,
            },
            event.user!.uid,
          );

          emit(
            PrioritiesStateAdded(
              priorities: event.priorities,
            ),
          );
        } catch (error) {
          emit(
            PrioritiesStateError(
              error: PrioritiesError.from(
                error,
              ),
            ),
          );
        }
      },
    );

    on<PrioritiesEventGetPriorities>(
      (event, emit) async {
        emit(
          const PrioritiesStateGetting(),
        );

        try {
          CloudService cloud = CloudService();
          Map<String, dynamic> query = {
            'uid': event.user.uid,
          };

          List<Map<String, dynamic>> data = await cloud
              .getCollection('users', query, queryType: QueryType.user);

          String priorities = data[0]['priorities'];

          emit(
            PrioritiesStateGot(
              priorities: priorities,
            ),
          );
        } catch (error) {
          emit(
            PrioritiesStateError(
              error: PrioritiesError.from(
                error,
              ),
            ),
          );
        }
      },
    );
  }
}
