import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:movistar/UI/Widget/LiquidSpinner.dart';
import 'package:movistar/UI/Widget/MovieWidget.dart';
import 'package:movistar/Util/Responsive.dart';
import 'package:movistar/blocs/SearchMovie/search_movie_bloc.dart';
import 'package:pagination_flutter/pagination.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController movieController = TextEditingController()
    ..addListener(() {});

  FocusNode? searchNode;

  int _current = 1;

  @override
  void initState() {
    super.initState();
    searchNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SearchMovieBloc()..add(GetMovie(title: "g", page: 1)),
      child: Scaffold(
          bottomNavigationBar: Pagination(
            numOfPages: 100,
            selectedPage: _current,
            pagesVisible: 3,
            onPageChanged: (page) {
              setState(() {
                _current = page;
                BlocProvider.of<SearchMovieBloc>(context)
                    .add(GetMovie(title: movieController.text, page: page));
              });
            },
            nextIcon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue,
              size: 14,
            ),
            previousIcon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
              size: 14,
            ),
            activeTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            activeBtnStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(38),
                ),
              ),
            ),
            inactiveBtnStyle: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(38),
              )),
            ),
            inactiveTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Colors.black,
          body: SafeArea(
              child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width > 900
                    ? MediaQuery.of(context).size.width * 0.3
                    : MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  onChanged: (value) {
                    BlocProvider.of<SearchMovieBloc>(context)
                        .add(GetMovie(title: value.toLowerCase(), page: 1));
                  },
                  onFieldSubmitted: (value) {
                    BlocProvider.of<SearchMovieBloc>(context)
                        .add(GetMovie(title: value.toLowerCase(), page: 1));
                  },
                  focusNode: searchNode,
                  style: GoogleFonts.poppins(color: Colors.white),
                  controller: movieController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      hintStyle: GoogleFonts.poppins(color: Colors.white),
                      hintText: "Search Movie",
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 1),
                      )),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Responsive.isDesktop(context)
                  ? BlocBuilder<SearchMovieBloc, SearchMovieState>(
                      builder: (context, state) {
                        if (state is Searching) {
                          return Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.5),
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            ),
                          );
                        } else if (state is SearchMovieSuccess) {
                          return Expanded(
                            flex: 1,
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 0.8),
                                itemCount: state.search.results.length,
                                itemBuilder: (context, index) {
                                  return MoviesWidget(
                                      title:
                                          state.search.results[index].title ??
                                              "",
                                      posterPath:
                                          // ignore: prefer_interpolation_to_compose_strings
                                          "https://image.tmdb.org/t/p/w500" +
                                              (state.search.results[index]
                                                      .posterPath ??
                                                  state
                                                      .search
                                                      .results[index + 4]
                                                      .posterPath!),
                                      id: state.search.results[index].id);
                                }),
                          );
                        } else if (state is SearchMovieFail) {
                          return const Center(
                            child: Text(
                              "No results found",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text(
                              "Search for a movie",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                      },
                    )
                  : BlocBuilder<SearchMovieBloc, SearchMovieState>(
                      builder: (context, state) {
                        if (state is Searching) {
                          return const Center(child: SingleChildScrollView());
                        } else if (state is SearchMovieSuccess) {
                          return Expanded(
                            flex: 1,
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        // crossAxisSpacing: 10,
                                        // mainAxisSpacing: 10,
                                        childAspectRatio: 0.55),
                                itemCount: state.search.results.length,
                                itemBuilder: (context, index) {
                                  return MoviesWidget(
                                      title:
                                          state.search.results[index].title ??
                                              "",
                                      posterPath:
                                          // ignore: prefer_interpolation_to_compose_strings
                                          "https://image.tmdb.org/t/p/w500" +
                                              (state.search.results[index]
                                                      .posterPath ??
                                                  state
                                                      .search
                                                      .results[index + 4]
                                                      .posterPath!),
                                      id: state.search.results[index].id);
                                }),
                          );
                        } else if (state is SearchMovieFail) {
                          return Center(
                            child: Text(
                              state.message,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text(
                              "Search for a movie",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                      },
                    ),
            ],
          ))),
    );
  }
}
