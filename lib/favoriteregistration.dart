import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'map.dart';

class fav extends StatefulWidget {
  const fav({Key? key}) : super(key: key);

  @override
  State<fav> createState() => _favState();
}

var lat,lng;
class _favState extends State<fav> {
var loca=TextEditingController();
var dia=TextEditingController();

getDeviceid() async
{

  var user=FirebaseAuth.instance.currentUser!;
  DocumentSnapshot<Map<String, dynamic>> ref=await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
  var deviceid=ref['id'];
  print(deviceid);
  var latref=await FirebaseDatabase.instance.reference().child('devices').child(deviceid).child("coordinates").child('lat').once();
  var lngref=await FirebaseDatabase.instance.reference().child('devices').child(deviceid).child("coordinates").child('lng').once();
  lat=latref.snapshot.value;
  lng=lngref.snapshot.value;

}


 void initState()
    {
   getDeviceid();
    }


//CollectionReference datashut = FirebaseFirestore.instance.collection('users').doc("userid.uid").collection("place");

  setdeviceid(Map<String, dynamic> userDataMap,String name) async {
    var user = await FirebaseAuth.instance.currentUser!;
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(user.uid).collection("place").doc(name);
    return ref.set(userDataMap, SetOptions(merge: true));
     }

  deleteitem(String placename1) async {
    Fluttertoast.showToast(msg: placename1+" is Deleted");
    var user=FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection('users').doc(user.uid).collection("place").doc(placename1).delete();
    }

  changeid()
    {
    Map<String,dynamic> datamap={"lat":lat==null? '0.0':lat,"lng":lng==null? '0.0':lng,"diameter":dia.text.toString().trim()};
    setdeviceid(datamap,loca.text.toString());
    Navigator.pop(context);
    }


  @override
  Widget build(BuildContext context) {

   Future<Widget> getdata() async {

      List a;
      var userid= await FirebaseAuth.instance.currentUser!;
      //FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("place").snapshots();
      CollectionReference ref = FirebaseFirestore.instance.collection('users').doc(userid.uid).collection("place");
      ref.get().then(
            (value) {
          value.docs.forEach(
                (element) {

             // print(element.data());

            },
          );
        },
      );

      return Text("data");
    }


Future<List>   getDocumentData () async
    {
     var userid= await FirebaseAuth.instance.currentUser!;
     //FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("place").snapshots();
     CollectionReference _cat= FirebaseFirestore.instance.collection('users').doc(userid.uid).collection("place");
     QuerySnapshot querySnapshot = await _cat.get();
     final _docData = querySnapshot.docs.map((doc) => doc.data()).toList();
     print(_docData);
     return _docData;
    }



     TableRow buildRow(List<String> cells) => TableRow(
      children: cells.map((cell) {

        return Container(
          padding:EdgeInsets.all(12),
          child: Center(
            child: Text(cell,style: TextStyle(color: Colors.white),),
          ),
        );
      }).toList(),
    );

    void showdialogbox(BuildContext context)=> showDialog(
    context: context,
    builder:  (BuildContext context){

      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
         width: MediaQuery.of(context).size.width,
          child: SimpleDialog(
           backgroundColor:Color(0xff392850),
            title:Text("Place Registration",style: TextStyle(color: Colors.white,fontFamily:'favo',fontSize: 25,) ,),
              children: [
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.symmetric(horizontal: 15),

                  width: MediaQuery.of(context).size.width*0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white54,
                      )

                  ),
                  child: SizedBox(
                    width: 20,
                    child: TextField(
                      controller: loca,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter location name",
                        hintStyle: TextStyle(color: Colors.white),

                      ),
                    ),
                  ),
                ),
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
                    controller: dia,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Radius in meter",
                      hintStyle: TextStyle(color: Colors.white),

                    ),
                  ),
                ),
                GestureDetector(
                  onTap:changeid ,
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    width: MediaQuery.of(context).size.width*0.4,
                    decoration: BoxDecoration(color: Colors.pink,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 20),)),
                  ),
                ),
              ],
            ),
          ),

      );
    });

Future<List> b=getDocumentData();
    return Scaffold(
       backgroundColor: Color(0xff392850),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(Icons.edit),
        onPressed: (){
          getdata();
          getDocumentData();
          showdialogbox(context);
        },
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
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
           SizedBox(height: 15,),
           Text("Registered Favorite Places",style: TextStyle(color: Colors.white,fontSize: 25),),
           StreamBuilder(
               stream:FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("place").snapshots(),
               builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                 if(!snapshot.hasData){
                   return Center(
                     child: CircularProgressIndicator(),
                   );
                 }
                 return    SizedBox(
                   height: MediaQuery.of(context).size.height*0.8,
                   child: ListView(
                     children:snapshot.data!.docs.map((document){
                       return Container(
                       margin:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05,vertical: 2),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(5),
                         color: Colors.white12
                       ),
                       height: MediaQuery.of(context).size.width*0.25,
                         child:Card(
                         color: Colors.transparent,


                         child:Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.start,

                               children: [
                                 Text("Place Name : "+document.id,style: TextStyle(color: Colors.white,fontWeight:FontWeight.w400,fontSize: 20),),
                                 Text("Diameter in Meter : "+document["diameter"],style: TextStyle(color: Colors.white70,fontWeight:FontWeight.w400,fontSize: 20),),
                                 GestureDetector(
                                   onTap: (){
                                     Navigator.push(context, MaterialPageRoute(builder:(context)=>locate(latitude: document["lat"],longitude: document["lng"],) ));
                                   },
                                  child: Text("Coordinates :"+document["lat"].toString()+","+document["lng"].toString(),style: TextStyle(color: Colors.white70,fontWeight:FontWeight.w400,fontSize: 20),),
                                 )
                               ],
                             ),
                             IconButton(onPressed: () async{
                                await deleteitem(document.id);
                             }, icon:Icon(Icons.delete_forever,color: Colors.red,size: 25,))
                           ],
                         )
                      )
                       );
                     }).toList(),
                   ),
                 );
               }),
          ],
        ),
      ),
    );
  }
}
