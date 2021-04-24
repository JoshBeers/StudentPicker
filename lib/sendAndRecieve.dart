import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class sendAndReceiveScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Send/ Receive'),
          bottom: TabBar(
            tabs: <Widget>[
              Column(
                children: <Widget>[
                  Icon(Icons.arrow_upward),
                  Text('Send')
                ],
              ),
              Column(
                children: <Widget>[
                  Icon(Icons.arrow_downward),
                  Text('Receive')
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(child:Text('Send- comming soon',
          textAlign: TextAlign.center,)),
            Center(child: Text('Receve - Coming Soon',
              textAlign: TextAlign.center)
            )
          ],
        ),
      ),
    );
  }

}