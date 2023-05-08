import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:homechefflutter/models/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/ui/DayOffDateRangePicker.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';


class KitchenHour extends StatefulWidget {
  @override
  _KitchenHourState createState() => _KitchenHourState();
}

class _KitchenHourState extends State<KitchenHour> {
  bool isChangingKitchenHours = false;
//hussain
  final dateFormat = new DateFormat('E, d MMM');

  String openStatus = "";
  bool onleave = false;
  //
  // bool vacationsInFuture = false;
  User user;
  bool popup = false;
  bool checkingVar = false;
  bool isInstructionView = true;
  var take_break_layout = true;
  var buisness_hour_layout = false;
  var kitchen_status_layout = false;
  Color break_color = Colors.white;

  Color kitchen_color = Color(0xFFF3F3F3);//transperent
  Color buisness_color = Color(0xFFF3F3F3);
  bool break_clicked = true;
  bool kitchen_clicked = false;
  bool buisness_clicked = false;
  bool tmpMonday=false;
  bool tmpTuesday=false;
  bool tmpWednesday=false;
  bool tmpThursday=false;
  bool tmpFriday=false;
  bool tmpSaturday=false;
  bool tmpSunday=false;
  int count = 0;
  var dropDownValueStart = "09 : 00 AM";
  var dropDownValueBottom = "09 : 00 PM";
  var tmpdropDownValueStart;
  var tmpdropDownValueBottom;
  var availableKitchenHoursStart = [
    "09 : 00 AM",
    "10 : 00 AM",
    "11 : 00 AM",
    "12 : 00 PM",
    "01 : 00 PM",
    "02 : 00 PM",
    "03 : 00 PM",
    "04 : 00 PM",
    "05 : 00 PM",
    "06 : 00 PM",
    "07 : 00 PM",
    "08 : 00 PM"
  ];
  var availableKitchenHoursEnd = [
    "10 : 00 AM",
    "11 : 00 AM",
    "12 : 00 PM",
    "01 : 00 PM",
    "02 : 00 PM",
    "03 : 00 PM",
    "04 : 00 PM",
    "05 : 00 PM",
    "06 : 00 PM",
    "07 : 00 PM",
    "08 : 00 PM",
    "09 : 00 PM"
  ];
  var hoursType = "custom";
  String newOffNotes;
  final offDateFormat = new DateFormat('d MMM');

  @override
  void initState() {

    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleHoursTypeRadioValueChanged(val) {
    setState(() {
      hoursType = val;
      if (val == "weekdays") {
        // user.userProfile.kitchen_hours
        //     .setHours("Monday", dropDownValueStart, dropDownValueBottom, true);
        // user.userProfile.kitchen_hours
        //     .setHours("Tuesday", dropDownValueStart, dropDownValueBottom, true);
        // user.userProfile.kitchen_hours.setHours(
        //     "Wednesday", dropDownValueStart, dropDownValueBottom, true);
        // user.userProfile.kitchen_hours.setHours(
        //     "Thursday", dropDownValueStart, dropDownValueBottom, true);
        // user.userProfile.kitchen_hours
        //     .setHours("Friday", dropDownValueStart, dropDownValueBottom, true);
        // user.userProfile.kitchen_hours.setHours(
        //     "Saturday", dropDownValueStart, dropDownValueBottom, false);
        // user.userProfile.kitchen_hours
        //     .setHours("Sunday", dropDownValueStart, dropDownValueBottom, false);
        tmpMonday = true;
        tmpTuesday = true;
        tmpWednesday = true;
        tmpThursday = true;
        tmpFriday = true;
        tmpSunday = false;
        tmpSaturday = false;
      }
      if (val == "daily") {
        // user.userProfile.kitchen_hours
        //     .setHours("Monday", dropDownValueStart, dropDownValueBottom, true);
        // user.userProfile.kitchen_hours
        //     .setHours("Tuesday", dropDownValueStart, dropDownValueBottom, true);
        // user.userProfile.kitchen_hours.setHours(
        //     "Wednesday", dropDownValueStart, dropDownValueBottom, true);
        // user.userProfile.kitchen_hours.setHours(
        //     "Thursday", dropDownValueStart, dropDownValueBottom, true);
        // user.userProfile.kitchen_hours
        //     .setHours("Friday", dropDownValueStart, dropDownValueBottom, true);
        // user.userProfile.kitchen_hours.setHours(
        //     "Saturday", dropDownValueStart, dropDownValueBottom, true);
        // user.userProfile.kitchen_hours
        //     .setHours("Sunday", dropDownValueStart, dropDownValueBottom, true);
        tmpMonday = true;
        tmpTuesday = true;
        tmpWednesday = true;
        tmpThursday = true;
        tmpFriday = true;
        tmpSunday = true;
        tmpSaturday = true;
      }
    });
  }

  void setupKitchenHours() {
    if (user.userProfile.kitchen_hours.days_off.isEmpty == false) {
      for(int i=0;i<user.userProfile.kitchen_hours.days_off.length;i++)
      {
        if (user.userProfile.kitchen_hours.days_off[i].checkingLeaves() ==
            true) {
          setState(() {
            onleave = true;
          });

          break;
        }
      }
    }
    tmpMonday = user.userProfile.kitchen_hours.hasDay("Monday");
    tmpTuesday = user.userProfile.kitchen_hours.hasDay("Tuesday");
    tmpWednesday = user.userProfile.kitchen_hours.hasDay("Wednesday");
    tmpThursday = user.userProfile.kitchen_hours.hasDay("Thursday");
    tmpFriday = user.userProfile.kitchen_hours.hasDay("Friday");
    tmpSaturday = user.userProfile.kitchen_hours.hasDay("Saturday");
    tmpSunday = user.userProfile.kitchen_hours.hasDay("Sunday");
    if(user.userProfile.kitchen_hours.schedule.isNotEmpty) {
      dropDownValueStart =
          user.userProfile.kitchen_hours.schedule[0].start_time;
      dropDownValueBottom = user.userProfile.kitchen_hours.schedule[0].end_time;
      tmpdropDownValueStart =
          user.userProfile.kitchen_hours.schedule[0].start_time;
      tmpdropDownValueBottom =
          user.userProfile.kitchen_hours.schedule[0].end_time;
    }

    if (user.userProfile.kitchen_hours.schedule.length == 7 &&
        user.userProfile.kitchen_hours.schedule[0].available == true &&
        user.userProfile.kitchen_hours.schedule[1].available == true &&
        user.userProfile.kitchen_hours.schedule[2].available == true &&
        user.userProfile.kitchen_hours.schedule[3].available == true &&
        user.userProfile.kitchen_hours.schedule[4].available == true &&
        user.userProfile.kitchen_hours.schedule[5].available == true &&
        user.userProfile.kitchen_hours.schedule[6].available == true) {
      print("length");
      hoursType = "daily";
    } else if (user.userProfile.kitchen_hours.hasDay("Monday") &&
        user.userProfile.kitchen_hours.hasDay("Tuesday") &&
        user.userProfile.kitchen_hours.hasDay("Wednesday") &&
        user.userProfile.kitchen_hours.hasDay("Thursday") &&
        user.userProfile.kitchen_hours.hasDay("Friday")) {
      print("week");
      hoursType = "weekdays";
    } else {
      print("custom");
      hoursType = "custom";
    }
    count++;
  }


//Widget to print status open close and leaves Details and checks
  Widget getNewstatus(isActive){
    if(kitchen_status_layout && !popup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {


            // if(onleave){
            //   _forcedPopup();
            //   setState(() {
            //     popup = true;
            //   });
            // }

        if (isActive) {
          if (user.userProfile.kitchen_hours.days_off.isEmpty == false) {
            for (int i = 0; i <
                user.userProfile.kitchen_hours.days_off.length; i++) {
              if (user.userProfile.kitchen_hours.days_off[i].checkingLeaves() ==
                  true) {
                _forcedPopup();
                setState(() {
                  popup = true;
                });
              }
            }
          }
        }




      });
    }
    Widget statusOnDashboard;
    if (isActive){
      statusOnDashboard = Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 8,8),
        child: RichText(
          text: TextSpan(
            text: 'Your profile is visible on HomeChef, and your dishes can be ordered.\n',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              fontFamily:'Open Sans',
              fontWeight: FontWeight.w600,
              color: Color(0xFF212529),),
            children: <TextSpan>[

              TextSpan(
                text: '\nChanging your status to Inactive would hide your profile and will prevent your dishes from being ordered until you are Active again.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  fontFamily:'Open Sans',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF656565),),
              ),
            ],
          ),textScaleFactor: 1.0,
        ),
      );

      if (user.userProfile.kitchen_hours.days_off.isEmpty == false) {
        for(int i=0;i<user.userProfile.kitchen_hours.days_off.length;i++)
        {
          if (user.userProfile.kitchen_hours.days_off[i].checkingLeaves() ==
              true) {
            setState(() {
              onleave = true;
            });

            break;
          }
        }
        if (onleave == true) {
          statusOnDashboard =
              RichText(
                text: TextSpan(
                  text: 'Your profile is visible on HomeChef, and your dishes can be ordered.\n',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontFamily:'Open Sans',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212529),),
                  children: <TextSpan>[
                    // TextSpan(
                    //   text: "currently ON LEAVE.\n",
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.w600, fontSize: 18),
                    // ),

                    TextSpan(
                      text: '\nChanging your status to Inactive would hide your profile and will prevent your dishes from being ordered until you are Active again.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        fontFamily:'Open Sans',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF656565),),
                    ),


                    // TextSpan(
                    //   text: '\n \n last date for my reference nowdishes are available for sale on HomeChef and you may receive orders to be dispatched after your vacation ends on '
                    //      +getSmallestDate(),
                    //   //+user.userProfile.kitchen_hours.days_off[0].getEndDateOfLeave()
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     fontWeight: FontWeight.w600,
                    //     color: Color(0xFF656565),),
                    // ),
                  ],
                ),textScaleFactor: 1.0,
              );

        }}
    }
    else {
      statusOnDashboard =
          RichText(
            text: TextSpan(
              text: 'Your profile is no longer visible on HomeChef, and your dishes cannot be ordered.\n',
              style: TextStyle(
                fontSize: 16,
                fontFamily:'Open Sans',
                height: 1.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212529),),
              children: <TextSpan>[
                // TextSpan(
                //   text: "CLOSED FOR BUSINESS.\n",
                //   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                // ),
                TextSpan(
                  text: '\nChange your status for foodies to see your profile and start receiving orders.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontFamily:'Open Sans',
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF656565),),
                ),
              ],
            ),textScaleFactor: 1.0,
          );
    }
    return statusOnDashboard;
  }




  // // getting end date if leave
  String getSmallestDate(){
    List <DateTime>endDate = [];
    if (user.userProfile.kitchen_hours.days_off.isEmpty == false) {
      for(int i=0;i<user.userProfile.kitchen_hours.days_off.length;i++)
      {
        if (user.userProfile.kitchen_hours.days_off[i].checkingOldVacations() ==
            true) {
          endDate.add(user.userProfile.kitchen_hours.days_off[i].getEnDate()) ;
        }
      }
    } //else return "error";
    endDate.sort();
    return dateFormat.format(endDate[0]).toString();
  }







  // Widget toShowPopupwhenChefIsOnVacation(isActive) {
  //
  //   return
  //
  //
  // }

  void _forcedPopup() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title:Text("You’re on a vacation.",
              textScaleFactor: 1.0,

              style: TextStyle(
              fontWeight: FontWeight.w600, height: 1.5,
                fontFamily:'Open Sans',fontSize: 16,color: Color(0xFF212529),
            ),),
            // insetPadding: EdgeInsets.symmetric(vertical: 70),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Foodies can schedule orders for after your vacation ends.",textScaleFactor: 1.0,
                  style: TextStyle(color: Color(0xFF656565),height: 1.5,
                      fontFamily:'Open Sans', fontSize: 14,fontWeight: FontWeight.w500),),

                Row(
                  mainAxisAlignment:MainAxisAlignment.end,
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                            top: 12, left: 10, right: 10, bottom: 10),
                        child: RaisedButton(
                          elevation: 0.0,
                          color: Color(0xFFFF872F),
                          disabledColor: Colors.black12,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0)),
                          padding: EdgeInsets.only(left: 25, right: 25),
                          onPressed: () {

                            Navigator.pop(context, true);
                            setState(() {}

                            );

                            FirebaseAnalytics().logEvent(name: 'VacationsNotification',
                                parameters: {
                                });

                          },
                          child: Text(
                            "Got it",
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 14),
                          ),)),
                  ],
                )

              ],
            )
        );
      },
    );

  }







  showAlertDialogWhenChefOnVacations(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("You’re on a vacation."),
      content: Text("This is my message."),

    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }






