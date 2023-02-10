// To parse this JSON data, do
//
//     final trending = trendingFromJson(jsonString);

import 'dart:convert';

Trending trendingFromJson(String str) => Trending.fromJson(json.decode(str));

String trendingToJson(Trending data) => json.encode(data.toJson());

class Trending {
    Trending({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    int page;
    List<Result> results;
    int totalPages;
    int totalResults;

    factory Trending.fromJson(Map<String, dynamic> json) => Trending(
        page: json["page"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}

class Result {
    Result({
        required this.adult,
        required this.backdropPath,
        required this.id,
        this.title,
        required this.originalLanguage,
        this.originalTitle,
        required this.overview,
        required this.posterPath,
        required this.mediaType,
        required this.genreIds,
        required this.popularity,
        this.releaseDate,
        this.video,
        required this.voteAverage,
        required this.voteCount,
        this.name,
        this.originalName,
        this.firstAirDate,
        this.originCountry,
    });

    bool adult;
    String ?backdropPath;
    int id;
    String? title;
    String originalLanguage;
    String? originalTitle;
    String ?overview;
    String ?posterPath;
    MediaType ? mediaType;
    List<int> ?genreIds;
    double ?popularity;
    DateTime? releaseDate;
    bool? video;
    double? voteAverage;
    int ?voteCount;
    String? name;
    String? originalName;
    DateTime? firstAirDate;
    List<String>? originCountry;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        adult: json["adult"],
        backdropPath: json["backdrop_path"] ?? "",
        id: json["id"],
        title: json["title"],
        originalLanguage: json["original_language"] ?? "en",
        originalTitle: json["original_title"],
        overview: json["overview"] ?? "",
        posterPath: json["poster_path"] ?? "",
        mediaType: mediaTypeValues.map[json["media_type"]] ?? MediaType.MOVIE,
        genreIds: json["genre_ids"] == null ? [] : List<int>.from(json["genre_ids"]!.map((x) => x)),
        popularity: json["popularity"]?? 0.0,
        releaseDate: json["release_date"] == null ? DateTime.now() : DateTime.parse(json["release_date"]),
        video: json["video"],
        voteAverage: json["vote_average"] ?? 0.0,
        voteCount: json["vote_count"] ?? 0,
        name: json["name"],
        originalName: json["original_name"],
        firstAirDate: json["first_air_date"] == null ? null : DateTime.parse(json["first_air_date"]),
        originCountry: json["origin_country"] == null ? [] : List<String>.from(json["origin_country"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "id": id,
        "title": title,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "poster_path": posterPath,
        "media_type": mediaTypeValues.reverse[mediaType],
        "genre_ids": List<dynamic>.from(genreIds!.map((x) => x)),
        "popularity": popularity,
        "release_date": "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "name": name,
        "original_name": originalName,
        "first_air_date": "${firstAirDate!.year.toString().padLeft(4, '0')}-${firstAirDate!.month.toString().padLeft(2, '0')}-${firstAirDate!.day.toString().padLeft(2, '0')}",
        "origin_country": originCountry == null ? [] : List<dynamic>.from(originCountry!.map((x) => x)),
    };
}

enum MediaType { MOVIE, TV }

final mediaTypeValues = EnumValues({
    "movie": MediaType.MOVIE,
    "tv": MediaType.TV
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
