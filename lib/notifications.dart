import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Data {
  String title;
  String link;
  Data(this.title, this.link);
}

List<Data> dataList = [];

class Notifications {
  final bool success;
  var data;
  final String lastRefreshed, lastOriginUpdate;

  Notifications(
      {this.success, this.data, this.lastRefreshed, this.lastOriginUpdate});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      success: json['success'],
      data: json['data']['notifications'],
      lastRefreshed: json['lastRefreshed'],
      lastOriginUpdate: json['lastOriginUpdate'],
    );
  }
}

Future<Notifications> getData() async {
  final response =
      await http.get('https://api.rootnet.in/covid19-in/notifications');

  if (response.statusCode == 200)
    return Notifications.fromJson(json.decode(response.body));
  else
    throw Exception('Server not Responding');
}

// class NotificationScreen extends StatefulWidget {
//   Future<Notifications> noti;
//   NotificationScreen({Key key, this.noti}) : super(key: key);

//   _NotiFicationScreenState createState() => _NotiFicationScreenState();
// }

class NotiFicationScreen extends StatelessWidget {
  final Future<Notifications> noti;
  NotiFicationScreen({Key key, this.noti}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Notifications>(
      future: noti,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print(snapshot.data.data);
          // for (var prop in snapshot.data.data) {
          //   // print(prop['title'] + " " + prop['link']);
          //   dataList.add(Data(
          //     prop['title'],
          //     prop['link'],
          //   ));
          // }
          // for (var prop in dataList) print(prop.title + " " + prop.link);
          return ListView.builder(
            itemCount: snapshot.data.data.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Text(snapshot.data.data[index]['link']);
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
