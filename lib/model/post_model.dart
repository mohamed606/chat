import 'package:flutter/cupertino.dart';

class PostModel {
  late String name;
  late String userId;
  late String profilePic;
  late String dateTime;
  late String text;
  late String postImage;

  PostModel(this.name, this.userId, this.profilePic, this.dateTime, this.text,
      this.postImage);

  PostModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    name = json['name'];
    userId = json['userId'];
    profilePic = json['profilePic'];
    dateTime = json['dateTime'];
    text = json['text'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'userId': userId,
        'profilePic': profilePic,
        'dateTime': dateTime,
        'text': text,
        'postImage': postImage,
      };
}
