// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WaitingLobbyScreen extends StatefulWidget {
  final int occupancy;
  final int noOfPlayer;
  final String lobbyName;
  final players;
  const WaitingLobbyScreen({
    Key? key,
    required this.occupancy,
    required this.noOfPlayer,
    required this.lobbyName,
    required this.players,
  }) : super(key: key);

  @override
  State<WaitingLobbyScreen> createState() => _WaitingLobbyScreenState();
}

class _WaitingLobbyScreenState extends State<WaitingLobbyScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
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
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Waiting for ${widget.occupancy - widget.noOfPlayer} players to join',
                  style: const TextStyle(
                    fontSize: 30,color: Colors.white
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                readOnly: true,
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.lobbyName));
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Copied!')));
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    filled: true,
                    fillColor: const Color(0xffF5F5FA),
                    hintText: 'Tap to copy room name',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const Text(
              'Players Joined',
              style: TextStyle(fontSize: 20 ,color: Colors.white),
            ),
            ListView.builder(
                itemCount: widget.noOfPlayer,
                primary: true,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(
                      '${index + 1}.',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                    title: Text(
                      widget.players[index]['nickName'],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
