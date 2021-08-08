import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_db/database/moor_database.dart';
import 'package:room_db/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();

    return MultiProvider(
      providers: [Provider<TaskDao>(create: (_) => db.taskDao), Provider(create: (_) => db.tagDao)],
      child: MaterialApp(title: 'Room Database', theme: ThemeData(primarySwatch: Colors.blue), home: HomePage()),
    );
  }
}
