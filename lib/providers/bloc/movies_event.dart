part of 'movies_bloc.dart';

class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

class MoviesFetch extends MoviesEvent {}

class MoviesRefresh extends MoviesEvent {}

class MoviesSearch extends MoviesEvent {
  String movieName;
  MoviesSearch(this.movieName);
  @override
  List<Object> get props => [movieName];
}

class MoviesSelection extends MoviesEvent {
  MoviesLoaded _list;
  MoviesSelection(this._list);
  @override
  List<Object> get props => [_list];
}
