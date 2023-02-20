import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movistar/UI/Details/Cast/CastWidgetPage.dart';
import 'package:movistar/UI/Details/MovieDetailsPage.dart';
import 'package:movistar/UI/Home/HomePage.dart';
import 'package:movistar/UI/Home/SearchPage.dart';
import 'package:movistar/blocs/Casts_bloc/casts_bloc.dart';
import 'package:movistar/blocs/SearchMovie/search_movie_bloc.dart';
import 'package:movistar/blocs/movieDetails_bloc/movie_details_bloc.dart';
import 'package:movistar/blocs/movieGenre_bloc/movie_genre_bloc.dart';
import 'package:movistar/blocs/similar_bloc/similar_bloc.dart';

import 'blocs/bloc/home_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       
        BlocProvider<MovieDetailsBloc>(
          create: (context) =>
              MovieDetailsBloc()..add(GetMovieDetails(movieId: 24)),
        ),
        BlocProvider<CastsBloc>(
          create: (context) => CastsBloc()..add(GetCasts(movieId: 24)),
        ),
        BlocProvider<SimilarBloc>(
          create: (context) => SimilarBloc()..add(GetSimilar(movieId: 24)),
        ),
         BlocProvider<MovieGenreBloc>(
          create: (context) => MovieGenreBloc()..add(GetMovieGenre()),
        ),
        BlocProvider<SearchMovieBloc>(
          create: (context) => SearchMovieBloc()..add(const SearchInitiated(title: "Kenya"))
          
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc()..add(GetHome(page: 1)),
        ),
        
      ],
      child: MaterialApp.router(
        scrollBehavior: const MaterialScrollBehavior().copyWith( dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch,}),
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return Home();
      },
    ),
    GoRoute(
      path: '/movieDetails',
      name: 'movieDetails',
      builder: (context, state) => MovieDetails(
        id: state.queryParams['id'] ?? '',
      ),
    ),
    GoRoute(
        path: '/castDetails',
        name: 'castDetails',
        builder: (context, state) =>
            CastDetails(id: state.queryParams['id'] ?? '')),
    GoRoute(
      path: "/search",
      name: "search",
      builder: (context, state) => const SearchPage(),

    ),
  ],
);
