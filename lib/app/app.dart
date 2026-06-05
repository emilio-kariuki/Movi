import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../services/movie_service.dart';
import '../services/preferences_service.dart';
import '../ui/views/cast_details/cast_details_view.dart';
import '../ui/views/favourites/favourites_view.dart';
import '../ui/views/genre_movies/genre_movies_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/keyword_movies/keyword_movies_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/movie_details/movie_details_view.dart';
import '../ui/views/popular_movies/popular_movies_view.dart';
import '../ui/views/profile/profile_view.dart';
import '../ui/views/register/register_view.dart';
import '../ui/views/search/search_view.dart';
import '../ui/views/startup/startup_view.dart';
import '../ui/views/top_rated_movies/top_rated_movies_view.dart';
import '../ui/views/trending_movies/trending_movies_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, initial: true),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: MovieDetailsView),
    MaterialRoute(page: SearchView),
    MaterialRoute(page: GenreMoviesView),
    MaterialRoute(page: KeywordMoviesView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: CastDetailsView),
    MaterialRoute(page: FavouritesView),
    MaterialRoute(page: PopularMoviesView),
    MaterialRoute(page: TopRatedMoviesView),
    MaterialRoute(page: TrendingMoviesView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: MovieService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: FirebaseService),
    LazySingleton(classType: PreferencesService),
  ],
)
class App {}
