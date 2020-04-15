import 'dart:convert';
import 'dart:math';
import 'package:like_button/like_button.dart';
import 'package:rmthks/common/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ImageCarousal extends StatefulWidget{
  @override
  _ImageCarousalState createState() => _ImageCarousalState();
}

class _ImageCarousalState extends State<ImageCarousal> {
  Random rng;
  Future imageLoader;
  bool isPerformingRequest;

  @override
  void initState() {
    rng=new Random(9859);
    super.initState();
    //imageLoader = fakeRequest(0, 10);
    imageLoader = _loadPublished();
  }

  Future _loadPublished() async {
    var url=Constants.APIPREFIX+"published";
    try {

      var response = await http.get(url, 
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode==200) {
        var items = json.decode(response.body);
        //print(items);
        return items;
      } else {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.contentLength}");
        print(response.headers);
        print(response.request);
      }
    } catch(e) {
      print(e.toString());
    }
    return [];

  }

  @override
  Widget build(Object context) {
    var theme=Theme.of(context);
    var size=MediaQuery.of(context).size;
    var buttonSize=25.0;
    return FutureBuilder(
      future: imageLoader,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var items=snapshot.data;
          return Container(
            width: size.height*0.6*16.0/9.0,
            height: size.height*0.6,
            child: Swiper(
              itemBuilder: (BuildContext context,int index){
                var item=items[index];
                return Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow (
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8.0, // has the effect of softening the shadow
                            spreadRadius: 4.0, // has the effect of extending the shadow
                            offset: Offset(0.0, 0.0,),
                          )
                        ],
                      ),
                      child: ClipRect(
                        child: Banner(
                          message:"",
                          location: BannerLocation.bottomEnd,
                          color: theme.primaryColor,
                          textStyle: theme.primaryTextTheme.bodyText1,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            //child: new Image.network(item["image"]),
                            child:FadeInImage.assetNetwork(
                              placeholder: 'assets/images/loading.gif',
                              image: item["image"],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child:Container(
                          height: 32,
                          width: size.width*0.25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32.0),
                            border: Border.all(
                                color: Colors.white,
                                width: 1.0
                            ),
                            boxShadow: [
                              BoxShadow (
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8.0, // has the effect of softening the shadow
                                spreadRadius: 4.0, // has the effect of extending the shadow
                                offset: Offset(0.0, 0.0,),
                              )
                            ],
                          ),
                          child: Center(child: Text(item["name"]+" ("+item['age'].toString()+")", style: theme.textTheme.bodyText1))),
                      ),
                    ),
                    Image.asset('assets/images/red_ribbon.png', width:32),
                  ],
                );
              },
              itemCount: items.length,
              //itemWidth: size.width*0.35,
              //pagination: SwiperPagination.fraction,
              control: new SwiperControl(),
              viewportFraction: 0.7,
              //layout: SwiperLayout.STACK,
              autoplay: true,
              autoplayDelay: 3000,
              autoplayDisableOnInteraction: true,
              onTap: (index){_showItem(items[index]);},
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text("Unable to load uploaded images.", style: theme.textTheme.bodyText1,);
        }
        return SpinKitThreeBounce(
          color: theme.primaryColor ,
          size: 50.0,
        );
      }
    );
  }

  _showItem(dynamic item) {
    var theme=Theme.of(context);
    var size=MediaQuery.of(context).size;
    return showDialog(context: context,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: AspectRatio(
            aspectRatio: 16/9,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow (
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8.0, // has the effect of softening the shadow
                          spreadRadius: 4.0, // has the effect of extending the shadow
                          offset: Offset(0.0, 0.0,),
                        )
                      ],
                    ),
                    child: ClipRect(
                      child: Banner(
                        message:"",
                        location: BannerLocation.bottomEnd,
                        color: theme.primaryColor,
                        textStyle: theme.primaryTextTheme.bodyText1,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          //child: new Image.network(item["image"]),
                          child:FadeInImage.assetNetwork(
                            placeholder: 'assets/images/loading.gif',
                            image: item["image"],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 8,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child:Container(
                      height: 32,
                      width: size.width*0.25,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32.0),
                        border: Border.all(
                            color: Colors.white,
                            width: 1.0
                        ),
                        boxShadow: [
                          BoxShadow (
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8.0, // has the effect of softening the shadow
                            spreadRadius: 4.0, // has the effect of extending the shadow
                            offset: Offset(0.0, 0.0,),
                          )
                        ],
                      ),
                      child: Center(child: Text(item["name"]+" ("+item['age'].toString()+")", style: theme.textTheme.bodyText1))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// from - inclusive, to - exclusive
  Future fakeRequest(int from, int to) async {
    return Future.delayed(Duration(seconds: 2), () {
      return List.generate(to - from, (i) {
        return {
          'index': i + from,
          'name': "Ram",
          'age': 9,
          'image':'http://lorempixel.com/800/600/abstract/?q=$i',
        };
      });
    });
  }
}