
import 'package:client/views/RoundButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class UploadForm extends StatefulWidget {
  const UploadForm({
    Key key,
    @required this.imageName,
    @required this.imageDataBase64,
  }) : super(key: key);

  final String imageName;
  final String imageDataBase64;

  @override
  _UploadFormState createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController= new TextEditingController();
  final TextEditingController _ageController= new TextEditingController();
  final TextEditingController _emailController= new TextEditingController(); 
  bool _isUploading=false;

  void initState() {
    super.initState();
  }

  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme=Theme.of(context);
    final imageData = base64.decode(widget.imageDataBase64);
    return Card(
      child: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Upload your painting!', style: theme.textTheme.headline4),
                Divider(),
                Container(
                  //color: theme.primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                boxShadow: [
                                  BoxShadow (
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8.0, // has the effect of softening the shadow
                                    spreadRadius: 4.0, // has the effect of extending the shadow
                                    offset: Offset(0.0, 0.0,),
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Transform.rotate(angle: 1*0.0174, child: Image.memory(imageData, semanticLabel: widget.imageName)),
                              )
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: <Widget>[
                              Text('Please add the following details.'),
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText:'Name',
                                  hintText: "Name of the student",
                                  border: OutlineInputBorder()
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a name.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height:4),
                              TextFormField(
                                controller: _ageController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Age',
                                  hintText: "Age in years",
                                  border: OutlineInputBorder()
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter the age.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height:4),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  labelText: 'Email',
                                  hintText: "Email",
                                  border: OutlineInputBorder()
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a valid email.';
                                  }
                                  return null;
                                },
                              ),
                            ]
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RoundButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _isUploading=true;
                          });
                          var body=json.encode({
                            "imagename": widget.imageName,
                            "name": _nameController.text,
                            "age":_ageController.text,
                            "email": _emailController.text,
                            "image": widget.imageDataBase64
                          });
                          var url= "http://127.0.0.1:8080/upload";
                          print("posting to $url");
                          try {
                            var response = await http.post(url,
                              headers: {"Content-Type": "application/json"},
                              body: body
                            );
                            print("Response status: ${response.statusCode}");
                            print("Response body: ${response.contentLength}");
                            print(response.headers);
                            print(response.request);
                          } catch(e) {
                            print(e);
                          }
                          setState(() {
                            _isUploading=false;
                          });
                          Navigator.pop(context, true);
                        }
                      }
                    )
                  ],
                )
              ],
            ),
          ),
          _isUploading ? Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: SpinKitChasingDots(color: Colors.white, size: 50,),
              ),
            )
          ) : Text(' ')
        ],
      ),
    );
  }
}
