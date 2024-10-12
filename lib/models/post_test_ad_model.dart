// To parse this JSON data, do
//
//     final postTestAd = postTestAdFromJson(jsonString);

import 'dart:convert';

PostTestAd postTestAdFromJson(String str) => PostTestAd.fromJson(json.decode(str));

String postTestAdToJson(PostTestAd data) => json.encode(data.toJson());

class PostTestAd {
  bool? status;
  int? responseCode;

  PostTestAd({
    this.status,
    this.responseCode,
  });

  factory PostTestAd.fromJson(Map<String, dynamic> json) => PostTestAd(
    status: json["status"],
    responseCode: json["response_code"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response_code": responseCode,
  };
}
