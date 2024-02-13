import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userapp/data/repo/users_dao_repo.dart';

class LoginPageCubit extends Cubit<void> {
  LoginPageCubit() : super(0);

  var krepo = UsersDaoRepository();

  Future<void> signIn(String email, String password) async {
    var result = await krepo.signIn(email, password);
    emit(result);
  }
}
