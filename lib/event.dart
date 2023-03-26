import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'map.dart';
class event extends StatefulWidget {
  const event({Key? key}) : super(key: key);

  @override
  State<event> createState() => _sosState();
}

class _sosState extends State<event> {
  @override
  Widget build(BuildContext context) {

    deleteitem(String placename1) async {
      Fluttertoast.showToast(msg: placename1+" is Deleted");
      var user=FirebaseAuth.instance.currentUser!;
      FirebaseFirestore.instance.collection('users').doc(user.uid).collection("event").doc(placename1).delete();
    }
    return Scaffold(
      backgroundColor: Color(0xff392850),
      body: Column(
        children: [
          AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,

              title:Text("event")
          ),

          StreamBuilder(
              stream:FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("event").snapshots(),
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
                                      Text("date : "+document["date"],style: TextStyle(color: Colors.white,fontWeight:FontWeight.w400,fontSize: 20),),
                                      Text("Time : "+document["time"],style: TextStyle(color: Colors.white70,fontWeight:FontWeight.w400,fontSize: 20),),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context){
                                           return locate(latitude:document["lat"],longitude:document["lng"]);
                                          }));
                                        },
                                      child:Text("Coordinates :"+document["lat"].toString()+","+document["lng"].toString(),style: TextStyle(color: Colors.white70,fontWeight:FontWeight.w400,fontSize: 20),),
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
    );
  }
}


