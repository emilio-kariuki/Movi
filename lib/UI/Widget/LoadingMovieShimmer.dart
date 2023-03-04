import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RectangleShimmer extends StatelessWidget {
  const RectangleShimmer({Key? key, this.height, this.width, this.child})
      : super(key: key);

  final double? height, width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 2),
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      direction: ShimmerDirection.ltr,
      enabled: true,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(10 / 2),
        decoration:  BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)),
        child: Center(child: child),
      ),
    );
  }
}

class ShowShimmerLoading extends StatelessWidget {
  const ShowShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.27,
      child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
            child: RectangleShimmer(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.3,
              child: const Icon(
                Icons.movie,
                size: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}
