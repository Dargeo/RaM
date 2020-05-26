
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:ram/Model/movie.dart';
import 'package:ram/notifier/movie_notifier.dart';
import 'package:ram/screens/movie_form.dart';
import 'package:ram/api/movie_api.dart';
class MovieDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    MovieNotifier movieNotifier = Provider.of<MovieNotifier>(context,listen: false);
    final List<String> sugars = ['Disponible', 'No disponible'];


  _onMovieDelete(Movie movie){
    
    movieNotifier.deleteMovie(movie);
    Navigator.of(context).pop();
  }
      return Scaffold(
        backgroundColor: Colors.teal[100],
        appBar: AppBar(title: Text(
          movieNotifier.currentMovie.name,
          )
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Column(
                children: <Widget>[
                  Image.network(movieNotifier.currentMovie.image== null ? 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg' :movieNotifier.currentMovie.image ,
                  ),
                  SizedBox(height: 32,),
                  Center(
                  child: Text(movieNotifier.currentMovie.name,
                  style:TextStyle(fontSize:40,) ,)
                  ),
                  Text(movieNotifier.currentMovie.category,
                  style: TextStyle(
                    fontSize:18,
                    fontStyle: FontStyle.italic,
                  ),
                  ),
                  
                ]
              )
            ),
          ),
        ),
              floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.view_list,
                overlayColor: Colors.black87,
                backgroundColor: Colors.cyan,
                animatedIconTheme: IconThemeData.fallback(),
                shape: CircleBorder(),
                children: [
                  SpeedDialChild(
                  child: Icon(Icons.delete),
                  backgroundColor: Colors.red,
                  label: 'Delete',
                  onTap:() {
                    deleteMovie(movieNotifier.currentMovie, _onMovieDelete);
                    Navigator.pop(context);
                  } 
                ),
                SpeedDialChild(
                  child: Icon(Icons.edit),
                  backgroundColor: Colors.green,
                  label: 'Edit',
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context){
                        return MovieForm(isUpdating: true,);
                        })
                      );
                  }
                ),
                ],
      ),
      );
    
  }
}