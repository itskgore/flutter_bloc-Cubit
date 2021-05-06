import 'package:cubitbloc/models/moviesModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieRepo {
  Future<List<Movies>> getMovies([String movieName]) async {
    try {
      final result = await http.Client().get(movieName == null
          ? "https://www.episodate.com/api/most-popular?page=1"
          : "https://www.episodate.com/api/search?q=$movieName&page=1");
      if (result.statusCode != 200) {
        throw Exception("Error");
      }
      final jsonData = json.decode(result.body) as Map<String, dynamic>;
      List<Movies> _movies = [];
      jsonData['tv_shows'].forEach((json) {
        _movies.add(Movies.fromJson(json));
      });
      return _movies;
    } catch (e) {
      throw Exception("Error");
    }
  }
}
