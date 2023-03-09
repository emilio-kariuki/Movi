import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movi/Repository/FirebaseRepository.dart';
import 'package:movi/UI/Widget/AuthButton.dart';
import 'package:movi/UI/Widget/MovieWidget.dart';
import 'package:movi/Util/Responsive.dart';
import 'package:movi/models/UserMovies.dart';

enum fav { delete }

class FavouriteMovies extends StatefulWidget {
  const FavouriteMovies({super.key});

  @override
  State<FavouriteMovies> createState() => _FavouriteMoviesState();
}

class _FavouriteMoviesState extends State<FavouriteMovies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Favourites",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: FutureBuilder<List<UserMovies>>(
          future: FirebaseRepository()
              .getUserFilms(id: FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.isDesktop(context)
                          ? 8
                          : Responsive.isTablet(context)
                              ? 7
                              : Responsive.isMobile(context)
                                  ? 3
                                  : 3,
                      childAspectRatio: Responsive.isTablet(context)
                          ? 0.5
                          : Responsive.isDesktop(context)
                              ? 0.6
                              : Responsive.isMobile(context)
                                  ? 0.58
                                  : 0.58),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    return Stack(
                      children: [
                        MoviesWidget(
                            title: snapshot.data![index].title ?? "No title",
                            posterPath:
                                // ignore: prefer_interpolation_to_compose_strings
                                "https://image.tmdb.org/t/p/w500" +
                                    (snapshot.data![index].posterPath ??
                                        snapshot.data![index + 4].posterPath!),
                            id: snapshot.data![index].id ?? 0),
                        Positioned.fill(
                            top: Responsive.isDesktop(context) ? 15 : 5,
                            right: Responsive.isDesktop(context) ? 20 : 1,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: PopupMenuButton<fav>(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                                onSelected: (value) {
                                  switch (value) {
                                    case fav.delete:
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                backgroundColor:
                                                    const Color(0xFF292929),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                title: const Text(
                                                  "Are you sure you want to remove from favourite?",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                                content: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      AuthButton(
                                                        width: 110,
                                                        height: 40,
                                                        borderRadius: 15,
                                                        color: Colors.blue,
                                                        text: "Yes",
                                                        onPressed: () {
                                                          FirebaseRepository()
                                                              .deleteUserFilm(
                                                            filmId: snapshot
                                                                .data![index]
                                                                .id!
                                                                .toString(),
                                                          )
                                                              .then((value) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                              backgroundColor:
                                                                  Colors.green,
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              width: 250,
                                                              content: Text(
                                                                  "Removed from favourites"),
                                                            ));
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {});
                                                          });
                                                        },
                                                      ),
                                                      const Spacer(),
                                                      AuthButton(
                                                        width: 110,
                                                        height: 40,
                                                        borderRadius: 15,
                                                        color: Colors.blue,
                                                        text: "No",
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<fav>>[
                                  const PopupMenuItem<fav>(
                                    value: fav.delete,
                                    child: Text("Delete "),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
