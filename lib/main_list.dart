
import 'package:flutter/material.dart';


import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter_desktop_widgets2/src/selectable_list.dart';
void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  int selection;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Demo Home Page'),
      ),
      body: new Center(
        child: SelectableList(
          itemCount: 20,
          itemHeight: 88,
          itemsBeforeScroll: 3,
          selectedIndex: selection,
          onSelectChange: (it) {
            setState(() {
              selection = it;
            });
          },
          onEnter: () {
            print("Selected $selection");
          },
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selection = index;
                });
              },
              child: Container(
                height: 80,
                color: selection == index? Colors.blue: null,
                padding: EdgeInsets.all(8),
                child: Text("Item $index"),
              ),
            );
          },
        ),
      ),
    );
  }
}

