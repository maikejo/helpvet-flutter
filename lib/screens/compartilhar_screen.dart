import 'package:flutter/material.dart';

class CompartilharScreen extends StatefulWidget {
  @override
  _CompartilharScreenState createState() => new _CompartilharScreenState();
}

class _CompartilharScreenState extends State<CompartilharScreen> {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Compartilhar nas redes'),
        ),
        body: new Center(

        ),
      ),
    );
  }
}