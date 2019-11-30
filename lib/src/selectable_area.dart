
import 'package:flutter/material.dart';

class FocusArea extends StatefulWidget {

  const FocusArea({Key key, this.outline = true, this.child, this.node}) : super(key: key);
  
  final bool outline;
  final Widget child;
  final FocusNode node;

  @override
  _FocusAreaState createState() => _FocusAreaState();
}

class _FocusAreaState extends State<FocusArea> {


  bool hasFocus;

  @override
  void initState() {
    super.initState();
    hasFocus = widget.node.hasFocus;
    widget.node.addListener(_listen);
  }

  void _listen() {
    setState(() {
      hasFocus = widget.node.hasFocus;
    });
  }

  @override
  void dispose() {
    //widget.node.dispose();
    widget.node.removeListener(_listen);
    super.dispose();
  }

  BoxDecoration get decoration {
    if(!widget.outline) return null;
    if(hasFocus) {
      return BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2
        ),
      );
    }

    return null;

  }
  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      /*onTap: () {
         FocusScope.of(context).requestFocus(widget.node);
      },*/
      onPointerUp: (it) {
        FocusScope.of(context).requestFocus(widget.node);
      },
      child: Container(
        decoration: decoration,
        child: widget.child,
      ),
    );
  }
}
