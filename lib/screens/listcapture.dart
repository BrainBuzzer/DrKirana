import 'package:flutter/material.dart';

class ListCapturePage extends StatefulWidget {
  final String type;

  ListCapturePage ({ this.type });

  @override
  _ListCapturePageState createState() => _ListCapturePageState();
}

class _ListCapturePageState extends State<ListCapturePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new Text("List Capture Page" + widget.type),
      )
    );
  }
}
