import 'package:flutter/material.dart';

class FinalLeaderBoard extends StatelessWidget {
  final scoreBoard;
  final String winner;
  const FinalLeaderBoard({ required this.scoreBoard,super.key, required this.winner});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
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
            SizedBox(height: height*0.05,),
            const Text('Leaderboard',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
            Column(children: [
              ListView.builder(
                primary: true,
                shrinkWrap: true,
                itemCount: scoreBoard.length,
                itemBuilder: (context,index){
                var data = scoreBoard[index].values;
                return ListTile(
                  title: Text(data.elementAt(0),style: const TextStyle(
                    color: Colors.white,fontSize: 23
                  ),),
                  trailing: Text(data.elementAt(1),style: const TextStyle(
                    color: Colors.yellow,fontSize: 20,fontWeight: FontWeight.bold
                  ),),
                );
              }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$winner has won the game!',style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
              )
      
            ]),
          ],
        ),
      ),
    );
  }
}