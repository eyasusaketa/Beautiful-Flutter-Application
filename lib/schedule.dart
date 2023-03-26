
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:safely4her/place.dart';
import 'package:safely4her/routine.dart';
import 'package:safely4her/userdata.dart';
import 'package:time_range/time_range.dart';
class schedule extends StatefulWidget {
  const schedule({Key? key}) : super(key: key);

  @override
  State<schedule> createState() => _scheduleState();
}
DateTime? datepicked,datetime,startdatetime;
TimeOfDay? timepicked;
String? dropdowntext;
Place? placeselected;


final _defaultTimeRange = TimeRangeResult(
  TimeOfDay(hour: 13, minute: 20),
  TimeOfDay(hour: 22, minute: 20),
);
TimeRangeResult? _timeRange;
var useridref;

class _scheduleState extends State<schedule> {
  var startT=TextEditingController();
  var stoptT=TextEditingController();
  static const orange =Colors.purple; //Color(0xFFFE9A75);
  static const dark =Colors.white54; //Color(0xEEFE00FF);
  static const double leftPadding = 50;
  @override
  var day;
  List<Place> places=[];
  var place;


  setschedule(Map<String, dynamic> userDataMap,String day) async {
    var user = await FirebaseAuth.instance.currentUser!;
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(user.uid).collection("schedule").doc(day);

    return ref.set(userDataMap, SetOptions(merge: true));
  }

  setplace({required Map<String,dynamic> plac}){
    var user=FirebaseAuth.instance.currentUser!;
    DocumentReference ref1=FirebaseFirestore.instance.collection('users').doc(user.uid).collection('schedule').doc(getText());
   return  ref1.set(plac);
  }
  Future selecttime(BuildContext contect) async{

    final date=await pickdate(context);
   if(date==null) return;

   setState((){
     datetime=DateTime(
         date?.year,
         date?.month,
         date?.day);
   });

  }

