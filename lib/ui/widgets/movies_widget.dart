import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _kCard = Color(0xFF1A1A2E);

class MoviesWidget extends StatelessWidget {
  const MoviesWidget({
    super.key,
    required this.title,
    required this.posterPath,
    required this.id,
    required this.onTap,
    this.voteAverage = 0.0,
  });

  final int id;
  final String posterPath;
  final String title;
  final double? voteAverage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isWide
            ? MediaQuery.of(context).size.width * 0.10
            : 110,
        margin: const EdgeInsets.only(right: 10, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: posterPath,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: _kCard),
                      errorWidget: (_, __, ___) =>
                          Container(color: _kCard,
                              child: const Icon(Icons.movie_outlined,
                                  color: Colors.white24, size: 32)),
                    ),
                    if ((voteAverage ?? 0) > 0)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Colors.amber, size: 10),
                              const SizedBox(width: 2),
                              Text(
                                voteAverage!.toStringAsFixed(1),
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
