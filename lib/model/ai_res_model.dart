// To parse this JSON data, do
//
//     final aiModel = aiModelFromJson(jsonString);

import 'dart:convert';

AiModel aiModelFromJson(String str) => AiModel.fromJson(json.decode(str));

String aiModelToJson(AiModel data) => json.encode(data.toJson());

class AiModel {
  List<Candidate>? candidates;

  AiModel({
    this.candidates,
  });

  factory AiModel.fromJson(Map<String, dynamic> json) => AiModel(
    candidates: json["candidates"] == null ? [] : List<Candidate>.from(json["candidates"]!.map((x) => Candidate.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "candidates": candidates == null ? [] : List<dynamic>.from(candidates!.map((x) => x.toJson())),
  };
}

class Candidate {
  Content? content;
  String? finishReason;
  int? index;
  List<SafetyRating>? safetyRatings;

  Candidate({
    this.content,
    this.finishReason,
    this.index,
    this.safetyRatings,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
    content: json["content"] == null ? null : Content.fromJson(json["content"]),
    finishReason: json["finishReason"],
    index: json["index"],
    safetyRatings: json["safetyRatings"] == null ? [] : List<SafetyRating>.from(json["safetyRatings"]!.map((x) => SafetyRating.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "content": content?.toJson(),
    "finishReason": finishReason,
    "index": index,
    "safetyRatings": safetyRatings == null ? [] : List<dynamic>.from(safetyRatings!.map((x) => x.toJson())),
  };
}

class Content {
  List<Part>? parts;
  String? role;

  Content({
    this.parts,
    this.role,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    parts: json["parts"] == null ? [] : List<Part>.from(json["parts"]!.map((x) => Part.fromJson(x))),
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "parts": parts == null ? [] : List<dynamic>.from(parts!.map((x) => x.toJson())),
    "role": role,
  };
}

class Part {
  String? text;

  Part({
    this.text,
  });

  factory Part.fromJson(Map<String, dynamic> json) => Part(
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
  };
}

class SafetyRating {
  String? category;
  String? probability;

  SafetyRating({
    this.category,
    this.probability,
  });

  factory SafetyRating.fromJson(Map<String, dynamic> json) => SafetyRating(
    category: json["category"],
    probability: json["probability"],
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "probability": probability,
  };
}
