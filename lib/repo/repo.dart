import 'package:flutter/material.dart';
import 'package:movistar/models/PopularModel.dart';
import 'package:http/http.dart' as http;
import 'package:movistar/models/TopRatedModel.dart';
import 'package:movistar/models/TrendingModel.dart';

class Repository {
  static Future<String> getResponse({required String url}) async {
    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = response.body;
        return data;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  static Future<Popular> getPopularMovies() async {
    String response = await getResponse(
      url:
          "https://api.themoviedb.org/3/movie/popular?api_key=502e894cf5940df8a65af3537e812b5c",
    );
    return popularFromJson(response);
  }

  static Future<Trending> getTrendingMovies() async {
    String response = await getResponse(
      url:
          "https://api.themoviedb.org/3/trending/all/day?api_key=502e894cf5940df8a65af3537e812b5c",
    );
    return trendingFromJson(response);
  }

   static Future<TopRated> getTopRatedMovies() async {
    String response = await getResponse(
      url:
          "https://api.themoviedb.org/3/movie/top_rated?api_key=502e894cf5940df8a65af3537e812b5c",
    );
    return topRatedFromJson(response);
  }
}
