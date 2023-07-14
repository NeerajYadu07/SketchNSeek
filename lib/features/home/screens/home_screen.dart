import 'package:flutter/material.dart';
import 'package:sketch_n_seek/features/room/screens/create_room_screen.dart';

import '../../room/screens/join_room_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

void navigateToCreateRoomScreen(BuildContext context){
  Navigator.pushNamed(context, CreateRoomScreen.routeName);
}
void navigateToJoinRoomScreen(BuildContext context){
  Navigator.pushNamed(context, JoinRoomScreen.routeName);
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('SKETCH-N-SEEK',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                 colors: [Color(0xff721c80), Color(0xff11091e)],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(50.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
          colors: [Color(0xff721c80), Color(0xff11091e)],
          stops: [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Create/Join a room to play!',
              style: TextStyle(fontSize: 24,color: Colors.white),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: ()=>navigateToCreateRoomScreen(context),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(width / 2.5, 50)),
                  ),
                  child: const Text(
                    'Create',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: ()=> navigateToJoinRoomScreen(context),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(width / 2.5, 50)),
                  ),
                  child: const Text(
                    'Join',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
