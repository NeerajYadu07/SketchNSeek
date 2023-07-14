import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:sketch_n_seek/features/game/screens/waiting_lobby_screen.dart';
import 'package:sketch_n_seek/features/home/screens/home_screen.dart';
import 'package:sketch_n_seek/models/touch_point.dart';
import 'package:sketch_n_seek/repository/socket_repository.dart';

import '../../../models/custom_painter.dart';
import '../widgets/side_drawer.dart';
import 'final_leaderboard.dart';

class GameScreen extends StatefulWidget {
  static const String routeName = 'game-screen';
  final Map<String, dynamic> data;
  final String from;
  const GameScreen({super.key, required this.data, required this.from});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // late IO.Socket _socket;
  SocketRepository socketRepository = SocketRepository();
  ScrollController _scrollController = ScrollController();
  TextEditingController controller = TextEditingController();
  Map<String, dynamic> roomData = {};
  List<TouchPoints?> points = [];
  StrokeCap strokeType = StrokeCap.round;
  Color selectedColor = Colors.black;
  double opacity = 1;
  double strokeWidth = 2;
  List<Widget> textBlankWidget = [];
  List<Map> messages = [];
  int guessedUserCount = 0;
  int _start = 60;
  late Timer _timer;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map> scoreBoard = [];
  bool isTextInputReadOnly = false;
  int maxPoints = 0;
  String winner = "";
  bool isShowFinalLeaderboard = false;

  @override
  void initState() {
    super.initState();
    connect();
    socketRepository.roomChangeListner((data) {
      print(data);
      setState(() {
        roomData = data;
        print(roomData['word']);
        renderTextBlank(roomData['word']);
      });
      print(roomData['isJoin']);
      if (roomData['isJoin'] != true) {
        startTimer();
      }
      scoreBoard.clear();
      for (int i = 0; i < roomData['players'].length; i++) {
        setState(() {
          scoreBoard.add({
            'username': roomData['players'][i]['nickName'],
            'points': roomData['players'][i]['points'].toString(),
          });
        });
      }
    });
    socketRepository.pointsChangeListner((point) {
      if (point['details'] != null) {
        setState(() {
          points.add(TouchPoints(
              paint: Paint()
                ..strokeCap = strokeType
                ..color = selectedColor.withOpacity(opacity)
                ..isAntiAlias = true
                ..strokeWidth = strokeWidth,
              points: Offset((point['details']['dx']).toDouble(),
                  (point['details']['dy']).toDouble())));
        });
      } else {
        points.add(null);
      }
    });

    socketRepository.colorChangeListner((colorString) {
      int value = int.parse(colorString, radix: 16);
      Color newColor = Color(value);
      setState(() {
        selectedColor = newColor;
      });
    });

    socketRepository.strokeWidthChangeListner((value) {
      setState(() {
        strokeWidth = value.toDouble();
      });
    });

    socketRepository.cleanScreenChangeListner((data) {
      setState(() {
        points.clear();
      });
    });

    socketRepository.messageListner((messageData) {
      setState(() {
        messages.add(messageData);
        guessedUserCount = messageData['guessedUserCount'];
      });
      if (guessedUserCount == roomData['players'].length - 1) {
        socketRepository.changeTurn(roomData['roomName']);
      }
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 40,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut);
    });

