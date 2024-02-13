import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userapp/data/entity/users.dart';
import 'package:userapp/data/repo/users_dao_repo.dart';
import 'package:userapp/ui/cubit/loginpage_cubit.dart';
import 'package:userapp/ui/utils/colors.dart';
import 'package:userapp/ui/views/auth/registerpage.dart';
import 'package:userapp/ui/views/pages/homepage.dart';
import 'package:userapp/ui/widgets/custombutton.dart';
import 'package:userapp/ui/widgets/customtext.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var tcEmail = TextEditingController();
  var tcPassword = TextEditingController();
  var krepo = UsersDaoRepository();
  bool isPasswordVisible = false;
  bool isLoginSuccessed = false;
  final formKey = GlobalKey<FormState>();

  Future<void> checkIsLoginSuccessed() async {
    Users? currentUser = await krepo.getCurrentUser();
    if (currentUser != null) {
      isLoginSuccessed = true;
    } else {
      isLoginSuccessed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              customText(
                text: "Giriş Yap",
                fontsize: 24,
                color: mediumColor,
                fontweight: FontWeight.w600,
              ),
              TextFormField(
                controller: tcEmail,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen Boş Alan Bırakmayınız';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: tcPassword,
                decoration: InputDecoration(
                  labelText: "Şifre",
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: lightColor,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen Boş Alan Bırakmayınız';
                  }
                  return null;
                },
                obscureText: !isPasswordVisible,
              ),
              customButton(
                  text: "Giriş Yap",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context
                          .read<LoginPageCubit>()
                          .signIn(tcEmail.text, tcPassword.text)
                          .then((value) {
                        const CircularProgressIndicator();
                        checkIsLoginSuccessed().then((value) {
                          if (isLoginSuccessed) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: dangerColor,
                                content: customText(
                                    text:
                                        "Kullanıcı giriş bilgileri hatalı.\n Lütfen tekrar deneyiniz!",
                                    fontsize: 16,
                                    color: Colors.white,
                                    maxlines: 2,
                                    textOverflow: TextOverflow.visible,
                                    textAlign: TextAlign.center,
                                    ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        });
                      });
                    }
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customText(
                    text: "Hesabınız yok mu?",
                    fontsize: 14,
                    color: mediumColor,
                    fontweight: FontWeight.w600,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => const RegisterPage()));
                    },
                    child: customText(
                        text: "Kayıt Ol",
                        fontsize: 14,
                        color: primaryColor,
                        fontweight: FontWeight.w600),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
