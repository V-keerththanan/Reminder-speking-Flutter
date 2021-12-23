import 'package:flutter/material.dart';

class BossDetails extends StatefulWidget {
  const BossDetails({Key? key}) : super(key: key);

  @override
  _BossDetailsState createState() => _BossDetailsState();
}

class _BossDetailsState extends State<BossDetails> {
  String DumName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[300],
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 60, left: 20, right: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Transform.rotate(
                  angle: 0.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi Sir ....",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            /*
                            Text("I am your Reminder ...",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30)),

                             */
                            Text("How can I call You? ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30)),
                            // Text("Enter Here.",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 30)),
                          ],
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Enter here!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  autofocus: true,
                  onChanged: (String value) {
                    setState(() {
                      DumName = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Your Name",
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                  ),
                  onPressed: () {
                    Navigator.pop(context, DumName);
                  },
                  child: Text("Done"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
