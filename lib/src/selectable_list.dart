import 'package:flutter/material.dart';
import 'package:flutter_desktop_widgets2/src/keyboard.dart';

class SelectableList extends StatefulWidget {

  SelectableList({
    Key key,
    this.selectedIndex,
    this.onSelectChange,
    this.itemBuilder,
    this.itemHeight,
    this.itemsBeforeScroll = 3,
    ScrollController controller,
    this.itemCount,
    this.onEnter,
    this.padding,
    this.focusNode,
    this.onEscape,
  }) : this.controller = controller?? ScrollController(), super(key: key);

  final int selectedIndex;
  final ValueChanged<int> onSelectChange;
  final VoidCallback onEnter;
  final KeyCallback onEscape;
  final IndexedWidgetBuilder itemBuilder;
  final double itemHeight;
  final int itemsBeforeScroll;
  final ScrollController controller;
  final int itemCount;
  final EdgeInsets padding;
  final FocusNode focusNode;

  @override
  _SelectableListState createState() => _SelectableListState();
}

class _SelectableListState extends State<SelectableList> {


  ScrollController controller;
  
  int get shadowSelection => widget.selectedIndex?? 0;

  @override
  void initState() {
    super.initState();
    if(widget.controller != null) {
      controller = widget.controller;
    } else {
      controller = ScrollController();
    }
  }

  @override
  void didUpdateWidget(SelectableList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.controller != widget.controller) {
      if(widget.controller != null) {
        controller = widget.controller;
      } else {
        controller = ScrollController();
      }
    }
  }

  void moveToNext() {
    double currentOffset = shadowSelection * widget.itemHeight;
    double remainingSpace = controller.position.extentBefore +
        controller.position.extentInside -
        currentOffset;
    if (remainingSpace < widget.itemHeight * widget.itemsBeforeScroll) {
      double jumpTo = controller.offset + widget.itemHeight;
      double maxHeight = (widget.itemCount * widget.itemHeight) - controller.position.viewportDimension;
      if(jumpTo <= maxHeight) {
        controller.jumpTo(jumpTo);
      } else {
        controller.jumpTo(widget.controller.position.maxScrollExtent);
      }
    }
  }

  void moveToPrevious() {
    double currentOffset = shadowSelection * widget.itemHeight;
    double remainingSpace = currentOffset - controller.position.extentBefore;
    if (remainingSpace < widget.itemHeight * widget.itemsBeforeScroll) {
      double jumpTo = controller.offset - widget.itemHeight;
      if(jumpTo >= 0) {
        controller.jumpTo(jumpTo);
      } else {
        controller.jumpTo(0);
      }
    }
  }

  bool onUp() {
    if(shadowSelection > 0) {
      widget.onSelectChange(shadowSelection - 1);
      moveToPrevious();
    }
    return true;
  }

  bool onDown() {
    if(shadowSelection < widget.itemCount - 1) {
      widget.onSelectChange(shadowSelection + 1);
      moveToNext();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return InteractionKeyboard(
      onUp: onUp,
      onDown: onDown,
      onEscape: () {
        widget.onEscape?.call();
      },
      onEnter: () {
        widget.onEnter?.call();
        return false;
      },
      focusNode: widget.focusNode,
      child: ListView.builder(
        padding: widget.padding,
        controller: controller,
        itemExtent: widget.itemHeight,
        itemBuilder: widget.itemBuilder,
        itemCount: widget.itemCount,
      ),
    );
  }
}
