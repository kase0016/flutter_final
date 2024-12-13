import 'dart:ffi';
import 'package:flutter/material.dart';

class Movie {
  String movie_name;
  String date;
  String poster_path;
  double rating;
  int movie_id;

  Movie(
      {required this.movie_name,
      required this.date,
      required this.rating,
      required this.poster_path,
      required this.movie_id});

  factory Movie.fromJson(Map<String, dynamic> movieData) {
    return Movie(
      movie_name: movieData['title'],
      date: movieData['release_date'],
      rating: movieData['vote_average'].toDouble(),
      poster_path: movieData['poster_path'],
      movie_id: movieData['id'],
    );
  }
}
