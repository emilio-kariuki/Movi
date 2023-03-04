import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movistar/Repository/AuthRepository.dart';
import 'package:movistar/UI/Auth/LoginPage.dart';
import 'package:movistar/UI/Auth/LoginPageWeb.dart';
import 'package:movistar/UI/Auth/RegisterPage.dart';
import 'package:movistar/UI/Details/Cast/CastWidgetPage.dart';
import 'package:movistar/UI/Details/MovieDetailsPage.dart';
import 'package:movistar/UI/Home/HomePage.dart';
import 'package:movistar/UI/Home/SearchPage.dart';
import 'package:movistar/Util/Responsive.dart';
import 'package:movistar/Util/SharedPreferencesManager.dart';
import 'package:movistar/blocs/Auth/auth_bloc.dart';
import 'package:movistar/blocs/Authentication/authentication_bloc.dart';
import 'package:movistar/blocs/Casts_bloc/casts_bloc.dart';
import 'package:movistar/blocs/Homebloc/home_bloc.dart';
import 'package:movistar/blocs/SearchMovie/search_movie_bloc.dart';
import 'package:movistar/blocs/movieDetails_bloc/movie_details_bloc.dart';
import 'package:movistar/blocs/movieGenre_bloc/movie_genre_bloc.dart';
import 'package:movistar/blocs/similar_bloc/similar_bloc.dart';
   import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc()..add(AppStarted()),
      child: MaterialApp(
        scrollBehavior:
            const MaterialScrollBehavior().copyWith(dragDevices: {
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
              return Responsive.isMobile(context)
                  ? const Login()
                  : const Login();
            } else if (state is AuthenticationAuthenticated) {
              return Home();
            } else if (state is AuthenticationUnauthenticated) {
              return Responsive.isMobile(context)
                  ? const Login()
                  : const Login();
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
