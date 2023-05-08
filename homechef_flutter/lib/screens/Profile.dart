import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homechefflutter/models/ProfileUpdate.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/screens/ProfileChangeDetail.dart';
import 'package:homechefflutter/screens/ProfileEdit.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  bool check = true;
  @override
  void initState() {

    super.initState();

    //User user = Provider.of<User>(context);

    //Timer.run(() => showAlert(context));
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    if(user.cheflevel=="upforreview"){checkFirstRun(context);}
    var changeRequestDateFormat = new DateFormat('dd/MM/yyyy');
    var changeRequestTimeFormat = new DateFormat('hh:mm a');
    var changeRequestUpdatedFormat = new DateFormat('dd/MM/yyyy hh:mm a');
    List<ProfileUpdate> profileUpdates =
    user.userProfile.getSortedProfileUpdates();



    return ChefAppScaffold(
        title: "Profile",
        showNotifications: true,
        showBackButton: false,
        showHomeButton: true,
        body: DefaultTabController(
          length: 2,
          child: Column(children: [
            Container(

              child: TabBar(
                tabs: [
                  Tab(
                    child: Center(
                        child: Text(
                          "ABOUT ME",
                          style: TextStyle(color: Color(0xFF656565), fontSize: 16),
                        )),
                  ),
                  Tab(
                    child: Center(
                        child: Text(
                          "REQUESTED CHANGES",
                          style: TextStyle(color: Color(0xFF656565), fontSize: 16),
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
                child: TabBarView(children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
                    color: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        ListView(
                          children: <Widget>[
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Name:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    user.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 0, top: 15.0, right: 0.0, bottom: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Business Name:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    user.userProfile.buisnessName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 0, top: 15.0, right: 0.0, bottom: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Mobile Number:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    user.getFormattedNum(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 0, top: 15.0, right: 0.0, bottom: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Email:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    user.email.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 0, top: 15.0, right: 0.0, bottom: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Facebook Profile:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    user.userProfile.facebookProfile.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 0, top: 15.0, right: 0.0, bottom: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Alternate Contact No:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    user.getFormattedAlternateNum(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 0, top: 15.0, right: 0.0, bottom: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "About Me:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    user.userProfile.aboutMe.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 0, top: 15.0, right: 0.0, bottom: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Food Story:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    user.userProfile.foodStory.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 0, top: 15.0, right: 0.0, bottom: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "My Speciality:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    user.userProfile.mySpeciality.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 0, top: 15.0, right: 0.0, bottom: 0.0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Master Cuisnes:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF656565),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      user.getMasterCuisines(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF656565),
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        user.getcheflevel()!="upforreview"?Container(
                          alignment: Alignment(0, 1),
                          child: (user.userProfile.getPendingProfileUpdate() != null) ? MaterialButton(
                            padding: EdgeInsets.all(5),
                            child: Text("Update Pending Request",
                                style: TextStyle(color: Color(0xFFFFFFFF))),
                            color: Color(0xFFFF7A18),
                            onPressed: () {
                              ProfileUpdate pu = user.userProfile.getPendingProfileUpdate();
                              pu.mergeWithChefProfile(user);
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (ctxt) => new ProfileEdit(pu)));
                            },
                          ) : MaterialButton(
                            padding: EdgeInsets.all(5),
                            child: Text("Request Changes",
                                style: TextStyle(color: Color(0xFFFFFFFF))),
                            color: Color(0xFFFF7A18),
                            onPressed: () {
                              ProfileUpdate pu = new ProfileUpdate();
                              pu.resetToChefProfile(user);
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (ctxt) => new ProfileEdit(pu)));
                            },
                          ),
                        ):Container()
                      ],
                    ),
                  ),
                  Container(
                      child: ListView.builder(
                          itemCount: user.userProfile.profileChangeRequests.length,
                          itemBuilder: (BuildContext context, int index) {
                            DateTime parsedRequestDate =
                            DateTime.parse(profileUpdates[index].requestDate)
                                .toLocal();
                            return Card(
                              color: Colors.white,
                              child: Column(children: [
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          EdgeInsets.fromLTRB(10, 10, 0, 10),
                                          child: Text(
                                            "Requested Change: " +
                                                profileUpdates[index]
                                                    .getUpdatedHeads() +
                                                " on " +
                                                changeRequestDateFormat
                                                    .format(parsedRequestDate) +
                                                ' at ' +
                                                changeRequestTimeFormat
                                                    .format(parsedRequestDate),
                                            style: TextStyle(
                                                color: Color(0xFF758E9A),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: 80,
                                          child: Padding(
                                              padding:
                                              EdgeInsets.fromLTRB(0, 10, 10, 0),
                                              child: Text(
                                                  profileUpdates[index]
                                                      .getApprovalStatus(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: profileUpdates[index]
                                                          .getApprovalStatusColor(),
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.w600))))
                                    ]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                        child: Text(
                                          "Last Updated: " +
                                              changeRequestUpdatedFormat
                                                  .format(parsedRequestDate) + " ",
                                          style: TextStyle(
                                              color: Color(0xFF758E9A),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        )),
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                builder: (context) =>
                                                new ProfileChangeDetail(index),
                                              ));
                                        },
                                        child: Padding(
                                            padding:
                                            EdgeInsets.fromLTRB(0, 30, 5, 0),
                                            child: Text(
                                              "Show Details",
                                              style: TextStyle(
                                                  color: Color(0xFF000000),
                                                  decoration:
                                                  TextDecoration.underline,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            )))
                                  ],
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                                (profileUpdates[index].approvalStatus != "Pending")
                                    ? Container()
                                    : Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child:Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          MaterialButton(
                                            color: Color(0xFFEA1717),
                                            padding: EdgeInsets.all(5.0),
                                            onPressed: () {
                                              this.deleteChangeRequest(context,
                                                  user, profileUpdates[index]);
                                            },
                                            child: Text("Delete",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFFFFFFFF),
                                                    fontWeight: FontWeight.w600)),
                                          ),
                                          Padding(padding: EdgeInsets.all(5)),
                                          MaterialButton(
                                            color: Color(0xFFFF7A18),
                                            padding: EdgeInsets.all(5.0),
                                            onPressed: () {
                                              profileUpdates[index]
                                                  .mergeWithChefProfile(user);
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                    builder: (ctxt) =>
                                                    new ProfileEdit(
                                                        profileUpdates[
                                                        index]),
                                                  ));
                                            },
                                            child: Text("Edit",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFFFFFFFF),
                                                    fontWeight: FontWeight.w600)),
                                          )
                                        ])),
                              ]),
                            );
                          }))
                ]))
          ]),

        ));

  }



  void showAlert(context) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) =>
            // AlertDialog(
            //   content: Text("To review your profile and make changes, please visit the Chef Application Page on via your desktop/tablet. "),
            // )
        AlertDialog(

          content: Text("To review your profile and make changes, please visit the Chef Application Page on via your desktop/tablet. "),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ));

    // AwesomeDialog(
    //   context: context,
    //   dialogType: DialogType.WARNING,
    //   animType: AnimType.BOTTOMSLIDE,
    //   desc: 'To review your profile and make changes, please visit the Chef Application Page on via your desktop/tablet.',
    //   showCloseIcon: true,
    // )..show();
  }

  Future checkFirstRun(context) async {



    if (check) {
      //Whatever you want to do, E.g. Navigator.push()
      WidgetsBinding.instance.addPostFrameCallback((_) {showAlert(context); });
      check = false;
    }
  }

  void deleteChangeRequest(
      BuildContext context, User user, ProfileUpdate thisUpdate) async {
    var params = {
      'chefId': user.uid,
      '_id': thisUpdate.getId(),
      'action': 'DELETE'
    };
    var response = await http.post(Uri.parse(
        Globals.BASE_URL + "api/chefapp/v1/sendProfileUpdateRequest"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    if (response.statusCode == 200) {
      print(response.body);
      Globals.showToast("Change has been deleted");
      Globals.getUserProfile(user);
      Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new Profile(),
          ));
    } else {
      print(response.body);
    }
  }
}
