import 'package:flutter/material.dart';
import 'package:homechefflutter/screens/login_screen.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}


class _ForgotPasswordState extends State<ForgotPassword> {
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChefAppScaffold(
        title: "Forgot Password",
        showNotifications: false,
        showBackButton: true,
        showHomeButton: false,
        body:

        Container(
          height: MediaQuery.of(context).size.height*.89,
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('images/Bg_5.png'),

              fit: BoxFit.fill,
            ),
          ),
          child:

          // Scrollbar(
          //   controller: _controller,
          //   isAlwaysShown: true,
          //   radius: Radius.circular(10),
          //   thickness: 20,
          //   child: SingleChildScrollView(
          //     controller: _controller,
          //     child: Column(children: <Widget>[
          //     Padding(
          //     padding: const EdgeInsets.fromLTRB(10.0, 25.0, 15.0, 10),
          //     child: Text("To reset your password, please visit HomeChef website."),
          //   ),
          //
          //

          Scrollbar(
            controller: _controller,
              // isAlwaysShown: true,
              //radius: Radius.circular(10),
              thickness: 10,
            child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0,25.0,15.0,10),
                    child: Text("To reset your password, please visit HomeChef website.",textScaleFactor: 1.0,style: TextStyle(color: Color(0xFF656565),fontSize: 16, fontWeight: FontWeight.w600),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(children:[
                      Text("Tap on the link to visit ",textScaleFactor: 1.0,style: TextStyle(color: Color(0xFF656565),fontSize: 16, fontWeight: FontWeight.w600)),
                      new InkWell(child: Text("homechef.pk",textScaleFactor: 1.0, style: TextStyle(color: Color(0xFFFF7A18),fontSize: 16)),
                      onTap: (){ launch('https://homechef.pk');
                      },)]),
                  ),


                  Container(


                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3)
                      ],
                    ),




                    child: ExpansionTile(
                      title: Text(
                        "Instructions",
                        textScaleFactor: 1.0,
                        style: TextStyle(color: Color(0xFF656565), fontSize: 18,fontWeight: FontWeight.w600),
                      ),
                      collapsedBackgroundColor: Colors.white,
                      children: <Widget>[
                        ListView(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),

                          children: <Widget>[

                            Divider(
                              color: Color(0xff656565),
                              thickness: 1,

                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                " 1. Tap on Login/Signup Icon.",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,fontSize: 16, color: Color(0xFF656565)),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Center(
                                child: Image.asset('images/home_page1.png',width: 250,height: 250, fit: BoxFit.fill,)),
                            Padding(padding: EdgeInsets.only(top:12)),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                " 2. Enter mobile number to continue.",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,fontSize: 16, color: Color(0xFF656565)),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Center(
                                child: Image.asset('images/HelloFoodie2.png',width: 250,height: 250, fit: BoxFit.fill,)),
                            Padding(padding: EdgeInsets.only(top:12)),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ' 3. Tap on "Forget Password?" Button.',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,fontSize: 16, color: Color(0xFF656565)),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Center(
                                child: Image.asset('images/login3.png',width: 250,height: 250, fit: BoxFit.fill,)),
                            Padding(padding: EdgeInsets.only(top:12)),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ' 4. Tap on "Send Verification Code" Button.',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,fontSize: 16, color: Color(0xFF656565)),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Center(
                                child: Image.asset('images/ForgotPassword4.png',width: 250,height: 250, fit: BoxFit.fill,)),
                            Padding(padding: EdgeInsets.only(top:12)),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                " 5. Enter the verification code send on your mobile number.",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,fontSize: 16, color: Color(0xFF656565)),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Center(
                                child: Image.asset('images/AccountVerification5.png',width: 250,height: 250, fit: BoxFit.fill,)),
                            Padding(padding: EdgeInsets.only(top:12)),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                " 6. Enter New Password for HomeChef Account.",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,fontSize: 16, color: Color(0xFF656565)),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Center(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0,0, 0, 15),
                                  child: Image.asset('images/CreateNewPassword6.png',width: 250,height: 250, fit: BoxFit.fill,),
                                )),
                            Padding(padding: EdgeInsets.only(top:12)),

                          ],
                        )
                      ],
                      backgroundColor: Colors.white,
                    ),
                  ),





                ]
            ),
          ),



        )

    );
    // TODO: implement build
    throw UnimplementedError();
  }

}