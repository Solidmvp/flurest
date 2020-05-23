import 'package:flurest/blocs/movie_detail_bloc.dart';
import 'package:flurest/models/movie_response.dart';
import 'package:flurest/networking/api_response.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MovieDetail extends StatefulWidget {
  final int selectedMovie;
  const MovieDetail(this.selectedMovie);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  MovieDetailBloc _movieDetailBloc;

  @override
  void initState() {
    super.initState();
    _movieDetailBloc = MovieDetailBloc(widget.selectedMovie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Mover',
          style: TextStyle(
//            color: Colors.white,
            fontSize: 20,
          ),
        ),
//        backgroundColor: Color(0xFF333333),
      ),
//      backgroundColor: Color(0xFF333333),
      body: RefreshIndicator(
        onRefresh: () =>
            _movieDetailBloc.fetchMovieDetail(widget.selectedMovie),
        child: StreamBuilder<ApiResponse<Movie>>(
          stream: _movieDetailBloc.movieDetailStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return ShowMovieDetail(displayMovie: snapshot.data.data);
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () =>
                        _movieDetailBloc.fetchMovieDetail(widget.selectedMovie),
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _movieDetailBloc.dispose();
    super.dispose();
  }
}

class ShowMovieDetail extends StatelessWidget {
  final Movie displayMovie;

  ShowMovieDetail({Key key, this.displayMovie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        new Image.network(
          'https://image.tmdb.org/t/p/w342${displayMovie.posterPath}',
          fit: BoxFit.cover,
        ),
        new BackdropFilter(
          filter: new ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: new Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        new SingleChildScrollView(
          child: new Container(
            margin: const EdgeInsets.all(20.0),
            child: new Column(
              children: <Widget>[
                new Container(
                  alignment: Alignment.center,
                  child: new Container(
                    width: 400.0,
                    height: 400.0,
                  ),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10.0),
                    image: new DecorationImage(
                        image: new NetworkImage(
                            'https://image.tmdb.org/t/p/w342${displayMovie.posterPath}'),
                        fit: BoxFit.cover),
                    boxShadow: [
                      new BoxShadow(
//                          color: Colors.black,
                          blurRadius: 20.0,
                          offset: new Offset(0.0, 10.0))
                    ],
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new Text(
                        displayMovie.title,
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontFamily: 'Arvo'),
                      )),
                      new Text(
                        displayMovie.voteAverage.toStringAsFixed(2),
//                      '${widget.movie['vote_average']}/10',
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'Arvo'),
                      )
                    ],
                  ),
                ),
                new Text(displayMovie.overview,
                    style:
                        new TextStyle(color: Colors.white, fontFamily: 'Arvo')),
                new Padding(padding: const EdgeInsets.all(10.0)),
                new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new Container(
                      width: 150.0,
                      height: 60.0,
                      alignment: Alignment.center,
                      child: new Text(
                        'Rate Movie',
                        style: new TextStyle(
                            color: Colors.white,
                            fontFamily: 'Arvo',
                            fontSize: 20.0),
                      ),
                      decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(10.0),
                          color: const Color(0xaa3C3261)),
                    )),
                    new Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: new Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: new Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(10.0),
                            color: const Color(0xaa3C3261)),
                      ),
                    ),
                    new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.center,
                          child: new Icon(
                            Icons.bookmark,
                            color: Colors.white,
                          ),
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(10.0),
                              color: const Color(0xaa3C3261)),
                        )),
                  ],
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class Error extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: Colors.redAccent,
            child: Text(
              'Retry',
              style: TextStyle(
//                color: Colors.white,
                  ),
            ),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
//              color: Colors.lightGreen,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
          ),
        ],
      ),
    );
  }
}
