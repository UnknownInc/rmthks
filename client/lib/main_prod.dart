import 'package:flutter/material.dart';

import 'app.dart';
import 'common/constants.dart';

import 'package:firebase/firebase.dart' as fb;
void main() {
  Constants.setEnvironment(Environment.PROD);
  fb.initializeApp(
    apiKey: "AIzaSyBZkzvBEFrYdg7PW2Fd7ymI65qROPz1Ny8",
    authDomain: "ind-si-infra-managment-184960.firebaseapp.com",
    databaseURL: "https://ind-si-infra-managment-184960.firebaseio.com",
    projectId: "ind-si-infra-managment-184960",
    storageBucket: "ind-si-infra-managment-184960.appspot.com",
    messagingSenderId: "149667563229",
    appId: "1:149667563229:web:fcd009fb16ecc574197d34"
  );
  runApp(App());
}

