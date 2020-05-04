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
  uploadMovieAndImage(Movie movie, bool isUpdating, File localFile)async{ 
    if(localFile!= null){
      print('Uploading image');

      var filExtension = path.extension(localFile.path);
      print(filExtension);

      var uuid = Uuid().v4();

      final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('movies/images/$uuid$filExtension');

        await firebaseStorageRef.putFile(localFile).onComplete.catchError(
          (onError){
            print(onError);
            return false;
          }
        );
        String url = await firebaseStorageRef.getDownloadURL();
        _uploadMovie(movie,isUpdating,imageUrl: url);
        print('download url: $url');

        //
    }else{
      print('skiping image upload'); 
      _uploadMovie(movie,isUpdating);
    }
  }
  _uploadMovie(Movie movie, bool isUpdating, {String imageUrl})async {
    CollectionReference movieRef = Firestore.instance.collection('movies');

    if(imageUrl != null ){
      movie.image = imageUrl;
    }

    if(isUpdating){
      await movieRef.document(movie.id).updateData(movie.toMap());
      print('updated movie with id: ${movie.id}');
    }else{
      DocumentReference documentRef = await movieRef.add(movie.toMap());

      movie.id = documentRef.documentID;

      print('uploaded movie successfully: ${movie.toString()}');

      await documentRef.setData(movie.toMap(),merge: true);
    }

  }