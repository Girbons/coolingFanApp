import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(new MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  _makeRequest(String endpoint) {
    String baseUrl = '';
    String completeUrl = baseUrl + endpoint;
    http.get(new Uri.http(baseUrl, endpoint));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cooling FAN',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cooling FAN'),
          backgroundColor: new Color(0xFF000000),
        ),

      body: new Center(
        child: new ListView(
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(top: 120.0),
              alignment: Alignment.center,
              child: new FloatingActionButton(
                  elevation: 5.0,
                  child: Text('ON'),
                  backgroundColor: new Color(0xFF4CAF50),
                  onPressed: () {
                    _makeRequest('/fan-on/');
                  }
                )
              ),
              new Container(
                margin: const EdgeInsets.only(top: 90.0),
                alignment: Alignment.center,
                child: new FloatingActionButton(
                  child: Text('OFF'),
                  elevation: 5.0,
                  backgroundColor: new Color(0xFFE57373),
                  onPressed: (){
                    _makeRequest('/fan-off/');
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
