
import 'package:flutter/material.dart';
import 'package:flutter_desktop_widgets2/src/cursor_position.dart';

Future<T> showDialogAndRestoreFocus<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  bool restoreFocus = true,
}) async {
  var node = FocusScope
      .of(context)
      .focusedChild;

  var result = await showDialog<T>(
    context: context,
    builder: builder,
  );

  if(restoreFocus) {
    FocusScope.of(context).requestFocus(node);
  }

  return result;

}

Future<T> showDialogAtContext<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  @required Size size,
  bool restoreFocus = true,
  bool top = true,
}) {
  RenderBox box = context.findRenderObject();

  var offset = box.localToGlobal(Offset.zero);
  final buttonWidth = box.size.width;
  var buttonMiddle = Offset(offset.dx + buttonWidth / 2, offset.dy);

  Offset result;

  result = buttonMiddle - Offset(size.width, size.height);

  return showDialogAt<T>(
    context: context,
    position: result,
    builder: builder,
    size: size,
    restoreFocus: restoreFocus,
  );

}

/// Shows a dialog at a specific location.
///
/// The dialog will be layed out from [position] extending to the bottom - right
///
/// If [avoidBorder] is set, it will try to make it fit inside the available space
/// flipping the layout to top/ left as necessary
Future<T> showDialogAt<T>({
  @required BuildContext context,
  @required Offset position,
  @required WidgetBuilder builder,
  @required Size size,
  bool restoreFocus = true,
  bool avoidBorder = true,
}) async {


  var node = FocusScope
      .of(context)
      .focusedChild;

  //FocusScope.of(context).requestFocus(null);

  Size rootSize = MediaQuery.of(context).size;
  Offset actualPosition = position;


  if(position.dx + size.width > rootSize.width - 10) {
    actualPosition = actualPosition.translate(-(size.width - (rootSize.width - position.dx)), 0);
    assert(actualPosition.dx + size.width <= rootSize.width);
  }
  if(position.dy + size.height > rootSize.height - 10) {
    actualPosition = actualPosition.translate(0, -size.height);
  }

  if(position.dx < 0){
    actualPosition = actualPosition.translate(-position.dx, 0);
  }
  if(position.dy < 0) {
    actualPosition = actualPosition.translate(0, -position.dy);
  }

  var result = await Navigator.of(context, rootNavigator: true).push<T>(_PositionedPopupRoute<T>(
    builder: builder,
    position: actualPosition,
    size: size,
  ));

  if(restoreFocus) {
    FocusScope.of(context).requestFocus(node);
  }

  return result;
}



Future<T> showDialogAtCursor<T>({@required BuildContext context, @required WidgetBuilder builder, @required Size size, bool restoreFocus = true}) {
  var position = CursorPositionWidget.of(context);
  return showDialogAt<T>(
    context: context,
    position: position,
    builder: builder,
    size: size,
    restoreFocus: restoreFocus
  );
}




class _PositionedPopupRoute<T> extends PopupRoute<T> {


  final WidgetBuilder builder;

  final Offset position;

  final Size size;

  _PositionedPopupRoute({this.size, this.builder, this.position});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return _PositionedPopupRoutePage(
      position: position,
      child: builder(context),
      size: size,
    );
  }

  @override
  Duration get transitionDuration => Duration.zero;

}


class _PositionedPopupRoutePage<T> extends StatelessWidget {


  const _PositionedPopupRoutePage({Key key, this.position, this.child, this.size}) : super(key: key);

  final Offset position;

  final Widget child;

  final Size size;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      removeTop: true,
      child: CustomSingleChildLayout(
        child: child,
        delegate: _PositionedPopupRouteLayout(position, size),

      ),
    );
  }
}



class _PositionedPopupRouteLayout extends SingleChildLayoutDelegate {

  final Offset position;
  final Size size;

  _PositionedPopupRouteLayout(this.position, this.size);

  Offset getPositionForChild(Size size, Size childSize) => position;

  @override
  Size getSize(BoxConstraints constraints) => size;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) => BoxConstraints.tight(size);

  @override
  bool shouldRelayout(_PositionedPopupRouteLayout oldDelegate) => oldDelegate.position != position;

}