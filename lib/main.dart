
import 'package:flutter/material.dart';


import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter_desktop_widgets2/src/keyboard.dart';
import 'package:flutter_desktop_widgets2/src/selectable_area.dart';
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


  FocusNode one = FocusNode(debugLabel: "One");
  FocusNode two = FocusNode(debugLabel: "Two");
  FocusNode three = FocusNode(debugLabel: "Three");
  FocusNode four = FocusNode(debugLabel: "Four");

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: OutlineButton(
          child: Text("Dump Tree"),
          onPressed: () {
            debugDumpFocusTree();
          },
        ),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: FocusArea(
                    child: Container(
                      color: Colors.indigo,
                    ),
                    node: one,
                  ),
                ),
                Expanded(
                  child: FocusArea(
                    node: two,
                    child: Container(
                      color: Colors.tealAccent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(two);
                            },
                            child: Container(
                              color: Colors.black,
                              height: 80,
                            ),
                          ),
                          Expanded(
                            child: SelectableList(
                              selectedIndex: selectedIndex,
                              controller: ScrollController(),
                              onSelectChange: (it) => setState(() {selectedIndex = it;}),
                              itemCount: 10,
                              itemHeight: 40,
                              focusNode: two,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).requestFocus(two);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    height: 24,
                                    color: selectedIndex == index? Colors.purple: Colors.pink,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: FocusArea(
                    child: Container(
                      color: Colors.purpleAccent,
                      alignment: Alignment.center,
                      child: TextField(),
                    ),
                    node: three,
                  ),
                ),
                Expanded(
                  child: InteractionKeyboard(
                    focusNode: four,
                    onCtrlSpace: () {
                      print("HERE I AM");
                      return false;
                    },
                    child: FocusArea(
                      child: Container(
                        color: Colors.orange,
                      ),
                      node: four,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

