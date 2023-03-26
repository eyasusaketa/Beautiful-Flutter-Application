import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:safely4her/signup.dart';
import 'page1.dart';



const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =

FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  print('A bg message just showed up :  ${message.messageId}');

}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  // ignore: unnecessary_new

  @override
void initState(){

    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/launcher_icon',
              ),
            ));
      }
    });



    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });


  }





  Widget build(BuildContext context) {

    Future<FirebaseApp> _initializeFirbase() async{

      FirebaseApp firebase=await Firebase.initializeApp();

      return firebase;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:FutureBuilder(
              future:_initializeFirbase(),
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return home();
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );

              }),

    );





  }
}
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final _emailcontroller=TextEditingController();
  final _passwordcontroller=TextEditingController();
Future getusername() async{
  var userid=FirebaseAuth.instance.currentUser!;
  var username=await userid.email;
  return username;
}

  Future signIn() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailcontroller.text.trim(),
          password: _passwordcontroller.text.trim()
      );}
    on FirebaseAuthException catch (e){

      showDialog(context: context, builder:(context){
        print(e);
        return AlertDialog(
          content: Text('Incorrect Email or Password'),
        );
      });
    }
  }
  @override
  void dispose(){
    super.dispose();
    _passwordcontroller.dispose();
    _emailcontroller.dispose();
  }
  @override
  Widget build(BuildContext context) {

    var w=MediaQuery.of(context).size.width;
    var h=MediaQuery.of(context).size.height;
    return Scaffold(

        backgroundColor: Color(0xff392850),
        body:StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return  page1();
            } else{
              return  SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 120,),

                    Image.asset('assets/logo.png',
                      height:150,// MediaQuery.of(context).size.height*0.40,
                      width:150,// MediaQuery.of(context).size.width*0.5,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                    Padding(

                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(color: Colors.white30)
                        ),

                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child:Row(
                              children:[
                                Icon(Icons.person,color: Colors.white,),
                                SizedBox(width: 5,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  child:TextField(
                                    style: TextStyle(color: Colors.white),
                                    controller: _emailcontroller,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:'username',
                                      hintStyle: TextStyle(color: Colors.white)
                               ),
                              ),
                             )
                           ]
                          ),
                        )
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),

                    Padding(

                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(color: Colors.white30)
                        ),

                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child:Row(
                          children:[
                            Icon(Icons.lock_outline,color: Colors.white,),
                           SizedBox(width: 5,),
                           SizedBox(
                           width: MediaQuery.of(context).size.width*0.6,
                            child:TextField(
                            style: TextStyle(color: Colors.white),
                            controller: _passwordcontroller,
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.white),
                                hintText:'Password'
                            ),
                          ),)
                          ]
                        ),)
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02),
                    Padding(
                      padding: const EdgeInsets.only(right:25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(" Forgot Password?",style: TextStyle(color:Colors.white,fontWeight:FontWeight.w500,fontSize:17),),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02),
                GestureDetector(
                  onTap:signIn ,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(

                          padding: EdgeInsets.all(17),
                          decoration: BoxDecoration(
                              color: Color(0xffB664D1),
                              borderRadius: BorderRadius.circular(25)
                          ),



                            child: Center(
                                child: Text("Sign in",
                                  style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18
                                  ),
                                )),
                          ),
                        ),
                      ),

                    SizedBox(height: MediaQuery.of(context).size.height*0.02),
                    Padding(
                      padding: const EdgeInsets.only(right:25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(" Don't have account?",style: TextStyle(color:Colors.white60,fontWeight:FontWeight.w400,fontSize:17),),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationScreen()));
                            },

                          child:Text(" Register now",style: TextStyle(color:Colors.white,fontWeight:FontWeight.w500,fontSize:17),),
              )],
                      ),
                    ),

                  ],
                ),
              );
            }

          },
        )
    );
  }
}
