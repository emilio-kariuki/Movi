// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

import 'dart:convert';

SearchModel searchModelFromJson(String str) =>
    SearchModel.fromJson(json.decode(str));

String searchModelToJson(SearchModel data) => json.encode(data.toJson());

class SearchModel {
  SearchModel({
    this.page,
    required this.results,
    this.totalPages,
    this.totalResults,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        page: json["page"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  int? page;
  List<Result> results;
  int? totalPages;
  int? totalResults;

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

class Result {
  Result({
    required this.id,
    this.title,
    this.posterPath,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        posterPath: json["poster_path"],
        title: json["title"],
      );

  int id;
  String? posterPath;
  String? title;

  Map<String, dynamic> toJson() => {
        "id": id,
        "poster_path": posterPath,
        "title": title,
      };
}
