import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/screens/NavDrawer.dart';
import 'package:homechefflutter/screens/OpenOrders.dart';
import 'package:homechefflutter/screens/PaymentEarning.dart';
import 'package:homechefflutter/screens/UnconfirmOrders.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/screens/KitchenHour.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:homechefflutter/models/UserProfile.dart';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
// import 'package:connectivity/connectivity.dart';
// final formatCurrency = new NumberFormat.currency(locale: "en_US",symbol: "");
final oCcy = new NumberFormat("#,##0", "en_US");

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Timer timer;

  @override
  void initState() {
    super.initState();
    _requestPermission(context);
    getDetails(context);
    // checkinternetConnectivity();
    timer = Timer.periodic(Duration(seconds: 40), (Timer t) => checkinternetConnectivity());
  }


  void _handleVacationTypeRadioValueChanged(val) {
    setState(() {
      vacationType = val;
    });
  }

  checkinternetConnectivity() async{

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Conected')));
      }} on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 5),
          content: Text(' No Internet Connection Found',textScaleFactor: 1.0,
            style: TextStyle(height: 1.5),)));
    }}


  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    var openOrderCount = 0;
    String nextPickupTime = "";
    String nextPickupOrders = "";
    var ordersDueTodayCount = 0;
    var balance = 0;
    var chefScore;
    var chefTotalRatings = 0;
    var chefRatingString = "";
    int moneyPaymentdue = 0;
    var imageRef="";
    var colorOnDash="";


    // checkinternetConnectivity();
    // for(int i=0;i<5;i++){checkinternetConnectivity();
    //sleep(const Duration(seconds: 10));}

    var nextPUTS = "";
    var nextPUCnt = 0;



    for (var data in user.allOrders) {
      if (data.ordertype.contains("sub"))
        openOrderCount += data.dishes[0].quantity;
      else if (data.status == "Confirmed") openOrderCount++;

      //today orders check
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final this_pu = DateTime.parse(data.pickuptimestamp).toLocal();
      final aDate = DateTime(this_pu.year, this_pu.month, this_pu.day);
      if (aDate == today) {

        if (data.ordertype.contains("sub"))
          ordersDueTodayCount += data.dishes[0].quantity;
        else if (data.status == "Confirmed") ordersDueTodayCount++;
      }

      if (data.status == "Confirmed") {
        // Next Pickup check
        if (nextPUTS == "") {
          nextPUTS = data.pickuptimestamp;
          nextPUCnt = 1;

        } else if (DateTime.parse(data.pickuptimestamp)
            .isBefore(DateTime.parse(nextPUTS))) {
          nextPUTS = data.pickuptimestamp;
          nextPUCnt = 1;
        } else if (data.pickuptimestamp == nextPUTS) {
          nextPUCnt++;
        }
      }
    }
    balance = user.earningsSummary.balance;
    print(user.userProfile.rating);
    chefScore = user.userProfile.rating;
    chefTotalRatings = user.userProfile.chefScore.mp_count +
        user.userProfile.chefScore.alc_count +
        user.userProfile.chefScore.ds_count;
    chefRatingString = user.userProfile.chefScore.rating_string.toString();
    moneyPaymentdue = balance;

    if (nextPUTS != "") {
      var timeFormat = new DateFormat('h:mm a');
      var dateFormat = new DateFormat('E, d MMM');
      DateTime nextPU = DateTime.parse(nextPUTS).toLocal();
      nextPickupTime = timeFormat.format(nextPU);
      nextPickupOrders =
          dateFormat.format(nextPU) + " (" + nextPUCnt.toString();
      if (nextPUCnt == 1) {
        nextPickupOrders = nextPickupOrders + " Order)";
      } else {
        nextPickupOrders = nextPickupOrders + " Orders)";
      }
    } else {
      nextPickupTime = "-";
      nextPickupOrders = "There are no orders";
    }
    final dateFormat = new DateFormat('E, d MMM');
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




