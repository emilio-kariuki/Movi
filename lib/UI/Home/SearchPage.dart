import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movistar/UI/Details/Widgets/LiquidSpinner.dart';
import 'package:movistar/UI/Home/Widget/MovieWidget.dart';
import 'package:movistar/blocs/SearchMovie/search_movie_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchMovieBloc get _searchMovieBloc =>
      BlocProvider.of<SearchMovieBloc>(context)
        ..add(const SearchInitiated(title: "Kenya"));
  TextEditingController? movieController;
  FocusNode? searchNode;
  @override
  void initState() {
    super.initState();
    movieController = TextEditingController()..addListener(() {});
    searchNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 50,
              child: TextFormField(
                controller: movieController,
                focusNode: searchNode,
                onFieldSubmitted: (value) {
                  _searchMovieBloc.add(SearchInitiated(title: value));
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.white, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            BlocBuilder<SearchMovieBloc, SearchMovieState>(
              builder: (context, state) {
                if (state is Searching) {
                  return const Center(
                    child: LiquidSpinner(height: 50, time: 10),
                  );
                } else if (state is SearchMovieSuccess) {
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      itemCount: state.search.results.length,
                      itemBuilder: (context, index) {
                        return MoviesWidget(
                            title: state.search.results[index].title ?? "",
                            posterPath:
                                state.search.results[index].posterPath ?? "",
                            id: state.search.results[index].id);
                      });
                } else if (state is SearchMovieFail) {
                  return const Center(
                    child: Text("No results found"),
                  );
                } else {
                  return const Center(
                    child: Text("Search for a movie"),
                  );
                }
              },
            )
          ],
        )));
  }
}
