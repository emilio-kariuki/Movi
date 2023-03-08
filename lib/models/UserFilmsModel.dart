// To parse this JSON data, do
//
//     final userFilms = userFilmsFromJson(jsonString);

import 'dart:convert';

UserFilms userFilmsFromJson(String str) => UserFilms.fromJson(json.decode(str));

String userFilmsToJson(UserFilms data) => json.encode(data.toJson());

class UserFilms {
  UserFilms({
    required this.cast,
    required this.crew,
    required this.id,
  });

  List<Casts> cast;
  List<Casts> crew;
  int id;

  factory UserFilms.fromJson(Map<String, dynamic> json) => UserFilms(
        cast: List<Casts>.from(json["cast"].map((x) => Casts.fromJson(x))),
        crew: List<Casts>.from(json["crew"].map((x) => Casts.fromJson(x))),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
        "id": id,
      };
}

class Casts {
  Casts({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
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
    this.character,
    required this.creditId,
    this.order,
    this.department,
    this.job,
  });

  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  OriginalLanguage originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  String releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;
  String? character;
  String creditId;
  int? order;
  String? department;
  String? job;

  factory Casts.fromJson(Map<String, dynamic> json) => Casts(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage:
            originalLanguageValues.map[json["original_language"]] ??
                OriginalLanguage.EN,
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"] ??
            "/sv1xJUazXeYqALzczSZ3O6nkH75.jpg",
        releaseDate: json["release_date"],
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
        character: json["character"],
        creditId: json["credit_id"],
        order: json["order"],
        department: json["department"],
        job: json["job"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguageValues.reverse[originalLanguage],
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "character": character,
        "credit_id": creditId,
        "order": order,
        "department": department,
        "job": job,
      };
}

enum OriginalLanguage { EN }

final originalLanguageValues = EnumValues({"en": OriginalLanguage.EN});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
