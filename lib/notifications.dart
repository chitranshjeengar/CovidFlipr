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

int comp(Data a, Data b) {
  if (a.date == null) return -1;
  if (b.date == null) return 1;
  // print(a.date + b.date);
  String d1, d2, m1, m2, y1, y2;
  d1 = a.date.substring(0, 2);
  m1 = a.date.substring(3, 5);
  y1 = a.date.substring(6);
  d2 = b.date.substring(0, 2);
  m2 = b.date.substring(3, 5);
  y2 = b.date.substring(6);
  // print("y1 - " + y1 + " y2 - " + y2 + " " + y1.compareTo(y2).toString());
  // print("m1 - " + m1 + " m2 - " + m2 + " " + m1.compareTo(m2).toString());
  // print("d1 - " + d1 + " d2 - " + d2 + " " + d1.compareTo(d2).toString());
  return (y1.compareTo(y2) != 0
      ? y1.compareTo(y2)
      : (m1.compareTo(m2) != 0 ? m1.compareTo(m2) : (d1.compareTo(d2))));
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
          dataList.clear();
          for (var prop in snapshot.data.data) {
            temp = prop['title'];
            // print(temp);
            temp.trim();
            temp = temp.replaceAll('&nbsp;', ' ');
            temp = temp.replaceAll('   ', ' ');
            temp = temp.replaceAll('  ', ' ');

            if (temp.length > 10) {
              dt = temp.substring(0, 10);
              // temp = temp.substring(11);
            }
            // if (temp.length > 10)
            //   print(temp.substring(0, 10) +
            //       " " +
            //       temp
            //           .substring(0, 10)
            //           .contains(r'^[\x30-\x39.]*$')
            //           .toString());
            // if (temp.length > 10 &&
            //     temp.substring(0, 10).contains(r'^[0-9.]*$')) {
            //   dt = temp.substring(0, 10);
            //   temp = temp.substring(11);
            // }
            // print(temp);
            if (dt != null && dt.contains(new RegExp(r'[A-Za-z]'))) {
              // temp = dt + temp;
              dt = null;
            } else if (dt != null) temp = temp.substring(11);

            if (dt == null &&
                temp.substring(0, 2).contains(new RegExp(r'[0-9.]'))) {
              // temp[0].replaceAll(new RegExp(r'[0-9]'), '');
              temp = temp.substring(3);
            }

            dataList.add(Data(
              title: temp,
              link: prop['link'],
              date: dt,
            ));
          }
          dataList.sort((b, a) => comp(a, b));

          // for (var prop in dataList) print(prop.date);
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
