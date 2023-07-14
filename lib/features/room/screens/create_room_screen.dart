import 'package:flutter/material.dart';
import 'package:sketch_n_seek/widgets/custom_text_field.dart';

import '../../game/screens/game_screen.dart';

class CreateRoomScreen extends StatefulWidget {
  static const String routeName = 'create-room';
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  late String? _maxRoundValue;
  late String? _roomSizeValue;

  void createRoom(BuildContext context) {
    if (_nameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty &&
        _maxRoundValue != null &&
        _roomSizeValue != null) {
      Map<String, dynamic> data = {
        "data": {
          "nickName": _nameController.text,
          "roomName": _roomNameController.text,
          "occupancy": _roomSizeValue,
          "maxRounds": _maxRoundValue,
        },
        "screenFrom": "create-room"
      };
      print(data);
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
      body: SingleChildScrollView(
        child: Container(
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
                'Create Room',
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
              DropdownButton(
                focusColor: const Color(0xffF5F6FA),
                hint: const Text(
                  'Select Max Rounds',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                items: <String>["2", "5", "10", "15"]
                    .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _maxRoundValue = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButton(
                focusColor: const Color(0xffF5F6FA),
                hint: const Text(
                  'Select Room Size',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                items: <String>["2", "3", "4", "5", "6", "7", "8"]
                    .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _roomSizeValue = value;
                  });
                },
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () => createRoom(context),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(width / 2.5, 50)),
                ),
                child: const Text(
                  'Create',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
