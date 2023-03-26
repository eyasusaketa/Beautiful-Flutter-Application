import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'griddashboard.dart';


class page1 extends StatefulWidget {
  const page1({Key? key}) : super(key: key);

  @override
  State<page1> createState() => _page1State();
}

var username;

class _page1State extends State<page1> {

  Future<String?> getusername() async{
    var userid=await FirebaseAuth.instance.currentUser!;
     username=userid.email;

  }
  void initState() {
    super.initState();
    getusername();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Row(
          children: [
            Text("Safety ",style:TextStyle(color: Colors.white,fontFamily: 'favo', fontSize: 22) ,),
            Text("4",style:TextStyle(color: Colors.white, fontSize: 22) ,),
            Text(" her",style:TextStyle(color: Colors.white,fontFamily: 'favo', fontSize: 22) ,),
          ],

        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap:(){   FirebaseAuth.instance.signOut();},
            child:Icon(Icons.logout)),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xff392850),
      body:  Column(
        children: <Widget>[

          SizedBox(
            height: 10,
          ),

          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Text(
                      username==null? "...................":username,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white54,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),

                    SizedBox(
                      height: 4,
                    ),

                    Text(
                      "home",
                      style:  TextStyle(
                              color: Colors.orange,
                              fontSize: 20,
                              fontFamily: 'favo',
                              fontWeight: FontWeight.w600)),

                  ],
                ),

                IconButton(
                  alignment: Alignment.topCenter,
                  icon: Image.asset(
                    "assets/logo.png",
                    width: 40,
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),

          SizedBox(
            height: 40,
          ),

          GridDashboard()

        ],

      ),

    );

  }
}
