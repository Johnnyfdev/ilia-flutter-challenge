import 'package:cineapp/error/movie_error.dart';
import 'package:cineapp/modules/movie/models/movie.dart';
import 'package:cineapp/modules/movie/models/movie_response.dart';
import 'package:cineapp/modules/movie/repository/movie_repository.dart';
import 'package:dartz/dartz.dart';

class MovieController {
  final _repository = MovieRepository();

  MovieResponseModel? movieResponseModel;
  MovieError? movieError;
  bool loading = true;

  List<MovieModel> get movies => movieResponseModel?.movies ?? <MovieModel>[];
  int get moviesCount => movies.length;
  bool get hasMovies => moviesCount != 0;
  int get totalPages => movieResponseModel?.totalPages ?? 1;
  int get currentPage => movieResponseModel?.page ?? 1;

  Future<Either<MovieError, MovieResponseModel>> fetchAllMovies(
      {int page = 1}) async {
    movieError = null;
    final result = await _repository.fetchPopularMovies(page);
    result!.fold(
      (error) => movieError = error,
      (movie) {
        if (movieResponseModel == null) {
          movieResponseModel = movie;
        } else {
          movieResponseModel!.page = movie.page;
          //Simulando Scroll Infinito
          movieResponseModel!.movies!.addAll(movie.movies as List<MovieModel>);
        }
      },
    );

    return result;
  }
}
