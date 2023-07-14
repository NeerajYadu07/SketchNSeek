import 'package:flutter/material.dart';

class PlayerDrawer extends StatelessWidget {
  final List<Map>userData;
  const PlayerDrawer({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height*0.05,),
            const Text('Scores',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black),),
            SizedBox(
              height: double.maxFinite,
              child: ListView.builder(
                itemCount: userData.length,
                itemBuilder: (context,index){
                var data = userData[index].values;
                return ListTile(
                  title: Text(data.elementAt(0),style: const TextStyle(
                    color: Colors.black,fontSize: 23
                  ),),
                  trailing: Text(data.elementAt(1),style: const TextStyle(
                    color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold
                  ),),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}