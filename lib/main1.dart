import 'package:flutter/material.dart';
import 'package:lottery/lottery_widget.dart';

import 'Chart.dart';
import 'main.dart';

void main() {
  runApp(const Lottery());
}
class Lottery extends StatelessWidget{
  const Lottery({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '九宮格抽獎',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MySetSelect(),
    );
  }
}

// Define a custom Form widget.
class MySetSelect extends StatefulWidget {
  const MySetSelect({ Key? key,}) : super(key: key);
  @override
  State<MySetSelect> createState() => _MySetSelectState();
}

final textFieldValues = List.generate(8, (index) => "");
// Define a corresponding State class.
// This class holds the data related to the Form.
class _MySetSelectState extends State<MySetSelect> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  //final textFieldValues = List.generate(8, (index) => "");
  @override
  Widget build(BuildContext context) {
    var stringListReturnedFromApiCall = ['1','2','3','4','5','6','7','8'];
    // This list of controllers can be used to set and get the text from/to the TextFields
    Map<String,TextEditingController> textEditingControllers = {};
    //var textFields = <TextField>[];
    var textFields = <Container>[];
    var idx = 0;
    stringListReturnedFromApiCall.forEach((str) {
      var textEditingController = new TextEditingController(text: str);
      textEditingControllers.putIfAbsent(str, ()=>textEditingController);
      //return textFields.add( TextField(controller: textEditingController));
      idx += 1;
      return textFields.add(
          Container(
              child: Row(children: [
                Expanded(
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.only(left: 10),
                    child: Text("第${(idx)}項"),
                  ),
                ),
                Container(
                  width: 200,
                  padding: EdgeInsets.only(right: 10),
                  child: TextField( textAlign: TextAlign.center, controller: textEditingController),
                )
              ])
          ));
    });
    int _selectedIndex = 0;
    final pages = [MyApp(),Lottery(),Chart()];
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        Navigator.push(context, MaterialPageRoute(builder: (context) =>pages[index]));
        _selectedIndex = 1;
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('獎項設定'),
        ),
        body: SingleChildScrollView(
            child: new Column(
                children:[
                  Container( padding: const EdgeInsets.all(40.0),child:Column(children:  textFields)),
                  ElevatedButton(
                      child: Text("設定完成"),
                      onPressed: (){
                        var i = 0;
                        stringListReturnedFromApiCall.forEach((str){
                          //print(textEditingControllers[str]!.text);
                          textFieldValues[i] = textEditingControllers[str]!.text;
                          i+=1;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()));
                      })
                ]
            )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'EatToday',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe44c, fontFamily: 'MaterialIcons')),
            label: 'Note',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }
}

//-------------------------------------------------------------------------
class MyApp1 extends StatelessWidget {
  const MyApp1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '九宫格抽奖',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<LotteryEntity> list;

  @override
  void initState() {
    super.initState();
    list = [
      LotteryEntity(textFieldValues[0]),
      LotteryEntity(textFieldValues[1]),
      LotteryEntity(textFieldValues[2]),
      LotteryEntity(textFieldValues[3]),
      LotteryEntity(textFieldValues[4]),
      LotteryEntity(textFieldValues[5]),
      LotteryEntity(textFieldValues[6]),
      LotteryEntity(textFieldValues[7]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('九宫格抽奖'),
      ),
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: LotteryWidget(list: list),
        ),
      ),
    );
  }
}
