

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';
import 'main1.dart';


// void main() => runApp(MaterialApp(
//
//   debugShowCheckedModeBanner: false,
//   theme: ThemeData(
//       brightness: Brightness.light,
//       primaryColor: Colors.blue,
//       accentColor: Colors.orange),
//   home: MyApp(),
// ));

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.orange),
    home: Chart(),
  ));
}

class Chart extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<Chart> {
  String todoTitle = "";
  String price ="";
  int icon =0xf316;
  static int total1=0;
  int total2=0;
  String totaPrice="";
  createTodos(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyTodos").doc(todoTitle);
    DocumentReference total = FirebaseFirestore.instance.collection("MyTodos").doc(price);
    Map<String ,String> todos ={
      "todoTitle":todoTitle,
      "timestamp": DateTime.now().toString(),
      "price": price.toString(),
      "icon":icon.toString(),
      "total":(total2+int.parse(price)).toString(),
    };
    documentReference.set(todos).whenComplete(() {
      print("$todoTitle create");
      total1+=int.parse(price);
      print("total1:$total1");
      print("price:$price");

    });
  }
  // void getPrices() async {
  //   final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('MyTodos').get();
  //   for (DocumentSnapshot document in snapshot.docs) {
  //     //print(document['price']);
  //     totaPrice=document['price'].toString();
  //    // print(totaPrice);
  //     total1+=int.parse(totaPrice);
  //     print("total=$total1");
  //   }
  // }
  deleteTodos(item){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyTodos").doc(item);
    DocumentReference total = FirebaseFirestore.instance.collection("MyTodos").doc(price);
    documentReference.delete().whenComplete(() {
      print("$item delete");
    });
    documentReference.update({"total":(total2)});

  }
  int _selectedIndex = 0;
  final pages = [MyApp(),Lottery(),Chart()];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.push(context, MaterialPageRoute(builder: (context) =>pages[index]));
      _selectedIndex = 1;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          //"mytodos"
        // 總共:$total2元
        title: Text("記事清單"),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      title: Text("紀錄"),
                      content: TextField(
                        onChanged: (String value){
                          todoTitle = value;
                        },
                      ),

                      actions: <Widget>[

                        TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (String value) {
                              price = value;
                            }),
                        Column(
                            children: <Widget>[
                              Text(""),
                              Text(""),

                            ]
                        ),
                        Row(
                            children: <Widget>[
                              Container(
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      icon=0xf316;
                                      print("123");
                                    });
                                  }, icon: Icon(
                                  Icons.restaurant_outlined,
                                  color: Colors.red,
                                ),
                                ),),
                              Container(
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      icon=0xe5e4;
                                    });
                                  }, icon: Icon(
                                  Icons.sports_bar_outlined,
                                  color:Colors.red,
                                ),
                                ),),
                              Container(
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      icon=0xe058;
                                    });
                                  }, icon: Icon(
                                  Icons.add_reaction,
                                  color: Colors.red,
                                ),
                                ),),
                              Text("                           "),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      createTodos();
                                      // getPrices();
                                      total2=total1+int.parse(price);
                                      print("收入=$total2");
                                      icon =0xf316;
                                      Navigator.of(context).pop();
                                    });

                                  },
                                  child: Text("確認")
                              ),
                            ]
                        ),
                      ],
                    );
                  });
            },
            child: Icon(
                Icons.add,
                color: Colors.white
            )
        ),
        body: StreamBuilder(stream:FirebaseFirestore.instance.collection("MyTodos").snapshots()
            ,builder: (context,snapshots)
            {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshots.data?.docs.length,
                  itemBuilder: (context,index) {
                    DocumentSnapshot? documentSnapshot = snapshots.data?.docs[index];
                    return Dismissible(
                        onDismissed: (direction){
                          deleteTodos(documentSnapshot?["todoTitle"]);
                        },
                        key: Key(documentSnapshot?["todoTitle"]),

                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: ListTile(

                            // title: Text(todos[index]),
                            title: Text("${documentSnapshot?["todoTitle"]}"+"  "+
                                "${documentSnapshot?["price"]}"+"元"),
                            // subtitle: Text(documentSnapshot?['price']),
                            leading: Icon(
                                IconData(int.parse(documentSnapshot?["icon"]) ,fontFamily: 'MaterialIcons')
                            ),
                            trailing:Wrap(
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          // todos.removeAt(index);
                                          total1-=int.parse(documentSnapshot?["price"]);
                                          total2=total1;
                                          print("收入=$total2");
                                          deleteTodos(documentSnapshot?["todoTitle"]);

                                        });
                                      }),
                                ]

                            ),
                          ),
                        ));
                  })
              ;
            }),
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




