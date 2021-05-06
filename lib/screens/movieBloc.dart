import 'package:cached_network_image/cached_network_image.dart';
import 'package:cubitbloc/providers/bloc/movies_bloc.dart';
import 'package:cubitbloc/repo/movieRepo.dart';
import 'package:cubitbloc/screens/movieSearchBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviesTwo extends StatefulWidget {
  MoviesTwo({Key key}) : super(key: key);

  @override
  _MoviesTwoState createState() => _MoviesTwoState();
}

class _MoviesTwoState extends State<MoviesTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SearchMovieBloc()));
        },
        child: Icon(Icons.search),
      ),
      body: BlocProvider(
          create: (context) => MoviesBloc(MovieRepo()),
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 2),
                  height: MediaQuery.of(context).size.width * 0.40,
                  width: double.infinity,
                  child: PopulatMoviesList()),
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.40,
                  child: PopulatMoviesListName()),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(top: 2),
                    // width: double.infinity,
                    // height: MediaQuery.of(context).size.width * 0.70,
                    child: PopulatMoviesPriview()),
              ),
            ],
          )),
    );
  }
}

class SearchMovie extends StatefulWidget {
  SearchMovie({Key key}) : super(key: key);

  @override
  _SearchMovieState createState() => _SearchMovieState();
}

class _SearchMovieState extends State<SearchMovie> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.black,
        ),
      ],
    );
  }
}

class PopulatMoviesPriview extends StatefulWidget {
  PopulatMoviesPriview({Key key}) : super(key: key);

  @override
  _PopulatMoviesPriviewState createState() => _PopulatMoviesPriviewState();
}

class _PopulatMoviesPriviewState extends State<PopulatMoviesPriview> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(builder: (context, states) {
      if (states is MoviesLoaded) {
        int index = states.getMoviesList
            .indexWhere((element) => element.id == states.getIndex);
        return Container(
          height: double.infinity,
          width: double.infinity,
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: "${states.getMoviesList[index].imageThumbnailPath}",
            placeholder: (context, url) => Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/SW_opening_crawl_logo.svg/1200px-SW_opening_crawl_logo.svg.png"),
            errorWidget: (context, url, error) => Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/Star_wars2.svg/1200px-Star_wars2.svg.png"),
          ),
        );
      }
      return Container();
    });
  }
}

class PopulatMoviesListName extends StatefulWidget {
  PopulatMoviesListName({Key key}) : super(key: key);

  @override
  _PopulatMoviesListNameState createState() => _PopulatMoviesListNameState();
}

class _PopulatMoviesListNameState extends State<PopulatMoviesListName> {
  void emitSelection(MoviesLoaded list) {
    final moviesbloc = BlocProvider.of<MoviesBloc>(context, listen: false);
    moviesbloc.add(MoviesSelection(list));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, states) {
        if (states is MoviesLoaded) {
          return ListView.builder(
              itemCount: states.getMoviesList.length,
              itemBuilder: (context, index) {
                var data = states.getMoviesList[index];

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(color: Colors.black45),
                  child: GestureDetector(
                    onTap: () {
                      states.selectionIndex(data.id);

                      emitSelection(states);
                    },
                    child: Text(
                      data.name,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              });
        }
        return Container();
      },
    );
  }
}

class PopulatMoviesList extends StatefulWidget {
  PopulatMoviesList({Key key}) : super(key: key);

  @override
  _PopulatMoviesListState createState() => _PopulatMoviesListState();
}

class _PopulatMoviesListState extends State<PopulatMoviesList> {
  Future<void> getMovies() async {
    final moviesBloc = BlocProvider.of<MoviesBloc>(context, listen: false);
    moviesBloc.add(MoviesFetch());
  }

  void emitSelection(MoviesState list) {
    final moviesbloc = BlocProvider.of<MoviesBloc>(context, listen: false);
    moviesbloc.add(MoviesSelection(list));
  }

  @override
  Widget build(BuildContext context) {
    final moviesBloc = BlocProvider.of<MoviesBloc>(context);
    return FutureBuilder(
        future: getMovies(),
        builder: (context, snap) => BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, states) {
                if (states is MoviesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (states is MoviesError) {
                  return Text("${states.error}");
                }
                if (states is MoviesLoaded) {
                  return ListView.builder(
                      itemCount: states.getMoviesList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var data = states.getMoviesList[index];

                        return GestureDetector(
                          onTap: () {
                            states.selectionIndex(data.id);
                            emitSelection(states);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: states.getIndex == data.id
                                        ? Colors.green
                                        : Colors.transparent,
                                    width: 2)),
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.width * 0.30,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: "${data.imageThumbnailPath}",
                              placeholder: (context, url) => Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/SW_opening_crawl_logo.svg/1200px-SW_opening_crawl_logo.svg.png"),
                              errorWidget: (context, url, error) => Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/Star_wars2.svg/1200px-Star_wars2.svg.png"),
                            ),
                          ),
                        );
                      });
                }
                return Text("adsads");
              },
            ));
  }
}

class SearchMovies extends StatefulWidget {
  SearchMovies({Key key}) : super(key: key);

  @override
  _SearchMoviesState createState() => _SearchMoviesState();
}

class _SearchMoviesState extends State<SearchMovies> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