//working  internet conectivity code
//     checkinternetConnectivity() async{
//
//
//       try {
//         final result = await InternetAddress.lookup('google.com');
//         if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text('Conected')));
//         }
//       } on SocketException catch (_) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text(' not Conected')));
//       }
//
//     }





    Widget kitchenStatusOpenClose(isActive) {
      user = Provider.of<User>(context);
      String openStatus = "";
      if(isActive){

        imageRef="images/dashboard/Openn.png";
        openStatus = "Active";
        colorOnDash="0xFF8CC248";
        // if (user.userProfile.kitchen_hours.days_off.isEmpty == false){
        // if (user.userProfile.kitchen_hours.days_off[0].checkingLeaves() == true) {
        //   openStatus = "On Leave";
        //   imageRef = "images/dashboard/leavee.png";
        //   colorOnDash="0xFF8CC248";
        //
        // }
        //
        // }
        if (user.userProfile.kitchen_hours.days_off.isEmpty == false) {
          for(int i=0;i<user.userProfile.kitchen_hours.days_off.length;i++)
          {
            if (user.userProfile.kitchen_hours.days_off[i].checkingLeaves() ==
                true) {
              openStatus = "On Vacation";
                imageRef = "images/dashboard/leavee.png";
                colorOnDash="0xFF8CC248";

              break;
            }
          }
        }
      }
      else{
        imageRef="images/dashboard/Closee.png";
        openStatus = "Inactive";
        colorOnDash="0xFF8CC248";

      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          openStatus!="On Vacation"?Container(
            margin: EdgeInsets.only(top: 12, bottom: 10,right: 7),
            child: RaisedButton(
              elevation: 0.0,
              color: Color(0xFFFDFDFD),
              //color: Colors.black38,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(4.0),
                  side: BorderSide(color: Color(0xFFFF7A18))),

              disabledColor: Colors.black,
              //Colors.black12,
              padding: EdgeInsets.only(left: 35, right: 35),
              onPressed: () {
                showModalBottomSheet(isScrollControlled: true,context: context,shape: const RoundedRectangleBorder( // <-- SEE HERE
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ), builder: (_) => MyBottomSheet());
              },
              child: Text(
                "Stop Receiving Orders",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFFF7A18), fontSize: 16,fontWeight: FontWeight.w600),
              ),
            ),
          ):Container(
            margin: EdgeInsets.only(top: 12, bottom: 0,right: 7),
            child: RaisedButton(
              elevation: 0.0,
              color: Color(0xFFFDFDFD),
              //color: Colors.black38,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(4.0),
                  side: BorderSide(color: Color(0xFFFF7A18))),

              disabledColor: Colors.black,
              //Colors.black12,
              padding: EdgeInsets.only(left: 35, right: 35),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (ctxt) => new KitchenHour()));
              },
              child: Text(
                "Manage Vacations",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFFF7A18), fontSize: 16,fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );




    }



    return ChefAppScaffold(
      title: "Dashboard",
      showNotifications: true,
      showBackButton: false,
      showHomeButton: false,




      body:
      SingleChildScrollView(
         child:

        Container(
          height: MediaQuery.of(context).size.height*.93,
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('images/dashboard/Bg4.png'),

              fit: BoxFit.fill,
            ),
          ),

          // alignment: Alignment.center,
          child:
          Container(
            margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
          child:
          Column(
            //physics: new PageScrollPhysics(),
          //Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //unconfirmed orders

              user.getUnconfirmedOrderCount() == 0
              ? Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 45,bottom: 50),
              )
              : Container(

                margin: EdgeInsets.only(left: 30, right: 30, top: 15,bottom: 5),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(16.0),
                  color: Color((0xFFB2473D)),


                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(5, 5), // changes position of shadow
                    ),
                  ],

                ),

                //margin: const EdgeInsets.only(top: 15.0),
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child:
                      InkWell(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[
                        Column(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: <Widget>[


                            Text("UNCONFIRMED ORDERS",style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),),



                            Text(user.getUnconfirmedOrderCount().toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),




                          ],)
                      ]
                  ),

                        onTap: () => {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new UnConfirmOrders())),

                        },
                ),
                ),
              ),


              //Kitchen Status
              InkWell(
                child:
                Container(
                  margin: const EdgeInsets.only(top: 15.0),

                  child: Center(
                    child:

                    kitchenStatusOpenClose(user.userProfile.isactive),

                  ),
                ),
                      onTap: (){
                    //       Navigator.push(
                    //       context,
                    //       new MaterialPageRoute(
                    //
                    // builder: (ctxt) => new
                    // KitchenHour()
                    //       ));

                    },
              ),

              //next order view
              Container(
                margin: EdgeInsets.only(left: 20, top: 15, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 2.5, color: Color(0x88607D8B)),
                        //    bottom: BorderSide(width: 1, color: Color(0x88607D8B))
                      )
                  ),
                  child: Row(
                    children: <Widget>[

                      Expanded(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Image.asset("images/dashboard/bikebig.png",height: 45,width: 45,),
                              Center(

                                child: Text(
                                  "Next Pickup",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF758E9A)),
                                ),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                        ),
                        flex: 4,
                      ),

                      Padding(
                          padding: EdgeInsets.only(
                              left: 0, top: 13, right: 0, bottom: 13),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                                border: Border(
                                  left:
                                  BorderSide(width: 2.5, color: Color(0x88607D8B)),
                                )),
                          )),
                      Expanded(
                        child: Container(
                          //margin: EdgeInsets.all(10.0),\
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                Text(nextPickupTime,
                                    style: Theme.of(context).textTheme.headline2),
                                Text(
                                  nextPickupOrders,
                                  style: TextStyle(
                                      fontSize: 10,
                                      height: 1.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF758E9A)),
                                ),
                                //Text("Remove"),
                                //Text("Comment")
                              ],
                            ),
                          ),

                          alignment: Alignment.center,
                        ),
                        flex: 4,
                      ),

                    ],
                  ),
                ),
              ),




              //
              //Chef Score View
              Container(
                margin: EdgeInsets.only(left: 20, top: 0, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 2.5, color: Color(0x88607D8B)),
                          bottom:
                          BorderSide(width: 2.5, color: Color(0x88607D8B)))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          // margin: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[



                              InkWell(child: Image.asset("images/Chef_Rating_32px.png",height: 45,width: 45,),onTap: (){

                                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                //     content: Text('No Internet Conection')));
                               checkinternetConnectivity();

                              },),



                              Center(
                                child: Text(
                                  "Chef Score",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF758E9A)),
                                ),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                        ),
                        flex: 4,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 0, top: 13, right: 0, bottom: 13),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                                border: Border(
                                  left:
                                  BorderSide(width: 2.5, color: Color(0x88607D8B)),
                                )),
                          )),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          child: chefScore.toString()!="null"?Column(
                            children: <Widget>[
                              Text(chefScore.toString() + " / 5",
                                  style: Theme.of(context).textTheme.headline2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  

                                  Text(
                                    " \n (" +
                                        chefTotalRatings.toString() +
                                        " Ratings)",
                                    style: TextStyle(
                                        fontSize: 9,
                                        height: 1.5,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF758E9A)),
                                  ),
                                ],
                              ),

                              // Text("Remove "),
                              // Text("Comments")
                            ],
                          ):Column(
                            children: <Widget>[
                              Text("-",
                                  style: Theme.of(context).textTheme.headline2),
                            ],
                          ),
                          alignment: Alignment.center,
                        ),
                        flex: 4,
                      ),
                    ],
                  ),
                ),
              ),



              Padding(
                padding: EdgeInsets.all(10.0),
              ),


              //Container of payment and open orders
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[


                    //payment Due View
                    Container(
                      width: MediaQuery.of(context).size.width *.48,
                      height: MediaQuery.of(context).size.height/4.5,

                      decoration: new BoxDecoration(
                        //borderRadius: new BorderRadius.circular(16.0),
                        borderRadius: BorderRadius.only(bottomRight:Radius.circular(25.0),topRight:Radius.circular(25.0)),
                        color: Color(0xFF97C85A),


                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(5, 5), // changes position of shadow
                          ),
                        ],

                      ),
                      child:

                      InkWell(
                          onTap: () => {
                            //print("Card tapped.")
                            Navigator.push(
                                context,
                                new MaterialPageRoute(

                                    builder: (ctxt) => new PaymentEarning())),

                            FirebaseAnalytics().logEvent(
                                name: 'PaymentClick',
                                parameters:
                                {
                                  // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                                  'Parameter':'Dashboard'
                                }
                            )
                          },
                          child:

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[
                              Image.asset("images/dashboard/moneybig.png",height:50, width: 50,),
                              Padding(padding: EdgeInsets.only(bottom: 5.0)),
                              Text("PAYMENT DUE",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold),),

                                Text('${oCcy.format(moneyPaymentdue
                                    //balance.toString()
                                )}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),

                                ),
                        //Text('${formatCurrency.format(_moneyCounter)}'
                        //       Text( balance.toString(),
                        //         style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 30,
                        //             fontWeight: FontWeight.bold),),
                             Padding(padding: EdgeInsets.only(bottom: 15.0))

                            ],

                          )

                      ),),



                    //OpenOrders
                    Container(
                      width: MediaQuery.of(context).size.width *.48,
                      height: MediaQuery.of(context).size.height/4.5,

                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft:Radius.circular(25.0),bottomLeft: Radius.circular(25.0)),

                        color: Color(0xFFFF872F),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(5, 5), // changes position of shadow
                          ),
                        ],

                      ),



                      child:

                      InkWell(
                          onTap: () => {
                            Navigator.push(context,
                                new MaterialPageRoute(builder: (ctxt) => new OpenOrders())),
                            FirebaseAnalytics().logEvent(
                                name: 'OpenOrdersClick',
                                parameters:
                                {
                                  // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                                  'Parameter':'Dashboard'
                                }
                            )

                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,


                            children: <Widget>[
                              Image.asset("images/dashboard/dishbig.png",
                              height:50, width: 50,
                              ),
                              Text("OPEN ORDERS",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold),),
                              Text(openOrderCount.toString(),style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)
                                ,),
                              Text("(" +
                                  ordersDueTodayCount.toString() + " Due Today)",
                                      style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.5,
                                      fontWeight: FontWeight.bold),),
                              Padding(padding: EdgeInsets.only(bottom: 15.0))

                            ],

                          )

                      ),)

                  ],
                ),
              )




            ],


          ),
          //  padding: EdgeInsets.fromLTRB(0,0,0,150),
          ),
        ),
      ),
    );
  }

  void _flexiblePopup() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title:Text("Update the App?", style: TextStyle(
              fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black,
            ),),
            // insetPadding: EdgeInsets.symmetric(vertical: 70),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Update to the latest version to use the newest features and services.",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                        padding: EdgeInsets.only(left: 15, right: 15),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: false).pop();
                        },
                        child: Text(
                          "Later",
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
                          padding: EdgeInsets.only(left: 15, right: 15),
                          onPressed: () {
                            // Navigator.of(context).pop();
                            launch('https://play.google.com/store/apps/details?id=pk.homechef.chefapp&hl=en&gl=US');

                          },
                          child: Text(
                            "Update",
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
            )
        );
      },
    );

  }


  //FORCED UPDATE
  void _forcedPopup() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title:Text("Update to Continue", style: TextStyle(
              fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black,
            ),),
            // insetPadding: EdgeInsets.symmetric(vertical: 70),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Update to the latest version to continue using the Chef app.",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                        padding: EdgeInsets.only(left: 15, right: 15),
                        onPressed: () {
                          exit(0);
                          //Navigator.of(context, rootNavigator: false).pop();
                        },
                        child: Text(
                          "Close",
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
                          padding: EdgeInsets.only(left: 15, right: 15),
                          onPressed: () {
                            // Navigator.of(context).pop();
                            launch('https://play.google.com/store/apps/details?id=pk.homechef.chefapp&hl=en&gl=US');

                          },
                          child: Text(
                            "Update Now",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //color: Colors.white,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        )),
                  ],
                )
              ],
            )
        );
      },
    );

  }

  getDetails(BuildContext context) async
  {
    var jsonResponse;
    var response = await http.get(Uri.parse(Globals.BASE_URL + "api/v3/checkversion?name=androidca"));
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body.toString());
      print("RESPONSE" + jsonResponse['version'].toString());
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String build = packageInfo.buildNumber;
      print("RESPONSE" + build);
      var appversion = jsonResponse['version'];
      if(appversion > int.parse(build))
        {
          setState(() {
            _flexiblePopup();
          });
        }
    }
  }


}

