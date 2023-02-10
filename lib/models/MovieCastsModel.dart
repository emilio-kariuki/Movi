// To parse this JSON data, do
//
//     final cast = castFromJson(jsonString);

import 'dart:convert';

Cast castFromJson(String str) => Cast.fromJson(json.decode(str));

String castToJson(Cast data) => json.encode(data.toJson());

class Cast {
    Cast({
        required this.id,
        required this.cast,
        required this.crew,
    });

    int id;
    List<CastElement> cast;
    List<CastElement> crew;

    factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        id: json["id"],
        cast: List<CastElement>.from(json["cast"].map((x) => CastElement.fromJson(x))),
        crew: List<CastElement>.from(json["crew"].map((x) => CastElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
    };
}

class CastElement {
    CastElement({
        required this.adult,
        required this.gender,
        required this.id,
        required this.knownForDepartment,
        required this.name,
        required this.originalName,
        required this.popularity,
        this.profilePath,
        this.castId,
        this.character,
        required this.creditId,
        this.order,
        this.department,
        this.job,
    });

    bool adult;
    int gender;
    int id;
    String knownForDepartment;
    String name;
    String originalName;
    double popularity;
    String? profilePath;
    int? castId;
    String? character;
    String creditId;
    int? order;
    String? department;
    String? job;

    factory CastElement.fromJson(Map<String, dynamic> json) => CastElement(
        adult: json["adult"],
        gender: json["gender"],
        id: json["id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        originalName: json["original_name"],
        popularity: json["popularity"]?.toDouble(),
        profilePath: json["profile_path"] ?? "/oTB9vGIBacH5aQNS0pUM74QSWuf.jpg",
        castId: json["cast_id"],
        character: json["character"],
        creditId: json["credit_id"],
        order: json["order"],
        department: json["department"],
        job: json["job"],
    );

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "gender": gender,
        "id": id,
        "known_for_department": knownForDepartment,
        "name": name,
        "original_name": originalName,
        "popularity": popularity,
        "profile_path": profilePath,
        "cast_id": castId,
        "character": character,
        "credit_id": creditId,
        "order": order,
        "department": department,
        "job": job,
    };
}
