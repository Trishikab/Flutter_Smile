import 'package:flutter/material.dart';
import './screen1.dart';
import './screen2.dart';
import './screen3.dart';
void main() => runApp(MyApp());



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Smile Project',
      debugShowCheckedModeBanner: false,//https://ipfs.io/ipfs/
      initialRoute: '/',
      routes: {
        '/': (context) =>  HomePage(storage: CounterStorage()),
        '/first':(context) => const chartScreen(),
        '/second':(context) => const premiumPage(),
      },


    );
  }
}