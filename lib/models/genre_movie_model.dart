// To parse this JSON data, do
//
//     final genreMovie = genreMovieFromJson(jsonString);

import 'dart:convert';

GenreMovie genreMovieFromJson(String str) => GenreMovie.fromJson(json.decode(str));

String genreMovieToJson(GenreMovie data) => json.encode(data.toJson());

class GenreMovie {
    GenreMovie({
        required this.createdBy,
        required this.description,
        required this.favoriteCount,
        required this.id,
        required this.items,
        required this.itemCount,
        required this.iso6391,
        required this.name,
        this.posterPath,
    });

    String createdBy;
    String description;
    int favoriteCount;
    String id;
    List<Item> items;
    int itemCount;
    String iso6391;
    String name;
    dynamic posterPath;

    factory GenreMovie.fromJson(Map<String, dynamic> json) => GenreMovie(
        createdBy: json["created_by"],
        description: json["description"],
        favoriteCount: json["favorite_count"],
        id: json["id"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        itemCount: json["item_count"],
        iso6391: json["iso_639_1"],
        name: json["name"],
        posterPath: json["poster_path"],
    );

    Map<String, dynamic> toJson() => {
        "created_by": createdBy,
        "description": description,
        "favorite_count": favoriteCount,
        "id": id,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "item_count": itemCount,
        "iso_639_1": iso6391,
        "name": name,
        "poster_path": posterPath,
    };
}

class Item {
    Item({
        required this.adult,
        this.backdropPath,
        required this.genreIds,
        required this.id,
        required this.mediaType,
        required this.originalLanguage,
        required this.originalTitle,
        required this.overview,
        required this.popularity,
        this.posterPath,
        required this.releaseDate,
        required this.title,
        required this.video,
        required this.voteAverage,
        required this.voteCount,
    });

    bool adult;
    String? backdropPath;
    List<int> genreIds;
    int id;
    MediaType mediaType;
    OriginalLanguage originalLanguage;
    String originalTitle;
    String overview;
    double popularity;
    String? posterPath;
    DateTime releaseDate;
    String title;
    bool video;
    double voteAverage;
    int voteCount;

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        mediaType: mediaTypeValues.map[json["media_type"]]!,
        originalLanguage: originalLanguageValues.map[json["original_language"]]!,
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
    );

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "media_type": mediaTypeValues.reverse[mediaType],
        "original_language": originalLanguageValues.reverse[originalLanguage],
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
    };
}

enum MediaType { MOVIE }

final mediaTypeValues = EnumValues({
    "movie": MediaType.MOVIE
});

enum OriginalLanguage { EN }

final originalLanguageValues = EnumValues({
    "en": OriginalLanguage.EN
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
