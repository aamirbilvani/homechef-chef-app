import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homechefflutter/models/ProfileUpdate.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';

class ProfileEdit extends StatelessWidget {
  final ProfileUpdate _profileUpdate;
  var changeRequestDateFormat = new DateFormat('dd/MM/yyyy');
  var changeRequestTimeFormat = new DateFormat('hh:mm a');
  var changeRequestUpdatedFormat = new DateFormat('dd/MM/yyyy hh:mm a');
  DateTime parsedRequestDate;
  User user;

  ProfileEdit(this._profileUpdate);

  final cuisines = [
    "American",
    "Asian Fusion",
    "BBQ",
    "British",
    "Burmese",
    "Chinese",
    "Continental",
    "European",
    "French",
    "Greek",
    "Gujrati",
    "Indian",
    "Italian",
    "Japanese",
    "Mediterranean",
    "Mexican",
    "Pakistani"
    "Pan Asian",
    "Parsi",
    "Portuguese",
    "Russian",
    "Thai",
    "Vietnamese"
  ];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    if(_profileUpdate.requestDate != null) {
      parsedRequestDate =
        DateTime.parse(_profileUpdate.requestDate).toLocal();
    }
    return ChefAppScaffold(
      title:
          (_profileUpdate.getId() == '') ? "My Profile" : "Requested Change",
      showNotifications: true,
      showBackButton: true,
      showHomeButton: true,
      body: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              (_profileUpdate.getId() == '') ? SizedBox.shrink() : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            "Requested Change: " +
                                _profileUpdate.getUpdatedHeads() +
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
                          child: Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                              child: Text(_profileUpdate.getApprovalStatus(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color:
                                          _profileUpdate.getApprovalStatusColor(),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))))
                    ]
              ),
              (_profileUpdate.getId() == '') ? SizedBox.shrink() : Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 0, 15),
                      child: Text(
                        "Last Updated: " +
                            changeRequestUpdatedFormat
                                .format(parsedRequestDate),
                        style: TextStyle(
                            color: Color(0xFF758E9A),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      )
              ),


              Container(
                margin: EdgeInsets.only(
                    left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Chef Name",
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565)),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: new TextFormField(
                        enabled: false,
                        initialValue: user.name,

                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF656565)),
                        maxLines: 1,
                        autofocus: false,
                        decoration: new InputDecoration(
                          fillColor: Color(0xffE9E9E9), filled: true,
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          hintText: 'Business Name',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff656565), width: 2.0),
                              // borderSide: BorderSide(color: Color(0xff656565)),
                              borderRadius: BorderRadius.circular(5.0)),
                        ),

                      ),
                    ),
                  ],
                ),
              ),







              Container(
                margin: EdgeInsets.only(
                    left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Business Name",
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565)),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: new TextFormField(
                        initialValue: _profileUpdate.businessname,
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF656565)),
                        maxLines: 1,
                        autofocus: false,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          hintText: 'Business Name',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff656565)),
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        validator: (value) =>
                            value.length < 1 ? 'Business name is empty' : null,
                        onSaved: (value) =>
                            _profileUpdate.businessname = value.trim(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Mobile Number",
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565)),
                    ),


                    // Text(
                    //   user.getFormattedNum(),
                    //   style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.normal,
                    //       color: Color(0xFF656565)),
                    // ),



                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: new TextFormField(
                        enabled: false,
                        initialValue: user.getFormattedNum(),
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF656565)),
                        decoration: new InputDecoration(
                            fillColor: Color(0xffE9E9E9), filled: true,
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff656565)),
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),









                  ],
                ),

              ),
              Container(
                margin: EdgeInsets.only(
                    left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Email",
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565)),
                    ),
                    // Container(
                    //   padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    //   child: Text(
                    //     user.email,
                    //     style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.normal,
                    //         color: Color(0xFF656565)),
                    //   ),
                    // ),

                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: new TextFormField(
                        enabled: false,
                        initialValue: user.email,
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF656565)),
                        decoration: new InputDecoration(
                          fillColor: Color(0xffE9E9E9), filled: true,
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff656565)),
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              Container(
                margin: EdgeInsets.only(
                    left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Chef URL",
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565)),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: new TextFormField(
                        enabled: false,
                        initialValue: user.userProfile.buisnessName == null ? "":"https://homechef.pk/"+user.userProfile.buisnessName.replaceAll(new RegExp(' '),'')+"",
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF656565)),
                        maxLines: 1,
                        autofocus: false,
                        decoration: new InputDecoration(
                          fillColor: Color(0xffE9E9E9), filled: true,
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          hintText: 'Chef URL',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff656565)),
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        //validator: (value) => value.length < 1 ? 'Password length too short' : null,
                        // onSaved: (value) =>
                        // _profileUpdate.facebookurl = value.trim(),
                      ),
                    ),
                  ],
                ),
              ),







              Container(
                margin: EdgeInsets.only(
                    left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Facebook Profile",
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565)),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: new TextFormField(
                        // enabled: false,
                        initialValue: _profileUpdate.facebookurl,
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF656565)),
                        maxLines: 1,
                        autofocus: false,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          hintText: 'Facebook Link',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff656565)),
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        //validator: (value) => value.length < 1 ? 'Password length too short' : null,
                        onSaved: (value) =>
                            _profileUpdate.facebookurl = value.trim(),
                      ),
                    ),
                  ],
                ),
              ),





              Container(
                margin: EdgeInsets.only(
                    left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Instagram Profile",
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565)),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: new TextFormField(
                        enabled: false,
                        initialValue: "Instagram Link",
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF656565)),
                        maxLines: 1,
                        autofocus: false,
                        decoration: new InputDecoration(
                          fillColor: Color(0xffE9E9E9), filled: true,
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          hintText: 'Instagram Link',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff656565)),
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        //validator: (value) => value.length < 1 ? 'Password length too short' : null,
                        // onSaved: (value) =>
                        // _profileUpdate.facebookurl = value.trim(),
                      ),
                    ),
                  ],
                ),
              ),








              Container(
                margin: EdgeInsets.only(
                    left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Twitter Profile",
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565)),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: new TextFormField(
                        enabled: false,
                        initialValue: "Twitter Profile",
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF656565)),
                        maxLines: 1,
                        autofocus: false,
                        decoration: new InputDecoration(
                          fillColor: Color(0xffE9E9E9), filled: true,
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          hintText: 'Twitter Profile',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff656565)),

                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        //validator: (value) => value.length < 1 ? 'Password length too short' : null,
                        // onSaved: (value) =>
                        // _profileUpdate.facebookurl = value.trim(),
                      ),
                    ),
                  ],
                ),
              ),



















              Container(
                margin: EdgeInsets.only(
                    left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Alternate Contact No",
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565)),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: new TextFormField(
                        initialValue: _profileUpdate.altnumber,
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF656565)),
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          hintText: 'Alternate Contact No',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff656565)),
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        // validator: (value) => value.length < 1 ? 'Password length too short' : null,
                        onSaved: (value) =>
                            _profileUpdate.altnumber = value.trim(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "About Me",
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565)),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: new TextFormField(
                        initialValue: _profileUpdate.about,
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF656565)),
                        maxLines: 3,
                        autofocus: false,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          hintText: 'About Me',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff656565)),
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        //validator: (value) => value.length < 1 ? 'Password length too short' : null,
                        onSaved: (value) => _profileUpdate.about = value.trim(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Food Story",
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565)),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: new TextFormField(
                        initialValue: _profileUpdate.foodstory,
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF656565)),
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        minLines: 2,
                        autofocus: false,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          hintText: 'Food Story',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff656565)),
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        //validator: (value) => value.length < 1 ? 'Password length too short' : null,
                        onSaved: (value) =>
                            _profileUpdate.foodstory = value.trim(),
                      ),

                    ),

                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Text(
                      "My Speciality",
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565)),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: new TextFormField(
                        initialValue: _profileUpdate.speciality,
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF656565)),
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        minLines: 2,
                        autofocus: false,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          hintText: 'My Speciality',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff656565)),
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        //validator: (value) => value.length < 1 ? 'Password length too short' : null,
                        onSaved: (value) =>
                            _profileUpdate.speciality = value.trim(),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  _showCuisineDialog(context);
                },
                child: Container(
                  margin: EdgeInsets.only(
                      left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Master Cuisnes",
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF656565)),
                      ),
                      Text(_profileUpdate.cuisines.join(", "),
                          style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Color(0xFF656565),
                              fontWeight: FontWeight.normal))
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Material(
                      //   borderRadius: BorderRadius.circular(3.0),
                      //   child: MaterialButton(
                      //     color: Color(0xFFFFFFFF),
                      //     padding: EdgeInsets.all(5.0),
                      //     onPressed: () {
                      //       Navigator.pop(context);
                      //     },
                      //     child: Text("Cancel",
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //             fontSize: 15,
                      //             color: Color(0xFF212529),
                      //             fontWeight: FontWeight.w600)),
                      //   ),
                      // ),

                      // Padding(padding: EdgeInsets.only(left:5)),



                      // RaisedButton(
                      //   elevation: 0.0,
                      //   color: Colors.white,
                      //   //color: Colors.black38,
                      //   shape: new RoundedRectangleBorder(
                      //       borderRadius: new BorderRadius.circular(4.0),
                      //       side: BorderSide(color: Colors.black)),
                      //
                      //   disabledColor: Colors.black,
                      //   //Colors.black12,
                      //   padding: EdgeInsets.only(left: 5, right: 5),
                      //   onPressed: () {
                      //     Navigator.of(context, rootNavigator: false).pop();
                      //   },
                      //   child: Text(
                      //     "Cancel",
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(color: Color(0xFF212529), fontSize: 16,fontWeight: FontWeight.w600),
                      //   ),
                      // ),


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
                          padding: EdgeInsets.only(left: 5, right: 5),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: false).pop();
                          },
                          child: Text(
                            "Cancel",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black,
                                height: 1.5,
                                fontSize: 16,fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),






                      Container(
                          margin: EdgeInsets.only(
                              top: 12, bottom: 10,left: 5),
                          child: RaisedButton(
                            elevation: 0.0,
                            color: Color(0xFFFF872F),
                            disabledColor: Colors.black12,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(4.0)),
                            padding: EdgeInsets.only(left: 5, right: 5),
                            onPressed: () {
                              final form = _formKey.currentState;
                              form.save();
                              FirebaseAnalytics().logEvent(name: 'Button',parameters: {'Category':'Button','Action':'Request Changes','Label':"Request Changes"});
                              saveProfile(user, context);
                            },
                            child: Text(
                                (_profileUpdate.getId() == '')
                                    ? "Send Changes for Approval"
                                    : "Update Changes",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.w600)),
                          )),







                      // Material(
                      //   borderRadius: BorderRadius.circular(10.0),
                      //   child: MaterialButton(
                      //     elevation: 0.0,
                      //     color: Color(0xFFFF7A18),
                      //     padding: EdgeInsets.all(5.0),
                      //     onPressed: () {
                      //       final form = _formKey.currentState;
                      //       form.save();
                      //       FirebaseAnalytics().logEvent(name: 'Button',parameters: {'Category':'Button','Action':'Request Changes','Label':"Request Changes"});
                      //       saveProfile(user, context);
                      //     },
                      //     child: Text(
                      //         (_profileUpdate.getId() == '')
                      //             ? "Send Changes for Approval"
                      //             : "Update Changes",
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //             fontSize: 15,
                      //             color: Color(0xFFFFFFFF),
                      //             fontWeight: FontWeight.w600)),
                      //   ),
                      // )



                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveProfile(User user, context) async {
    _profileUpdate.chefId = user.uid;

    var response = await http.post(Uri.parse(
        Globals.BASE_URL + "api/chefapp/v1/sendProfileUpdateRequest"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(_profileUpdate));
    if (response.statusCode == 200) {
      print(response.body);
      Globals.showToast("Changes sent for approval");
      Globals.getUserProfile(user);
      Navigator.pop(context);
    } else {
      print(response.body);
    }
  }

  _showCuisineDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Select Cuisines"),
            content: MultiSelectChip(cuisines),
            actions: <Widget>[
              FlatButton(
                child: Text("Done"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged; // +added
  MultiSelectChip(this.reportList, {this.onSelectionChanged} // +added
      );
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  _buildChoiceList(context) {
    List<Widget> choices = List();
    User user = Provider.of<User>(context);
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: user.userProfile.masterCuisine.contains(item),
          onSelected: (selected) {
            user.userProfile.masterCuisine.contains(item)
                ? user.userProfile.masterCuisine.remove(item)
                : user.userProfile.masterCuisine.add(item);
            user.doNotifyListeners();
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(context),
    );
  }
}
