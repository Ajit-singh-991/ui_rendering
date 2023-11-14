import 'dart:convert';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI Rendering Engine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.light, // Default theme is light
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String jsonData = '''
  {
     "app":{
        "theme":"light"
     },
     "widgets":[
        {
           "type":"grid",
           "children":[
              {
                 "icon":"assets/images/reliance.png",
                 "company_name":"Reliance Power",
                 "current":"20.50",
                 "prev_close":"21.25"
              },
              {
                 "icon":"assets/images/zomato.png",
                 "company_name":"Zomato",
                 "current":"121.30",
                 "prev_close":"121.85"
              },
              {
                 "icon":"assets/images/suzlonenergy.avif",
                 "company_name":"Suzlon Energy",
                 "current":"37.90",
                 "prev_close":"37.30"
              }
           ]
        },
        {
           "type":"horizontal_list",
           "children":[
              {
                 "company_name":"Reliance Power",
                 "current":"20.50",
                 "prev_close":"21.25"
              },
              {
                 "company_name":"Zomato",
                 "current":"121.30",
                 "prev_close":"121.85"
              },
              {
                 "company_name":"Suzlon Energy",
                 "current":"37.90",
                 "prev_close":"37.30"
              }
           ]
        },
        {
           "type":"alert",
           "title":"All set for muhurat trading?",
           "message":"The 1-hour trading window open on 12 Nov, 6:15 PM. Orders placed now will be placed on 12 Nov, 6:15 PM.",
           "icon":"assets/images/rocket.png"
        }
     ]
  }
  ''';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = json.decode(jsonData);

    // Check and apply dark theme if specified in JSON
    if (data['app']['theme'] == 'dark') {
      return MaterialApp(
        title: 'UI Rendering Engine',
        theme: ThemeData.dark(),
        home: MyHomePage(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('UI Rendering Engine'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildWidgets(data['widgets']),
        ),
      ),
    );
  }

  List<Widget> _buildWidgets(List<dynamic> widgets) {
    List<Widget> widgetList = [];

    for (var widgetData in widgets) {
      switch (widgetData['type']) {
        case 'grid':
          widgetList.add(_buildGrid(widgetData['children']));
          break;
        case 'horizontal_list':
          widgetList.add(_buildHorizontalList(widgetData['children']));
          break;
        case 'alert':
          widgetList.add(_buildAlertBanner(
            widgetData['title'],
            widgetData['message'],
            widgetData['icon'],
          ));
          break;
      }
    }

    return widgetList;
  }

  Widget _buildGrid(List<dynamic> children) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.purple,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius:
                    BorderRadius.circular(10), // Adjust the radius as needed
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    children[index]['icon'],
                    height: 50.0,
                  ),
                  Text(children[index]['company_name']),
                  Text('Current: ${children[index]['current']}'),
                  Text('Prev Close: ${children[index]['prev_close']}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHorizontalList(List<dynamic> children) {
    return Container(
      height: 100.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        itemBuilder: (context, index) {
          return Card(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius:
                    BorderRadius.circular(10), // Adjust the radius as needed
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(children[index]['company_name']),
                    Text('Current: ${children[index]['current']}'),
                    Text('Prev Close: ${children[index]['prev_close']}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAlertBanner(String title, String message, String icon) {
    return Card(
      color: Colors.amber,
      child: ListTile(
        leading: Image.asset(
          icon,
          height: 40.0,
        ),
        title: Text(title),
        subtitle: Text(message),
        trailing: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            // Add logic to close the alert
          },
        ),
      ),
    );
  }
}
