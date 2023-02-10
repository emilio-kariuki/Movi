import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movistar/UI/Details/Cast/CastWidgetPage.dart';
import 'package:movistar/UI/Details/MovieDetailsPage.dart';
import 'package:movistar/UI/Home/HomePage.dart';
import 'package:movistar/blocs/Casts_bloc/casts_bloc.dart';
import 'package:movistar/blocs/genre_bloc/genre_bloc_bloc.dart';
import 'package:movistar/blocs/movieDetails_bloc/movie_details_bloc.dart';
import 'package:movistar/blocs/movieGenre_bloc/movie_genre_bloc.dart';
import 'package:movistar/blocs/similar_bloc/similar_bloc.dart';
import 'package:movistar/blocs/topRated_bloc/top_rated_bloc.dart';
import 'package:movistar/blocs/trending_bloc/trending_bloc.dart';
import 'package:movistar/blocs/userCasts_bloc/user_bloc.dart';
import 'package:movistar/models/TopRatedModel.dart';

import 'blocs/popular_bloc/popular_bloc.dart';

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
        BlocProvider<PopularBloc>(
          create: (context) => PopularBloc()..add(GetPopular(1)),
        ),
        BlocProvider<TrendingBloc>(
          create: (context) => TrendingBloc()..add(GetTrending(1)),
        ),
        BlocProvider<TopRatedBloc>(
          create: (context) => TopRatedBloc()..add(GetTopRated(1)),
        ),
        BlocProvider<GenreBlocBloc>(
            create: (context) => GenreBlocBloc()..add(GetGenre(1))),
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
        // BlocProvider<UserBloc>(
        //   create: (context) => UserBloc()
        //     ..add(GetUser(id: 24))
        //     ..add(GetUserFilms(id: 24)),
        // )
      ],
      child: MaterialApp.router(
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
  ],
);
