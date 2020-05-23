import 'dart:async';
import 'package:flurest/models/movie_response.dart';
import 'package:flurest/networking/api_response.dart';
import 'package:flurest/repository/movie_detail_repository.dart';

class MovieDetailBloc {
  MovieDetailRepository _movieDetailRepository;

  StreamController _movieDetailController;

  StreamSink<ApiResponse<Movie>> get movieDetailSink =>
      _movieDetailController.sink;

  Stream<ApiResponse<Movie>> get movieDetailStream =>
      _movieDetailController.stream;

  MovieDetailBloc(selectedMovie) {
    _movieDetailController = StreamController<ApiResponse<Movie>>();
    _movieDetailRepository = MovieDetailRepository();
    fetchMovieDetail(selectedMovie);
  }

  fetchMovieDetail(int selectedMovie) async {
    movieDetailSink.add(ApiResponse.loading('Fetching Details'));
    try {
      Movie details =
          await _movieDetailRepository.fetchMovieDetail(selectedMovie);
      movieDetailSink.add(ApiResponse.completed(details));
    } catch (e) {
      movieDetailSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _movieDetailController?.close();
  }
}
