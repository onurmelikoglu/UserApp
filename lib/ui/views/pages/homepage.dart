import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userapp/data/entity/users.dart';
import 'package:userapp/data/repo/users_dao_repo.dart';
import 'package:userapp/ui/cubit/homepage_cubit.dart';
import 'package:userapp/ui/utils/colors.dart';
import 'package:userapp/ui/views/auth/loginpage.dart';
import 'package:userapp/ui/widgets/customtext.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Users? currentUser;
  List<String> hobbiesList = [];
  int hobbiesLength = 0;
  var krepo = UsersDaoRepository();
  var tcHobby = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> getCurrentUser() async {
    currentUser = await krepo.getCurrentUser();
    hobbiesLength = currentUser!.hobbies.length;
    hobbiesList = [];
    for (var i = 0; i < hobbiesLength; i++) {
      hobbiesList.add(currentUser!.hobbies[i]);
    }
  }

  Future<List> getHobbies() async {
    currentUser = await krepo.getCurrentUser();
    return currentUser!.hobbies;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customText(text: "Merhaba", fontsize: 20, color: Colors.black),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  context.read<HomePageCubit>().signOut().then((value) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  });
                },
                child: const Icon(
                  Icons.exit_to_app,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Column(
        children: [
          UserInfoCard(
            fullname: currentUser?.fullname ?? "",
            email: currentUser?.email ?? "",
            birthdate: currentUser?.birthdate ?? "",
            bio: currentUser?.biography ?? "",
          ),
          customText(
            text: "Hobiler",
            fontsize: 20,
            color: mediumColor,
            fontweight: FontWeight.w600,
          ),
          Expanded(
            child:FutureBuilder(
                future: getHobbies(),
                builder: (context, snapshot) {
                  var hobbyList = snapshot.data;
                  // print("asd xx: " + hobbyList.toString());
                  if (snapshot.hasData) {
                    // If the data is still loading, show a loading indicator
                    // print("asd xx : " + hobbyList[0].toString());
                    return RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: () async {
                        getHobbies();
                        return Future<void>.delayed(const Duration(seconds: 2));
                      },
                      child: ListView.builder(
                          itemCount: hobbyList!.length,
                          itemBuilder: (context, index) {
                            var hobby = hobbyList[index];
                            return hobbyCard(name: hobby);
                          }),
                    );
                  } else {
                    return const Center();
                  }
                },
              ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Yeni Hobi"),
                  content: TextField(
                    controller: tcHobby,
                    decoration: const InputDecoration(hintText: "Yüzmek.."),
                  ),
                  // backgroundColor: Colors.grey,
                  actions: [
                    TextButton(
                        onPressed: () {
                          // print("İptal seçildi");
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "İptal",
                          style: TextStyle(color: Colors.black),
                        )),
                    TextButton(
                        onPressed: () {
                          // print("Kaydet Seçildi");
                          getCurrentUser();
                          hobbiesList.add(tcHobby.text);
                          print("hobby list" + hobbiesList.toString());
                          context
                              .read<HomePageCubit>()
                              .updateUser(currentUser!.userid, hobbiesList)
                              .then((value) {
                            getCurrentUser().then((value) {
                              getHobbies();
                            });
                            _refreshIndicatorKey.currentState?.show();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => const HomePage(),
                              ),
                              (route) => false,
                            );
                          });
                          // Navigator.pop(context);
                          tcHobby.text = "";
                        },
                        child: const Text(
                          "Kaydet",
                          style: TextStyle(color: Colors.black),
                        )),
                  ],
                );
              });
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  final String fullname;
  final String email;
  final String birthdate;
  final String bio;

  UserInfoCard({
    required this.fullname,
    required this.email,
    required this.birthdate,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Adı: $fullname',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $email',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Doğum Tarihi: $birthdate',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Bio: $bio',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class hobbyCard extends StatelessWidget {
  String name;

  hobbyCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Container(
              height: 80,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      width: 8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(name,
                          style: const TextStyle(fontSize: 20),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis)),
                  // r
                ],
              )),
        ),
      ),
    );
  }
}
