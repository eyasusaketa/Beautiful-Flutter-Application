import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class routine extends StatefulWidget {
  const routine({Key? key}) : super(key: key);

  @override
  State<routine> createState() => _routineState();
}

class _routineState extends State<routine> {
  var loca=TextEditingController();
  var dia=TextEditingController();

//CollectionReference datashut = FirebaseFirestore.instance.collection('users').doc("userid.uid").collection("place");


  deleteitem(String placename1) async {
    Fluttertoast.showToast(msg: placename1+" is Deleted");
    var user=FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection('users').doc(user.uid).collection("schedule").doc(placename1).delete();

  }

  @override
  Widget build(BuildContext context) {










    return Scaffold(
      backgroundColor: Color(0xff392850),

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
            Text("Registered  Places",style: TextStyle(color: Colors.white,fontSize: 25),),

            StreamBuilder(
                stream:FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("schedule").snapshots(),
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
                                        Text("Place Name: "+document['placename'],style: TextStyle(color: Colors.white,fontWeight:FontWeight.w400,fontSize: 20),),
                                        Text("Date: "+document.id,style: TextStyle(color: Colors.white70,fontWeight:FontWeight.w400,fontSize: 20),),
                                        Text("Start From  : "+document["starttime"].toString() +" Upto "+document["stoptime"].toString() ,style: TextStyle(color: Colors.white70,fontWeight:FontWeight.w400,fontSize: 20),),
                                        Text("Coordinates :"+document["lat"].toString()+","+document["lng"].toString(),style: TextStyle(color: Colors.white70,fontWeight:FontWeight.w400,fontSize: 20),),

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