//Widget to print open closed or Leave below toggle
  Widget openMsg(isActive) {
    String openStatus = "";
    String msgBelow="";
    if (isActive) {
      openStatus = "ACTIVE";
      onleave = false;
      if (user.userProfile.kitchen_hours.days_off.isEmpty == false) {
        for(int i=0;i<user.userProfile.kitchen_hours.days_off.length;i++)
          {
            if (user.userProfile.kitchen_hours.days_off[i].checkingLeaves() ==
                true) {
              setState(() {
                onleave = true;
                // openStatus = "ON VACATION";
                openStatus = "ACTIVE";
                msgBelow="(on vacation)";
              });

              break;
            }
          }

      }
    }else {
      openStatus = "INACTIVE";
      msgBelow = "";
    }


    return
      // RichText(
      //   text: TextSpan(
      //     text: openStatus,
      //     style: TextStyle(
      //         fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF656565)),
      //     children: <TextSpan>[
      //
      //       TextSpan(
      //         text: msgBelow,
      //         style: TextStyle(
      //               fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF656565)),
      //         )
      //
      //
      //     ],
      //   ),
      // );
    
    Column(
      children: [
        Text(openStatus,style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF656565)),),
        Text(msgBelow,style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF656565)),)
        
      ],
      
    );



    //
    //   Text(
    //   openStatus,
    //   style: TextStyle(
    //       fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF656565)),
    // );

  }



  String toggleColor(isActive) {
    String openStatus = "";
    if (isActive) {
      openStatus = "ACTIVE";

      if (user.userProfile.kitchen_hours.days_off.isEmpty == false) {
        for(int i=0;i<user.userProfile.kitchen_hours.days_off.length;i++)
        {
          if (user.userProfile.kitchen_hours.days_off[i].checkingLeaves() ==
              true) {

              openStatus = "ON VACATION";

            break;
          }
        }

      }
    }else
      openStatus = "INACTIVE";


    return openStatus;

  }


  //Widget dataBelowToggle(isActive) {
  //   String openStatus = "";
  //   if (isActive) {
  //     if (user.userProfile.kitchen_hours.days_off.isEmpty == true) {
  //       for(int i=0;i<user.userProfile.kitchen_hours.days_off.length;i++)
  //       {
  //         if (user.userProfile.kitchen_hours.days_off[i].checkingFutureVacations() ==
  //             true) {
  //           setState(() {
  //             openStatus = "active ha buss";
  //           });
  //
  //           break;
  //         }
  //       }
  //
  //     }
  //
  //     if (user.userProfile.kitchen_hours.days_off.isEmpty == false) {
  //       for(int i=0;i<user.userProfile.kitchen_hours.days_off.length;i++)
  //       {
  //         if (user.userProfile.kitchen_hours.days_off[i].checkingLeaves() ==
  //             true) {
  //           setState(() {
  //             openStatus = "Vacation pe haio";
  //           });
  //
  //           break;
  //         }
  //       }
  //
  //     }
  //   }else
  //     openStatus = "band ha ";
  //
  //
  //   return Text(
  //     openStatus,
  //     style: TextStyle(
  //         fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF656565)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //
    //   _forcedPopup();
    //
    // });
    // _forcedPopup();
    return ChefAppScaffold(
      title: "Kitchen Hours & Status",
      showNotifications: true,
      showBackButton: false,
      showHomeButton: true,
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[



              Container(
                width: 2,
                //height: double.maxFinite,
                color: Colors.grey.shade400,
                height: 70,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      kitchen_status_layout = false;
                      take_break_layout = true;
                      buisness_hour_layout = false;
                      kitchen_color = Color(0xFFF3F3F3);
                      buisness_color = Color(0xFFF3F3F3);
                      break_color = Colors.white;
                      kitchen_clicked = false;
                      break_clicked = true;
                      buisness_clicked = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: break_clicked?BoxDecoration(border: Border(
                      bottom: BorderSide(width: 2.0, color: Color(0xFFFF872F)),
                    ),color: break_color):BoxDecoration(color: break_color),
                    child: Center(
                      child: Text(
                        "MANAGE VACATIONS",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                flex: 1,
              ),

              Container(
                width: 2,
                //height: double.maxFinite,
                color: Colors.grey.shade400,
                height: 70,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      kitchen_status_layout = false;
                      take_break_layout = false;
                      buisness_hour_layout = true;
                      kitchen_color = Color(0xFFF3F3F3);
                      buisness_color = Colors.white;
                      break_color = Color(0xFFF3F3F3);
                      kitchen_clicked = false;
                      break_clicked = false;
                      buisness_clicked = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: buisness_clicked?BoxDecoration(border: Border(
                      bottom: BorderSide
                        (width: 2.0, color: Color(0xFFFF872F)),
                    ),color: buisness_color):BoxDecoration(color: buisness_color),
                    child: Center(
                      child: Text(
                        "KITCHEN HOURS",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                flex: 1,
              ),

              Container(
                width: 2,
                //height: double.maxFinite,
                color: Colors.grey.shade400,
                height: 70,
              ),



              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {

                      kitchen_status_layout = true;
                      take_break_layout = false;
                      buisness_hour_layout = false;
                      kitchen_color = Colors.white;
                      buisness_color = Color(0xFFF3F3F3);
                      break_color = Color(0xFFF3F3F3);
                      kitchen_clicked = true;
                      break_clicked = false;
                      buisness_clicked = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: kitchen_clicked?BoxDecoration(border: Border(
                      bottom: BorderSide(width: 2.0, color: Color(0xFFFF872F)),
                    ),color: kitchen_color):BoxDecoration(color: kitchen_color),
                    child: Center(
                      child: Text(
                        "KITCHEN STATUS",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                flex: 1,
              ),

              Container(
                width: 2,
                //height: double.maxFinite,
                color: Colors.grey.shade400,
                height: 70,
              ),





            ],
          ),

          //Kitchen Status
          Visibility(

            visible: kitchen_status_layout,
            child: Container(
              child: Column(
                children: <Widget>[

                  Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        // Text(
                           //kitchenStatusText,
                        //   style: TextStyle(fontSize: 18),
                        // )

                        getNewstatus(user.userProfile.isactive),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 10, top: 15, right: 10, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Text(
                              "KITCHEN STATUS",textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF656565)),
                            ),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Transform.scale(
                                  scale: 1.4,
                                  child: user.getcheflevel()!="upforreview" && user.userProfile.profilelevel !="suspended"?Switch(
                                    activeColor: toggleColor(user.userProfile.isactive)== "ACTIVE"?Color(0xFFFF7A18):Color(0xFFFFC107),
                                    value: user.userProfile.isactive,
                                    onChanged: (bool isOn) {
                                      //CircularProgressIndicator();
                                      // SfRadialGauge();
                                      //CircularProgressIndicator();
                                      print("Doing " + isOn.toString());
                                      setState(() {
                                        if (isOn) {
                                          FirebaseAnalytics().logEvent(name: 'Toggle',parameters: {'Category':'Toggle','Action':"Kitchen Status",'Label':"Open"});
                                          // user.userProfile.isactive = isOn;
                                          // kitchenStatusText = kitchenStatusTextOpen;
                                          // saveKitchenStatus(user);

                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  OpenKitchenConfirmationDialog());
                                        } else {
                                          showDialog(
                                              context: context,

                                              builder: (_) =>
                                                  CloseKitchenConfirmationDialog());
                                        }
                                      });
                                    },
                                  ):Container()
                                ),
                                openMsg(user.userProfile.isactive),
                              ],
                            ),
                          ),
                          flex: 2,
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),

                  Container(
                    // LEAVES WORK LEAVES WORK
                    //date now formatted
                    //child: Text(offDateFormat.format(starty)),
                    child: Column(
                      children: [
                        user.userProfile.isactive == true && kitOnFutureVacation()== false && !onleave ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18, 24, 18,8),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Take a vacation instead?\n\n',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                    fontFamily:'Open Sans',
                                    color: Color(0xFF212529),),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Keep your profile visible and have new orders ready for when you get back.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 1.5,

                                        fontFamily:'Open Sans',
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF656565),),
                                    ),


                                  ],
                                ),textScaleFactor: 1.0,
                              ),
                            ),





                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                                  child: Container(
                                      // margin: EdgeInsets.only(top: 12),
                                      child: RaisedButton(
                                        elevation: 0.0,
                                        color: Color(0xFFFF872F),
                                        disabledColor: Colors.black12,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(4.0)),
                                        padding: EdgeInsets.only(left: 35, right: 35),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (ctxt) => new KitchenHour()));


                                          FirebaseAnalytics().logEvent(name: 'KSManageVacations',
                                              parameters: {
                                              });


                                        },
                                        child: Text(

                                          "Manage Vacations",
                                          textScaleFactor: 1.0,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            //color: Colors.white,
                                            fontWeight:FontWeight.w600,
                                              color: Colors.white,
                                              fontFamily:'Open Sans',
                                              fontSize: 14,
                                          ),
                                        ),
                                      )),
                                ),



                              ],
                            )
                          ],
                    ):Container(),






                        // Text(formatted),
                        // Text(user.userProfile.kitchen_hours.days_off[0].getStartDateof()),
                        // Text(user.userProfile.kitchen_hours.days_off[0].checkingLeaves() == true ?
                        // "inleaves" :  "noo Leaves"),

                        // user.userProfile.isactive ? Container(
                        //
                        //   child:
                        //     Column(
                        //       children: <Widget>[
                        //         Text("Your have scheduled leaves for future"),
                        //
                        //
                        //         Padding(
                        //           padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                        //           child: Text("To Manage your vacations, ",
                        //               style:TextStyle(
                        //                   fontSize: 18,
                        //                   fontWeight:FontWeight.w600,
                        //                   color: Color(0xFF656565)
                        //
                        //               )),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        //           child: InkWell(
                        //             child: Text("Tap here",
                        //                 style:TextStyle(
                        //                     decoration: TextDecoration.underline,
                        //                     fontSize: 18,
                        //                     fontWeight:FontWeight.w600,
                        //                     color: Color(0xFFFF7A18)
                        //                 )
                        //             ),
                        //             onTap: (){
                        //               // //Navigator.pop(context),
                        //               // Navigator.push(
                        //               // context,
                        //               // new MaterialPageRoute(
                        //               // builder: (ctxt) => new KitchenHour()));
                        //
                        //               setState(() {
                        //                 kitchen_status_layout = false;
                        //                 take_break_layout = true;
                        //                 buisness_hour_layout = false;
                        //                 kitchen_color = Colors.transparent;
                        //                 buisness_color = Colors.transparent;
                        //                 break_color = Colors.white;//black12
                        //               });
                        //
                        //
                        //
                        //
                        //             },
                        //           ),
                        //         )
                        //
                        //
                        //
                        //       ],
                        //     )
                        // ):


                        //isActive == true ? Container():

         //Commenting working code

                        user.userProfile.kitchen_hours.days_off.isEmpty?Container():
                        user.userProfile.isactive == false? Container():
                        onleave ? Container(
                            child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                                  child: Text("You’re on vacation until "+getSmallestDate()+".\n ",
                                    textScaleFactor: 1.0,
                                      style:TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                          fontWeight:FontWeight.w600,
                                          color: Color(0xFF212529)

                                      ),),
                                ),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  child: Text("Foodies can schedule orders for after "+getSmallestDate()+". Manage your vacation to change your vacation days.",
                                    textScaleFactor: 1.0,
                                    style:TextStyle(
                                        fontSize: 14,
                                        height: 1.5,

                                        fontFamily:'Open Sans',
                                        fontWeight:FontWeight.w500,
                                        color: Color(0xFF656565),

                                    ),),
                                ),


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Container(
                                          margin: EdgeInsets.only(top: 16, right: 4),
                                          child: RaisedButton(
                                            elevation: 0.0,
                                            color: Color(0xFFFF872F),
                                            disabledColor: Colors.black12,
                                            shape: new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(4.0)),
                                            padding: EdgeInsets.only(left: 35, right: 35),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (ctxt) => new KitchenHour()));


                                              FirebaseAnalytics().logEvent(name: 'KSManageVacations',
                                                  parameters: {
                                                  });


                                            },
                                            child: Text(
                                              "Manage Vacations",
                                              textScaleFactor: 1.0,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                //color: Colors.white,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            ),
                                          )),
                                    ),



                                  ],
                                )

                              ],
                            )
                        )
