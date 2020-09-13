import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Data {
  String title, link, date;
  Data({this.title, this.link, this.date});
}

List<Data> dataList = [];

class Notifications {
  final bool success;
  var data;
  // List<Data> dataList;
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

class NotiFicationScreen extends StatelessWidget {
  final Future<Notifications> noti;
  NotiFicationScreen({Key key, this.noti}) : super(key: key);

  _launchURL(String url) async {
    // String url = 'https://google.com';
    if (await canLaunch(url))
      await launch(url);
    else
      throw 'Could not Launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Notifications>(
      future: noti,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String temp, dt;
          for (var prop in snapshot.data.data) {
            temp = prop['title'];
            // print(temp);
            temp = temp.replaceAll('&nbsp;', '');
            temp = temp.replaceAll('  ', ' ');
            temp.trim();

            if (temp.length > 10) {
              dt = temp.substring(0, 10);
              // temp = temp.substring(11);
            }
            // print(temp);
            // if (dt != null) print(dt);
            if (dt != null && dt.contains(new RegExp(r'[A-Za-z]'))) {
              // temp = dt + temp;
              dt = null;
            } else if (dt != null) temp = temp.substring(11);

            dataList.add(Data(
              title: temp,
              link: prop['link'],
              date: dt,
            ));
          }
          // for (var prop in dataList) print(prop.title + " " + prop.link);
          return ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return ListTile(
                title: Text(dataList[index].title),
                onTap: () {
                  _launchURL(dataList[index].link);
                },
                // trailing: IconButton(
                //   icon: Icon(Icons.arrow_forward_ios),
                //   onPressed: () {
                //     // _launchURL(dataList[index].link);
                //   },
                // ),
                trailing: Icon(Icons.arrow_forward_ios),
              );
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
