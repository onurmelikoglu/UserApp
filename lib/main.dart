import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userapp/ui/cubit/homepage_cubit.dart';
import 'package:userapp/ui/cubit/loginpage_cubit.dart';
import 'package:userapp/ui/cubit/registerpage_cubit.dart';
import 'package:userapp/ui/utils/colors.dart';
import 'package:userapp/ui/views/pages/splashpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: invalid_use_of_visible_for_testing_member
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginPageCubit()),
        BlocProvider(create: (context) => RegisterPageCubit()),
        BlocProvider(create: (context) => HomePageCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}