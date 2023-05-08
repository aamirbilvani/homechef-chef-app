import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homechefflutter/models/ProfileUpdate.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/screens/Profile.dart';
import 'package:homechefflutter/screens/ProfileEdit.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProfileChangeDetail extends StatelessWidget {
  final int _changeDetailIndex;
  ProfileUpdate thisUpdate;

  ProfileChangeDetail(this._changeDetailIndex);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    thisUpdate =
        user.userProfile.getSortedProfileUpdates()[_changeDetailIndex];
    var changeRequestDateFormat = new DateFormat('dd/MM/yyyy');
    var changeRequestTimeFormat = new DateFormat('hh:mm a');
    var changeRequestUpdatedFormat = new DateFormat('dd/MM/yyyy hh:mm a');
    DateTime parsedRequestDate =
        DateTime.parse(thisUpdate.requestDate).toLocal();

    return ChefAppScaffold(
        title: "Requested Change",
        showNotifications: true,
        showBackButton: true,
        showHomeButton: true,
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Text(
                              "Requested Change: " +
                                  thisUpdate.getUpdatedHeads() +
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
                                padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                child: Text(thisUpdate.getApprovalStatus(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color:
                                            thisUpdate.getApprovalStatusColor(),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600))))
                      ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 15),
                        child: Text(
                          "Last Updated: " +
                              changeRequestUpdatedFormat
                                  .format(parsedRequestDate),
                          style: TextStyle(
                              color: Color(0xFF758E9A),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 5, 15),
                            child: Text(
                              "Hide Details",
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            )))
                  ],
                ),
                this.getFieldDetails(user, thisUpdate),
                (thisUpdate.approvalStatus != "Pending")
                    ? SizedBox.shrink()
                    : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                            MaterialButton(
                              color: Color(0xFFEA1717),
                              padding: EdgeInsets.all(5.0),
                              onPressed: () {
                                this.deleteChangeRequest(context, user);
                              },
                              child: Text("Delete Request",
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
                                editChangeRequest(context, thisUpdate, user);
                              },
                              child: Text("Edit",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600)),
                            )
                          ]),
              ]),
        ));
  }

  Widget getFieldDetails(User user, ProfileUpdate thisUpdate) {
    List<Widget> foo = new List();
    if (thisUpdate.businessname != null) {
      var field = getSingleBox("businessname", "Business Name", thisUpdate,
          user.userProfile.buisnessName, thisUpdate.businessname);
      foo.add(field);
    }
    if (thisUpdate.facebookurl != null) {
      var field = getSingleBox("facebookurl", "Facebook Profile", thisUpdate,
          user.userProfile.facebookProfile, thisUpdate.facebookurl);
      foo.add(field);
    }
    if (thisUpdate.altnumber != null) {
      var field = getSingleBox("altnumber", "Alternate Contact No.", thisUpdate,
          user.userProfile.alternateContact, thisUpdate.altnumber);
      foo.add(field);
    }
    if (thisUpdate.about != null) {
      var field = getSingleBox("about", "About Me", thisUpdate,
          user.userProfile.aboutMe, thisUpdate.about);
      foo.add(field);
    }
    if (thisUpdate.foodstory != null) {
      var field = getSingleBox("foodstory", "Food Story", thisUpdate,
          user.userProfile.foodStory, thisUpdate.foodstory);
      foo.add(field);
    }
    if (thisUpdate.speciality != null) {
      var field = getSingleBox("speciality", "My Speciality", thisUpdate,
          user.userProfile.mySpeciality, thisUpdate.speciality);
      foo.add(field);
    }
    if (thisUpdate.cuisines != null) {
      var field = getSingleBox(
          "cuisines",
          "Master Cuisines",
          thisUpdate,
          user.userProfile.masterCuisine.join(", "),
          thisUpdate.cuisines.join(", "));
      foo.add(field);
    }
    return new Column(children: foo);
  }

  Widget getSingleBox(updateFieldText, stringText, thisUpdate, userFieldValue,
      updateFieldValue) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              Expanded(
                  child: Text(
                stringText,
                style: TextStyle(
                    color: Color(0xFF758E9A),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
              (thisUpdate.approvalStatus == "Pending" ||
                      thisUpdate.getFieldStatus(updateFieldText) == null)
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Image.asset(
                        (thisUpdate.getFieldStatus(updateFieldText) ==
                                'approve')
                            ? "images/icon_check.png"
                            : "images/icon_cross.png",
                        width: 20,
                        height: 20,
                      )),
              (thisUpdate.approvalStatus == "Pending" ||
                      thisUpdate.getFieldStatus(updateFieldText) == null)
                  ? Container():
                  // : Text(
                  //     (thisUpdate.getFieldStatus(updateFieldText) == 'approve')
                  //         ? "Approved"
                  //         : "Rejected",
                  //     style:
                  //         TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  //   )
              (thisUpdate.getFieldStatus(updateFieldText) == 'approve')? Text("Approved ", style:
            TextStyle(fontSize: 14, fontWeight: FontWeight.w400),): Padding(
                padding: EdgeInsets.fromLTRB(1, 0, 0, 0),
                child:
                Text("Rejected   ",style:
            TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
              ),

            ]),
            (thisUpdate.approvalStatus != "Pending")
                ? Container()
                : Container(
                    child: Text(
                    userFieldValue,
                    style: TextStyle(
                        color: Color(0xFF758E9A),
                        decoration: TextDecoration.lineThrough,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )),
            Text(
              updateFieldValue,
              style: TextStyle(
                  color: Color(0xFF758E9A),
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            (thisUpdate.getFieldNotes(updateFieldText) == "")
                ? SizedBox.shrink()
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(1),
                    margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    decoration: BoxDecoration(
                        color: Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Color(0xFFC4C4C4), width: 1)),
                    child: Text(
                      thisUpdate.getFieldNotes(updateFieldText),
                      style: TextStyle(
                          color: Color(0xFF758E9A),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ))
          ],
        ));
  }

  void deleteChangeRequest(BuildContext context, User user) async {
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

  void editChangeRequest(context, ProfileUpdate pu, User user) {
    pu.mergeWithChefProfile(user);
    Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new ProfileEdit(pu),
        ));
  }
}
