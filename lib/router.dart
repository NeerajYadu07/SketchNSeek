import 'package:flutter/material.dart';
import 'package:sketch_n_seek/features/game/screens/game_screen.dart';
import 'package:sketch_n_seek/features/home/screens/home_screen.dart';
import 'package:sketch_n_seek/features/room/screens/create_room_screen.dart';
import 'package:sketch_n_seek/features/room/screens/join_room_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case CreateRoomScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CreateRoomScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case JoinRoomScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const JoinRoomScreen(),
      );
    case GameScreen.routeName:
      var data = routeSettings.arguments as Map<String,dynamic>;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => GameScreen(data: data["data"],from: data["screenFrom"],),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(
                body: Center(
                  child: Text("Screen doesn't exist"),
                ),
              ));
  }
}
