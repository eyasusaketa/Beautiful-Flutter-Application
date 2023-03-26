
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserData {

  final String starttime;
  final String stoptime;
UserData({required this.starttime,required this.stoptime});

 Map<String ,dynamic> scheduledata(){
   return {'starttime':starttime,'stoptime':stoptime};
 }
  }
