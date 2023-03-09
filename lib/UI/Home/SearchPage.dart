import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:movi/UI/Widget/MovieWidget.dart';
import 'package:movi/Util/Responsive.dart';
import 'package:movi/blocs/SearchMovie/search_movie_bloc.dart';
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
          SearchMovieBloc()..add(GetMovie(title: "a", page: 2)),
      child: Builder(builder: (context) {
        return Scaffold(
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
                    child: Responsive.isMobile(context)
                        ? Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 5),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(child: SearchBar(context)),
                            ],
                          )
                        : SearchBar(context)),
                const SizedBox(
                  height: 10,
                ),
                Responsive.isDesktop(context)
                    ? BlocBuilder<SearchMovieBloc, SearchMovieState>(
                        builder: (_, state) {
                          if (state is Searching) {
                            return Container(
                              margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.5),
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
                                          crossAxisCount: 8,
                                         
                                          childAspectRatio: 0.65),
                                  itemCount: state.search.results.length,
                                  itemBuilder: (_, index) {
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
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: const Text(
                                  "No results found",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: const Text(
                                  "Search for a movie",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : BlocBuilder<SearchMovieBloc, SearchMovieState>(
                        builder: (_, state) {
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
                                  itemBuilder: (_, index) {
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
            )));
      }),
    );
  }

  TextFormField SearchBar(BuildContext context) {
    return TextFormField(
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
              size: 20,
            ),
          ),
          hintStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 12  ),
          hintText: "Search Movie",
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent, width: 1),
          )),
    );
  }
}
