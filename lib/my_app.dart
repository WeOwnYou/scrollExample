import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scroll_example/scrolling_menu_example/bloc/scrolling_menu_bloc.dart';
import 'package:scroll_example/scrolling_menu_example/scroll_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(backgroundColor: Colors.white, canvasColor: Colors.white),
      // home: ChangeNotifierProvider(
      //   create: (_) => ScrollingMenuBloc(),
      //   child: const MenuView(),
      // ),
      home: BlocProvider<ScrollingMenuBloc>(
        create: (ctx) => ScrollingMenuBloc(ctx),
        child: const MenuView(),
      ),
    );
  }
}
