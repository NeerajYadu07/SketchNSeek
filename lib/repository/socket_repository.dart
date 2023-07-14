import 'package:socket_io_client/socket_io_client.dart';

import '../clients/socket_client.dart';

class SocketRepository{
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  void createRoom(Map<String,dynamic>data) {
    _socketClient.emit('create-room', data);
    
  }

  void joinRoom(Map<String,dynamic>data) {
    _socketClient.emit('join-room', data);
  }

  void paint (Map<String,dynamic>data){
    _socketClient.emit('paint',data);

  }

  void changeColor(Map<String,dynamic>data){
    _socketClient.emit('color-change',data);
  }

  void changeStrokeWidth(Map<String,dynamic>data){
    _socketClient.emit('stroke-width',data);
  }

  void cleanScreen(String data){
    _socketClient.emit('clean-screen',data);
  }

  void sendMessage(Map<String,dynamic>data){
    _socketClient.emit('message',data);
  }

  void changeTurn(dynamic data){
    _socketClient.emit('change-turn',data);
  }
  
  void updateScore(dynamic data){
    _socketClient.emit('update-score',data);
  }

  void roomChangeListner(Function(Map<String,dynamic>) func){
    _socketClient.on('update-room',(data)=> func(data));
  }

  void pointsChangeListner(Function(Map<String,dynamic>) func){
    _socketClient.on('points',(data)=> func(data));
  }

  void colorChangeListner(Function(String) func){
    _socketClient.on('color-change',(data)=> func(data));
  }

  void strokeWidthChangeListner(Function(double) func){
    _socketClient.on('stroke-width',(data)=> func(data));
  }

  void cleanScreenChangeListner(Function(dynamic) func){
    _socketClient.on('clean-screen',(data)=> func(data));
  }

  void messageListner(Function(dynamic) func){
    _socketClient.on('message',(data)=> func(data));
  }

  void changeTurnListner(Function(dynamic) func){
    _socketClient.on('change-turn',(data)=> func(data));
  }

  void changeRoundListner(Function(dynamic) func){
    _socketClient.on('change-round',(data)=> func(data));
  }

  void closeInput(Function(dynamic) func){
    _socketClient.on('close-input',(data)=> func(data));
  }

  void updateScoreChangeListner(Function(dynamic) func){
    _socketClient.on('update-score',(data)=> func(data));
  }

  void showLeaderboard(Function(dynamic) func){
    _socketClient.on('show-leaderboard',(data)=> func(data));
  }

  void userDisconnected(Function(dynamic) func){
    _socketClient.on('user-disconnected',(data)=> func(data));
  }
  
  void invalidGame(Function(dynamic) func){
    _socketClient.on('invalid-game',(data)=> func(data));
  }

}