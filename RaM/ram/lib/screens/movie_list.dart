import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/api/movie_api.dart';
import 'package:ram/notifier/movie_notifier.dart';
import 'package:ram/screens/detail.dart';
import 'package:ram/screens/movie_form.dart';

class MovieList extends StatefulWidget{
  @override 
  _MovieListState createState() => _MovieListState();
}


class _MovieListState extends State<MovieList> {

  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();
    MovieNotifier movieNotifier = Provider.of<MovieNotifier>(context, listen: false);
    getMovie(movieNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    MovieNotifier movieNotifier = Provider.of<MovieNotifier>(context);
Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    MovieNotifier movieNotifier = Provider.of<MovieNotifier>(context, listen: false);
    getMovie(movieNotifier);
    return null;

  }
    return Stack(
      children: <Widget>[
        Image.asset('assets/bg.jpg',
        height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Center(
              child: Text(
                'RaM',          ),
            ),
            
          ),
          body: RefreshIndicator(
            key: refreshKey,
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  leading : Image.network(
                    movieNotifier.movieList[index].image!= null ? movieNotifier.movieList[index].image : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                  width:120 ,
                  fit:  BoxFit.fitWidth,),
                  title: Text(movieNotifier.movieList[index].name,
                  style: TextStyle(color: Colors.blue)),
                  subtitle: Text(movieNotifier.movieList[index].category,
                  style: TextStyle(color: Colors.blue)),
                  onTap: (){
                    movieNotifier.currentMovie = movieNotifier.movieList[index];
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context ){
                      return MovieDetail();
                    }));
                  },
                );
              },
              itemCount: movieNotifier.movieList.length,
              separatorBuilder: (BuildContext context, int index){
                return Divider(
                  color: Colors.white,
                );
              },
            ), onRefresh: () async{
              return refreshList();
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              movieNotifier.currentMovie =null;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context){
                  return MovieForm(isUpdating: false,);
                }),
              );
            },
            child: Icon(Icons.add),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}