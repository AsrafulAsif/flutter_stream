import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterstreamproject/models/Photo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PhotoList extends StatefulWidget {
  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  late StreamController<Photo> _streamController;
  List<Photo> list = [];

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<Photo>.broadcast();

    _streamController.stream.listen((p) => setState(() => list.add(p)));

    load(_streamController);
  }

  load(StreamController<Photo> sc) async {
    String url = "https://nagaderp.mynagad.com:7070/dcm/audit/api/getAllDSO";
    var client = http.Client();

    var req = http.Request('POST', Uri.parse(url))
      ..headers['Content-Type'] = 'application/json'
      ..headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjI0MTA2NSIsIkxvZ2VkSUQiOiI1MDU3MDIiLCJVc2VySUQiOiIxODAyIiwiUGVyc29uSUQiOiIxMzkwIiwiSXNBZG1pbiI6IkZhbHNlIiwiQXBwbGljYXRpb25JRCI6IjAiLCJDb21wYW55SUQiOiJuYWdhZCIsIkNvbXBhbnlOYW1lIjoiTkFHQUQgTFRELiIsIkxvZ0luRGF0ZVRpbWUiOiI2LzMwLzIwMjQgMTowNDoxNyBQTSIsIklQQWRkcmVzcyI6IjEwLjIxMC4yLjEzMSIsIlVzZXJOYW1lIjoiMjQxMDY1IiwiRnVsbE5hbWUiOiJNZC4gQXNyYWZ1bCBJc2xhbSBBc2lmIiwiU2hvcnROYW1lIjoiTm90IHlldCBzZXQiLCJJbWFnZVBhdGgiOiIvdXBsb2FkXFxpbWFnZXMvUGVyc29uXFwxMzkwIC0gTWQuQXNyYWZ1bElzbGFtQXNpZkFzaWYvUHJvZmlsZS0yMTEyMjMxNTM1NTMtMS5qcGciLCJJc0ZvcmNlZExvZ2luIjoiRmFsc2UiLCJFbXBsb3llZUlEIjoiMTM0OSIsIkVtcGxveWVlQ29kZSI6IjI0MTA2NSIsIkRpdmlzaW9uSUQiOiI1MzkiLCJEZXBhcnRtZW50SUQiOiI2NDgiLCJEaXZpc2lvbk5hbWUiOiJUZWNobm9sb2d5IFRyYW5zZm9ybWF0aW9uICYgUHJvZ3JhbSBPZmZpY2UiLCJEZXBhcnRtZW50TmFtZSI6IlNXICYgTVcgRGV2ZWxvcG1lbnQiLCJEZXNpZ25hdGlvbk5hbWUiOiJTb2Z0d2FyZSBFbmdpbmVlciIsIkRlc2lnbmF0aW9uSUQiOiI5MSIsIkNvbXBhbnlTaG9ydENvZGUiOiJOR0QiLCJXb3JrTW9iaWxlIjoiMDE4NDQ0ODA3OTAiLCJFbWFpbCI6ImFzcmFmdWwuYXNpZkBuYWdhZC5jb20uYmQiLCJSb2xlIjoiSFEiLCJuYmYiOjE3MTk3MzEwNTcsImV4cCI6MTcxOTgxNzQ1NywiaWF0IjoxNzE5NzMxMDU3fQ.3W0n3zSixVt5E97S37ElX2at2sb4w546asMLhQeuYZw';
    
    req.body = jsonEncode({"APP_VERSION": "3.1.1"});

    var streamedRes = await client.send(req);

 streamedRes.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((jsonElement) => jsonElement as Map<String, dynamic>?)
      .map((jsonMap) => jsonMap?['data'] as List<dynamic>?)
      .expand((data) => data ?? [])
      .map((map) => Photo.fromJsonMap(map as Map<String, dynamic>))
      .pipe(sc);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Streams"),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) => _makeElement(index),
          itemCount: list.length,
        ),
      ),
    );
  }

  Widget _makeElement(int index) {
    if (index >= list.length) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          // Image.network(list[index].url, width: 150.0, height: 150.0),
          Text(list[index].fullName),
          Text(list[index].dhName),
          Text(list[index].walletNumber),

        ],
      ),
    );
  }
}
