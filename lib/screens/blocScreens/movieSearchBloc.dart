import 'package:cached_network_image/cached_network_image.dart';
import 'package:cubitbloc/providers/bloc/movies_bloc.dart';
import 'package:cubitbloc/repo/movieRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchMovieBloc extends StatefulWidget {
  SearchMovieBloc({Key key}) : super(key: key);

  @override
  _SearchMovieBlocState createState() => _SearchMovieBlocState();
}

class _SearchMovieBlocState extends State<SearchMovieBloc> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String movieName;
  void submitData(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      final movieBloc = BlocProvider.of<MoviesBloc>(context, listen: false);
      _formKey.currentState.save();
      movieBloc.add(MoviesSearch(movieName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => MoviesBloc(MovieRepo()),
          child: BlocBuilder<MoviesBloc, MoviesState>(
            builder: (context, states) {
              return Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        child: TextFormField(
                          validator: (val) {
                            if (val.isEmpty) {
                              return "";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            movieName = val.trimLeft().trimRight();
                          },
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Movie name..",
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  submitData(context);
                                }),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      states is MoviesInitial
                          ? Container(
                              child:
                                  Text("Remove your hands from those pockets!!",
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                            )
                          : states is MoviesSearchLoading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : states is MoviesSearchLoaded
                                  ? Expanded(
                                      child: Container(
                                          child: states
                                                  .getSearchMovieList.isEmpty
                                              ? Center(
                                                  child: Text(
                                                      "Does '${movieName}' really exist??",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      )),
                                                )
                                              : ListView.builder(
                                                  itemCount: states
                                                      .getSearchMovieList
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var data = states
                                                            .getSearchMovieList[
                                                        index];

                                                    return Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 6),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      width: double.infinity,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.50,
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                              child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child:
                                                                CachedNetworkImage(
                                                              fit: BoxFit.fill,
                                                              imageUrl:
                                                                  "${data.imageThumbnailPath}",
                                                              placeholder: (context,
                                                                      url) =>
                                                                  Image.network(
                                                                      "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/SW_opening_crawl_logo.svg/1200px-SW_opening_crawl_logo.svg.png"),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Image.network(
                                                                      "https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/Star_wars2.svg/1200px-Star_wars2.svg.png"),
                                                            ),
                                                          )),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        20),
                                                            child: Text(
                                                                "${data.name}",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  })),
                                    )
                                  : Container()
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