//commenting working code up
                        //    :
                        //     user.userProfile.isactive ?
                        // Container(
                        //     child:
                        //       Column(
                        //         children: <Widget>[
                        //           Text("Your have scheduled leaves for future"),
                        //
                        //
                        //           Padding(
                        //             padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                        //             child: Text("To Manage your vacations, ",
                        //                 style:TextStyle(
                        //                     fontSize: 18,
                        //                     fontWeight:FontWeight.w600,
                        //                     color: Color(0xFF656565)
                        //
                        //                 )),
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        //             child: InkWell(
                        //               child: Text("Tap here",
                        //                   style:TextStyle(
                        //                       decoration: TextDecoration.underline,
                        //                       fontSize: 18,
                        //                       fontWeight:FontWeight.w600,
                        //                       color: Color(0xFFFF7A18)
                        //                   )
                        //               ),
                        //               onTap: (){
                        //                 // //Navigator.pop(context),
                        //                 // Navigator.push(
                        //                 // context,
                        //                 // new MaterialPageRoute(
                        //                 // builder: (ctxt) => new KitchenHour()));
                        //
                        //                 setState(() {
                        //                   kitchen_status_layout = false;
                        //                   take_break_layout = true;
                        //                   buisness_hour_layout = false;
                        //                   kitchen_color = Colors.transparent;
                        //                   buisness_color = Colors.transparent;
                        //                   break_color = Colors.white;//black12
                        //                 });
                        //
                        //
                        //
                        //
                        //               },
                        //             ),
                        //           )
                        // ]))
