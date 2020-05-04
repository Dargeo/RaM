
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/notifier/movie_notifier.dart';
import 'package:ram/screens/movie_form.dart';

class MovieDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    MovieNotifier movieNotifier = Provider.of<MovieNotifier>(context,listen: false);
    final List<String> sugars = ['Disponible', 'No disponible'];

      return Scaffold(
        
        appBar: AppBar(title: Text(
          movieNotifier.currentMovie.name,
          )
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Column(
                children: <Widget>[
                  Image.network(movieNotifier.currentMovie.image,
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
              floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context){
              return MovieForm();
            })
          );
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
      );
    
  }
}