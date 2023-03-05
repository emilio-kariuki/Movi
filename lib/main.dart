import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movistar/UI/Auth/LoginPage.dart';
import 'package:movistar/UI/Home/HomePage.dart';
import 'package:movistar/blocs/Authentication/authentication_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthenticationBloc? authenticationBloc;
  @override
  void initState() {
    super.initState();
    authenticationBloc = AuthenticationBloc()
      ..add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authenticationBloc!,
      child: MaterialApp(
        scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        }),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationUnitialized) {
              return const Login();
            } else if (state is AuthenticationAuthenticated) {
              return Home();
            } else if (state is AuthenticationUnauthenticated) {
              return const Login();
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
