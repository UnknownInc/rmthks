import 'dart:html' as html;
import 'dart:math';

import 'package:rmthks/views/HeaderBanner.dart';
import 'package:rmthks/views/ImageCarousal.dart';
import 'package:rmthks/views/RoundButton.dart';
import 'package:rmthks/views/UploadForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:image_picker_web/image_picker_web.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(Object context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          var theme = Theme.of(context);
          var bgColor = theme.primaryColor;
          var textTheme = theme.primaryTextTheme;
          var size = MediaQuery.of(context).size;
          var toprow=<Widget>[];

           if (constraints.maxWidth>660)  {
            toprow=<Widget>[
              Image.asset('assets/images/logo1.jpg', width: min(200.0,constraints.maxWidth*0.2)),
              HeaderBanner(bgColor: bgColor, textTheme: textTheme),
              Image.asset('assets/images/logo2.jpg', width: min(200.0,constraints.maxWidth*0.2)),
            ];
           } else {
             toprow=<Widget>[
                    //if (constraints.maxWidth>660)  
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    HeaderBanner(bgColor: bgColor, textTheme: textTheme),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset('assets/images/logo1.jpg', width: 100),
                        Image.asset('assets/images/logo2.jpg', width: 200),
                      ],
                    )
                  ],
                ),
              ];
           }
          print(size);
          return Container(
            decoration: BoxDecoration(
              image: new DecorationImage(
                image: new ExactAssetImage('assets/images/bgdoodles.jpeg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(child: 
            Column(
              children: <Widget>[
                SizedBox(height:16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: toprow,
                ),
                SizedBox(height:32),
                RoundButton(
                  onPressed:() async {
                    var imageFile = await ImagePickerWeb.getImage(outputType: ImageType.file );
                    if (imageFile != null) {
                      collectDetails(context, imageFile);
                    }
                  }
                ),
                SizedBox(height: 8,),
                Stack(
                  children: <Widget>[
                    ImageCarousal(),
                    Positioned(
                      bottom: 0,
                      left: 0, right: 0,
                      child: Text('')
                    )
                  ],
                ),
                ]
              ),
            ),
          );
        }
      )
    );
  }

  void collectDetails(Object context, html.File imageFile) async {
    final reader = html.FileReader();
    reader.readAsDataUrl(imageFile);
    await reader.onLoad.first;
    final encoded = reader.result as String;
    final imageDataBase64 =
        encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    final imageName = imageFile.name;

    var size=MediaQuery.of(context).size;
    showDialog(context: context,
      child: Container(
        margin: EdgeInsets.all(8),
        child: Center(
          child: FractionallySizedBox(
            widthFactor: size.width>660?0.5:1.0,
            child: UploadForm(imageName: imageName, imageDataBase64: imageDataBase64),
          ),
        ),
      )
    );
  }
}