import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:ram/Model/movie.dart';
import 'package:ram/notifier/movie_notifier.dart';
import 'package:uuid/uuid.dart';

getMovie(MovieNotifier movieNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance.collection('movies').getDocuments();

  List<Movie> _movieList = [];
  
  snapshot.documents.forEach((document)
  {
    Movie movie = Movie.fromMap(document.data);
    _movieList.add(movie);
  });

  movieNotifier.movieList = _movieList;
}
  uploadMovieAndImage(Movie movie, bool isUpdating, {File localFile})async{ 
    if(localFile!= null){
      print('Uploading image');

      var filExtension = path.extension(localFile.path);
      print(filExtension);

      var uuid = Uuid().v4();

      final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('movies/images/');
    }
  }