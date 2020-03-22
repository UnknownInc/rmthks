import 'package:flutter/material.dart';

class HeaderBanner extends StatelessWidget {
  const HeaderBanner({
    Key key,
    @required this.bgColor,
    @required this.textTheme,
  }) : super(key: key);

  final Color bgColor;
  final TextTheme textTheme;
  //final Float width;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: bgColor,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Gratitude to the healthcare teams!',style: textTheme.headline5,),
            Text('Say a thank-you to your heroes!', style:textTheme.headline6),
            Image.asset('assets/images/children_line.png', width: MediaQuery.of(context).size.width * 0.4),
          ],
        ),
      ),
    );
  }
}