import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class aboutPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('About'),
      ),
       body: ListView(
         children: <Widget>[
           new Text('Created By: Josh Beers',textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline4,),
           new Text('For Itec 4550',textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline4),
           new Image.asset('Assets/potato.jpeg',height: 200,width: 100),
           new Text('4/28/2020', textAlign: TextAlign.center,)
         ],
       ),
    );
  }


}