
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class locate extends StatefulWidget {
  var latitude,longitude;


  locate({Key? mykey ,required this.latitude,required this.longitude});

  @override
  State<locate> createState() => _locateState();

}
var lat,lng;
var homelat=0.0,homelng=0.0;
List<LatLng> polylineCoordinates=[];
class _locateState extends State<locate> {



  gethome() async{
    DocumentSnapshot<Map<String, dynamic>> ref=await FirebaseFirestore.instance.collection("uses").doc(user.uid).collection("place").doc("home").get();
    homelat=ref['lat']==null? 0.0:ref['lat'].toDouble();
    homelng=ref['lat']==null? 0.0:ref['lng'].toDouble();
  }

  var user=FirebaseAuth.instance.currentUser!;
  @override
  //getDeviceid() async {
   /* DocumentSnapshot<Map<String, dynamic>> ref=await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
    var deviceid=ref['id'];
    print(deviceid);
    var latref=await FirebaseDatabase.instance.reference().child('devices').child(deviceid).child("coordinates").child('lat').once();
    var lngref=await FirebaseDatabase.instance.reference().child('devices').child(deviceid).child("coordinates").child('lng').once();*/


  gethomelat(){
    return homelat.toDouble();
  }

  gethomelng(){
    return homelng.toDouble();
  }

  getlat(){
    lat=widget.latitude;
    return lat==null? 0.0:lat.toDouble();
  }

  getlng(){
    lng=widget.longitude;
    return lng==null? 0.0:lng.toDouble();
  }


  void getpolyline() async{
    PolylinePoints polylinePoints=PolylinePoints();
    PolylineResult result= await polylinePoints.getRouteBetweenCoordinates("AIzaSyA3JCDRewz1-LBXvHwKZYvzH638OeB33aw", PointLatLng(homelat,homelng),PointLatLng(getlat(), getlng()) );
    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude,point.longitude)));
    }

  }
  @override
  void initState(){
    getpolyline();
    super.initState();
    gethome();
  }
  Widget build(BuildContext context) {


    return Scaffold(
      body:GoogleMap(

          mapType: MapType.hybrid,
          mapToolbarEnabled: true,
          initialCameraPosition: CameraPosition(target:LatLng(getlat(),getlng()),zoom: 17),
          polylines: {
            Polyline(
                color: Colors.red,
                width: 15,
                polylineId: PolylineId("Route "),
                points: polylineCoordinates
            )
          },
          markers: {
            Marker(
              markerId: MarkerId("Source"),
              position: LatLng(gethomelat(),gethomelng()),

            ),
            Marker(
                markerId: MarkerId("Destination"),
                position: LatLng(getlat(),getlng())
            )

          }

      ),
    );
  }
}
