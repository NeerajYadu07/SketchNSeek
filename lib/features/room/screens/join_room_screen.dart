import 'package:flutter/material.dart';
import 'package:sketch_n_seek/widgets/custom_text_field.dart';

import '../../game/screens/game_screen.dart';

class JoinRoomScreen extends StatefulWidget {
  static const String routeName = 'join-room';
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();

  void joinRoom(BuildContext context) {
    if (_nameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty) {
      Map<String, dynamic> data = {
        "data": {
          "nickName": _nameController.text,
          "roomName": _roomNameController.text,
        },
        "screenFrom": "join-room"
      };
      Navigator.pushNamed(context, GameScreen.routeName,arguments: data);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SKETCH-N-SEEK',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
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
        height: height,
          decoration:  const BoxDecoration(
          gradient: LinearGradient(
          colors: [Color(0xff721c80), Color(0xff11091e)],
          stops: [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Join Room',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(
              height: height * 0.08,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: _nameController,
                hintText: "Enter Your Name",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: _roomNameController,
                hintText: "Enter Room Name",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () => joinRoom(context),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(width / 2.5, 50)),
              ),
              child: const Text(
                'Join',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