//commenting working code down
                                :


                        Container(

                        //child: Text(kitOnFutureVacation()== true ? "activ ha futer vacation ha ":"no idea ")
                        child: kitOnFutureVacation()? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                            //   child: Text("You have scheduled vacations for future."),
                            // ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'You have scheduled a Vacation.  \n',

                                      style: TextStyle(

                                        fontSize: 14,
                                        height: 1.5,
                                        // fontFamily:'Open Sans',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF656565),),
                                      children: <TextSpan>[

                                        TextSpan(
                                          text: 'To see details, manage your Vacations.                 ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            height: 1.5,
                                            fontFamily:'Open Sans',
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF656565),),
                                        ),


                                      ],
                                    ),textScaleFactor: 1.0,
                                  ),
                                ),




                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 5, 16, 0),
                                      child: Container(
                                          margin: EdgeInsets.only(top: 12),
                                          child: RaisedButton(
                                            elevation: 0.0,
                                            color: Color(0xFFFF872F),
                                            disabledColor: Colors.black12,
                                            shape: new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(4.0)),
                                            padding: EdgeInsets.only(left: 35, right: 35),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (ctxt) => new KitchenHour()));


                                              FirebaseAnalytics().logEvent(name: 'KSManageVacations',
                                                  parameters: {
                                                  });


                                            },
                                            child: Text(
                                              "Manage Vacations",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                //color: Colors.white,
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          )),
                                    ),



                                  ],
                                )
                              ],
                            ),


                          ],

                        ):Row(),
                        )
//cmmenting working code


                        //dataBelowToggle(user.userProfile.isactive),



                      ],
                    ),

                  ),
                ],
              ),
            ),

          ),

          //MANAGE LEAVES LAYOUT
          Visibility(
              visible: take_break_layout,
              child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(

                         // "If you need a leave or are planning a vacation, add your days off here so you don't get orders to be dispatched during those days.",
                         'Need time off? Add your "Vacations" here, so you don'+"'t get orders for delivery on those days. You will still be getting orders for before and after your days off.",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontFamily:'Open Sans',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF212529),
                            // Color(0xFF656565),
                            //color: Color(0xFF656565)
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(5.0),
                            color: Color(0xFFFF872F),
                            child: MaterialButton(
                              // minWidth: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(left: 35, right: 35),
                              onPressed: () {
                                FirebaseAnalytics().logEvent(name: 'AddVacationsClick',
                                    parameters: {
                                    });
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (_) => DayOffDateRangePicker());
                              },
                              child: Text(
                                " Add Days Off",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: 25),
                          child: Text(
                            "Scheduled Vacations",textScaleFactor: 1.0,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              //Color(0xFF656565)
                            ),
                          ),
                        ),

                        Padding(padding: EdgeInsets.only(bottom: 15.0)),

                        user.userProfile.kitchen_hours.days_off.length == 0 ?
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(

                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Color(0xFFc4c4c4)),
                              color: Color(0xFFF1F1F1),),

                            child: Text("You do not have any scheduled vacations yet.",
                              textScaleFactor: 1.0,
                              style: TextStyle(fontSize: 16,height: 1.5),),
                          ),
                        ):
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                              user.userProfile.kitchen_hours.days_off.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border:
                                        Border.all(color: Color(0xFFc4c4c4)),
                                        color: Color(0xFFF1F1F1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[


                                                  //Flexible(child:
                                                  Text(
                                                    user.userProfile.kitchen_hours
                                                        .days_off[index]
                                                        .getDisplayString(),textScaleFactor: 1.0,
                                                    //maxLines: 2,
                                                    style: TextStyle(
                                                      height: 1.5,
                                                        fontSize: 16,
                                                        color: Color(0xFF6C6B6B)),
                                                  ),


                                                  //Text("${Icons.arrow_back}"),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[


                                                      Image.asset(
                                                        user.userProfile.kitchen_hours.days_off[index].notes == ""?"images/blankicon.png":'images/arrowrightdown.png',
                                                        width: 20.0,
                                                        height: 20.0,
                                                        fit: BoxFit.cover,
                                                      ),

                                                      Flexible(
                                                        child: Padding(
                                                          padding: const EdgeInsets.fromLTRB(0,0,2,0),
                                                          child: Text(
                                                            user.userProfile.kitchen_hours.days_off[index].notes == null?
                                                            "" : user.userProfile.kitchen_hours.days_off[index].notes,textScaleFactor: 1.0,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                height:1.5,
                                                                color: Color(0xFF6C6B6B)),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )),
                                          (user.userProfile.kitchen_hours
                                              .days_off[index]
                                              .getStartDate()
                                              .isBefore(DateTime.now()))
                                              ? SizedBox.shrink()
                                              : MaterialButton(
                                            color: Color(0xFFEA1717),
                                            onPressed: () {
                                              // user.userProfile.kitchen_hours
                                              //     .days_off
                                              //     .removeAt(index);
                                              // postKitchenHours(
                                              //     user, "remove");
                                              // user.doNotifyListeners();

                                              FirebaseAnalytics().logEvent(name:'RemoveVacationClicks',
                                                  parameters: {
                                                    // 'Parameter':'Fail',
                                                  });

                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (_) => showAlertDialogforDaysOff(context,index)
                                              );
                                            },
                                            child: Text("Remove",textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    color: Colors.white,height: 1.5, fontWeight:FontWeight.w600,fontSize: 14 )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ))



          ),


          getKitchenHourLayout()
        ],
      ),
    );
  }

  bool kitOnFutureVacation(){
      if (user.userProfile.kitchen_hours.days_off.isEmpty == false) {
        for(int i=0;i<user.userProfile.kitchen_hours.days_off.length;i++)
        {
          if (user.userProfile.kitchen_hours.days_off[i].checkingFutureVacations() ==
              true) {
              return true;
          }
   break;
  }
  }
    return false;
  }

