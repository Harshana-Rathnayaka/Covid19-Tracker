import 'package:flutter/material.dart';

import '../helper_methods.dart';

class InfoCard extends StatelessWidget {
  final Color? backgroundColor;
  final Color headingColor;
  final Color bodyText1Color;
  final Color bodyText2Color;
  final String heading;
  final bodyText1;
  final int? bodyText2;

  const InfoCard({
    Key? key,
    this.backgroundColor = Colors.white,
    this.headingColor = Colors.white,
    this.bodyText1Color = Colors.white,
    this.bodyText2Color = Colors.grey,
    required this.heading,
    required this.bodyText1,
    this.bodyText2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 10.0,
        color: backgroundColor,
        shadowColor: Colors.grey.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        borderOnForeground: true,
        child: Container(
          height: 80.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(heading, style: TextStyle(fontSize: 15.0, color: headingColor)),
              SizedBox(height: 10.0),
              Text(
                bodyText1.runtimeType != String ? numberFormat.format(bodyText1) : bodyText1,
                style: TextStyle(fontSize: 14, color: bodyText1Color),
                textAlign: TextAlign.center,
              ),
              bodyText2 != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_upward, color: headingColor.withOpacity(0.8), size: 11),
                        Text(bodyText2 == null ? '0' : numberFormat.format(bodyText2).toString(), style: TextStyle(color: bodyText2Color, fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
