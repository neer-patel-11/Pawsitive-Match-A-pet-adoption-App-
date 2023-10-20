import 'package:flutter/material.dart';
import 'package:sdp_project/petProfile.dart';
import 'package:sdp_project/profile.dart';
import 'login.dart';
import 'register.dart';
import 'registerPet.dart';
import 'petList.dart';


void main() {
  runApp(MaterialApp(

    debugShowCheckedModeBanner: false,
    home:MyLogin(),
    // home: PetList(),
    // home:MyRegisterPet(),
    // home:PetList(),
    // home:PetProfile(),
    routes: {
      'petList' : (context) => PetList(),
      'registerPet' :(context) => MyRegisterPet(),
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
      'profile':(context) => Profile(),
      // 'petProfile' :(context) => PetProfile(id),
    },
  ));
}