//alert for remove days Off
  Widget showAlertDialogforDaysOff(context,index){
    Map dates = user.userProfile.kitchen_hours
        .days_off[index].toJson();

    DateTime startD = DateTime.parse(dates['start_date']);
    DateTime endD = DateTime.parse(dates['end_date']);

    return AlertDialog(
      content: Column(

        mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: <Widget>[
          // Align(
          //   alignment: Alignment.topRight,
          //   child: IconButton(
          //       icon: Icon(Icons.close),
          //       onPressed: () => {
          //         Navigator.pop(context, true)
          //
          //       }),
          // ),

          Align(
              alignment: Alignment.center,
              child:
              Text(
                  "Are you sure you want to remove your scheduled vacation?",
                  textScaleFactor: 1.0,
                  textAlign:TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color:Color(0xFF656565),
                  ))),

          Padding(padding: EdgeInsets.only(bottom: 15.0)),
          //padding: EdgeInsets.only(top: 15),
          RichText(
            textAlign:TextAlign.center,
            text: TextSpan(
              text: 'From ',
              style:TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontFamily:'Open Sans',
                  fontWeight: FontWeight.w600,
                  color:Color(0xFF656565)
              ),
              children: <TextSpan>[
                TextSpan(text: dateFormat.format(startD).toString(),style: TextStyle(color: Color(0xFF212529),fontFamily:'Open Sans', height: 1.5,decoration: TextDecoration.underline,fontWeight: FontWeight.bold)),
                TextSpan(text: ' to ',style:TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    fontFamily:'Open Sans',
                    color:Color(0xFF656565)
                )),
                TextSpan(text: dateFormat.format(endD).toString(),style: TextStyle(color: Color(0xFF212529), height: 1.5,
                    fontFamily:'Open Sans', decoration: TextDecoration.underline,fontWeight: FontWeight.bold)),
              ],
            ),textScaleFactor: 1.0,
          ),
          Container(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 12, bottom: 10),
                    child: RaisedButton(
                      elevation: 0.0,
                      color: Colors.white,
                      //color: Colors.black38,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black)),
                      disabledColor: Colors.black,
                      //Colors.black12,
                      padding: EdgeInsets.only(left: 35, right: 35),
                      onPressed: () {
                        Navigator.pop(context, true);
                        setState(() {});
                        FirebaseAnalytics().logEvent(name:'RemoveVacations',
                            parameters: {
                              'Parameter':'remove_no',
                            });
                      },
                      child: Text(
                        "No",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          top: 12, left: 10, right: 10, bottom: 10),
                      child: RaisedButton(
                        elevation: 0.0,
                        color: Color(0xFFFF872F),
                        disabledColor: Colors.black12,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        padding: EdgeInsets.only(left: 35, right: 35),
                        onPressed: () {
                          user.userProfile.kitchen_hours
                              .days_off
                              .removeAt(index);
                          postKitchenHours(
                              user, "remove");
                          user.doNotifyListeners();
                          Navigator.pop(context, true);
                          setState(() {});


                          FirebaseAnalytics().logEvent(name:'RemoveVacations',
                              parameters: {
                                'Parameter':'remove_yes',
                              });
                        },
                        child: Text(
                          "Yes",
                          textAlign: TextAlign.center,
                          style: TextStyle(

                              color: Colors.white,
                              fontSize: 16),
                        ),)),
                ],
              ))
        ],
      ),);
  }


  void saveKitchenHours(user) async {
    for (int a = 0; a < user.userProfile.kitchen_hours.schedule.length; a++) {
      user.userProfile.kitchen_hours.schedule[a].start_time =
          dropDownValueStart;
      user.userProfile.kitchen_hours.schedule[a].end_time = dropDownValueBottom;
    }
    postKitchenHours(user, "hours");
  }

  void postKitchenHours(user, istype) async {
    Map data = {
      'chefId': user.uid,
      'kitchen_hours': user.userProfile.kitchen_hours,
      'istype': istype
    };
    var body = json.encode(data);
    print(body);
    var response = await http.post(Uri.parse(
        Globals.BASE_URL + "api/chefapp/v1/kitchen_hours"),
        headers: {"Content-Type": "application/json"},
        body: body);
    print(response.body);
    if (response.statusCode == 200) {
      user.doNotifyListeners();
      Globals.showToast("Changes have been saved");
    } else {}
  }

  Widget getKitchenHourLayout() {
    //print("in function");
    if(isChangingKitchenHours == false) {
      //print("changing");





      // Kitchen hours Layout

      return Visibility(
        visible: buisness_hour_layout,
        child: Container(
          margin: EdgeInsets.all(20),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your current kitchen hours and operating days are as follows: ",
                textScaleFactor: 1.0,
                style: TextStyle(
                    // fontSize: 15, fontWeight:FontWeight.w600,color: Color(0xFF656565)),
                  fontSize: 16,
                  height: 1.5,
                  fontFamily:'Open Sans',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212529),)
              ),
              Padding(
                  padding: EdgeInsets.only(top:20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Kitchen Timings:",textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600,
                          color:Color(0xFF212529)
                          // Color(0xFF656565)
                      )),
                  Material(
                    borderRadius: BorderRadius.circular(3.0),
                    child: MaterialButton(
                      disabledColor: Color(0xFFADAAA7),
                      color: Color(0xFFFF7A18),
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      onPressed: () {
                        setState(() {
                          setupKitchenHours();
                          isChangingKitchenHours = true;
                        });

                        FirebaseAnalytics().logEvent(name:'KitchenTimingsChange',
                            parameters: {
                              // 'Parameter':'remove_no',
                            });


                      },
                      child: Text("Change",textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w600)),
                    ),
                  ),

                ],
              ),

              Padding(
                  padding: EdgeInsets.only(top:7)),

              Row(
                children: [
                  Text(
                      "From: "+(user.userProfile.kitchen_hours.schedule.isEmpty == true  ? ("09 : 00 AM") : user.userProfile.kitchen_hours.schedule[0].start_time ),textScaleFactor: 1.0,
                          // +user.userProfile.kitchen_hours.schedule[0].start_time,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal,color:Color(0xFF656565))),

                  Text(
                    // Provider.of<StringProvider>(context, listen: true).getOffStart.toString() ?? "Not Set",
                      " To "+( user.userProfile.kitchen_hours.schedule.isEmpty == true ? "09 : 00 PM":user.userProfile.kitchen_hours.schedule[0].end_time),textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal,color:Color(0xFF656565))),
                ],
              ),


              Padding(
                  padding: EdgeInsets.only(top:25)
              ),

              Text("Kitchen Open Days:",textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600,color:Color(0xFF212529))),

              Padding(
                  padding: EdgeInsets.only(top:18)),

              //Days Lay out
              Row(
                mainAxisAlignment: MainAxisAlignment.start,

                children: <Widget>[

                  // Expanded(
                  //     child: CheckboxListTile(
                  //         contentPadding: EdgeInsets.all(0),
                  //         value: user.userProfile.kitchen_hours
                  //             .hasDay("Monday"),
                  //         controlAffinity:
                  //         ListTileControlAffinity.leading,
                  //         title: Text("Mon",
                  //             style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565)))
                  //     )
                  // ),

                  //Text( user.userProfile.kitchen_hours.hasDay("Monday")  ? "yes":"no"),
                  Padding(padding: EdgeInsets.only(left:15)),

                  Image.asset( user.userProfile.kitchen_hours.hasDay("Monday") ? "images/tick.png":"images/x.png" , height: 18, width:18,),
                  Text(" Mon",textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565))
                  ),


                  Padding(padding: EdgeInsets.only(left:45)),


                  Image.asset( user.userProfile.kitchen_hours.hasDay("Tuesday") ? "images/tick.png":"images/x.png" , height: 18, width:18,),
                  Text(" Tue",textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565))
                  ),

                  Padding(padding: EdgeInsets.only(left:45)),

                  Image.asset( user.userProfile.kitchen_hours.hasDay("Wednesday") ? "images/tick.png":"images/x.png" , height: 18, width:18,),
                  Text(" Wed",textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565))
                  ),
                  Padding(padding: EdgeInsets.only(bottom:45)),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left:15)),

                  Image.asset( user.userProfile.kitchen_hours.hasDay("Thursday") ? "images/tick.png":"images/x.png" , height: 18, width:18,),
                  Text(" Thur",textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565))
                  ),

                  Padding(padding: EdgeInsets.only(left:45)),

                  Image.asset( user.userProfile.kitchen_hours.hasDay("Friday") ? "images/tick.png":"images/x.png" , height: 18, width:18,),
                  Text(" Fri",textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565))
                  ),

                  Padding(padding: EdgeInsets.only(left:45)),


                  Image.asset( user.userProfile.kitchen_hours.hasDay("Saturday") ? "images/tick.png":"images/x.png" , height: 18, width:18,),
                  Text(" Sat",textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565))
                  ),
                  Padding(padding: EdgeInsets.only(bottom:45)),

                ],
              ),

              Row(
                //mainAxisSize:MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left:15,top:45)),

                  Image.asset( user.userProfile.kitchen_hours.hasDay("Sunday") ? "images/tick.png":"images/x.png" , height: 18, width:18,),
                  Text(" Sun",textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565))
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    else {
      print("false");
      return Visibility(
          visible: buisness_hour_layout,
          child: Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment.topLeft,
            child: Column(
              children: <Widget>[

                Text("Set the days and hours your kitchen is open and meals can be picked up from you",textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600,height:1.5,color:Color(0xFF656565))
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: RadioListTile(

                      value: "daily",
                      groupValue: hoursType,
                      onChanged: _handleHoursTypeRadioValueChanged,
                      title: Text(
                        " Every day (7 days a week)",textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 15,height: 1.5, fontWeight: FontWeight.w600,color:Color(0xFF656565)),
                      )),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26),
                          //color: Colors.deepOrangeAccent,
                        ),
                        child: DropdownButton<String>(
                          value: dropDownValueStart,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (hoursType != "daily")
                              ? null
                              : (String newValue) {
                            setState(() {
                              dropDownValueStart = newValue;
                            });
                          },
                          isExpanded: true,
                          items: availableKitchenHoursStart
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,textScaleFactor: 1.0,),
                                );
                              }).toList(),
                        ),
                      ),
                      flex: 2,
                    ),
                    Text("TO",textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 15,height: 1.5, fontWeight: FontWeight.w500,color:Color(0xFF656565))),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26),
                          //color: Colors.deepOrangeAccent,
                        ),
                        child: DropdownButton<String>(
                          value: dropDownValueBottom,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (hoursType != "daily")
                              ? null
                              : (String newValue) {
                            setState(() {
                              dropDownValueBottom = newValue;
                            });
                          },
                          isExpanded: true,
                          items: availableKitchenHoursEnd
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,textScaleFactor: 1.0,),
                                );
                              }).toList(),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: RadioListTile(
                      value: "weekdays",
                      groupValue: hoursType,
                      onChanged: _handleHoursTypeRadioValueChanged,
                      title: Text(
                        "Weekdays ( Mon - Fri)",textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 15,height:1.5, fontWeight: FontWeight.w600,color:Color(0xFF656565)),
                      )),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26),
                          //color: Colors.deepOrangeAccent,
                        ),
                        child: DropdownButton<String>(
                          value: dropDownValueStart,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (hoursType != "weekdays")
                              ? null
                              : (String newValue) {
                            setState(() {
                              dropDownValueStart = newValue;
                            });
                          },
                          isExpanded: true,
                          items: availableKitchenHoursStart
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,textScaleFactor: 1.0,),
                                );
                              }).toList(),
                        ),
                      ),
                      flex: 2,
                    ),
                    Text("TO",textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500,color:Color(0xFF656565))
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26),
                          //color: Colors.deepOrangeAccent,
                        ),
                        child: DropdownButton<String>(
                          value: dropDownValueBottom,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (hoursType != "weekdays")
                              ? null
                              : (String newValue) {
                            setState(() {
                              dropDownValueBottom = newValue;
                            });
                          },
                          isExpanded: true,
                          items: availableKitchenHoursEnd
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,textScaleFactor: 1.0,),
                                );
                              }).toList(),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: RadioListTile(
                      value: "custom",
                      groupValue: hoursType,
                      onChanged: _handleHoursTypeRadioValueChanged,
                      title: Text(
                        "Custom",textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600,color:Color(0xFF656565)),
                      )),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26),
                          //color: Colors.deepOrangeAccent,
                        ),
                        child: DropdownButton<String>(
                          value: dropDownValueStart,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (hoursType != "custom")
                              ? null
                              : (String newValue) {
                            setState(() {
                              print(newValue);
                              dropDownValueStart = newValue;
                            });
                          },
                          isExpanded: true,
                          items: availableKitchenHoursStart
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,textScaleFactor: 1.0,),
                                );
                              }).toList(),
                        ),
                      ),
                      flex: 2,
                    ),
                    Text("TO" ,textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500,color:Color(0xFF656565))),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26),
                          //color: Colors.deepOrangeAccent,
                        ),
                        child: DropdownButton<String>(
                          value:
                          dropDownValueBottom,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (hoursType != "custom")
                              ? null
                              : (String newValue) {
                            setState(() {
                              dropDownValueBottom = newValue;
                            });
                          },
                          isExpanded: true,
                          items: availableKitchenHoursEnd
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,textScaleFactor: 1.0,),
                                );
                              }).toList(),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),



                //
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   mainAxisSize: MainAxisSize.min,
                //   children: <Widget>[
                //     Expanded(
                //       child: CheckboxListTile(
                //         value: tmpMonday,
                //         onChanged: (bool value) {
                //           setState(() {
                //             tmpMonday = value;
                //           });
                //         },
                //       ),
                //     )
                //
                //
                //
                //
                //   ],
                // ),
                //
                //



                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[


                      Expanded(
                        child:
                        CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            value: tmpMonday,
                            controlAffinity:
                            ListTileControlAffinity.leading,
                            onChanged: (hoursType != "custom")
                                ? null
                                : (val) {
                              setState(() {
                                tmpMonday = val;
                              });
                            },
                            title: Text(" Mon",textScaleFactor: 1.0,
                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565))
                            ),

                        )),


                        //
                        // FlatButton(
                        //   // here toggle the bool value so that when you click
                        //   // on the whole item, it will reflect changes in Checkbox
                        //     onPressed:
                        //       (hoursType != "custom")
                        //           ? null
                        //           : (val) {
                        //         setState(() {
                        //           tmpMonday = val;
                        //
                        //         });
                        //       }
                        //
                        //
                        //     }),
                        //      Row(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         children: [
                        //           SizedBox(
                        //               height: 24.0,
                        //               width: 24.0,
                        //               child: Checkbox(
                        //                   value: tmpMonday,
                        //                   onChanged: (value){
                        //                     setState(() => tmpMonday = value);
                        //                   }
                        //               )
                        //           ),
                        //           // You can play with the width to adjust your
                        //           // desired spacing
                        //           SizedBox(width: 10.0),
                        //           Text("Monday")
                        //         ]
                        //     )
                        // )



                      // ),


                    Expanded(
                        child: CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            // value: user.userProfile.kitchen_hours
                            //     .hasDay("Tuesday"),
                            value: tmpTuesday,
                            controlAffinity:
                            ListTileControlAffinity.leading,
                            onChanged: (hoursType != "custom")
                                ? null
                                : (val) {
                              setState(() {
                                // user.userProfile.kitchen_hours
                                //     .setHours(
                                //     "Tuesday",
                                //     dropDownValueStart,
                                //     dropDownValueBottom,
                                //     val);
                                tmpTuesday = val;
                              });
                            },
                          title:Text("Tue",textScaleFactor: 1.0,
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565))
                          ),

                      )),


                    Expanded(
                        child: CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            // value: user.userProfile.kitchen_hours
                            //     .hasDay("Wednesday"),
                            value: tmpWednesday,
                            controlAffinity:
                            ListTileControlAffinity.leading,
                            onChanged: (hoursType != "custom")
                                ? null
                                : (val) {
                              setState(() {
                                // user.userProfile.kitchen_hours
                                //     .setHours(
                                //     "Wednesday",
                                //     dropDownValueStart,
                                //     dropDownValueBottom,
                                //     val);
                                tmpWednesday = val;
                              });
                            },
                            title: Text("Wed",textScaleFactor: 1.0,
                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565))
                            ),)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Expanded(
                        child: CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            // value: user.userProfile.kitchen_hours
                            //     .hasDay("Thursday"),
                            value: tmpThursday,
                            controlAffinity:
                            ListTileControlAffinity.leading,
                            onChanged: (hoursType != "custom")
                                ? null
                                : (val) {
                              setState(() {
                                // user.userProfile.kitchen_hours
                                //     .setHours(
                                //     "Thursday",
                                //     dropDownValueStart,
                                //     dropDownValueBottom,
                                //     val);
                                tmpThursday = val;
                              });
                            },
                            title: Text("Thur",textScaleFactor: 1.0,
                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565))
                            ),)),


                    Expanded(
                        child:
                        CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            // value: user.userProfile.kitchen_hours
                            //     .hasDay("Friday"),
                            value: tmpFriday,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (hoursType != "custom")
                                ? null
                                : (val) {
                              setState(() {
                                // user.userProfile.kitchen_hours.setHours(
                                //     "Friday",
                                //     dropDownValueStart,
                                //     dropDownValueBottom,
                                //     val);
                                tmpFriday = val;
                                print(user.userProfile.kitchen_hours
                                    .toJson());
                              });
                            },
                            title: Text("Fri",textScaleFactor: 1.0,
                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565))
                            ),)
                    ),
                    Expanded(
                        child: CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            // value: user.userProfile.kitchen_hours
                            //     .hasDay("Saturday"),
                            value: tmpSaturday,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (hoursType != "custom")
                                ? null
                                : (val) {
                              setState(() {
                                // user.userProfile.kitchen_hours.setHours(
                                //     "Saturday",
                                //     dropDownValueStart,
                                //     dropDownValueBottom,
                                //     val);
                                tmpSaturday = val;
                              });
                            },
                            title:Text("Sat",textScaleFactor: 1.0,
                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565))
                            ),))


                  ],
                ),

                Row(
                  //mainAxisSize:MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            // value: user.userProfile.kitchen_hours
                            //     .hasDay("Sunday"),
                            value: tmpSunday,
                            controlAffinity:
                            ListTileControlAffinity.leading,
                            onChanged:

                            (hoursType != "custom")
                                ? null
                                : (val) {
                              // (checkingVar==true)? setState((){}) :
                              setState(() {
                                //bug. save temporarily, only store when save button clicked
                                //print("i m in");
                                // user.userProfile.kitchen_hours
                                //     .setHours(
                                //     "Sunday",
                                //     dropDownValueStart,
                                //     dropDownValueBottom,
                                //     val);
                                tmpSunday = val;
                              });
                            },
                            title:
                            Text("Sun",textScaleFactor: 1.0,
                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color:Color(0xFF656565))
                            ),
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    //Cancel button
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          setupKitchenHours();
                          isChangingKitchenHours = false;

                        });
                      },
                      child: Text('Cancel',textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600
                          )
                      ),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid
                          ), borderRadius: BorderRadius.circular(5)),
                    ),

                    Padding(
                        padding: EdgeInsets.only(left:5,right: 5)

                    ),
                    Material(
                      borderRadius: BorderRadius.circular(5.0),
                      child: MaterialButton(
                        disabledColor: Color(0xFFADAAA7),
                        color: Color(0xFFFF7A18),
                        padding: EdgeInsets.all(5.0),
                        onPressed: ()
                        // {
                        //
                        //   FirebaseAnalytics().logEvent(name: 'Button',
                        //       parameters: {
                        //         'Category': 'Button',
                        //         'Action': 'Business Hours',
                        //         'Label': hoursType
                        //       });
                        //   saveKitchenHours(user);
                        //   setState(() {
                        //     //layout status set to false
                        //     isChangingKitchenHours = false;
                        //   });
                        // },



                        {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) =>saveDaysConfirmationDialog(context)
                          );
                        },


                        child: Text("Save",textScaleFactor: 1.0,

                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w600)),
                      ),
                    )
                  ],)
              ],
            ),
          ));
    }
  }


  Widget saveDaysConfirmationDialog(context){
    return AlertDialog(
      // backgroundColor: Colors.purple,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: IconButton(
          //       icon: Icon(Icons.close),
          //       onPressed: () => {
          //         Navigator.of(context, rootNavigator: true).pop(),
          //       }),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Text(
                "Are you sure you want to change your kitchen hours ?",textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: 16,height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF656565),
                  //Color(0xFF656565)
                ),textAlign: TextAlign.center,),
          ),
          // Container(
          //     padding: EdgeInsets.only(top: 8),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Container(
          //           margin: EdgeInsets.only(top: 12, bottom: 10),
          //
          //           child: RaisedButton(
          //             elevation: 0.0,
          //             color: Colors.white,
          //             //color: Colors.black38,
          //             shape: new RoundedRectangleBorder(
          //                 borderRadius: new BorderRadius.circular(4.0),
          //                 side: BorderSide(color: Colors.black)),
          //
          //             disabledColor: Colors.black,
          //             //Colors.black12,
          //             padding: EdgeInsets.only(left: 35, right: 35),
          //             onPressed: () {
          //               // FirebaseAnalytics().logEvent(name: 'Button',
          //               //     parameters: {
          //               //       'Category': 'Button',
          //               //       'Action': 'Business Hours',
          //               //       'Label': hoursType
          //               //     });
          //               // saveKitchenHours(user);
          //               Navigator.pop(context, true);
          //               setState(() {
          //                 //layout status set to false
          //                 checkingVar=true;
          //                 //isChangingKitchenHours = false;
          //               });
          //
          //             },
          //             child: Text(
          //               "No",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(color: Colors.black, fontSize: 16),
          //             ),
          //           ),
          //         ),
          //         Container(
          //             margin: EdgeInsets.only(
          //                 top: 12, left: 10, right: 10, bottom: 10),
          //             child: RaisedButton(
          //               elevation: 0.0,
          //               color: Color(0xFFFF872F),
          //               disabledColor: Colors.black12,
          //               shape: new RoundedRectangleBorder(
          //                   borderRadius: new BorderRadius.circular(4.0)),
          //               padding: EdgeInsets.only(left: 35, right: 35),
          //               onPressed: () {
          //                 setState(() {
          //
          //                     user.userProfile.kitchen_hours.setHours(
          //                         "Monday", dropDownValueStart,
          //                         dropDownValueBottom, tmpMonday);
          //                     user.userProfile.kitchen_hours.setHours(
          //                         "Tuesday", dropDownValueStart,
          //                         dropDownValueBottom, tmpTuesday);
          //                     user.userProfile.kitchen_hours.setHours(
          //                         "Wednesday", dropDownValueStart,
          //                         dropDownValueBottom, tmpWednesday);
          //                     user.userProfile.kitchen_hours.setHours(
          //                         "Thursday", dropDownValueStart,
          //                         dropDownValueBottom, tmpThursday);
          //                     user.userProfile.kitchen_hours.setHours(
          //                         "Friday", dropDownValueStart,
          //                         dropDownValueBottom, tmpFriday);
          //                     user.userProfile.kitchen_hours.setHours(
          //                         "Saturday", dropDownValueStart,
          //                         dropDownValueBottom, tmpSaturday);
          //                     user.userProfile.kitchen_hours.setHours(
          //                         "Sunday", dropDownValueStart,
          //                         dropDownValueBottom, tmpSunday);
          //
          //                 });
          //
          //
          //
          //
          //
          //                 FirebaseAnalytics().logEvent(name: 'Button',
          //                     parameters: {
          //                       'Category': 'Button',
          //                       'Action': 'Business Hours',
          //                       'Label': hoursType
          //                     });
          //                 saveKitchenHours(user);
          //                 Navigator.pop(context, true);
          //
          //                 ////
          //
          //
          //                 ////
          //                 setState(() {
          //                   //layout status set to false
          //
          //                   isChangingKitchenHours = false;
          //                 });
          //
          //
          //
          //
          //               },
          //               child: Text(
          //                 "Yes",
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                   //color: Colors.white,
          //                     color: Colors.white,
          //                     fontSize: 16),
          //               ),
          //             )),
          //       ],
          //     ))

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 10,right: 7),
                child: RaisedButton(
                  elevation: 0.0,
                  color: Colors.white,
                  //color: Colors.black38,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(4.0),
                      side: BorderSide(color: Colors.black)),

                  disabledColor: Colors.black,
                  //Colors.black12,
                  padding: EdgeInsets.only(left: 35, right: 35),
                  onPressed: () {

                    Navigator.of(context, rootNavigator: false).pop();
                  },
                  child: Text(
                    "No",textScaleFactor: 1.0,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              Container(
                  margin: EdgeInsets.only(
                      top: 12, bottom: 10,left: 7),
                  child: RaisedButton(
                    elevation: 0.0,
                    color: Color(0xFFFF872F),
                    disabledColor: Colors.black12,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(4.0)),
                    padding: EdgeInsets.only(left: 35, right: 35),
                    onPressed: () {

                                      setState(() {

                                          user.userProfile.kitchen_hours.setHours(
                                              "Monday", dropDownValueStart,
                                              dropDownValueBottom, tmpMonday);
                                          user.userProfile.kitchen_hours.setHours(
                                              "Tuesday", dropDownValueStart,
                                              dropDownValueBottom, tmpTuesday);
                                          user.userProfile.kitchen_hours.setHours(
                                              "Wednesday", dropDownValueStart,
                                              dropDownValueBottom, tmpWednesday);
                                          user.userProfile.kitchen_hours.setHours(
                                              "Thursday", dropDownValueStart,
                                              dropDownValueBottom, tmpThursday);
                                          user.userProfile.kitchen_hours.setHours(
                                              "Friday", dropDownValueStart,
                                              dropDownValueBottom, tmpFriday);
                                          user.userProfile.kitchen_hours.setHours(
                                              "Saturday", dropDownValueStart,
                                              dropDownValueBottom, tmpSaturday);
                                          user.userProfile.kitchen_hours.setHours(
                                              "Sunday", dropDownValueStart,
                                              dropDownValueBottom, tmpSunday);

                                      });





                                      FirebaseAnalytics().logEvent(name: 'Button',
                                          parameters: {
                                            'Category': 'Button',
                                            'Action': 'Business Hours',
                                            'Label': hoursType
                                          });
                                      saveKitchenHours(user);
                                      Navigator.pop(context, true);

                                      ////


                                      ////
                                      setState(() {
                                        //layout status set to false

                                        isChangingKitchenHours = false;
                                      });



                      //
                    },
                    child: Text(
                      "Yes",textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //color: Colors.white,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }


}

void saveKitchenStatus(user) async {
  Map data = {
    'chefId': user.uid,
    'isactive': user.userProfile.isactive.toString()
  };
  print(data);
  var response = await http
      .post(Uri.parse(Globals.BASE_URL + "api/chefapp/v1/kitchen_status"), body: data);
  if (response.statusCode == 200) {
    user.doNotifyListeners();
    Globals.showToast("Kitchen status updated");
  } else {}
}

//closekitchen Conformation dialog

class CloseKitchenConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: IconButton(
          //       icon: Icon(Icons.close),
          //       onPressed: () => {
          //         Navigator.of(context, rootNavigator: true).pop(),
          //       }),
          // ),

          Padding(
              padding: const EdgeInsets.fromLTRB(8,8,8,0),
              child:

              // Text(
              //     "",
              //     // textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.w600,
              //         color: Color(0xFF212529)
              //       //Color(0xFF656565)
              //     )),

              RichText(
                text: TextSpan(
                  text: 'Would you like to change your status?\n\n',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,

                    // fontFamily:'Open Sans',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212529),),
                  children: <TextSpan>[

                    TextSpan(
                      text: 'Changing your status to ',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        fontFamily:'Open Sans',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF656565),),
                    ),

                    TextSpan(
                      text: 'Inactive ',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        fontFamily:'Open Sans',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF7930),),
                    ),
                    TextSpan(
                      text: 'would hide your profile from foodies, and will prevent your dishes from being ordered until you are Active again.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        fontFamily:'Open Sans',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF656565),),
                    ),

                  ],
                ),textScaleFactor: 1.0,
              )


          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: Container(
                  height: 40,
                    width: 400,
                    // margin: EdgeInsets.only(top: 12, bottom: 10,left: 7),
                    child: RaisedButton(
                      elevation: 0.0,
                      color: Color(0xFFFF872F),
                      disabledColor: Colors.black12,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(4.0)),
                      // padding: EdgeInsets.only(left: 35, right: 35),
                      onPressed: () {
                        FirebaseAnalytics().logEvent(
                            name: 'Toggle',
                            parameters: {
                              'Category': 'Toggle',
                              'Action': 'Kitchen Status',
                              'Label': "Close-Yes"
                            });
                        User user = Provider.of<User>(context, listen: false);
                        user.userProfile.isactive = false;
                        saveKitchenStatus(user);
                        Navigator.of(context, rootNavigator: true).pop();


                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 5), () {
                                Navigator.of(context).pop(true);
                              });

                              //ThirdKitchenClosedDialog
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[


                              RichText(
                                      text: TextSpan(
                                      text: 'Hope to see you soon!\n',
                                      style: TextStyle(
                                      fontSize: 16,
                                        height: 1.5,
                                        // fontFamily:'Open Sans',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF212529),),
                                      children: <TextSpan>[
                                    TextSpan(
                                      text: '\nYour profile is now',
                                      style: TextStyle(
                                      fontSize: 14,
                                        height: 1.5,
                                        fontFamily:'Open Sans',
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF656565),),
                                    ),
                                        TextSpan(
                                          text: ' Inactive ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            height: 1.5,
                                            fontFamily:'Open Sans',
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFFFF7930),),
                                        ),
                                        TextSpan(
                                          text: 'and is no longer visible to Foodies.\n\nSet your Kitchen Status to Active to start getting orders.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            height: 1.5,
                                            fontFamily:'Open Sans',
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF656565),),
                                        ),

                              ],
                              ),textScaleFactor: 1.0,
                              )




                                  ],
                                ),
                              );
                            });



                      },
                      child: Text(
                        "Change Kitchen Status",
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          //color: Colors.white,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    )),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Container(
              height: 40,
              width:400,
              // margin: EdgeInsets.only(top: 12, bottom: 10,right: 7),
              child: RaisedButton(
                elevation: 0.0,
                color: Colors.white,
                //color: Colors.black38,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(4.0),
                    side: BorderSide(color: Colors.black)),

                disabledColor: Colors.black,
                //Colors.black12,
                // padding: EdgeInsets.only(left: 35, right: 35),
                onPressed: () {
                  FirebaseAnalytics().logEvent(
                      name: 'Toggle',
                      parameters: {
                        'Category': 'Toggle',
                        'Action': 'Kitchen Status',
                        'Label': "Close-No"
                      });
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text(
                  "Cancel",
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),


          // Container(
          //     padding: EdgeInsets.only(top: 15),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Container(
          //           margin: EdgeInsets.only(top: 12, bottom: 10),
          //           // ignore: deprecated_member_use
          //           child: RaisedButton(
          //             elevation: 0.0,
          //             color: Colors.white,//Color(0xFFFF7A18)
          //             shape: new RoundedRectangleBorder(
          //                 side: BorderSide(color: Colors.black),
          //                 borderRadius: new BorderRadius.circular(4.0)),
          //             disabledColor: Colors.black12,
          //             padding: EdgeInsets.only(left: 35, right: 35),
          //             onPressed: () {
          //               FirebaseAnalytics().logEvent(
          //                   name: 'Toggle',
          //                   parameters: {
          //                     'Category': 'Toggle',
          //                     'Action': 'Kitchen Status',
          //                     'Label': "Close-No"
          //                   });
          //               Navigator.of(context, rootNavigator: true).pop();
          //             },
          //             child: Text(
          //               "No",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
          //             ),
          //           ),
          //         ),
          //         Container(
          //             margin: EdgeInsets.only(
          //                 top: 12, left: 10, right: 10, bottom: 10),
          //             child: RaisedButton(
          //               elevation: 0.0,
          //               color: Color(0xFFFF872F),
          //               disabledColor: Colors.black12,
          //               shape: new RoundedRectangleBorder(
          //                   borderRadius: new BorderRadius.circular(4.0)),
          //               padding: EdgeInsets.only(left: 35, right: 35),
          //               onPressed: () {
          //                 FirebaseAnalytics().logEvent(
          //                     name: 'Toggle',
          //                     parameters: {
          //                       'Category': 'Toggle',
          //                       'Action': 'Kitchen Status',
          //                       'Label': "Close-Yes"
          //                     });
          //                 User user = Provider.of<User>(context, listen: false);
          //                 user.userProfile.isactive = false;
          //                 saveKitchenStatus(user);
          //                 Navigator.of(context, rootNavigator: true).pop();
          //               },
          //               child: Text(
          //                 "Yes",
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w600),
          //               ),
          //             )),
          //       ],
          //     ))
        ],
      ),
    );
  }
}

