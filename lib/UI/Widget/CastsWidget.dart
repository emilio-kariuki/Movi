import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movistar/UI/Details/Cast/CastWidgetPage.dart';
import 'package:movistar/blocs/userCasts_bloc/user_bloc.dart';

class CastsWidget extends StatelessWidget {
  final String? posterPath;
  final String castId;
  final String name;
  final String role;
  const CastsWidget(
      {super.key,
      required this.posterPath,
      required this.castId,
      required this.name,
      required this.role});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, ),
      child: SizedBox(
        // height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width > 900
            ? MediaQuery.of(context).size.width * 0.12
            : MediaQuery.of(context).size.width * 0.27 ,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                debugPrint("cast id is $castId");
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CastDetails(id: castId,)));
                
              },
              child: CachedNetworkImage(
                height: MediaQuery.of(context).size.height > 400
                    ? MediaQuery.of(context).size.height * 0.2
                    : MediaQuery.of(context).size.height * 0.2,
                imageUrl: "https://image.tmdb.org/t/p/w500$posterPath",
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
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
            MediaQuery.of(context).size.width> 900 ? const SizedBox(
              height: 10,
            ) : Container(),
            Text(
              name,
              // overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 1,
            ),
            Text(
              role,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
