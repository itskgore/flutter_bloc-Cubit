part of 'movies_cubit.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesChangeSelectionIndex extends MoviesState {}

class MoviesLoaded extends MoviesState {
  List<Movies> _listMoviews;

  MoviesLoaded(this._listMoviews, this._selectedIndex);
  int _selectedIndex = 0;

  int get getIndex {
    return _selectedIndex;
  }

  void selectionIndex(int index) {
    _selectedIndex = index;
  }

  List<Movies> get getMoviesList {
    return [..._listMoviews];
  }

  @override
  List<Object> get props => [_listMoviews];
}

class MoviesError extends MoviesState {
  String error;
  MoviesError(this.error);
  @override
  List<Object> get props => [error];
}

class MoviesSearchError extends MoviesState {
  String error;
  MoviesSearchError(this.error);
  @override
  List<Object> get props => [error];
}

class MoviesSearchLoading extends MoviesState {}

class MoviesSearchLoaded extends MoviesState {
  List<Movies> _listMovies;
  MoviesSearchLoaded(this._listMovies);

  List<Movies> get getSearchMovieList {
    return [..._listMovies];
  }

  @override
  List<Object> get props => [_listMovies];
}
