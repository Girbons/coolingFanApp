import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class SettingsPage extends StatefulWidget {
  @override
  _SettingsStatePage createState() => _SettingsStatePage();
}



class _MyAppState extends State<MyApp> {
  int index = 0;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cooling FAN',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cooling FAN'),
          backgroundColor: Color(0xFF000000),
        ),

        body: Stack(
          children: <Widget> [
            Offstage(
              offstage: index != 0,
              child: TickerMode(
                enabled: index == 0,
                child: MaterialApp(home: HomePage()),
              ),
            ),

            Offstage(
              offstage: index != 1,
              child: TickerMode(
                enabled: index == 1,
                child: MaterialApp(home: SettingsPage()),
              ),
            ),
          ]
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (int index) {
            setState(() {
              this.index = index;
            });
          },
          items: <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text("Settings"),
            ),
          ]
        ),
      ),
    );
  }
}


class HomePage extends StatelessWidget {

  String _retrieveSocket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ip = prefs.getString('ip');
    int port = prefs.getInt('port');
    return ip + ':' + port.toString();
  }

  void _makeRequest (String endpoint) async {
    String baseUrl = await this._retrieveSocket();
    String completeUrl = baseUrl + endpoint;
    http.get(Uri.http(baseUrl, endpoint));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            margin: EdgeInsets.only(top: 120.0),
            alignment: Alignment.center,
            child: FloatingActionButton(
                elevation: 5.0,
                child: Text('ON'),
                backgroundColor: Color(0xFF4CAF50),
                onPressed: () {
                  _makeRequest('/fan-on/');
                }
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 90.0),
              alignment: Alignment.center,
              child: FloatingActionButton(
                child: Text('OFF'),
                elevation: 5.0,
                backgroundColor: Color(0xFFE57373),
                onPressed: (){
                  _makeRequest('/fan-off/');
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Settings {
  String ip = '';
  int port = null;
}


class _SettingsStatePage extends State<SettingsPage> {
 final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _ipForm;
  TextEditingController _portForm;
 _Settings _settingsData = new _Settings();

 @override
 void initState() {
   super.initState();
   this._loadSettings();

 }

 _loadSettings() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
     this._settingsData.ip = prefs.getString('ip');
     this._settingsData.port = prefs.getInt('port');

     _ipForm = TextEditingController(text: this._settingsData.ip);
     _portForm = TextEditingController(text: this._settingsData.port.toString());
   });
 }

 void submit() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   _formKey.currentState.save();

   prefs.setInt('port', this._settingsData.port);
   prefs.setString('ip', this._settingsData.ip);
 }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: Form(
          key: this._formKey,
          child: ListView(
            children: <Widget> [
              TextFormField(
                controller: _ipForm,
                decoration: InputDecoration(
                  hintText: '192.168.1.78',
                  labelText: 'IP',
                ),
                onSaved: (String value) {
                  this._settingsData.ip = value;
                }
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _portForm,
                decoration: InputDecoration(
                  hintText: '8000',
                  labelText: 'Port'
                ),
                onSaved: (String value) {
                  this._settingsData.port = int.parse(value);
                }
              ),
              Container(
                width: screenSize.width,
                child: new RaisedButton(
                  child: new Text(
                    'Save',
                    style: new TextStyle(
                      color: Colors.white
                    ),
                  ),
                  onPressed: this.submit,
                  color: Colors.blue,
                ),
                margin: new EdgeInsets.only(
                  top: 20.0
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
