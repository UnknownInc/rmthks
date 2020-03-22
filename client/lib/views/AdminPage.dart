
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool isLoggedin=false;
  String username;
  String password;
  Future uploadsListFuture;

  Future _getUploads() async {
    var url="http://127.0.0.1:8080/uploads";
    try {

      var response = await http.get(url, 
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Basic "+base64Url.encode(utf8.encode(username+":"+password)),
        },
      );
      if (response.statusCode==200) {
        var items = json.decode(response.body);
        print(items);
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

  Future _publish(Map item) async {
    var url="http://127.0.0.1:8080/publish";
    try {

      var response = await http.post(url, 
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Basic "+base64Url.encode(utf8.encode(username+":"+password)),
        },
        body:json.encode({
          'image': item["image"]
        })
      );
      if (response.statusCode!=200) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.contentLength}");
        print(response.headers);
        print(response.request);
        return false;
      }
      return true;
    } catch(e) {
      print(e.toString());
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var theme=Theme.of(context);
    if (!isLoggedin) {
      return Scaffold(
        body:Center(
          child: FractionallySizedBox(
            widthFactor: 0.4,
            child: Card(
              elevation: 8,
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Login'),
                      Divider(height: 8,),
                      TextFormField(
                        decoration:InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Username'
                        ),
                        onChanged: (value) {
                          setState(() {
                            username=value;
                          });
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration:InputDecoration(
                          prefixIcon: Icon(Icons.vpn_key),
                          labelText: 'Password'
                        ),
                        onChanged: (value) {
                          setState(() {
                            password=value;
                          });
                        },
                      ),
                      Divider(height: 8.0,),
                      Center(
                        child: RaisedButton(
                          color: theme.primaryColor,
                          child: Text('Login', style: theme.primaryTextTheme.bodyText1),
                          onPressed: () async {
                            var url="http://127.0.0.1:8080/login";
                            var body = json.encode({
                              'username': username,
                              'password': password
                            });
                            try {
                              var response = await http.post(url, 
                                headers: {"Content-Type": "application/json"},
                                body: body
                              );
                              if (response.statusCode==200) {
                                setState(() {
                                  isLoggedin=true;
                                  uploadsListFuture = _getUploads();
                                });
                              } else {
                                print("Response status: ${response.statusCode}");
                                print("Response body: ${response.contentLength}");
                                print(response.headers);
                                print(response.request);
                              }
                            } catch(e) {
                              print(e.toString());
                            }
                          },
                        )
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        )
      );
    }//if not logged in

    return Scaffold(
      body: FutureBuilder(
        future: uploadsListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data=snapshot.data;
            return GridView.builder(
              itemCount: data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
                  //crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  child: new GridTile(
                    child: FittedBox(
                      child: Image.network(data[index]['image']),
                    ),
                    footer: Container(
                      color: Colors.white.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(data[index]['name']),
                            SizedBox(width: 16,),
                            Text(data[index]['age']),
                            SizedBox(width: 16,),
                            RaisedButton(
                              color: theme.primaryColor,
                              child: Text('PUBLISH', style: theme.primaryTextTheme.bodyText1,),
                              onPressed: () async {
                                var done=await _publish(data[index]);
                                if (done) {
                                  uploadsListFuture=_getUploads();
                                }
                              }
                            )
                        ],),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          if (snapshot.hasError) {
           return Text('Error'); 
          }

          return SpinKitChasingDots(
            color: theme.primaryColor,
            size: 50,
          );
        }
      )
    );
  }
}