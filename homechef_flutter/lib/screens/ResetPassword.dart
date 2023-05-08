import 'package:flutter/material.dart';
import 'package:homechefflutter/screens/login_screen.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}


class _ResetPasswordState extends State<ResetPassword> {

  TextEditingController _c ;
  String text = "Enter your registered phone number and we will email you a recovery link to reset your password.";
  String reset = "Reset Password";
  String btn_text = "Continue";
  var number_box = true;

  @override
  void initState() {
    _c = new TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    _c?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ChefAppScaffold(
      title: "Forgot Password",
      showNotifications: false,
      showBackButton: true,
      showHomeButton: false,
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 70,left: 20,right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(reset,textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(text,style: TextStyle(
                  fontSize: 14
                ),
                ),
                Padding(padding: EdgeInsets.only(top: 40)),
                Visibility(
                  visible: number_box,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text("+92", style: TextStyle(
                          fontSize: 16
                      ),
                      ),flex: 1,),
                      Expanded(child: TextFormField(
                        maxLines:  1,
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        controller: _c,
                        decoration: new InputDecoration(
                        hintText: '3001234567',
                        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      validator: (value) => value.length < 10 || value.length > 11 ? 'Incorrect Number' : null,
                    ),
                      flex: 6,
                    )
                  ],
                ),
                ),

                Padding(padding: EdgeInsets.only(top: 40)),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(8.0),
                  color:  Colors.deepOrangeAccent,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(5.0),
                    onPressed: () {
                      if(btn_text.toString() == "Continue"){
                        setState(() {
                          number_box = false;
                          reset = "Pasword Reset Email Sent!";
                          btn_text = "Sign In";
                          text = "An email has been sent to your registered account. If you do not see your email, check your junk and spam folders.\n\n For Further help? Call customer care on 0311-1222605.";
                        });
                        sendPasswordResetEmail();
                      }
                      else{
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (ctxt) => new LoginScreen())
                        );
                      }
                    },
                    child: Text(btn_text,
                        textAlign: TextAlign.center, style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    )
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  sendPasswordResetEmail() async {
    Map data = {
      'mobile': _c.text
    };
    var response =
        await http.post(Uri.parse(Globals.BASE_URL + "api/v1/passwordresetrequest"), body: data);
    print(response.body);
  }
}
