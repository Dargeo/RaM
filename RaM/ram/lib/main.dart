
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/notifier/movie_notifier.dart';
import 'package:ram/screens/movie_list.dart';

void main() => runApp(MultiProvider(
  providers:[

    ChangeNotifierProvider(
    create: (context) => MovieNotifier(),
    ),
  ],
  child: MyApp(),

));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer<MovieNotifier>(
        builder: (context,notifier,child){
          return MovieList();
        },
      )
    );
  }
}

