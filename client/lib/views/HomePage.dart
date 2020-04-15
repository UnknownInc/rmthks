import 'dart:html' as html;
import 'dart:math';

import 'package:like_button/like_button.dart';
import 'package:rmthks/common/MouseCursor.dart';
import 'package:rmthks/views/HeaderBanner.dart';
import 'package:rmthks/views/ImageCarousal.dart';
import 'package:rmthks/views/RoundButton.dart';
import 'package:rmthks/views/UploadForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:image_picker_web/image_picker_web.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static Firestore db=fb.firestore();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final DocumentReference likesDoc = db.collection('rmthks').doc('likes');
  int _likeCount=700;
  bool _isLiked=false;

  Future<bool> onLikeButtonTapped(bool isLiked) async{
    print(isLiked);
    try {
      var op= FieldValue.increment(isLiked ? -1 : 1);
      var prefs = await _prefs;
      await likesDoc.update(data:{'count':op});
      prefs.setBool('rmthks_liked', !isLiked);
      return !isLiked;
    } catch (e) {
      print(e);
      return isLiked;
    }
  }

  @override
  void initState() { 
    super.initState();
    _prefs.then((prefs) => {
      this.setState(() { 
        try{
          _isLiked = prefs.getBool('rmthks_liked');
          print('p:'+_isLiked.toString());
        } catch(e) {
          print(e);
        }
      })
    });
    likesDoc.get().then((doc){
      this.setState(() {_likeCount=doc.data()['count'];});
    });
    // likesDoc.onSnapshot.listen((doc) { 
    //   this.setState(() {_likeCount=doc.data()['count'];});
    // });
  }
  Widget buildLikeButton(BuildContext context) {
    var buttonSize=75.0;
    return LikeButton(
      size: buttonSize,
      circleSize: 500,
      bubblesSize: 250 ,
      circleColor: CircleColor(start: Colors.pink[300], end: Colors.purpleAccent[100].withAlpha(128)),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Colors.purple[100],
        dotSecondaryColor: Colors.pink[300],
      ),
      isLiked: _isLiked,
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.favorite,
          color: isLiked ? Colors.red[600] : Colors.grey,
          size: buttonSize,
        );
      },
      likeCount: _likeCount,
      countBuilder: (int count, bool isLiked, String text) {
        var color = isLiked ? Colors.red : Colors.grey;
        Widget result;
        if (count == 0) {
          result = Text(
            "love",
            style: TextStyle(color: color),
          );
        } else
          result = Text(
            text,
            style: TextStyle(color: color),
          );
        return result;
      },
      onTap: this.onLikeButtonTapped,
    );
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) {
              var theme = Theme.of(context);
              var bgColor = theme.primaryColor;
              var textTheme = theme.primaryTextTheme;
              var size = MediaQuery.of(context).size;
              var toprow=<Widget>[];

              if (constraints.maxWidth>660)  {
                toprow=<Widget>[
                  MouseCursor(
                    child: InkWell(
                      hoverColor: Colors.blue,
                      child: Image.asset('assets/images/logo1.jpg', width: min(200.0,constraints.maxWidth*0.2)),
                      onTap: () async {
                        const url = 'http://rareminds.in/';
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                    ),
                  ),
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
                            InkWell(
                              hoverColor: Colors.blue,
                              child: Image.asset('assets/images/logo1.jpg', width: 100),
                              onTap: () async {
                                const url = 'https://rareminds.in/';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                }
                              },
                            ),
                            Image.asset('assets/images/logo2.jpg', width: 200),
                          ],
                        )
                      ],
                    ),
                  ];
              }
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
                    Row( 
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[
                      RoundButton(
                        onPressed:() async {
                          var imageFile = await ImagePickerWeb.getImage(outputType: ImageType.file );
                          if (imageFile != null) {
                            collectDetails(context, imageFile);
                          }
                        }
                      ),
                      SizedBox(width: 32,),
                      
                    ]),
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
          ),
          Positioned(
            bottom: 8,
            right: 8  ,
            child: buildLikeButton(context),
          )
        ],
      ),
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