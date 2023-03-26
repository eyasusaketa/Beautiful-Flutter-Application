import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safely4her/locating.dart';
import 'package:safely4her/schedule.dart';
import 'package:safely4her/sos.dart';

import 'deviceid.dart';
import 'event.dart';
import 'favoriteregistration.dart';

class GridDashboard extends StatelessWidget {
  Future getusername() async{
    var userid=FirebaseAuth.instance.currentUser!;
    var username=await userid.email;
    return username;
  }

  Items item1 = new Items(
      title: "Locate",
      subtitle: ">>>>>",
      event: "Last Place",
      img: "assets/map.png",
    page:locate(),
  );

  Items item2 = new Items(
    title: "Favorite Places",
    subtitle: "School,Cherch",
    event: "Register comman places",
    img: "assets/place.png",
    page:fav(),
  );
  Items item3 = new Items(
    title: "SOS",
    subtitle: "List of SOS messge",
    event: "See in detail",
    img: "assets/sos.png",
    page:sos(),
  );
  Items item4 = new Items(
    title: "Schedule",
    subtitle: "where to go",
    event: "Make a plan",
    img: "assets/calendar.png",
    page:schedule(),
  );
  Items item5 = new Items(
    title: "Events",
    subtitle: "If Divice is not in favorite place,",
    event: "List of notification detail",
    img: "assets/event.png",
    page:event(),
  );
  Items item6 = new Items(
    title: "Register Device",
    subtitle: "",
    event: "device is registered",
    img: "assets/device.png",
    page:deviceid(),
  );

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6];
    var color = 0xff453658;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return GestureDetector(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context){
                  return data.page;
                }));
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white54
                  ),
                    color: Color(color), borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      data.img,
                      width: 42,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.title,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.subtitle,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.event,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Widget page;
  Items({required this.title,required this.page, required this.subtitle, required this.event, required this.img});
}