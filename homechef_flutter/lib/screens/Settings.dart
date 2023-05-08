import 'package:flutter/material.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/models/UserProfile.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  User user;
  final availableTimes = [
    "01:00 AM",
    "02:00 AM",
    "03:00 AM",
    "04:00 AM",
    "05:00 AM",
    "06:00 AM",
    "07:00 AM",
    "08:00 AM",
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 AM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
    "07:00 PM",
    "08:00 PM",
    "09:00 PM",
    "10:00 PM",
    "11:00 PM",
    "12:00 PM"
  ];

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    if (user.userProfile.alerts == null ||
        user.userProfile.alerts.ring_alert_on == null) {
      const ringAlertOn = true;
      const setDnd = true;
      const ringAlertDndStart = "11:00 PM";
      const ringAlertDndEnd = "06:00 AM";

      user.userProfile.alerts =
          Alerts(ringAlertOn, setDnd, ringAlertDndStart, ringAlertDndEnd);
    }

    return ChefAppScaffold(
      title: "Settings",
      showNotifications: true,
      showBackButton: false,
      showHomeButton: true,
      body: Container(
        height: MediaQuery.of(context).size.height*.89,
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('images/Bg_5.png'),

            fit: BoxFit.fill,
          ),
        ),
        // margin: EdgeInsets.all(10),
        // color: Colors.white,
        child: ListView(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: 30, top: 30, right: 0, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Text(
                              "Ring Alert",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontSize: 22, height:1.5,fontWeight: FontWeight.bold),
                            ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Switch(
                                value: user.userProfile.alerts.ring_alert_on,
                                onChanged: (bool isOn) {
                                  setState(() {
                                    user.userProfile.alerts.ring_alert_on =
                                        isOn;
                                    //user.doNotifyListeners();
                                  });
                                },
                              ),
                            ),
                          ),
                          flex: 2,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Text(
                      "This is the sound alert where your phone rings every time when you receive a new order",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Container(
                    //margin: EdgeInsets.all(20),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                        value: user.userProfile.alerts.set_dnd,
                        onChanged: (!user.userProfile.alerts.ring_alert_on) ? null : (bool newValue) {
                          setState(() {
                            user.userProfile.alerts.set_dnd = newValue;
                          });
                        },
                        title: Text(
                          "Do not disturb between:",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16, height: 1.5),
                        )),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black26),
                            //color: Colors.deepOrangeAccent,
                          ),
                          child: DropdownButton<String>(
                            value: user.userProfile.alerts.ring_alert_dnd_start,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            onChanged: (!user.userProfile.alerts.set_dnd || !user.userProfile.alerts.ring_alert_on) ? null : (String newValue) {
                              setState(() {
                                user.userProfile.alerts.ring_alert_dnd_start =
                                    newValue;
                              });
                            },
                            isExpanded: true,
                            items: availableTimes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        flex: 2,
                      ),
                      Text("To",textScaleFactor: 1.0,),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black26),
                            //color: Colors.deepOrangeAccent,
                          ),
                          child: DropdownButton<String>(
                            value: user.userProfile.alerts.ring_alert_dnd_end,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            onChanged: (!user.userProfile.alerts.set_dnd || !user.userProfile.alerts.ring_alert_on) ? null : (String newValue) {
                              setState(() {
                                user.userProfile.alerts.ring_alert_dnd_end =
                                    newValue;
                              });
                            },
                            isExpanded: true,
                            items: availableTimes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                  Center(
                      child: Material(
                    borderRadius: BorderRadius.circular(3.0),
                    child: MaterialButton(
                      disabledColor: Color(0xFFADAAA7),
                      color: Color(0xFFFF7A18),
                      padding: EdgeInsets.all(5.0),
                      onPressed: () {
                        saveProfile(user);
                      },
                      child: Text("Save",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w600)),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveProfile(user) async {
    Map data = {
      'chefId': user.uid,
      'ring_alert_on': user.userProfile.alerts.ring_alert_on.toString(),
      'set_dnd': user.userProfile.alerts.set_dnd.toString(),
      'ring_alert_dnd_start': user.userProfile.alerts.ring_alert_dnd_start,
      'ring_alert_dnd_end': user.userProfile.alerts.ring_alert_dnd_end
    };
    var response = await http
        .post(Uri.parse(Globals.BASE_URL + "api/chefapp/v1/do_not_disturb"), body: data);
    if (response.statusCode == 200) {
      user.doNotifyListeners();
      Globals.showToast("Changes have been saved");
    } else {}
  }
}