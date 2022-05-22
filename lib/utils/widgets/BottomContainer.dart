import 'package:flutter/material.dart';

class BottomContainer extends StatelessWidget {
  final Widget child;
  const BottomContainer({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.26,
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
        ),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0), child: child));
  }
}
