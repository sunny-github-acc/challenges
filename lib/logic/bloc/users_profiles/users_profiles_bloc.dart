import 'package:bloc/bloc.dart';
import 'package:challenges/logic/bloc/users_profiles/users_profiles_error.dart';
import 'package:challenges/logic/bloc/users_profiles/users_profiles_events.dart';
import 'package:challenges/logic/bloc/users_profiles/users_profiles_state.dart';
import 'package:challenges/services/cloud/cloud.dart';

class UsersProfilesBloc extends Bloc<UsersProfilesEvent, UsersProfilesState> {
  UsersProfilesBloc()
      : super(
          const UsersProfilesStateEmpty(),
        ) {
    on<UsersProfilesEventGetUserProfile>(
      (event, emit) async {
        emit(
          const UsersProfilesStateGetting(),
        );

        try {
          CloudService cloud = CloudService();
          Map<String, dynamic> query = {
            'uid': event.user,
          };

          List<Map<String, dynamic>> data = await cloud.getCollection(
            'users',
            query,
            queryType: QueryType.user,
          );

          Map<String, dynamic> userProfile = data[0];

          emit(
            UsersProfilesStateGot(
              userProfile: userProfile,
            ),
          );
        } catch (error) {
          emit(
            UsersProfilesStateError(
              error: UsersProfilesError.from(
                error,
              ),
            ),
          );
        }
      },
    );
  }
}
