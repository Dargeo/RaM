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
  uploadMovieAndImage(Movie movie, bool isUpdating, File localFile, Function function)async{ 
    if(localFile!= null){
      print('Uploading image');

      var filExtension = path.extension(localFile.path);
      print(filExtension);

      var uuid = Uuid().v4();
      var now = new DateTime.now();
      final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('movies/images/$uuid$filExtension');

        await firebaseStorageRef.putFile(localFile).onComplete.catchError(
          (onError){
            print(onError);
            return false;
          }
        );
        String url = await firebaseStorageRef.getDownloadURL();
        _uploadMovie(movie,function,isUpdating,imageUrl: url);
        print('download url: $url');

        //
    }else{
      print('skiping image upload'); 
      _uploadMovie(movie,function,isUpdating);
    }
  }
  _uploadMovie(Movie movie, Function function, bool isUpdating, {String imageUrl} )async {
    CollectionReference movieRef = Firestore.instance.collection('movies');

    if(imageUrl != null ){
      movie.image = imageUrl;
    }

    if(isUpdating){
      await movieRef.document(movie.id).updateData(movie.toMap());
      function(movie);
      print('updated movie with id: ${movie.id}');
    }else{
      DocumentReference documentRef = await movieRef.add(movie.toMap());

      movie.id = documentRef.documentID;

      print('uploaded movie successfully: ${movie.toString()}');

      await documentRef.setData(movie.toMap(),merge: true);

      function(movie);
    }

  }

  deleteMovie(Movie movie, Function functionDeleted) async{
    if(movie.image != null){
      StorageReference storageReference = await FirebaseStorage.instance.getReferenceFromUrl(movie.image);

      print(storageReference.path);

      await storageReference.delete();
    }
await Firestore.instance.collection('movies').document(movie.id).delete();
  }