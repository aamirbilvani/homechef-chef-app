import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/screens/Dashboard.dart';
import 'package:homechefflutter/screens/ResetPassword.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ForgotPassword.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  User user;
  bool showPassword = false;

  final signupString =
  //"You can only use this app if you are already an approved chef on HomeChef.\n\n Want to become a chef on HomeChef and sell your dishes?\n\nGo to: homechef.pk/be-a-chef from a computer";
      "We’re here to help you join our team of approved Chefs.\n \n Log onto homechef.pk/be-a-chef and start now.";

  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (user != null && user.uid != "") {
        Globals.getData(user);
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (ctxt) => new Dashboard()));
      }

      getUserFromSP(context, user);
      Future.delayed(Duration(seconds: 1), () {
        Globals.getToken(user);
        Globals.getMessage(context);
      });
      print(Globals.firebaseToken);
    });
  }


  @override
  Widget build(BuildContext context) {
    return ChefAppScaffold(
        title: "Login",
        showNotifications: false,
        showBackButton: false,
        showHomeButton: false,
        showMenuButton: false,
        body: SingleChildScrollView(child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height*.89,
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('images/Bg_5.png'),

                fit: BoxFit.fill,
              ),
            ),
            //margin: EdgeInsets.only(top: 20),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "images/hclogo.png",
                    width: 180,
                    height: 120,
                  ),
                  Text("Chef App", style: Theme.of(context).textTheme.headline1),
                  SizedBox(height: 25.0),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.phone,
                      autofocus: false,
                      controller: phoneController,
                      decoration: new InputDecoration(
                        hintText: 'Mobile Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new TextFormField(
                      maxLines: 1,
                      obscureText: !showPassword,
                      autofocus: false,
                      controller: passwordController,
                      decoration: new InputDecoration(
                        hintText: 'Password',
                        suffixIcon: InkWell(
                            child: (showPassword)
                                ? Image.asset("images/password_show.png")
                                : Image.asset("images/password_hide.png"),
                            onTap: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            }),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () {
                          FirebaseAnalytics().logEvent(name: 'Button',parameters: {'Category':'Button','Action':'Forgot Password','Label':'Forgot Password'});
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (ctxt) => new ForgotPassword()));
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.deepOrangeAccent,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(5.0),
                          onPressed: () {
                            _submit(context);
                          },
                          child: Text("Login",
                              textAlign: TextAlign.center,
                              style: style.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Don’t have an account?",
                          style: TextStyle(fontSize: 16, color: Colors.black38),
                        ),
                        InkWell(
                          onTap: () => {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                                content: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: const Color(0xFFFFFF),
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(50.0)),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () => {
                                              Navigator.of(context,
                                                  rootNavigator: true)
                                                  .pop(),
                                            }),
                                      ),
                                      // Text("Hello flutter"),

                                      // InkWell(child:
                                      // Text(
                                      //   //signupString,
                                      //   "hello",
                                      //   style: TextStyle(fontSize: 16),
                                      //   textAlign: TextAlign.center,
                                      // ),
                                      // onTap: (){ launch('https://homechef.pk/be-a-chef');}
                                      // ),



                                      RichText(
                                        text: TextSpan(
                                          text: 'We’re here to help you join our team of approved Chefs. Log onto ',
                                          style:TextStyle(color:Color(0xFF656565),fontSize: 16,
                                            // fontWeight: FontWeight.w600
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'homechef.pk/be-a-chef',
                                              style: TextStyle(fontSize: 16, color: Color((0xFFFF872F))),
                                              recognizer: TapGestureRecognizer()..onTap = () {
                                                launch('https://homechef.pk/be-a-chef');
                                                // Single tapped.
                                              },
                                            ),

                                            TextSpan(text: ' and start now.\n\nOr contact us with further querries on ', style:TextStyle(color:Color(0xFF656565),fontSize: 16,
                                              // fontWeight: FontWeight.w600
                                            )),

                                            TextSpan(
                                              text: '03-111-222-605',
                                              style: TextStyle(fontSize: 16, color: Color((0xFFFF872F))),
                                              recognizer: TapGestureRecognizer()..onTap = () {
                                                setState(() {
                                                  _makePhoneCall('tel:03111222605');
                                                });

                                                // Single tapped.
                                              },
                                            ),






                                          ],
                                        ),
                                      ),




                                      //
                                      // InkWell(child: Text("homechef.pk", style: TextStyle(color: Color(0xFFFF7A18))),
                                      //   onTap: (){ launch('homechef.pk/be-a-chef');
                                      //   },)

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,10,0,0),
                          child: Text(Globals.app_version!=""?
                          "v" + Globals.app_version:"",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF656565),
                                  fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ));




  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getUserFromSP(context, user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("user");
    if (data != null && data != "" && data != "Instance of 'User'") {
      User ux = User.fromJson(jsonDecode(data));
      user.mobile = ux.mobile;
      user.name = ux.name;
      user.token = ux.token;
      user.uid = ux.uid;
      user.usertype = ux.usertype;
      user.email = ux.email;
      user.allOrders = ux.allOrders;
      user.earningsSummary = ux.earningsSummary;
      user.userProfile = ux.userProfile;
      user.cheflevel = ux.cheflevel;
      user.lastNotificationViewTime = ux.lastNotificationViewTime;
      if (user.uid != "") {
        Globals.getData(user);
        FirebaseAnalytics().logEvent(name: 'Open',parameters: {'Category':'Open','Action':'Logged In','Label':user.uid});
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (ctxt) => new Dashboard()));
      }
    }
  }

  void _submit(BuildContext context) {

    if (phoneController.text.toString().length < 11) {
      Globals.showToast("Enter a valid Number");
    } else if (passwordController.toString().length < 5) {
      Globals.showToast('Enter a valid passowrd');
    } else {
      Globals.showLoading(context);
      signIn(phoneController.text, passwordController.text, context);
    }
  }

  signIn(String mobile, String pass, BuildContext context) async {
    Map data = {
      'mobile': mobile.trim(),
      'password': pass,
      'firebasetoken': Globals.firebaseToken
    };
    var jsonResponse;
    var response =
    await http.post(Uri.parse(Globals.BASE_URL + "api/chefapp/v1/login"), body: data);
    print(response.body);
    jsonResponse = json.decode(response.body);
    String errorString = signupString;
    if (response.statusCode != 200 &&
        jsonResponse["message"].contains("password")) {
      errorString = jsonResponse["message"];
    }
    if (response.statusCode == 200) {
      if (jsonResponse != null) {
        user.mobile = jsonResponse['mobile'];
        user.name = jsonResponse['name'];
        user.token = jsonResponse['token'];
        user.uid = jsonResponse['uid'];
        user.usertype = jsonResponse['usertype'];
        user.email = jsonResponse['email'];
        user.cheflevel = jsonResponse['cheflevel'];
        Globals.getData(user, force: true);
        SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
        sharedPreferences.setString("user", jsonEncode(user));
        Globals.hideLoading();
        FirebaseAnalytics().logEvent(name: 'Open',parameters: {'Category':'Open','Action':'Login Successful','Label':user.uid});
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (ctxt) => new Dashboard()));
      }
    } else {
      Globals.hideLoading();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => {
                        Navigator.of(context, rootNavigator: true).pop(),
                      }),
                ),
                Text(
                  errorString,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
