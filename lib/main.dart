import 'package:contact/views/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider12/provider.dart';
import 'viewmodels/contact_viewmodel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContactViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contact App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.redAccent,
          ),
          listTileTheme: ListTileThemeData(
            iconColor: Colors.redAccent,
            textColor: Colors.black,
          ),
        ),
        home: ContactList(),
      ),
    );
  }
}
