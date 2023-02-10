import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatelessWidget {
  final double width ;
  final String path;
   const CarouselImage({super.key, required this.width, required this.path});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CachedNetworkImage(
        height: MediaQuery.of(context).size.height * 0.2,
        width: width,
        imageUrl:
            "https://image.tmdb.org/t/p/w500$path",
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
    );
  }
}
