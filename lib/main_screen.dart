import 'package:covid_19_stats/notifications.dart';
import 'package:covid_19_stats/themeing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notifications.dart';

class MainScreen extends StatefulWidget {
  _MainScreenState createState() => _MainScreenState();
}

// int selectedId = 0;

class _MainScreenState extends State<MainScreen> {
  int _selectedId = 0;

  void onTapped(int index) {
    setState(() {
      _selectedId = index;
    });
  }

  Widget build(BuildContext context) {
    final _themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (_themeNotifier.getTheme()) == blackTheme;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.symmetric(horizontal: 120.0, vertical: 55.0),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            ListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(fontSize: 20.0),
              ),
              trailing: Switch(
                value: _darkTheme,
                onChanged: (value) {
                  setState(() {
                    _darkTheme = value;
                  });

                  onThemeChanged(value, _themeNotifier);
                },
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: _selectedId == 0
            ? Text('Hospital Dashboard')
            : (_selectedId == 1
                ? Text('Contact & Helpline')
                : (_selectedId == 2
                    ? Text('Latest Releases')
                    : Text('Daily Sampling'))),
      ),
      body: _selectedId == 0
          ? (null)
          : (_selectedId == 1
              ? (null)
              : (_selectedId == 2
                  ? (NotiFicationScreen(
                      noti: getData(),
                    ))
                  : null)),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.red,
        // fixedColor: Colors.red,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Dashboard'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone),
            title: Text('Contact'),
            // backgroundColor: Colors.orangeAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Notification'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            title: Text('Daily sampling'),
          ),
        ],
        currentIndex: _selectedId,
        selectedItemColor: blackTheme.accentColor,
        onTap: onTapped,
        // unselectedItemColor: Colors.grey,
        // showUnselectedLabels: true,
      ),
    );
  }
}
