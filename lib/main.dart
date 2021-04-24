import 'dart:io';
import 'dart:math';

import 'package:finalproject/aboutPage.dart';
import 'package:finalproject/addStudentr.dart';
import 'package:finalproject/sendAndRecieve.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


/*
Created By: Josh Beers
For: itec: 4550
Created 4/28

 */
void main() {
  runApp(MyApp(
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.green,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Thorns, buds, and roses'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Student> _students = List<Student>();
  String result= "";
  Image i = new Image.asset('Assets/thorn.png',width: 70,height: 70);
  final String fileName = 'list.txt';

  @override
  void initState() {
    super.initState();
   setState(() {
     _readList().then((value) => _students = value);
   });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<List<Student>> _readList() async {
    print('read file');
    String text;
    List<Student> rtn = new List<Student>();
    try {
      final File file = await _localFile;
      text = await file.readAsString();

      List<String> temp = text.split('/');
      print(temp.length);
      if(temp.length > 0 || temp[0]==''){
        temp.forEach((element) {
          bool b = false;
          if(element.split(',')[1] == 'true')
            b= true;
          rtn.add(new Student(element.split(',')[0], b));
        });
      }


    } catch (e) {
      print("Couldn't read file");
    }
    return rtn;
  }

  void _saveList() async {
    print('writefile');
    writeStudents(_students).then((value) => print('file written'));
  }

  Future<File> writeStudents(List<Student> names) async {
    print(names);
    final file = await _localFile;  // Write the file
    var sink = file.openWrite(mode: FileMode.write);

    String text = '';

    _students.forEach((element) {
      if(text == ''){
        text = '${element.name},${element.hidden}';
      } else {
        text = text +'/${element.name},${element.hidden}';
      }
    });

    sink.write(text);
    
    await sink.flush();
    await sink.close();
    print(text);

    return file;
  }








  _hideElement(int index){
    print('student at index $index hidden status changed through hideElement');
    setState(() {
      _students[index].hidden = !_students[index].hidden;
    });
    _saveList();
  }
  
  _deletElement(int idex){
    print('delete elem at $idex');
    setState(() {
      _students.removeAt(idex);
    });
    _saveList();
  }

  _faBOnPress() {
    print('fab pressed');
   Student s = _getRandomStudent();
   print('student '+s.name+' chose');
   setState(() {
     result = s.name;
   });
   bool temp = true;
   if(s.name == 'There are no \navaible students'){
     temp = false;
   }
   setIcon(temp);
  }

  Student _getRandomStudent() {
    List<Student> temp = _students.where((element) => !element.hidden).toList();
    Random r = new Random();
    
    if(temp.length == 0){
      return new Student('There are no \navaible students', false);
    }
    return temp[r.nextInt(temp.length)];
  }
  
  setIcon(bool display) {
    if(!display){
      i = new Image.asset('Assets/thorn.png',width: 0,height: 0);

      return;
    }
    Random r = new Random();
    int ii = r.nextInt(3);
      if(ii == 0){
        setState(() {
          i = new Image.asset('Assets/thorn.png',width: 70,height: 70);
        });
      }
      else if( ii == 1) {
        setState(() {
          i = new Image.asset('Assets/rose.jpg',width: 70,height: 70);
        });
      }
      else {
        setState(() {
          i = new Image.asset('Assets/bud.png', width: 70, height: 70);
        });
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _handleClick,
            itemBuilder: (context){
              return {'Send/Recive', 'Add Name','Sort','Shuffle','Clear','About'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),

      body: ListView(

        children: <Widget>[

          new Image.asset('Assets/bbuildingwavy.jpg'),
          new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              new Text(result,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
                i
            ]

          ),

          Container(
            height: MediaQuery.of(context).size.height*.65,
          child:ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            // Let the ListView know how many items it needs to build.
            itemCount: _students.length,
            // Provide a builder function. This is where the magic happens.
            // Convert each item into a widget based on the type of item it is.
            itemBuilder: (context, index) {
              final item = _students[index];

              return Dismissible(
                key: ObjectKey(item),

                child:GestureDetector(child:item.buildTitle(context),
                onTap: () => _hideElement(index)),



                direction: DismissDirection.endToStart,
                onDismissed: (direction) => {

                  if(direction == DismissDirection.endToStart){
                    _deletElement(index)
                  }
                },
              );
            },
          )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){_faBOnPress();},
        child: Icon(Icons.sync),
        backgroundColor: Colors.green,
      ),
    );
  }


  void _handleClick(String val) {
    switch(val){
      case 'Clear':{
        setState(() {
          _students.clear();
        });
        _saveList();
      }
      break;

      case 'Sort': {
        setState(() {
          _students.sort((student1, student2)=>student1.name.compareTo(student2.name));
        });
        _saveList();

      }
      break;

      case 'Shuffle': {
        setState(() {
          _shuffleList();
        });

      }
      break;

      case 'Add Name': {
        _handleAddStudent();
      }
      break;

      case 'Send/Recive': {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> sendAndReceiveScreen()));

      }
      break;

      case 'About': {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> aboutPage()));
      }
      break;
    }
  }

  void _handleAddStudent() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder:(context) => AddStudentScreen()
        ));
    setState(() {
      if(result == null)
        return;
      else {
        _students.add(new Student(result, false));
      }
    });
    _saveList();
  }

  void _shuffleList() {
    if(_students.length == 0)
      return;
    Random r = new Random();
    _students.forEach((element) {
      switchElements(_students, r.nextInt(_students.length), r.nextInt(_students.length));
    });
    _saveList();
  }

  void switchElements(List<Student> list,int a,int b) {
    Student ta = _students[a];
    _students[a] = _students[b];
    _students[b] = ta;
  }

}


class Student {
  final String name;
  bool hidden;

  Student(this.name, this.hidden );

  Widget buildTitle(BuildContext context) {
    if(hidden){

    } else{
      return Card(child:ListTile(title:Text(name)));
    }
    return Card(
        child: ListTile(
          title:Text(name),
          trailing: Icon(Icons.visibility_off),
        )
    );
  }

}



/// A ListItem that contains data to display a message.
