import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:homechefflutter/models/ProfileUpdate.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:homechefflutter/models/EarningsSummary.dart';
import 'package:homechefflutter/models/Order.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/models/UserProfile.dart';
import 'package:homechefflutter/screens/AlcDishes.dart';
import 'package:homechefflutter/screens/Dashboard.dart';
import 'package:homechefflutter/screens/DishReviewAndRating.dart';
import 'package:homechefflutter/screens/FlagIssue.dart';
import 'package:homechefflutter/screens/KitchenHour.dart';
import 'package:homechefflutter/screens/Notifications.dart';
import 'package:homechefflutter/screens/OpenOrders.dart';
import 'package:homechefflutter/screens/PaymentEarning.dart';
import 'package:homechefflutter/screens/Profile.dart';
import 'package:homechefflutter/screens/Settings.dart';
import 'package:homechefflutter/screens/Gallery.dart';
import 'package:homechefflutter/screens/playvideo.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class NavDrawer extends StatelessWidget {
  User user;
  User userA;
  bool onleave = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, user, child) {
      return Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                    children: [Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: CircleAvatar(
                          backgroundImage: NetworkImage(user.userProfile.img),
                          backgroundColor: Colors.transparent,
                          radius: 40),
                    ),
                      Row(

                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3.0)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10, top: 5, right: 10, bottom: 5),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0)),
                                  InkWell(
                                    child:
                                    getKitchenStatus(user.userProfile.isactive, context),
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (ctxt) => new KitchenHour()));

                                      FirebaseAnalytics().logEvent(
                                          name: 'KitchenStatusClick',
                                          parameters:
                                          {
                                            // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                                            'Parameter':'hamburger_menu1'
                                          }
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ]
                  ),

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 0, top: 0, right: 0, bottom: 10),
                            child: Text(
                              user.userProfile.buisnessName == null ? " ":user.userProfile.buisnessName,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF212529),
                                  fontWeight: FontWeight.w700),
                            ),
                          ),


                        ],
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(color: new Color(0xFF8CC248))),


          // CustomListTile(
          //     Image.asset("images/menu/home.png"),
          //     'Home',
          //     () => {
          //           //Navigator.pop(context),
          //           Navigator.push(
          //               context,
          //               new MaterialPageRoute(
          //                   builder: (ctxt) => new Dashboard()))
          //         }),
          CustomListTile(
              Image.asset("images/menu/log_issue6.png",height: 25,width: 25,),
              'Report an Issue',
                  () => {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (ctxt) => new FlagIssue()))
              }),
          CustomListTile(
              Image.asset("images/menu/open_orders.png"),
              'Open Orders',
              () => {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (ctxt) => new OpenOrders())),
                FirebaseAnalytics().logEvent(
                    name: 'OpenOrdersClick',
                    parameters:
                    {
                      'Parameter':'hamburger_menu'
                    }
                )



                  }),
          CustomListTile(
              Image.asset("images/menu/kitchen_hrs.png"),
              'Kitchen Availability',
                  () => {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (ctxt) => new KitchenHour())),

                FirebaseAnalytics().logEvent(
                    name: 'KitchenStatusClick',
                    parameters:
                    {
                      'Parameter':'hamburger_menu2'
                    }
                )

              }),
          ExpansionTile(title: Row(children: [
            Image.asset("images/Group.png",width: 24,),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
              child: Text("Dish Listing & Reviews",style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF656565),
                  fontWeight: FontWeight.w600),),
            )
          ],
           ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(17,0,0,0),
                child: CustomListTile(
                    Image.asset("images/Approved-Dish.png",width: 24,),
                    'Approved Dishes',
                        () => {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (ctxt) => new AlcDishes()))
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(17,0,0,0),
                child: CustomListTile(
                    Image.asset("images/menu/star.png"),
                    'Dish Ratings & Reviews',
                        () => {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (ctxt) => new DishReviewAndRating()))
                    }),
              ),
            ],


          ),
          CustomListTile(
              Image.asset("images/menu/payments.png"),
              'Payments & Earnings',
                  () => {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (ctxt) => new PaymentEarning())),


                FirebaseAnalytics().logEvent(
                    name: 'PaymentClick',
                    parameters:
                    {
                      'Parameter':'hamburger_menu'
                    }
                )

              }),

          ExpansionTile(title: Row(children: [
            Image.asset("images/menu/profile.png",width: 24,),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
              child: Text("Profile",style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF656565),
                  fontWeight: FontWeight.w600),),
            )
          ],
          ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(17,0,0,0),
                child: CustomListTile(
                    Image.asset("images/menu/profile.png"),
                    'Chef Profile',
                        () => {
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (ctxt) => new Profile()))
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(17,0,0,0),
                child: CustomListTile(
                    Image.asset("images/menu/Galleryicon2.png", height: 23,width: 23,),
                    'My Gallery',
                        () => {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (ctxt) => new Gallery()))
                    }),
              ),
            ],


          ),

          ExpansionTile(title: Row(children: [
            Image.asset("images/menu/settings.png",width: 24,),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
              child: Text("Settings",style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF656565),
                  fontWeight: FontWeight.w600),),
            )
          ],
          ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(17,0,0,0),
                child:  CustomListTile(
                    Image.asset("images/Ringer_Alert.png", width: 24),
                    'Order Alert',
                        () => {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (ctxt) => new Settings()))
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(17,0,0,0),
                child: CustomListTile(
                    Image.asset("images/menu/logout.png"),
                    'Logout',
                        () => {
                      logout(context)
                    }),
              ),
            ],


          ),









          // CustomListTile(
          //     Image.asset("images/menu/notifications.png"),
          //     'Notifications',
          //     () => {
          //           Navigator.push(
          //               context,
          //               new MaterialPageRoute(
          //                   builder: (ctxt) => new Notifications()))
          //         }),



          CustomListTile(
              Image.asset("images/menu/share.png",height: 24,width: 24,),
              'Share Chef URL',
                  () => {
                      Share.share(user.userProfile.profileurl == null ? " ":
                      "Hi, I can't wait for you to start ordering and enjoying delicious food. Visit my kitchen at https://homechef.pk/"+user.userProfile.profileurl.replaceAll(new RegExp(' '),'%20')+"" +" to place an order now!"),
                    print("HELLO HUSS"),
                    print("homechef.pk/"+user.userProfile.profileurl.toString()),
              }),






          Image.asset("images/logo-blur.png"),
          Text("v" + Globals.app_version,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF656565),
                  fontWeight: FontWeight.w600)),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
          )
        ],
      ));
    });
  }



  void logout(context) async {
    User user = Provider.of<User>(context, listen: false);
    print(Globals.firebaseToken);
    Map data = {
        'chefId': user.uid,
        'firebasetoken': Globals.firebaseToken
    };
    var response =
        await http.post(Uri.parse(Globals.BASE_URL + "api/chefapp/v1/firebase_token_remove"), body: data);
    print(response.body);
    user.mobile = "";
    user.name = "";
    user.token = "";
    user.uid = "";
    user.usertype = "";
    user.email = "";
    user.allOrders = new List<Order>();
    user.userProfile = new UserProfile("", "", "", "","", "", "", "","", "", "", new List<String>(),"");
    user.earningsSummary = new EarningsSummary(0, 0, new LatestPayment(0, "", ""));
    user.notifications = new List();
    Globals.firebaseToken = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("user");
    user.doNotifyListeners();
    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false);
  }



  Widget getKitchenStatus(isActive,context) {
    user = Provider.of<User>(context);
      String imageRef = "";
      String openStatus = "";

    if (isActive) {
      openStatus = "Status: Active";
      imageRef="images/dashboard/Openn.png";

      if (user.userProfile.kitchen_hours.days_off.isEmpty == false) {
        for(int i=0;i<user.userProfile.kitchen_hours.days_off.length;i++)
        {
          if (user.userProfile.kitchen_hours.days_off[i].checkingLeaves() ==
              true) {
            openStatus = "Status: On Vacation";
            imageRef = "images/dashboard/leavee.png";

            break;
          }
        }
      }
    }
    else
    {
          imageRef = "images/dashboard/Closee.png";
          openStatus = "Status: Inactive";
        }

    return  Row(
      children: <Widget>[
        Image.asset(imageRef,width: 7,
          height: 7,),
        Text("  "+openStatus,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Color(0xFF656565)),
        ),


      ],
    );
  }
}


class CustomListTile extends StatelessWidget {
  final Image icon;
  final String text;
  final Function onTap;

  CustomListTile(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context) {
    //ToDO
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(

        child: InkWell(
            splashColor: Colors.orangeAccent,
            onTap: onTap,
            child: Container(
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
                          child: icon,
                        ),
                        Text(
                          text,
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF656565),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ))),
      ),
    );
  }
}


