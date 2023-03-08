// To parse this JSON data, do
//
//     final genres = genresFromJson(jsonString);

import 'dart:convert';

Genres genresFromJson(String str) => Genres.fromJson(json.decode(str));

String genresToJson(Genres data) => json.encode(data.toJson());

class Genres {
    Genres({
        required this.genres,
    });

    List<Genre> genres;

    factory Genres.fromJson(Map<String, dynamic> json) => Genres(
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    };
}

class Genre {
    Genre({
        required this.id,
        required this.name,
    });

    int id;
    String name;

    factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
