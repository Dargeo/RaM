import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/Model/movie.dart';
import 'package:ram/notifier/movie_notifier.dart';

class MovieForm extends StatefulWidget {
  @override
  _MovieFormState createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Movie _currentMovie;
  final List <String> disponibilidad = ['Disponible','No disponible'];
  
  
 @override
 void initState(){
   super.initState();
   MovieNotifier movieNotifier = Provider.of<MovieNotifier>(context,listen: false);
 
  if(movieNotifier.currentMovie != null){
    _currentMovie = movieNotifier.currentMovie;
  }else{
    _currentMovie = new Movie();
  }
 }
 
Widget _showImage(){
    return Text('image here');
  }
  Widget _buildNameField(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Movie Name'),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize:20),
      validator: (String value){
        if(value.isEmpty){
          
          return 'Name is required';
        }
        return null;
      },
      onSaved: (String value){
        _currentMovie.name = value;
      },
    );
  }
    Widget _buildCategoryField(){
    return DropdownButtonFormField(
      items: disponibilidad.map((estado){
        return DropdownMenuItem(
          value: estado,
          child: Text('$estado')
        );
      }).toList(),
      onChanged : (value) =>
      _currentMovie.estado = value, 
      );
  }
 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('movie form'),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child:Form(
          key: _formkey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              _showImage(),
              SizedBox(height: 16,),
              Text("Add a new movie",
               textAlign: TextAlign.center,
               style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 16,),
              ButtonTheme(
                child:RaisedButton(
                child: Text(
                  "add image",
                  style: TextStyle(color: Colors.white)
                ),
                onPressed: () => {},
                ),


              ),
                _buildNameField(),
                _buildCategoryField(),
            ],
          ),
        ),)
    );
  }
}