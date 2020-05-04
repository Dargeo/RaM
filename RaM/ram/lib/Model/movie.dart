import 'dart:io';

class Movie {
  String id;
  String name;
  String category;
  String estado;
  String image;

Movie();

  Movie.fromMap(Map<String,dynamic> data ){
    id = data['id'];
    name = data['name'];
    category = data['category'];
    estado = data['estado'];
    image = data['image'];
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'name':name,
      'category':category,
      'estado':estado,
      'image':image,
    };
  }

}