// hussain working
// open kitchen Conformation dialog
class OpenKitchenConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: IconButton(
          //       icon: Icon(Icons.close),
          //       onPressed: () => {
          //         Navigator.of(context, rootNavigator: true).pop(),
          //       }),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8,8,8,0),
            child:

            // Text(
            //     "",
            //     // textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.w600,
            //         color: Color(0xFF212529)
            //       //Color(0xFF656565)
            //     )),

              RichText(
                text: TextSpan(
                text: 'Would you like to change your status?\n\n',

                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212529),),
                  children: <TextSpan>[

                    TextSpan(
                      text: 'Changing your status to ',

                      style: TextStyle(
                        fontSize: 14,
                        fontFamily:'Open Sans',
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF656565),),
                    ),

                    TextSpan(
                      text: 'Active ',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily:'Open Sans',
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF7930),),
                    ),
                    TextSpan(
                      text: 'will make your profile visible to foodies and allow them to order your dishes.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        fontFamily:'Open Sans',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF656565),),
                    ),

                  ],
                ),textScaleFactor: 1.0,
              )


          ),






          Container(
              padding: EdgeInsets.only(top: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height:40,
                      width: 400,
                      // margin: EdgeInsets.only(top: 12, left: 7, right: 10, bottom: 10),
                      child: RaisedButton(
                        elevation: 0.0,
                        color: Color(0xFFFF872F),
                        disabledColor: Colors.black12,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0)),
                        // padding: EdgeInsets.only(left: 35, right: 35),
                        onPressed: () {
                          FirebaseAnalytics().logEvent(
                              name: 'Toggle',
                              parameters: {
                                'Category': 'Toggle',
                                'Action': 'Kitchen Status',
                                'Label': "Open"
                              });
                          User user = Provider.of<User>(context, listen: false);
                          user.userProfile.isactive = true;
                          saveKitchenStatus(user);
                          Navigator.of(context, rootNavigator: false).pop();


                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 5), () {
                                  Navigator.of(context).pop(true);
                                });

                                //ThirdKitchenClosedDialog
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[


                                      RichText(
                                        text: TextSpan(
                                          text: 'Glad to see you again!\n',
                                          style: TextStyle(
                                            fontSize: 16,
                                            height: 1.5,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF212529),),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: '\nYour profile is now',
                                              style: TextStyle(
                                                fontSize: 14,
                                                height:1.5,
                                                fontFamily:'Open Sans',
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF656565),),
                                            ),
                                            TextSpan(
                                              text: ' Active ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily:'Open Sans',
                                                height:1.5,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFFFF7930),),
                                            ),
                                            TextSpan(
                                              text: 'and visible to Foodies.\n\nYou’ll start receiving orders again soon',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily:'Open Sans',
                                                height: 1.5,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF656565),),
                                            ),

                                          ],
                                        ),textScaleFactor: 1.0,
                                      )




                                    ],
                                  ),
                                );
                              });



                        },
                        child: Text(
                          "Change Kitchen Status",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //color: Colors.white,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Container(
                      height:40,
                      width:400,
                      // margin: EdgeInsets.only(top: 12, bottom: 10, right:7),
                      child: RaisedButton(
                        elevation: 0.0,
                        color: Colors.white,
                        //color: Colors.black38,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0),
                            side: BorderSide(color: Colors.black)),

                        disabledColor: Colors.black,
                        //Colors.black12,
                        // padding: EdgeInsets.only(left: 35, right: 35),
                        onPressed: () {
                          FirebaseAnalytics().logEvent(
                              name: 'Toggle',
                              parameters: {
                                'Category': 'Toggle',
                                'Action': 'Kitchen Status',
                                'Label': "Open"
                              });
                          Navigator.of(context, rootNavigator: false).pop();
                        },
                        child: Text(
                          "Cancel",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),

                ],
              ))
        ],
      ),
    );
  }

}
