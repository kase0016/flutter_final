import 'dart:ffi';
import 'session.dart';
import 'movie.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HttpHelper {
  final String domain = 'api.themoviedb.org';
  final String path = '3/movie/now_playing';
  final String apiKey = '11991eca1cf4fc1e17cc5cbb25a36635';

  Future<List<Movie>> fetchMovies() async {
    Map<String, dynamic> params = {
      'api_key': apiKey,
      'language': 'en-US',
      'page': '1'
    };

    Uri uri = Uri.https(domain, path, params);

    http.Response response = await http.get(uri);
    Map<String, dynamic> data = jsonDecode(response.body);
    List<dynamic> moviesList = data['results'];

    List<Movie> movies =
        moviesList.map((json) => Movie.fromJson(json)).toList();

    return movies;
  }

  Future<Map<String, dynamic>> startSession(String deviceId) async {
    final String domain = 'movie-night-api.onrender.com';
    final String path = '/start-session';

    Map<String, dynamic> params = {
      'device_id': deviceId,
    };

    Uri uri = Uri.https(domain, path, params);

    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body)['data'];
        return data;
      } else {
        throw Exception(
            'Failed to start session: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error starting session: $e');
    }
  }

  Future<Map<String, dynamic>> joinSession(String deviceId, int code) async {
    final String domain = 'movie-night-api.onrender.com';
    final String path = '/join-session';

    Map<String, dynamic> params = {'device_id': deviceId, 'code': code};
    print('Request Params: $params');
    Uri uri = Uri.https(domain, path, params);

    try {
      http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body)['data'];
        return data;
      } else {
        throw Exception(
            'Failed to start session: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error starting session: $e');
    }
  }

  Future<Map<String, dynamic>> voteMovie(
      String session_code, int movie_id, bool vote) async {
    final String domain = 'movie-night-api.onrender.com';
    final String path = '/vote-movie';

    Map<String, dynamic> params = {
      'session_id': session_code,
      'movie_id': movie_id.toString(),
      'vote': vote.toString()
    };

    Uri uri = Uri.https(domain, path, params);

    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final decodeRes = jsonDecode(response.body);
        return decodeRes;
      } else {
        throw Exception(
            'Failed to vote: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error starting session: $e');
    }
  }
}
