
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    var theme=Theme.of(context);
    return RaisedButton(
      color: theme.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.file_upload, color: theme.primaryIconTheme.color,),
          SizedBox(width:8),
          Text("UPLOAD ", style: theme.primaryTextTheme.bodyText1,),
        ],
      ),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(32.0),
      ),
      onPressed: onPressed,
    );
  }
}