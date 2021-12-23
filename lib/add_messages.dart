import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';

class Message extends StatefulWidget {
  var h;
  var w;

  Message({Key? key, required this.h, required this.w}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  // String _message = "";
  String r="";
  FlutterTts siri = FlutterTts();
  var Actual_time_byUser;
  TextEditingController con = TextEditingController();

  time_manager() {
    if (Actual_time_byUser == null) {
      return "Set Date&time";
    } else {
      return r;
    }
  }

  List<dynamic> pair = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Add message",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                        MediaQuery
                            .of(context)
                            .size
                            .height * 0.050539),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Date&Time :-",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.234375),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors
                                .white),
                            //Here is time manager
                            child: Text(time_manager().toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            onPressed: () {
                              TimePicker();
                            },
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "message:-",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(

                    controller: con,
                    maxLines: 10,

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery
                          .of(context)
                          .size
                          .width * 0.4),
                  child: ElevatedButton(
                      onPressed: () {
                        if (Actual_time_byUser == null) {
                          Navigator.pop(context);
                          pair.clear();
                        } else {
                          if (con.text == "") {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        "If you set a Date and time ,\n You should enter the message"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Accept"))
                                    ],
                                  );
                                });
                          } else {
                            pair.add(con.text);
                            pair.add(Actual_time_byUser);
                            pair.add(r);

                            Navigator.pop(context, pair);
                          }
                        }
                      },
                      child: Text("Done")),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  void TimePicker() async {
    // Here i am going to try Date time picker
    var _date;
    DateTime currentDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if(pickedDate != null ) {

      setState((){
        _date = pickedDate;
      });
      TimeOfDay initialTime = TimeOfDay.now();
      TimeOfDay? result = await showTimePicker(
          context: context,
          initialTime: initialTime,
          builder: (context, childWidget) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(

                    alwaysUse24HourFormat: false),
                //set this as false to use 12 hour format

                child: childWidget!);
          }
      );

      if(result!=null){


        DateTime temp=DateTime(_date.year,_date.month,_date.day,result.hour,result.minute);
       String formattedDate =  DateFormat.yMd().add_jm().format(temp);
        setState(() {
          Actual_time_byUser=temp;
          r=formattedDate;
        });


          print(formattedDate);
      }

      print(Actual_time_byUser);

    }





  }

}



