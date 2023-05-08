import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/screens/DishReviewAndRating.dart';
import 'package:homechefflutter/screens/OpenOrders.dart';
import 'package:homechefflutter/screens/PaymentEarning.dart';
import 'package:homechefflutter/screens/UnconfirmOrders.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  User user;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      user.lastNotificationViewTime = DateTime.now().toLocal();
      saveToSP(user);
      user.doNotifyListeners();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    Globals.getData(user);

    return ChefAppScaffold(
      title: "Notifications",
      showNotifications: true,
      showBackButton: false,
      showHomeButton: true,
      body: Container(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: user.notifications.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Widget next;
                    if (user.notifications[index].type == "NEW_ORDER") {
                      next = new UnConfirmOrders();
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (ctxt) => next));
                    } else if (user.notifications[index].type ==
                        "RIDER_ARRIVED") {
                      next = new OpenOrders();
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (ctxt) => next));
                    } else if (user.notifications[index].type ==
                        "ORDER_CANCELLED") {
                      showDialog(
                        barrierDismissible: false,
                          context: context,
                          builder: (_) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            content: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(color: Colors.white)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () => {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(),
                                            }),
                                  ),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                                      child: Text(
                                        "Order # " +
                                            user.notifications[index].entityId +
                                            " has been Cancelled.\nPlease check your email for details.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF656565)),
                                      )),
                                  Padding(padding: EdgeInsets.only(top: 20)),
                                  Center(
                                    child: RaisedButton(
                                      elevation: 0.0,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(8.0)),
                                      color: Colors.deepOrangeAccent,
                                      padding: EdgeInsets.all(5.0),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    } else if (user.notifications[index].type ==
                        "PAYMENT_MADE") {
                      next = new PaymentEarning();
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (ctxt) => next));
                    } else if (user.notifications[index].type == "NEW_RATING") {
                      next = new DishReviewAndRating();
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (ctxt) => next));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: (user.lastNotificationViewTime == null ||
                                user.lastNotificationViewTime.isBefore(
                                    user.notifications[index].getTime()))
                            ? Color(0xFFF0FAE1)
                            : Color(0xFFFFFFFF),
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Color(0xFF656565)))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: user.notifications[index]
                                .getNotificationImage(),
                        ),
                        Expanded(child: Container(
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  //padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                                  child: Text(
                                    user.notifications[index].title,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF656565)),
                                  )),
                              Container(
                                  padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                                  child: Text(
                                user.notifications[index].subtitle,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF656565)),
                              )),
                              Container(
                                child: Text(
                                  user.notifications[index].text,
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF656565)),
                                ),
                              ),
                            ],
                          ),
                        )),
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 25, 25, 15),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.access_time),
                                Text(
                                    " " +
                                        user.notifications[index]
                                            .getMinutesToNow(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6D6A6A),
                                        fontWeight: FontWeight.w500))
                              ],
                            )),
                      ],
                    ),
                  ),
                );
              })),
    );
  }

  saveToSP(user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("user", jsonEncode(user));
  }
}
