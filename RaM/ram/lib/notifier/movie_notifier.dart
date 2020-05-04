import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:ram/Model/movie.dart';

class MovieNotifier with ChangeNotifier{
  List<Movie> _movieList= [];
  Movie _currentMovie;

  UnmodifiableListView<Movie> get movieList => UnmodifiableListView(_movieList);

  Movie get currentMovie => _currentMovie;

  set movieList(List<Movie> movieList){
    _movieList = movieList;
    notifyListeners();
  }

  set currentMovie(Movie movie){
    _currentMovie = movie;
    notifyListeners();
  }
}