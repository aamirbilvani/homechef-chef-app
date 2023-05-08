import 'package:flutter/material.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/screens/Done.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';

class FlagIssue extends StatefulWidget {
  @override
  _FlagIssueState createState() => _FlagIssueState();
}

class _FlagIssueState extends State<FlagIssue> {
  String _radioValue = "";
  final TextEditingController feedbackController = new TextEditingController();

  void _handleRadioValueChange1(String value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void _submitForm(context) async {
    User user = Provider.of<User>(context, listen: false);
    Map data = {
      'chefid': user.uid,
      'title': _radioValue,
      'details': feedbackController.text
    };
    var response = await http
        .post(Uri.parse(Globals.BASE_URL + "api/chefapp/v1/log_issue"), body: data);
    if (response.statusCode == 200) {
      print(response.body);
      FirebaseAnalytics().logEvent(name: 'Button',parameters: {'Category':'Button','Action':"Report An Issue",'Label':_radioValue});
      Navigator.push(context,
          new MaterialPageRoute(builder: (ctxt) => new Done("Thank you for reporting this issue! Your feedback is important to us.\nSomeone from our team will get back to you as soon as possible.\n\nIf no one gets back to you within three days, please send us an email at support@homechef.pk.\n\nHave a great day!")));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return ChefAppScaffold(
      title: "Report an Issue",
      showNotifications: true,
      showBackButton: false,
      showHomeButton: true,
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30, right: 20, left: 20, bottom: 20),
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(3.0),
                border: Border.all(color: Color(0xFFC4C4C4))),
            child: Column(
              children: <Widget>[
                RadioListTile(
                  value: "Order not picked up on time",
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange1,
                  title: Text(
                    "Order not picked up on time",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF656565),
                        fontWeight: FontWeight.w600),
                  ),
                ),
                RadioListTile(
                    value: "Poor rider behaviour",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange1,
                    title: Text(
                      "Poor rider behaviour",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF656565),
                          height: 1.5,
                          fontWeight: FontWeight.w600),
                    )),
                RadioListTile(
                    value: "Poor food handling",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange1,
                    title: Text(
                      "Poor food handling",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF656565),
                          fontWeight: FontWeight.w600),
                    )),
                RadioListTile(
                    value: "HomeChef team is not responsive",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange1,
                    title: Text(
                      "HomeChef team is not responsive",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF656565),
                          fontWeight: FontWeight.w600),
                    )),
                RadioListTile(
                    value: "Incorrect account statement",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange1,
                    title: Text(
                      "Incorrect account statement",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF656565),
                          fontWeight: FontWeight.w600),
                    )),
                RadioListTile(
                    value: "Payment issues",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange1,
                    title: Text(
                      "Payment issues",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF656565),
                          fontWeight: FontWeight.w600),
                    )),
                RadioListTile(
                    value: "App related issues",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange1,
                    title: Text(
                      "App related issues",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF656565),
                          fontWeight: FontWeight.w600),
                    )),
                RadioListTile(
                    value: "Other",
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange1,
                    title: Text(
                      "Other",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF656565),
                          fontWeight: FontWeight.w600),
                    )),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(5),
              child: TextField(
                keyboardType: TextInputType.multiline,
                controller: feedbackController,
                style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF979797)),
                maxLines: 3,
                minLines: 3,
                cursorColor: Colors.transparent,
                decoration: InputDecoration(
                  hintText:
                      'Add further details here to help us understand your issue',
                  focusColor: Colors.black38,
                  hoverColor: Colors.black38,
                  border: new OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC4C4C4)),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(8.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF8CC248))),
                ),
              )),
          Center(
              child: Material(
            borderRadius: BorderRadius.circular(3.0),
            child: MaterialButton(
              disabledColor: Color(0xFFADAAA7),
              color: Color(0xFFFF7A18),
              padding: EdgeInsets.all(5.0),
              onPressed: (_radioValue == "") ? null : () {_submitForm(context);},
              child: Text("Submit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w600)),
            ),
          )),
        ],
      ),
    );
  }
}
