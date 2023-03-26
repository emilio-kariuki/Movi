import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movi/UI/auth/Details/movie_details_page.dart';
import 'package:movi/util/responsive.dart';

class MoviesWidget extends StatelessWidget {
  const MoviesWidget({
    super.key,
    required this.title,
    required this.posterPath,
    required this.id,
    this.voteAverage = 0.7,
  });

  final int id;
  final String posterPath;
  final String title;
  final double? voteAverage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: Responsive.isDesktop(context) ? 20 : 5, top: 10, bottom: 2),
      child: SizedBox(
        height: MediaQuery.of(context).size.width > 900
            ? MediaQuery.of(context).size.height * 0.35
            : MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width > 900
            ? MediaQuery.of(context).size.width * 0.12
            : MediaQuery.of(context).size.width * 0.31,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MovieDetails(
                          id: id.toString(),
                        )));

                debugPrint("the movie id is $id");
              },
              child: CachedNetworkImage(
                height: MediaQuery.of(context).size.width > 900
                    ? MediaQuery.of(context).size.height * 0.3
                    : MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width > 900
                    ? MediaQuery.of(context).size.width * 0.12
                    : MediaQuery.of(context).size.width * 0.3,
                imageUrl: posterPath,
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                errorWidget: (context, url, error) => const Icon(
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
              title,
              overflow: TextOverflow.clip,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
