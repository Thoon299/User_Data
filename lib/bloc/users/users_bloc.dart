import 'package:bloc/bloc.dart';
import 'package:user_data_system/bloc/users/users_event.dart';
import 'package:user_data_system/bloc/users/users_state.dart';
import 'package:user_data_system/models/UserListModel.dart';

import '../../data/repository/user_repository.dart';

class UsersBloc extends Bloc<UsersEvent,UsersState>{
  final UsersRepository usersRepository;
  UsersBloc(this.usersRepository) : super(UsersEmpty());

  @override
  Stream<UsersState> mapEventToState(
      UsersEvent event
      ) async*{
    if(event is FetchUsers){
      yield UsersLoading();
      try{
        UserListModel userListModel = await usersRepository.getUsers();
        yield UsersLoaded(userListModel: userListModel);
      }
      on Exception{
        yield UsersError(errorMessage: 'Fail to get users.');
      }
      catch(e){
        yield UsersError(errorMessage: e.toString());
      }
    }


  }
}