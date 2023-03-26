import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
class deviceid extends StatefulWidget {
  const deviceid({Key? key}) : super(key: key);

  @override
  State<deviceid> createState() => _deviceidState();
}


class _deviceidState extends State<deviceid> {
 var idcont=TextEditingController();
 var deviceid="Loading ......";
 void setid(){
   String id=idcont.text.toString();
   var user=FirebaseAuth.instance.currentUser!;

   var ref=FirebaseFirestore.instance.collection("users").doc(user.uid).set({"id":id});
   getid();
   updatetoken();
 }
 String textValue = 'Hello World !';
 initState(){
   super.initState();
   getid();
 }
updatetoken(){
  FirebaseMessaging.instance.getToken().then((token) {
    update(token!);
  });
}

 update(String token) async {
   print(token);
   var user = await FirebaseAuth.instance.currentUser!;
   DocumentSnapshot<Map<String, dynamic>> ref=await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
   var deviceid=ref['id'];

   DatabaseReference databaseReference = new FirebaseDatabase().reference();
   databaseReference.child('devices/${deviceid}').update({"token": token});
   databaseReference.child('devices/${deviceid}').update({'userid':user.uid});
   textValue = token;
   setState(() {});
 }


Future<String> getid() async {
   var id;
   var user=FirebaseAuth.instance.currentUser!;
   var ref=await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
   id=ref['id'];
   setState(() {
     deviceid=id;
   });
  return id;
 }

  @override

  Widget build(BuildContext context) {




    return Scaffold(
      backgroundColor: Color(0xff392850),
      body: Column(
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: Colors.pink,
            title: Row(
              children: [
                Text("Safety ",style:TextStyle(color: Colors.white,fontFamily: 'favo', fontSize: 20) ,),
                Text("4",style:TextStyle(color: Colors.white, fontSize: 20) ,),
                Text(" her",style:TextStyle(color: Colors.white,fontFamily: 'favo', fontSize: 20) ,),
              ],
            ),
          ),
          SizedBox(
            height: 30,),
          Container(
              margin: EdgeInsets.all(10),
              child: Text("Device Registration",style: TextStyle(color: Colors.white,fontFamily:'favo',fontSize: 25,),)),
          Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.symmetric(horizontal: 15),

            width: MediaQuery.of(context).size.width*0.8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white54,
                )
            ),
            child: TextField(
              controller: idcont,
              style: TextStyle(
                color: Colors.white
              ),

              decoration: InputDecoration(
                hintText: "Enter Device Id",
                border:InputBorder.none,

                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
          GestureDetector(
            onTap:setid,
            child: Container(
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.symmetric(vertical: 15),
              width: MediaQuery.of(context).size.width*0.8,
              decoration: BoxDecoration(color: Colors.pink,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(child: Text("Update",style: TextStyle(color: Colors.white,fontSize: 20),)),
            ),
          ),
          SizedBox(height: 50,),
          Container(
              margin: EdgeInsets.all(10),
              child: Text("Device Id : " + deviceid,style: TextStyle(color: Colors.white,fontSize: 15,),)),
        ],
      ),
    );
  }
}
