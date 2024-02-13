import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userapp/data/repo/users_dao_repo.dart';

class RegisterPageCubit extends Cubit<void> {
  RegisterPageCubit():super(0);

  var krepo = UsersDaoRepository();

  Future<void> signUp(String email, String password) async{
    await krepo.signUp(email, password);
  }

}