import 'package:flutter/material.dart';
import 'dart:async';
import '../data/http_helper.dart';
import '../data/movie.dart';

class MovieSelectPage extends StatefulWidget {
  final String session;
  const MovieSelectPage({super.key, required this.session});

  @override
  _MovieSelectState createState() => _MovieSelectState();
}

class _MovieSelectState extends State<MovieSelectPage> {
  late Future<List<Movie>> movies;
  late Future<Map<String, dynamic>>? voteResponse;
  int currentMovie = 0;

  @override
  void initState() {
    super.initState();
    movies = HttpHelper().fetchMovies();
  }

  void _voteAndNext(bool isLiked, int movieId) async {
    try {
      final result =
          await HttpHelper().voteMovie(widget.session, movieId, isLiked);

      setState(() {
        voteResponse = Future.value(result);
      });
    } catch (e) {
      print('Error voting for movie: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to vote for the movie')),
      );
    } finally {
      setState(() {
        currentMovie = (currentMovie + 1) % 20;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Movie>>(
          future: movies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Movie movie = snapshot.data![currentMovie];
              return Center(
                child: Dismissible(
                  key: Key(movie.movie_id.toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      // Swipe right: Like
                      print("Liked: ${movie.movie_name}");
                      _voteAndNext(true, movie.movie_id);
                    } else if (direction == DismissDirection.endToStart) {
                      // Swipe left: Dislike
                      print("Disliked: ${movie.movie_name}");
                      _voteAndNext(false, movie.movie_id);
                    }
                  },
                  background: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: const [
                        Icon(Icons.thumb_up, color: Colors.black, size: 40),
                        SizedBox(width: 10),
                        Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          "Nope",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.thumb_down, color: Colors.black, size: 40),
                      ],
                    ),
                  ),
                  child: Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          'https://image.tmdb.org/t/p/w500/${movie.poster_path}',
                          width: 275,
                          height: 475,
                          fit: BoxFit.contain,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 27),
                                const Icon(Icons.movie, size: 40),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    movie.movie_name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(width: 27),
                                const Icon(Icons.star,
                                    size: 40, color: Colors.amber),
                                const SizedBox(width: 10),
                                Text(
                                  '${movie.rating.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(width: 27),
                                const Icon(Icons.date_range,
                                    size: 40, color: Colors.blue),
                                const SizedBox(width: 10),
                                Text(
                                  movie.date,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
