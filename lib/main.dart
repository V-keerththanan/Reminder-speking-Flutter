
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:again/add_messages.dart';
import 'package:again/get_boss_details.dart';
import 'package:again/speak_assistant.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Databse/todo_model.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();


const String todoBoxName = "todo";
const String pres="pres";

late SharedPreferences prefs;
late SharedPreferences pre;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>(todoBoxName);
  await Hive.openBox<String>("boss");
  prefs = await SharedPreferences.getInstance();
  pre=await SharedPreferences.getInstance();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}


/*
f(int j){
  print('Alarm fired!' + '$j');

  print(todoBox.get(j)!.message);
}

 */


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late Box<TodoModel> todoBox;
  late Box<String> b;




   static Future<void> FireAlaram(int i)async {

   print('Alarm fired!' + '$i');
   final pre=await SharedPreferences.getInstance();
   String? currentMessage=pre.getString("pers${i}");
   FlutterTts alexa = FlutterTts();
   if(currentMessage!=null){
     await alexa.speak(currentMessage);
   }
   await alexa.setSpeechRate(0.55);





  }


  var t = DateTime(1999);
  var needmessage;
  var products = [];
  var m = {};
  //............Here, i have created 2 list for store data values temp.....
  List<String> Reminders_messages = [];
  List<String> Reminders_times = [];
  String? BosName = "";

  //..............Here is Actual Local list..............................
  List<String> store_message = [];
  List<String> store_time = [];

//...................Here , set boss name .......
  boss_manager() {
    if (BosName == "" || BosName == null) {
      return "Welcome sir";
    } else {
      return "Welcome ${BosName}";
    }
  }

  //...........................................Here is function

  @override
  void initState() {
    // TODO: implement initState
    AndroidAlarmManager.initialize();
    super.initState();
    todoBox = Hive.box<TodoModel>(todoBoxName);
    b = Hive.box<String>("boss");

    if (BosName != "" || b.get("b") != null) {
      setState(() {
        BosName = b.get("b");
      });

      Assistant("Welcome ${BosName}").speak();
    } else {
      Assistant("Welcome Sir").speak();
    }
   //do_backgroundTask();

  }

  do_backgroundTask() {

    var ke = todoBox.keys.cast<int>().toList();
    if (ke.length > 0) {
      for (var _k in ke) {
        if (todoBox.get(_k)!.time.compareTo(DateTime.now()) >= 0) {
          m.addAll(todoBox.get(_k)!.toMap());
        }
      }
      if (m.length > 0) {
        products = m.keys.toList();
        products.sort();
        print(products[0]);
        setState(() {
          t = products[0];
        });

       print(t);
       print(m[t]);


        AndroidAlarmManager.oneShotAt(t, 1, FireAlaram,
            alarmClock: true, wakeup: true);

      }
    }
  }



  @override
  Widget build(BuildContext context) {
    double h =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double w = MediaQuery.of(context).size.width;
    return Container(
        decoration: BoxDecoration(

        gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [

         //
   // Color(0x995ac18e),
    Color(0xcc5ac18e),
    Color(0xff5ac18e),


    ]),
        ),
    child: Scaffold(
      backgroundColor: Color(0x00000000),
        body: SafeArea(

          child: Column(
            children: [
              Container(
                height: h * 0.30,
                decoration: BoxDecoration(

                    border: Border.all(color: Colors.white),

                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(h * 0.0732111251580278),
                        bottomRight: Radius.circular(h * 0.0732111251580278))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: h * 0.05690926, left: 10),
                          child: const Text(
                            "Remainder",
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w300),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: h * 0.06990926, right: 10),
                          child: PopupMenuButton(
                              color: Colors.grey[200],
                              onSelected: (int val) async {
                                //Here is a Clear part of All remainder messages
                                if (val == 1) {
                                  print(DateTime.now());
                                  todoBox.clear();
                                } else {
                                  var DoubleDummi = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BossDetails())) as String;
                                  if (DoubleDummi != "") {
                                    b.put("b", DoubleDummi);

                                    setState(() {
                                      BosName = b.get("b")!;
                                    });
                                  }
                                }
                              },
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 1,
                                      child: Text(
                                        "Clear",
                                        style: TextStyle(),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: Text("Boss"),
                                    ),
                                  ]),
                        )
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10, top: h * 0.01690926),
                        child: Text(
                          boss_manager(),
                          style: TextStyle(fontWeight: FontWeight.w300),
                        )),
                  ],
                ),
              ),
              //
              SizedBox(height: 8),
              //Here i have created Builder .....Important part of this app
              Expanded(
                  child: ValueListenableBuilder(
                valueListenable: todoBox.listenable(),
                builder: (context, Box<TodoModel> todos, _) {
                  List<int> keys;
                  keys = todos.keys.cast<int>().toList();

                  return ListView.separated(
                    itemBuilder: (_, index)  {
                      final int key = keys[index];
                      if (todoBox.get(key)!.time.compareTo(DateTime.now()) >= 0) {
                        AndroidAlarmManager.oneShotAt(todos.get(key)!.time, key, FireAlaram,
                            exact: true, wakeup: true);

                        pre.setString("pers${key}",todos.get(key)!.message );

                      }else{
                        todoBox.get(key)!.delete();
                        AndroidAlarmManager.cancel(key);
                        pre.remove("pers${key}");
                      }


                      final TodoModel? todo = todos.get(key);

                      return Container(
                          padding: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? EdgeInsets.all(h * 0.025351627067425)
                              : EdgeInsets.all(10),
                          margin:
                              EdgeInsets.only(right: 8.0, left: 8.0, bottom: 4),
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? h * 0.139560187487693
                              : 110,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white70),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              todo!.message.length > 25
                                  ? Text(
                                      "message : ${todo.message.substring(0, 25)}...",
                                      style: TextStyle(fontSize: 16),
                                    )
                                  : Text(
                                      "message : ${todo.message}...",
                                      style: TextStyle(fontSize: 16),
                                    ),
                              SizedBox(
                                height: 0.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "Date&Time : ${DateFormat.yMd().add_jm().format(todo.time)}"),
                                  // Here i am going to add two icon button for deleting and editting
                                  IconButton(
                                      onPressed: () {
                                        todoBox.get(key)!.delete();
                                      },
                                      icon: Icon(Icons.delete_outlined)),
                                  IconButton(
                                      onPressed: () {},
                                      icon:
                                          Icon(Icons.add_to_home_screen_rounded)),
                                ],
                              )
                            ],
                          ));
                    },
                    separatorBuilder: (_, index) => Divider(),
                    itemCount: keys.length,
                    shrinkWrap: true,
                  );
                },
              )),
            ],
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () async {
            dynamic D_message_pair = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Message(
                          h: h,
                          w: w,
                        )));
            // print(D_message_pair);

            if (D_message_pair[0] != "") {
              final String _message = D_message_pair[0];
              var _time = D_message_pair[1];

              TodoModel todo = TodoModel(_message, _time);
             // temp_box.put(alaram_ID, _message);

              todoBox.add(todo);
            }
          },
          child: Icon(Icons.add,color: Colors.black,),
        ),
      ),
    );
  }
}


