import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movi/UI/Auth/Details/MovieDetailsPage.dart';
import 'package:movi/Util/Responsive.dart';
import 'package:movi/blocs/userCasts_bloc/user_bloc.dart';

class CastDetails extends StatefulWidget {
  final String id;
  const CastDetails({super.key, required this.id});

  @override
  State<CastDetails> createState() => _CastDetailsState();
}

class _CastDetailsState extends State<CastDetails> {
  // late final UserBloc _userBloc;

  // @override
  // void initState() {
  //   super.initState();
  //   _userBloc = BlocProvider.of<UserBloc>(context)
  //     ..add(GetUser(id: int.parse(widget.id)));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider(
        create: (context) => UserBloc()
          ..add(GetUser(id: int.parse(widget.id)))
          ..add(GetUserFilms(id: int.parse(widget.id))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  } else if (state is UserLoaded) {
                    return SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              CachedNetworkImage(
                                height: Responsive.isDesktop(context)
                                    ? MediaQuery.of(context).size.height * 0.5
                                    : MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.width,
                                imageUrl:
                                    "https://image.tmdb.org/t/p/original/${state.user.profilePath}",
                                fit: BoxFit.cover,
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                              Positioned.fill(
                                top: Responsive.isDesktop(context) ||
                                        Responsive.isTablet(context)
                                    ? 0
                                    : 35,
                                bottom: Responsive.isDesktop(context) ||
                                        Responsive.isTablet(context)
                                    ? 10
                                    : 0,
                                left: Responsive.isDesktop(context) ||
                                        Responsive.isTablet(context)
                                    ? 30
                                    : 10,
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CachedNetworkImage(
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  900
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.18,
                                          width:
                                              MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      900
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.12
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                          imageUrl:
                                              "https://image.tmdb.org/t/p/original/${state.user.profilePath}",
                                          fit: BoxFit.cover,
                                          imageBuilder:
                                              (context, imageProvider) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Responsive.isDesktop(context) ||
                                                Responsive.isTablet(context)
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "${state.user.name} ",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.1),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    // ignore: prefer_interpolation_to_compose_strings
                                                    state.user
                                                            .knownForDepartment +
                                                        formatedDate(
                                                            date: state.user
                                                                .birthday) +
                                                        " - " +
                                                        state.user.placeOfBirth,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        letterSpacing: 0.1),
                                                  ),
                                                ],
                                              )
                                            : Container()
                                      ],
                                    )),
                              ),
                              Responsive.isDesktop(context)
                                  ? Container()
                                  : Positioned.fill(
                                      top: 3,
                                      left: 10,
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                          )),
                                    ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width >
                                        600
                                    ? MediaQuery.of(context).size.width * 0.01
                                    : 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Responsive.isDesktop(context) ||
                                        Responsive.isTablet(context)
                                    ? Container()
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "${state.user.name} ",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.1),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            // ignore: prefer_interpolation_to_compose_strings
                                            state.user.knownForDepartment +
                                                formatedDate(
                                                    date: state.user.birthday) +
                                                " - " +
                                                state.user.placeOfBirth,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.1),
                                          ),
                                        ],
                                      ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  state.user.biography,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Responsive.isDesktop(context) ||
                                              Responsive.isTablet(context)
                                          ? 16
                                          : 14,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.1),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "Films",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.1),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.width >
                                          900
                                      ? MediaQuery.of(context).size.height * 0.4
                                      : MediaQuery.of(context).size.height *
                                          0.3,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.userFilms.cast.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              // height: MediaQuery.of(context).size.height * 0.1,
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      900
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      MovieDetails(
                                                                        id: state
                                                                            .userFilms
                                                                            .cast[index]
                                                                            .id
                                                                            .toString(),
                                                                      )));
                                                      // Navigator.pushNamed(context, "movieDetails
                                                    },
                                                    child: CachedNetworkImage(
                                                      height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width >
                                                              900
                                                          ? MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.3
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.2,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      imageUrl:
                                                          "https://image.tmdb.org/t/p/original/${state.userFilms.cast[index].posterPath}",
                                                      fit: BoxFit.cover,
                                                      imageBuilder: (context,
                                                          imageProvider) {
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      placeholder:
                                                          (context, url) =>
                                                              const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 3,
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    state.userFilms.cast[index]
                                                        .title,
                                                    // overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    state.userFilms.cast[index]
                                                            .character ??
                                                        "unknown",
                                                    // overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (state is UserError) {
                    return const Center(
                        child: Text(
                      "No cast details found",
                      style: TextStyle(color: Colors.white),
                    ));
                  } else {
                    return const Center(
                        child: Text(
                      "No cast details found",
                      style: TextStyle(color: Colors.white),
                    ));
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  formatedDate({required DateTime date}) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
