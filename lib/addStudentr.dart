import 'package:flutter/material.dart';

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() {
    return _AddStudentScreenState();
  }
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  // this allows us to access the TextField text
  TextEditingController textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second screen'),
      actions: <Widget>[
        IconButton(
          icon: Text('Add'),
          onPressed:() =>{ _sendDataBack(context)},
        )
        ],
      ),
      body: ListView(
        children: [

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: textFieldController
            ),
          ),


        ],
      ),
    );
  }

  // get the text in the TextField and send it back to the FirstScreen
  void _sendDataBack(BuildContext context) {
    String textToSendBack = textFieldController.text;
    Navigator.pop(context, textToSendBack);
  }
}