var vacationType = "default";
var selectedDate = DateTime.now();
List<DateTime> picked;
DateTime newOffStart;
DateTime newOffEnd;
var reason = "";
User user;
var count = 0;


class MyBottomSheet extends StatefulWidget {
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  bool _flag = false;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0,20,0,0),
                child: Align(
                    alignment:Alignment.center,
                    child: Text("Stop Receiving Orders", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(35,8,35,24),
                child: Align(
                    alignment:Alignment.center,
                    child: Text("You will not receive orders for delivery on the selected day(s)", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Color(0xFF656565)),textAlign: TextAlign.center)),
              ),
              RadioListTile(
                value: "today",
                groupValue: vacationType,
                selected: false,
                onChanged: (newValue) {setState(() {
                  vacationType = newValue;
                  newOffEnd = null;
                  newOffStart = null;
                  picked = null;
                });},

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('For Today - ' + DateFormat('E').format(DateTime.now()),style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF656565))),
                  ],
                ),
              ),

              RadioListTile(
                value: "tomorrow",
                groupValue: vacationType,
                selected: false,
                onChanged: (newValue) {setState(() {
                  vacationType = newValue;
                  newOffEnd = null;
                  newOffStart = null;
                  picked = null;
                });},
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('For Tomorrow - ' + DateFormat('E').format(DateTime.now().add(Duration(days:1))),style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF656565))),
                  ],
                ),
              ),
              RadioListTile(
                value: "week",
                groupValue: vacationType,
                selected: false,
                onChanged: (newValue) {setState(() {
                  vacationType = newValue;
                  newOffEnd = null;
                  newOffStart = null;
                  picked = null;
                });},
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('For this week - ' + DateFormat('MMMd').format(DateTime.now()) + " to " + DateFormat('MMMd').format(DateTime.now().add(Duration(days:7))),style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF656565))),
                  ],
                ),
              ),
              RadioListTile(
                value: "custom",
                groupValue: vacationType,
                selected: false,
                onChanged: (newValue)  async {
                  picked =
                      await DateRangePicker.showDatePicker(
                      context: context,
                      initialFirstDate: new DateTime.now(),
                      initialLastDate: new DateTime.now()
                          .add(new Duration(days: 7)),
                      firstDate: new DateTime.now().subtract(new Duration(days: 1)),
                      lastDate: new DateTime.now().add(const Duration(days: 120)));
                  if(picked!=null) {
                    newOffStart = DateTime.utc(picked[0].year, picked[0].month, picked[0].day, 0, 0, 0, 0, 0);
                    newOffEnd = DateTime.utc(picked[1].year, picked[1].month, picked[1].day, 23, 59, 59, 0, 0);
                    setState(() {
                      vacationType = newValue;
                    });
                  }
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Custom - Select date range',style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF656565))),
                  ],
                ),
              ),
              (newOffStart.toString() == null && vacationType != 'custom') || (picked == null && vacationType != 'custom')?Container():Column(children:[Padding(
              padding: const EdgeInsets.fromLTRB(24,16,0,8),
              child: Align(
                  alignment:Alignment.centerLeft,
                  child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [Text("Selected Dates",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,24,0),
                    child: GestureDetector(onTap:() async{
                      picked =
                          await DateRangePicker.showDatePicker(
                          context: context,
                          initialFirstDate: new DateTime.now(),
                          initialLastDate: new DateTime.now()
                              .add(new Duration(days: 7)),
                          firstDate: new DateTime.now().subtract(new Duration(days: 1)),
                          lastDate: new DateTime.now().add(const Duration(days: 120)));
                      if(picked!=null) {
                        newOffStart = DateTime.utc(picked[0].year, picked[0].month, picked[0].day, 0, 0, 0, 0, 0);
                        newOffEnd = DateTime.utc(picked[1].year, picked[1].month, picked[1].day, 23, 59, 59, 0, 0);
                        setState(() {

                        });
                      }
                    },child: Image.asset("images/Edit_icon_24px.png",height: 24,width: 24,)),
                  ),]))) , Padding(
                    padding: const EdgeInsets.fromLTRB(24,0,0,16),
                    child: Align(alignment: Alignment.centerLeft, child: Text(DateFormat('MMMEd').format(newOffStart) + " to " + DateFormat('MMMEd').format(newOffEnd) + " ("+ (newOffEnd.difference(newOffStart).inDays + 1).toString() + " days off)",style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF656565)),)),
                  )]),

            ],
          ),vacationType == "default"?Container():Padding(
            padding: const EdgeInsets.fromLTRB(24,16,0,8),
            child: Align(alignment:Alignment.centerLeft,child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [Text("Reason:*", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,8,24,0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Eg: Public Holidays",
                  ),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 3,
                  onChanged: (newReason) {
                    setState(() {
                      reason = newReason;
                    });
                  },
                ),

              ),
              Text(reason == "" && count > 0 ?"\n Please add a reason for your leave.":"",
                  style:TextStyle(
                    color:Colors.red,
                    fontSize: 12,
                  )),

            ])),
          ), Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24,0,0,0),
                child: Container(
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
                      setState(() {
                        vacationType = "default";
                        newOffStart = null;
                        newOffEnd = null;
                        reason = "";
                        count = 0;
                      });

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,24,0),
                child: vacationType!="default"?Container(
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
                          count++;
                        });
                        if(vacationType=="today" && reason!="")
                        {
                          var dt = DateTime.now();
                          DaysOff newOff = new DaysOff(DateTime.utc(dt.year, dt.month, dt.day, 0, 0, 0, 0, 0).toString(),
                              DateTime.utc(dt.year, dt.month, dt.day, 23, 59, 59, 0, 0).toString(), reason);
                          user.userProfile.kitchen_hours.days_off.insert(0, newOff);
                          saveKitchenHours(user);
                          user.doNotifyListeners();
                          setState(() {
                            vacationType = "default";
                            newOffStart = null;
                            newOffEnd = null;
                            reason = "";
                            count = 0;
                          });
                          Navigator.of(context, rootNavigator: true).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 5),
                              content: Text('Your vacation has been added.',textScaleFactor: 1.0,
                                style: TextStyle(height: 1.5),)));
                        }
                        else if(vacationType=="tomorrow" && reason!="")
                        {
                          var dt = DateTime.now().add(new Duration(days: 1));
                          DaysOff newOff = new DaysOff(DateTime.utc(dt.year, dt.month, dt.day, 0, 0, 0, 0, 0).toString(),
                              DateTime.utc(dt.year, dt.month, dt.day, 23, 59, 59, 0, 0).toString(), reason);
                          user.userProfile.kitchen_hours.days_off.insert(0, newOff);
                          saveKitchenHours(user);
                          user.doNotifyListeners();
                          setState(() {
                            vacationType = "default";
                            newOffStart = null;
                            newOffEnd = null;
                            reason = "";
                            count = 0;
                          });
                          Navigator.of(context, rootNavigator: true).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 5),
                              content: Text('Your vacation has been added.',textScaleFactor: 1.0,
                                style: TextStyle(height: 1.5),)));
                        }
                        else if(vacationType=="week" && reason!="")
                        {
                          var dtstart = DateTime.now();
                          var dtend = dtstart.add(new Duration(days: 7));
                          DaysOff newOff = new DaysOff(DateTime.utc(dtstart.year, dtstart.month, dtstart.day, 0, 0, 0, 0, 0).toString(),
                              DateTime.utc(dtend.year, dtend.month, dtend.day, 23, 59, 59, 0, 0).toString(), reason);
                          user.userProfile.kitchen_hours.days_off.insert(0, newOff);
                          saveKitchenHours(user);
                          user.doNotifyListeners();
                          setState(() {
                            vacationType = "default";
                            newOffStart = null;
                            newOffEnd = null;
                            reason = "";
                            count = 0;
                          });
                          Navigator.of(context, rootNavigator: true).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 5),
                              content: Text('Your vacation has been added.',textScaleFactor: 1.0,
                                style: TextStyle(height: 1.5),)));
                        }
                        else if(vacationType=="custom" && newOffStart != null && reason!="")
                        {

                            DaysOff newOff = new DaysOff(newOffStart.toString(),
                                newOffEnd.toString(), reason);
                            user.userProfile.kitchen_hours.days_off.insert(
                                0, newOff);
                            saveKitchenHours(user);
                            user.doNotifyListeners();
                            setState(() {
                              vacationType = "default";
                              newOffStart = null;
                              newOffEnd = null;
                              reason = "";
                              count = 0;
                            });
                            Navigator.of(context, rootNavigator: true).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 5),
                                content: Text('Your vacation has been added.',textScaleFactor: 1.0,
                                  style: TextStyle(height: 1.5),)));
                        }
                      },
                      child: Text(
                        "Apply",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          //color: Colors.white,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    )):
                Container(
                    margin: EdgeInsets.only(
                        top: 12, bottom: 10,left: 7),
                    child: RaisedButton(
                      elevation: 0.0,
                      color: Color(0xFFC4C4C4),
                      disabledColor: Colors.black12,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(4.0)),
                      padding: EdgeInsets.only(left: 35, right: 35),
                      onPressed: () {

                      },
                      child: Text(
                        "Apply",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          //color: Colors.white,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    )),
              )
            ],
          )]
        ),
      ),
    );
  }
  void saveKitchenHours(user) async {
    Map data = {
      'chefId': user.uid,
      'kitchen_hours': user.userProfile.kitchen_hours,
      'istype':"break"
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
    } else {}
  }
}

Future<void> _requestPermission(BuildContext context) async {
  print("In NOti");
  final status = await Permission.notification.status;
  if (status.isDenied) {
    final result = await Permission.notification.request();
    final isPermanentlyDenied = result.isPermanentlyDenied;
    if (result.isGranted) {

    } else if (isPermanentlyDenied) {
      openAppSettings();
    }
  } else if (status.isGranted) {

  }
}




