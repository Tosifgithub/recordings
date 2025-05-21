import 'package:flutter/material.dart';

class Recording {
  final String title;
  final String path;
  final Color color;

  Recording({required this.title, required this.path, required this.color});

  Map<String, dynamic> toJson() => {
    'title': title,
    'path': path,
    'color': color.value,
  };

  factory Recording.fromJson(Map<String, dynamic> json) => Recording(
    title: json ['title'],
    path: json['path'],
    color: Color(json['color']),
  );
}

