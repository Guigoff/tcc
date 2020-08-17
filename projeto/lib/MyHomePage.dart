import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:tcc/HomePage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {
      _barcodestring = new QRCodeReader()
          .setAutoFocusIntervalInMs(200)
          .setForceAutoFocus(true)
          .setTorchEnabled(true)
          .setHandlePermissions(true)
          .setExecuteAfterPermissionGranted(true)
          .scan();
    });
  }

  Future<String> _barcodestring;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        
        title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(
     
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new FutureBuilder<String>(
                future: _barcodestring,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return new Text(snapshot.data != null ? snapshot.data : '');
                }),
            Padding(
              padding:  EdgeInsets.all(20.0), //const EdgeInsets.symmetric(vertical: 70.0),
              child: RaisedButton(
                onPressed: (){
                  (Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>HomePage())));
                },
                color: Colors.deepPurple[600],
                child: Text("Meus Cartoes"),
                textColor: Colors.white,
              ),
            ),   
          ],
        ),
	    	
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add_a_photo),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}