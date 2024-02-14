import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userapp/data/repo/home_dao_repo.dart';
import 'package:userapp/data/repo/users_dao_repo.dart';

class HomePageCubit extends Cubit<void> {
  HomePageCubit() : super(0);

  var krepo = UsersDaoRepository();
  var hrepo = HomeDaoRepository();

  Future<void> signOut() async {
    await krepo.signOut();
  }

  Future<void> updateUser(String userid, List hobbies) async {
    await hrepo.updateUser(userid, hobbies);
  }
}
