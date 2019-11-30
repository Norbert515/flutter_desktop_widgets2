import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CursorPositionWidget extends StatefulWidget {
  const CursorPositionWidget({Key key, this.child}) : super(key: key);

  final Widget child;

  static Offset of(BuildContext context) {
    return Provider.of<_CursorPositionWidgetState>(context).currentPosition;
  }

  @override
  _CursorPositionWidgetState createState() => _CursorPositionWidgetState();
}

class _CursorPositionWidgetState extends State<CursorPositionWidget> {
  Offset currentPosition;

  @override
  Widget build(BuildContext context) {
    return Provider<_CursorPositionWidgetState>.value(
      value: this,
      child: MouseRegion(
        onHover: (event) {
          currentPosition = event.position;
        },
        child: widget.child,
      ),
    );
  }
}
