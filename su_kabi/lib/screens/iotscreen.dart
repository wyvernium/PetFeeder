import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class IotScreen extends StatefulWidget {
  const IotScreen({Key? key}) : super(key: key);

  @override
  _IotScreenState createState() => _IotScreenState();
}

class _IotScreenState extends State<IotScreen> {
  @override
  bool value = false;
  final dbRef = FirebaseDatabase.instance.reference();

  onUpdate() {
    setState(() {
      value = !value; //toggles between true and false
    });
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      body: StreamBuilder(
          stream: dbRef.child("Data").onValue,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data.snapshot.value != null) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.clear_all,
                          color: Colors.black,
                        ),
                        Text(
                          "Water Level",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.settings)
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Storage",
                              style: TextStyle(
                                  color: value ? Colors.red : Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.data.snapshot.value["Storage:"]
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Bowl",
                          style: TextStyle(
                              color: value ? Colors.red : Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.data.snapshot.value["Bowl:"].toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.data.snapshot.value["pump"],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      onUpdate();
                      // we need to write   data to firebase so that our light can respond to it
                      writeData(); //lets write this function
                    },
                    label: value ? Text("Refill") : Text("Stop"),
                    elevation: 20,
                    backgroundColor: value ? Colors.green : Colors.red,
                    icon: value ? Icon(Icons.autorenew) : Icon(Icons.block),
                  )
                ],
              );
            } else
              return Container();
          }),
    );
  }

  Future<void> writeData() async {
    // lets also create a Data node for temperature and Humudity
    //dbRef.child("Data").set({"Bowl:": 0, "Storage:": 0});
    // now we need to listen to the changes in humudity and temperature
    dbRef.child("Motor").set({"switch": !value});
  }
}

// we have succesfully built our app
//now we need to connect nodeMCU to the same firebase realtime database
//the nodeMCU will now push the temp and humidity to this "Data" node
//our app will push the light state to the child "LightState" node and will turn on
//the StreamBuilder widget in our app has a stream on dbRef.onValue whis widget will listen to any changes in the stream
//whenever a new value of emperature or humidity is received in the database the value in the app changes
