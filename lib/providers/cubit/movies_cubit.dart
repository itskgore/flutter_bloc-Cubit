import 'package:bloc/bloc.dart';
import 'package:cubitbloc/models/moviesModel.dart';
import 'package:cubitbloc/repo/movieRepo.dart';
import 'package:equatable/equatable.dart';

part 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MovieRepo _movieRepo;
  MoviesCubit(this._movieRepo) : super(MoviesInitial());

  void getMovies() async {
    try {
      emit(MoviesLoading());
      List<Movies> _list = await _movieRepo.getMovies();
      emit(MoviesLoaded(_list, _list.first.id));
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }

  void changedIndex(MoviesLoaded state) {
    state.getMoviesList.forEach((element) {
      if (element.id == state.getIndex) {
        element.selectedIndex = state.getIndex;
      } else {
        element.selectedIndex = 0;
      }
    });
    emit(MoviesLoading());
    emit(MoviesLoaded(state.getMoviesList, state.getIndex));
  }

  void searchMovie(String movieName) async {
    try {
      emit(MoviesSearchLoading());
      List<Movies> _list = await _movieRepo.getMovies(movieName);
      emit(MoviesSearchLoaded(
        _list,
      ));
    } catch (e) {
      emit(MoviesSearchError(e.toString()));
    }
  }
}
