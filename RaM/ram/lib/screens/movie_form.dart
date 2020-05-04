import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ram/Model/movie.dart';
import 'package:ram/notifier/movie_notifier.dart';

class MovieForm extends StatefulWidget {
  
  final bool isUpdating;

  MovieForm({@required this.isUpdating});

  @override

  _MovieFormState createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Movie _currentMovie;
  final List <String> disponibilidad = ['Available','Not available'];
  final List <String> categorias =['Drama', 'Comedy','Thriller','Action','Terror','Kids'];
  String _imageUrl;
  File _imageFile;
  
 @override
 void initState(){
   super.initState();
   MovieNotifier movieNotifier = Provider.of<MovieNotifier>(context,listen: false);
 
  if(movieNotifier.currentMovie != null){
    _currentMovie = movieNotifier.currentMovie;
  }else{
    _currentMovie = Movie();
  }
  _imageUrl = _currentMovie.image;
 }
 
 _showImage(){
    if(_imageFile== null && _imageUrl == null){
      return Text('Image placeholder');
    }else if (_imageFile != null ){
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }else if(_imageUrl != null ){
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }
  _getLocalImage() async {
    File imageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildNameField(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Movie Name'),
      initialValue : _currentMovie.name,
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

     Widget _buildStateField(){
    return DropdownButtonFormField(
      value: _currentMovie.estado,
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
      Widget _buildCategoryField(){
    return DropdownButtonFormField(
      value: _currentMovie.category,
      items: categorias.map((cat){
        return DropdownMenuItem(
          value: cat,
          child: Text('$cat')
        );
      }).toList(),
      onChanged : (value) =>
      _currentMovie.estado = value, 
      );
  }

  _saveFood(context){
    if(!_formkey.currentState.validate()){
      return;
    }
    _formkey.currentState.save();
    

    print("name: ${_currentMovie.name}");
    print("category: ${_currentMovie.category}");
    print("disponibilidad: ${_currentMovie.estado}");
  }
   @override
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
              Text(
                widget.isUpdating ? "Edit Movie":
                "Add a new movie",
               textAlign: TextAlign.center,
               style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 16,),
              _imageFile == null && _imageUrl == null ? 
              ButtonTheme(
                child:RaisedButton(
                child: Text(
                  "add image",
                  style: TextStyle(color: Colors.white)
                ),
                onPressed: _getLocalImage,
                ),


              ): SizedBox(height: 0,),
                _buildNameField(),
                _buildStateField(),
                _buildCategoryField(),
            ],
          ),
        ),),
                  floatingActionButton: FloatingActionButton(
            onPressed: ()=> _saveFood(context),

            child: Icon(Icons.save),
            foregroundColor: Colors.white,
          ),
    );
  }
}