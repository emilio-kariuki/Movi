import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movistar/UI/Home/HomePage.dart';
import 'package:movistar/blocs/topRated_bloc/top_rated_bloc.dart';
import 'package:movistar/blocs/trending_bloc/trending_bloc.dart';
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
          create: (context) => PopularBloc()..add(GetPopular()),
        ),
        BlocProvider<TrendingBloc>(
          create: (context) => TrendingBloc()..add(GetTrending()),
        ),
        BlocProvider<TopRatedBloc>(
          create: (context) => TopRatedBloc()..add(GetTopRated()),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