    socketRepository.changeTurnListner((data) {
      String oldWord = roomData['word'];
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(const Duration(seconds: 3), () {
              setState(() {
                roomData = data;
                renderTextBlank(roomData['word']);
                isTextInputReadOnly = false;
                guessedUserCount = 0;
                points.clear();
                _start = 60;
                Navigator.of(context).pop();
                _timer.cancel();
                startTimer();
              });
            });
            return AlertDialog(
              title: Center(child: Text('Word was $oldWord')),
            );
          });
    });

    socketRepository.closeInput((_) {
      socketRepository.updateScore(widget.data['roomName']);
      setState(() {
        isTextInputReadOnly = true;
      });
    });

    socketRepository.updateScoreChangeListner((roomData) {
      scoreBoard.clear();
      for (int i = 0; i < roomData['players'].length; i++) {
        setState(() {
          scoreBoard.add({
            'username': roomData['players'][i]['nickName'],
            'points': roomData['players'][i]['points'].toString(),
          });
        });
      }
    });

    socketRepository.showLeaderboard((players) {
      scoreBoard.clear();
      for (int i = 0; i < players.length; i++) {
        setState(() {
          scoreBoard.add({
            'username': players[i]['nickName'],
            'points': players[i]['points'].toString(),
          });
        });
        if (maxPoints < int.parse(scoreBoard[i]['points'])) {
          winner = scoreBoard[i]['username'];
          maxPoints = int.parse(scoreBoard[i]['points']);
        }
      }
      setState(() {
        _timer.cancel();
        isShowFinalLeaderboard = true;
      });
    });

    socketRepository.userDisconnected((roomData) {
      scoreBoard.clear();
      for (int i = 0; i < roomData['players'].length; i++) {
        setState(() {
          scoreBoard.add({
            'username': roomData['players'][i]['nickName'],
            'points': roomData['players'][i]['points'].toString(),
          });
        });
      }
    });

    socketRepository.invalidGame((data) {
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (route) => false);
    });
  }

  void connect() {
    if (widget.from == 'create-room') {
      socketRepository.createRoom(widget.data);
    }
    if (widget.from == 'join-room') {
      socketRepository.joinRoom(widget.data);
    }
  }

  void selectColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Color'),
        content: SingleChildScrollView(
          child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                String colorString = color.toString();
                String valueString = colorString.split('0x')[1].split(')')[0];
                Map<String, String> colorData = {
                  'color': valueString,
                  'roomName': roomData['roomName'],
                };
                socketRepository.changeColor(colorData);
              }),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'))
        ],
      ),
    );
  }

  void renderTextBlank(String word) {
    textBlankWidget.clear();
    for (int i = 0; i < word.length; i++) {
      textBlankWidget.add(const Text(
        '_',
        style: TextStyle(fontSize: 30,color: Colors.white),
      ));
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        socketRepository.changeTurn(roomData['roomName']);
        setState(() {
          _timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<bool> showExitPopup() async {
      return await showDialog( 
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit Game'),
          content: const Text('Do you want to exit the game?'),
          actions:[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child:const Text('No'),
            ),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), 
              child:const Text('Yes'),
            ),

          ],
        ),
      )??false;
    }
    

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: showExitPopup ,
      child: Scaffold(
        key: scaffoldKey,
        drawer: PlayerDrawer(
          userData: scoreBoard,
        ),
        // ignore: unnecessary_null_comparison
        body: roomData != null
            ? roomData['isJoin'] != true
                ? !isShowFinalLeaderboard
                    ? SafeArea(
                        child: Container(
                          height: height,
          decoration:  const BoxDecoration(
          gradient: LinearGradient(
          colors: [Color(0xff721c80), Color(0xff11091e)],
          stops: [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: height*0.07,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all( Radius.circular(21),
                                        ),
                                        border: Border.all(
                                          width: 3,
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      width: width,
                                      height: height * 0.45,
                                      child: GestureDetector(
                                        onPanUpdate: (details) {
                                          print(details.localPosition.dx);
                                          Map<String, dynamic> data = {
                                            'details': {
                                              'dx': details.localPosition.dx,
                                              'dy': details.localPosition.dy,
                                            },
                                            'roomName': widget.data['roomName']
                                          };
                                          socketRepository.paint(data);
                                        },
                                        onPanStart: (details) {
                                          print(details.localPosition.dx);
                                          Map<String, dynamic> data = {
                                            'details': {
                                              'dx': details.localPosition.dx,
                                              'dy': details.localPosition.dy,
                                            },
                                            'roomName': widget.data['roomName']
                                          };
                                          socketRepository.paint(data);
                                        },
                                        onPanEnd: (details) {
                                          Map<String, dynamic> data = {
                                            'details': null,
                                            'roomName': widget.data['roomName']
                                          };
                                          socketRepository.paint(data);
                                        },
                                        child: SizedBox.expand(
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(20)),
                                            child: RepaintBoundary(
                                              child: CustomPaint(
                                                size: Size.infinite,
                                                painter: MyCustomPainter(
                                                    pointsList: points),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => selectColor(),
                                          icon: Icon(
                                            Icons.color_lens,
                                            color: selectedColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Slider(
                                            min: 1.0,
                                            max: 10,
                                            label: "Strokewidth $strokeWidth",
                                            activeColor: selectedColor,
                                            value: strokeWidth,
                                            onChanged: (double value) {
                                              Map<String, dynamic> widthData = {
                                                'width': value,
                                                'roomName': roomData['roomName'],
                                              };
                                              socketRepository
                                                  .changeStrokeWidth(widthData);
                                            },
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            socketRepository
                                                .cleanScreen(roomData['roomName']);
                                          },
                                          icon: Icon(
                                            Icons.layers_clear,
                                            color: selectedColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    roomData['turn']['nickName'] !=
                                            widget.data['nickName']
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: textBlankWidget,
                                          )
                                        : Center(
                                            child: Text(
                                              roomData['word'],
                                              style: const TextStyle(fontSize: 30,color: Colors.white),
                                            ),
                                          ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height * 0.3,
                                      child: ListView.builder(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          physics: const BouncingScrollPhysics(
                                              parent:
                                                  AlwaysScrollableScrollPhysics()),
                                          controller: _scrollController,
                                          shrinkWrap: true,
                                          itemCount: messages.length,
                                          itemBuilder: (context, index) {
                                            var message = messages[index].values;
                                            return ListTile(
                                              title: Text(
                                                message.elementAt(0),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                message.elementAt(1),
                                                style: TextStyle(
                                                    color: message.elementAt(1)=="Guessed it!"?Colors.green:Colors.white,
                                                    fontSize: 16),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              roomData['turn']['nickName'] !=
                                      widget.data['nickName']
                                  ? Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 20, right: 20, bottom: 5),
                                        child: TextFormField(
                                          controller: controller,
                                          readOnly: isTextInputReadOnly,
                                          onFieldSubmitted: (value) {
                                            if (value.trim().isNotEmpty) {
                                              Map<String, dynamic> data = {
                                                'username':
                                                    widget.data['nickName'],
                                                'message': value.trim(),
                                                'word': roomData['word'],
                                                'roomName':
                                                    widget.data['roomName'],
                                                'guessedUserCount':
                                                    guessedUserCount,
                                                'totalTime': 60,
                                                'timeTaken': 60 - _start,
                                              };
                                              socketRepository.sendMessage(data);
                                              controller.clear();
                                            }
                                          },
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16, vertical: 14),
                                            filled: true,
                                            fillColor: const Color(0xffE5B8F4),
                                            hintText: "Your Guess",
                                            hintStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black
                                            ),
                                          ),
                                          textInputAction: TextInputAction.done,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SafeArea(
                                child: IconButton(
                                  onPressed: () =>
                                      scaffoldKey.currentState!.openDrawer(),
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : FinalLeaderBoard(
                        scoreBoard: scoreBoard,
                        winner: winner,
                      )
                : WaitingLobbyScreen(
                    lobbyName: roomData['roomName'],
                    noOfPlayer: roomData['players'].length,
                    occupancy: roomData['occupancy'],
                    players: roomData['players'],
                  )
            : const Center(
                child: CircularProgressIndicator(),
              ),
        floatingActionButton:roomData['isJoin'] != true && !isShowFinalLeaderboard?SizedBox(
          height: height*0.05,
          width: width*0.25,
          child: FloatingActionButton(
            onPressed: () {},
            elevation: 7,
            backgroundColor: Colors.white,
            child: Text(
              '$_start',
              style: const TextStyle(color: Colors.black, fontSize: 22),
            ),
          ),
        ):Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      ),
    );
  }

}

