import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MoviesWidget extends StatelessWidget {
  final String title;
  final String posterPath;
  const MoviesWidget({
    super.key,
    required this.title,
    required this.posterPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
      child: SizedBox(
        // height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.3,
              imageUrl: posterPath,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              // overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