  Future pickdate(BuildContext context) async{
    final initialdate=DateTime.now();


    final newDate= await showDatePicker(
        context: context,
        initialDate: initialdate,
        firstDate: DateTime(DateTime.now().year-5)  ,
        lastDate: DateTime(DateTime.now().year+5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              background: Colors.white30,
              primary: Color(0xff392850), // <-- SEE HERE
              onPrimary: Colors.white70, // <-- SEE HERE
              onSurface: Color(0xff392850), // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Color(0xff392850), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },

    );
    if(newDate==null) return;
  setState(() {
    datepicked=newDate;
  });

  }


changedata(){
   String datet=getText();

   setschedule( UserData(
       starttime:convertdate(_timeRange!.start.format(context)),
       stoptime:convertdate(_timeRange!.end.format(context)),


   ).scheduledata(),datet);
}


  @override
  void initState() {
    super.initState();
  useridref=FirebaseAuth.instance.currentUser!;
    _timeRange = _defaultTimeRange;
  }

String convertdate(String date){
    var timearray=date?.split(' ');
    var time=timearray?[0];
    var flag=timearray?[1];
    var timesplit=time?.split(':');
    var hour=timesplit?[0];
    var minute=timesplit?[1];
    var hourint;
    if(flag=="PM"){
      hourint= int.parse(hour!)+12;
      hour=hourint.toString();
    }
    return "$hour:$minute";
}
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff392850),
     body: SingleChildScrollView(
       child: Column(
         children: [

           AppBar(
         backgroundColor: Colors.transparent,
         elevation: 0,
         title: Row(
         children: [
         Text("Safety ",style:TextStyle(color: Colors.white,fontFamily: 'favo', fontSize: 25) ,),
          Text("4",style:TextStyle(color: Colors.white, fontSize: 20) ,),
          Text(" her",style:TextStyle(color: Colors.white,fontFamily: 'favo', fontSize: 25) ,),
          ],
         ),
       ),
           SizedBox(
             height: 15,),
           Container(
               margin: EdgeInsets.all(6),
               child: Text("Routine Registration Form",style: TextStyle(color: Colors.white,fontSize: 27,fontFamily: 'favo'),)),

           Container(
             margin: EdgeInsets.only(top: 30),
             padding: EdgeInsets.symmetric(horizontal: 15),

             width: MediaQuery.of(context).size.width*0.8,
             decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white54
                ),

                 borderRadius: BorderRadius.circular(25),


             ),
             child: StreamBuilder<QuerySnapshot>(
               stream: FirebaseFirestore.instance.collection('users').doc(useridref.uid).collection("place").snapshots(),
               builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Text("Loading...");
                }else{

                  List<DropdownMenuItem<String>> _items=[];

                  for(int i=0;i < snapshot.data!.docs.length;i++){
                    DocumentSnapshot snap=snapshot.data!.docs[i];
                    _items.add(
                      DropdownMenuItem(child: Text(snap.reference.id),
                      value: i.toString(),
                      ),);
                      places.add(
                       Place(
                         lat: snap['lat'],
                         lng: snap['lng'],
                         diameter: snap['diameter'],
                         placename: snap.reference.id
                       ),
                      );


                  }
                  return DropdownButton(
                    hint:(dropdowntext!=null)? Text("Selected place is " + dropdowntext!,style: TextStyle(color: Colors.white),):Text("Select favorite place",style: TextStyle(color: Colors.white),),
                    items: _items,
                    style: TextStyle(color:Colors.white),
                    elevation: 10,
                    dropdownColor: Colors.deepPurple,
                    underline: SizedBox(),
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(25),bottomRight: Radius.circular(25)),
                    onChanged: (value) {

                      setState(() {
                          dropdowntext=places[int.parse(value as String)].placename;
                          placeselected=places[int.parse(value as String)];



                      });
                    },
                  );

                }
               },
             )             ),

           GestureDetector(
             child:Container(

             margin: EdgeInsets.only(top: 30),

             padding: EdgeInsets.symmetric(horizontal: 15),

             width: MediaQuery.of(context).size.width*0.8,
             height: MediaQuery.of(context).size.height*0.068,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(25),
               border: Border.all(
                 color: Colors.white54,
               )
             ),
             child:Center(
             child: Text(
              getText(),
                   style: TextStyle(color: Colors.white,fontSize: 16),

               ),
             )
           ),
           onTap:()=> selecttime(context),
           ),
           SizedBox(height: MediaQuery.of(context).size.height*0.03,),
           TimeRange(
             fromTitle: Text(
               'FROM',
               style: TextStyle(
                 fontSize: 14,
                 color: dark,
                 fontWeight: FontWeight.w600,
               ),
             ),
             toTitle: Text(
               'TO',
               style: TextStyle(
                 fontSize: 14,
                 color: dark,
                 fontWeight: FontWeight.w600,
               ),
             ),
             titlePadding: leftPadding,
             textStyle: TextStyle(
               fontWeight: FontWeight.normal,
               color: dark,
             ),
             activeTextStyle: TextStyle(
               fontWeight: FontWeight.bold,
               color: orange,
             ),
             borderColor: dark,
             activeBorderColor: dark,
             backgroundColor: Colors.transparent,
             activeBackgroundColor: dark,
             firstTime: TimeOfDay(hour: 0, minute: 00),
             lastTime: TimeOfDay(hour: 24, minute: 00),
             initialRange: _timeRange,
             timeStep: 10,
             timeBlock: 30,
             onRangeCompleted: (range) => setState(() => _timeRange = range),
           ),
           SizedBox(height: MediaQuery.of(context).size.height*0.03,),
           if (_timeRange != null)
             Padding(
               padding: const EdgeInsets.only(top: 8.0, left: leftPadding),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   Text(
                     'Selected Range: ${_timeRange!.start.format(context)} - ${_timeRange!.end.format(context)}',
                     style: TextStyle(fontSize: 20, color: Colors.white),
                   ),
                   SizedBox(height: 20),
                   MaterialButton(
                     child: Text('Default',style: TextStyle(color: Colors.white),),
                     onPressed: () =>
                         setState(() => _timeRange = _defaultTimeRange),
                     color: orange,
                   )
                 ],
               ),
             ),


           GestureDetector(
             onTap:(){
               var dat={"lat":placeselected!.lat,"lng":placeselected!.lng,"placename":placeselected!.placename,"diameter":placeselected!.diameter};
               Fluttertoast.showToast(msg: "Submitted");
               changedata();
               setplace( plac:dat);
             } ,
             child: Container(
               margin: EdgeInsets.only(top: 30),
               padding: EdgeInsets.symmetric(vertical: 15),
               width: MediaQuery.of(context).size.width*0.8,
               decoration: BoxDecoration(color: Colors.pink,
               borderRadius: BorderRadius.circular(25),
               ),
               child: Center(child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 20),)),
             ),
           )

         ],
       ),
     ),

      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context,MaterialPageRoute(builder:(context) =>routine() ) );
      },
        backgroundColor: Colors.pink,
        child: Icon(Icons.reviews),
      ),
    );
  }

  String getText() {
    if(datepicked==null)
    {
      return "Select Date";
    }
    else
    {
    return '${datepicked?.month}-${datepicked?.day}-${datepicked?.year}';
  }
  }

   gettimeText() {
     startdatetime=DateFormat('HH:mm').parseStrict(_timeRange!.start.format(context));
  }
}
