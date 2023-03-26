import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:safely4her/page1.dart';
import 'rounded_button.dart';

//code for designing the UI of our text field where the user writes his email id or password

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white30, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white30, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
late final TextEditingController email,password;
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailcontroller=TextEditingController();
  final _passwordcontroller=TextEditingController();

  bool showSpinner = false;

  Future signup() async {
    setState(() {
      showSpinner=true;
    });
    try {
      print("111111111111111");
      print(_emailcontroller!.text.trim());
      final newUser = await _auth.createUserWithEmailAndPassword(

          email: _emailcontroller!.text.trim(), password: _passwordcontroller!.text.trim());
      print("kkkkkkkkkkkkkkkkkkkk");
      if (newUser != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>page1()));
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      showSpinner=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xff392850),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image(
                width: 140,
                  height: 140,
                  image: AssetImage('assets/logo.png')
              ),

              SizedBox(
                height: 50.0,
              ),
              TextField(
                 controller: _emailcontroller,
                  style: TextStyle(color: Colors.white70),
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email')),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                   controller: _passwordcontroller,
                  style: TextStyle(color: Colors.white70),
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your Password')),
              SizedBox(
                height: 24.0,
              ),
              GestureDetector(
                onTap:signup ,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(

                    padding: EdgeInsets.all(17),
                    decoration: BoxDecoration(
                        color: Color(0xffB664D1),
                        borderRadius: BorderRadius.circular(25)
                    ),



                    child: Center(
                        child: Text("Sign up",
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        )),
                  ),
                ),
              ),

            ],
          ),

      ),
    );
  }
}