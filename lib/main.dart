import 'package:flutter/material.dart';
import 'controller/quote_controller.dart';
import 'pages/home_page.dart';
import 'pages/explore_page.dart';
import 'pages/favorite_pages.dart';


void main(){
  runApp(MotifyApp());
}

class MotifyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final controller = QuoteController();

    return MaterialApp(
      title: 'Motify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.green[500]),
          titleTextStyle: TextStyle(
            color: Colors.green[500],
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15))
          ),
        ),
      ),
      // home: HomeShell(controller: controller),
    );
  }
}