import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cubitbloc/models/moviesModel.dart';
import 'package:cubitbloc/repo/movieRepo.dart';
import 'package:equatable/equatable.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MovieRepo _movieRepo;
  MoviesBloc(this._movieRepo) : super(MoviesInitial());

  @override
  Stream<MoviesState> mapEventToState(
    MoviesEvent event,
  ) async* {
    if (event is MoviesFetch) {
      try {
        yield MoviesLoading();
        List<Movies> _list = await _movieRepo.getMovies();
        yield MoviesLoaded(_list, _list.first.id);
      } catch (e) {
        yield MoviesError(e.toString());
      }
    } else if (event is MoviesRefresh) {
    } else if (event is MoviesSelection) {
      yield MoviesLoading();
      yield MoviesLoaded(event._list.getMoviesList, event._list.getIndex);
    } else if (event is MoviesSearch) {
      try {
        yield MoviesSearchLoading();
        List<Movies> _list = await _movieRepo.getMovies(event.movieName);
        yield MoviesSearchLoaded(_list);
      } catch (e) {
        yield MoviesSearchError(e.toString());
      }
    }
  }
}
