import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homechefflutter/ui/DishImage.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/models/AlcDishesApproved.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:homechefflutter/utils/Globals.dart';
import 'dart:convert';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flushbar/flushbar.dart';
import 'package:homechefflutter/screens/Dish_Details.dart';

class AlcDishes extends StatefulWidget {
  @override
  _AlcDishesState createState() => _AlcDishesState();
}

final myController = TextEditingController();

class _AlcDishesState extends State<AlcDishes>
    with SingleTickerProviderStateMixin {
  List<AlcDishesApproved> _dishlist = new List();
  List<AlcDishesApproved> _activelist = new List();
  List<AlcDishesApproved> _inactivelist = new List();
  List<AlcDishesApproved> _alllist = new List();

  TabController _controller;

  var allcount = 0;
  var activecount = 0;
  var inactivecount = 0;
  User user;
  int _selectedIndex=0;

  List<String> _options = [
    'Name',
    'Highest Rated',
    'Total Orders',
    'Price Low to High',
    'Price High to Low'
  ];

  Widget _buildChips() {
    List<Widget> chips = new List();

    for (int i = 0; i < _options.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedIndex == i,
        label: Text(_options[i],
            style: TextStyle(
                color: _selectedIndex == i
                    ? Color(0xFFFFFFFF)
                    : Color(0xFF656565))),
        //elevation: 10,
        pressElevation: 5,

        shape: StadiumBorder(
            side: BorderSide(
              color: _selectedIndex == i ? Color(0xFFFF7A18) : Color(
                  0xFF656565),
              width: 1.5,
            )),
        //shadowColor: Colors.teal,
        backgroundColor: Colors.white,
        selectedColor: Color(0xFFFF7A18),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndex = i;
            }
          });
        },
      );

      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), child: choiceChip));
    }
    return Wrap(
      // This next line does the trick.
      //scrollDirection: Axis.vertical,
      children: chips,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      vsync: this,
      length: 4,
      initialIndex: 1,
    );
    myController.addListener(() {
      // if (myController.text.isEmpty) {
      //   setState(() {
      //     _alllist.clear();
      //     _alllist = _dishlist;
      //   });
      // } else {
      setState(() {

        _alllist.clear();
        _inactivelist.clear();
        _activelist.clear();
        for (int i = 0; i < _dishlist.length; i++) {
          if (_dishlist[i].dishName.toLowerCase().contains(myController.text)) {
            _alllist.add(_dishlist[i]);
            if(_dishlist[i].isactive=="true")
              {
                _activelist.add(_dishlist[i]);
              }
            else
              {
                _inactivelist.add(_dishlist[i]);
              }
          }
        }
        allcount=_alllist.length;
        activecount = _activelist.length;
        inactivecount = _inactivelist.length;
        if(myController.text=="")
          {
            if (_selectedIndex != null) {
              if (_selectedIndex == 0) {
                _alllist.sort((a, b) =>
                    a.dishName.toLowerCase().compareTo(b.dishName.toLowerCase()));
                _activelist.sort((a, b) =>
                    a.dishName.toLowerCase().compareTo(b.dishName.toLowerCase()));
                _inactivelist.sort((a, b) =>
                    a.dishName.toLowerCase().compareTo(b.dishName.toLowerCase()));
              }
              if (_selectedIndex == 1) {
                _alllist.sort((a, b) => a.rating.compareTo(b.rating));
                _alllist = _alllist.reversed.toList();

                _activelist.sort((a, b) => a.rating.compareTo(b.rating));
                _activelist = _activelist.reversed.toList();

                _inactivelist.sort((a, b) => a.rating.compareTo(b.rating));
                _inactivelist = _inactivelist.reversed.toList();
              }
              if (_selectedIndex == 2) {
                _alllist.sort((a, b) => a.numorderrs.compareTo(b.numorderrs));
                _alllist = _alllist.reversed.toList();

                _activelist.sort((a, b) => a.numorderrs.compareTo(b.numorderrs));
                _activelist = _activelist.reversed.toList();

                _inactivelist.sort((a, b) => a.numorderrs.compareTo(b.numorderrs));
                _inactivelist = _inactivelist.reversed.toList();
              }
              if (_selectedIndex == 3) {
                _alllist.sort((a, b) => a.price.compareTo(b.price));

                _activelist.sort((a, b) => a.price.compareTo(b.price));

                _inactivelist.sort((a, b) => a.price.compareTo(b.price));
              }
              if (_selectedIndex == 4) {
                _alllist.sort((a, b) => a.price.compareTo(b.price));
                _alllist = _alllist.reversed.toList();

                _activelist.sort((a, b) => a.price.compareTo(b.price));
                _activelist = _activelist.reversed.toList();

                _inactivelist.sort((a, b) => a.price.compareTo(b.price));
                _inactivelist = _inactivelist.reversed.toList();
              }
            }
          }
      });
    });
    //myController.addListener(search(myController.text));
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    getDishes("api/chefapp/v1/getdishesapproved?chefid=" + user.uid, context);
    return ChefAppScaffold(
        title: "Approved Dishes",
        showNotifications: true,
        showBackButton: false,
        showHomeButton: true,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 80.0,
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: -12,
                      blurRadius: 10,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ],
                ),

                //color: Colors.white,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  // child: SearchBar<AlcDishesApproved>(
                  //   searchBarStyle: SearchBarStyle(
                  //     padding: EdgeInsets.only(left: 20),
                  //     backgroundColor: Colors.white,
                  //     borderRadius: BorderRadius.circular(40),
                  //
                  //   ),
                  //   hintText: "Search Dishes",
                  //   onSearch: search,
                  //
                  //   icon: Icon(
                  //     Icons.search,
                  //     color: Colors.orange,
                  //     size: 30.0,
                  //   ),
                  // ),
                  child: TextField(
                    decoration: new InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 15.0),
                      prefixIcon: Image.asset("images/search1.png"),
                      hintText: "Search Dishes",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(40.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(40.0),
                        ),
                      ),
                    ),
                    controller: myController,
                    // onSubmitted: search(myController.text),
                    //onChanged: sear(),
                  ),
                ),
              ),
            ),
            Expanded(
                child: DefaultTabController(
                    length: 4,
                    initialIndex: 1,
                    child: Column(
                      children: <Widget>[
                        Container(
                          transform: Matrix4.translationValues(0.0, -15.0, 0.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: TabBar(
                                    controller: _controller,
                                    labelColor: Color(0xFFFF7A18),
                                    unselectedLabelColor: Color(0xFF656565),
                                    isScrollable: true,
                                    tabs: [
                                      Tab(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                          child: Image.asset("images/filter3.png", height:28,width: 28,),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          "All (" + allcount.toString() + ")",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                            //color: Color(0xFF656565),
                                            height: 1.5,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          "Active (" +
                                              activecount.toString() +
                                              ")",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                            //color: Color(0xFF656565),
                                            height: 1.5,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          "Inactive (" +
                                              inactivecount.toString() +
                                              ")",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                            //color: Color(0xFF656565),
                                            height: 1.5,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ))),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _controller,
                            children: <Widget>[
                              Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              margin:
                                              EdgeInsets.only(bottom: 10),
                                              child: Text(
                                                "Sort By",
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                  //color: Color(0xFF656565),
                                                  height: 1.5,
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              )))),
                                  Container(
                                    child: _buildChips(),
                                  ),
                                  Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[

                                                ButtonTheme(
                                                    minWidth: 300,
                                                    height: 50.0,
                                                    child: RaisedButton(
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                        ),
                                                        color:
                                                        _selectedIndex != null
                                                            ? Color(0xFFFF7A18)
                                                            : Color(0xFFC4C4C4),
                                                        elevation: 3,
                                                        child: Text("Apply",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFFFFFFFF),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                        onPressed: () =>
                                                            ApplyFilter(
                                                                context)))
                                              ],
                                            )),
                                      ))
                                ],
                              ),
                              Container(

                                  child: ListView.builder(
                                      itemCount:
                                      (_alllist == null || allcount == 0)
                                          ? 0
                                          : _alllist.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector (
                                          onTap: () => {
                                            Navigator.push(context,
                                                new MaterialPageRoute(builder: (context) => new Dish_Details(dishid:_alllist[index].dishId))).then((value) => setState(() {_dishlist.clear();_alllist.clear();_activelist.clear();_inactivelist.clear();}))
                                          },
                                          child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  15, 15, 15, 0),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(3.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.15),
                                                      spreadRadius: 5,
                                                      blurRadius: 10,
                                                      offset: Offset(0,
                                                          2), // changes position of shadow
                                                    ),
                                                  ]),
                                              child: Column(children: [
                                                Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: DishImage(
                                                              _alllist[index]
                                                                  .dishImage),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 50,
                                                              transform: Matrix4
                                                                  .translationValues(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  _alllist[index]
                                                                      .dishName,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  textScaleFactor: 1.0,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      16,
                                                                      color: Color(
                                                                          0xFF656565),
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    right: 5),
                                                                child: Container(
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: Color(
                                                                        0xFFf6f6f6),
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        10.0),
                                                                  ),
                                                                  width: double
                                                                      .infinity,
                                                                  height: 72,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .fromLTRB(
                                                                                    10,
                                                                                    5,
                                                                                    0,
                                                                                    0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets
                                                                                          .fromLTRB(
                                                                                          0,
                                                                                          0,
                                                                                          5,
                                                                                          0),
                                                                                      child: Image
                                                                                          .asset(
                                                                                          "images/clock.png",width: 16),
                                                                                    ),
                                                                                    Text(
                                                                                      _alllist[index]
                                                                                          .Dishhrs +
                                                                                          " hrs",textScaleFactor: 1.0,
                                                                                      style: TextStyle(
                                                                                        height: 1.5,
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w500,
                                                                                        fontSize: 13,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .fromLTRB(
                                                                                    0,
                                                                                    5,
                                                                                    10,
                                                                                    0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      "Rs",
                                                                                      textScaleFactor: 1.0,
                                                                                      style: TextStyle(
                                                                                        height: 1.5,
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w600,
                                                                                        fontSize: 10,
                                                                                      ),
                                                                                    ),
                                                                                    Text(_alllist[index].price.toString()!="null"?
                                                                                      _alllist[index]
                                                                                          .price.toString():"-",textScaleFactor: 1.0,
                                                                                      style: TextStyle(
                                                                                        height: 1.5,
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w700,
                                                                                        fontSize: 19,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .fromLTRB(
                                                                                    10,
                                                                                    0,
                                                                                    0,
                                                                                    5),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets
                                                                                          .fromLTRB(
                                                                                          0,
                                                                                          0,
                                                                                          5,
                                                                                          0),
                                                                                      child: Image
                                                                                          .asset(
                                                                                          "images/weighing-machine.png",width: 16,),
                                                                                    ),
                                                                                    Text(
                                                                                      _alllist[index]
                                                                                          .dishmeasurement +
                                                                                          " " +
                                                                                          _alllist[index]
                                                                                              .servingtype,textScaleFactor: 1.0,
                                                                                      style: TextStyle(
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w500,
                                                                                        fontSize: 12,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .fromLTRB(
                                                                                    0,
                                                                                    0,
                                                                                    10,
                                                                                    5),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets
                                                                                          .fromLTRB(
                                                                                          0,
                                                                                          0,
                                                                                          5,
                                                                                          0),
                                                                                      child: Image
                                                                                          .asset(
                                                                                          "images/soup.png",width: 16),
                                                                                    ),
                                                                                    Text(_alllist[index]
                                                                                        .serves!="null"?
                                                                                      "Serves " +
                                                                                          _alllist[index]
                                                                                              .serves:"-",textScaleFactor: 1.0,
                                                                                      style: TextStyle(
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w500,
                                                                                        fontSize: 12,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                  //,
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                                Column(children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(
                                                            15, 5, 10, 15),
                                                        child: Container(
                                                          width: 120,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                    "images/rating_star.png"),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      5,
                                                                      0,
                                                                      0,
                                                                      0),
                                                                  child: Text(_alllist[index]
                                                                      .rating!="0"?
                                                                    _alllist[index]
                                                                        .rating +
                                                                        " (" +
                                                                        _alllist[
                                                                        index]
                                                                            .totalrating +
                                                                        ")":"-",textScaleFactor: 1.0,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        13,
                                                                        color: Color(
                                                                            0xFF656565)),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          // /crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0,
                                                                  5,
                                                                  0,
                                                                  15),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                            "images/sent.png",width: 16),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .fromLTRB(
                                                                              5,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                          Text(
                                                                            _alllist[index]
                                                                                .numorderrs.toString() +
                                                                                " Orders",textScaleFactor: 1.0,
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight
                                                                                    .w600,
                                                                                color: Color(
                                                                                    0xFF656565)),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                        transform: Matrix4
                                                                            .translationValues(
                                                                            -10.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                        FlutterSwitch(
                                                                            width:
                                                                            85.0,
                                                                            height:
                                                                            28.0,
                                                                            value: _alllist[index]
                                                                                .isactive ==
                                                                                "true"
                                                                                ? true
                                                                                : false,
                                                                            activeColor:
                                                                            Color(
                                                                                0xFF8CC248),
                                                                            inactiveColor:
                                                                            Color(
                                                                                0xFFFF4444),
                                                                            activeText:
                                                                            "Active",
                                                                            inactiveText:
                                                                            "Inactive",
                                                                            showOnOff:
                                                                            true,
                                                                            valueFontSize:
                                                                            12,
                                                                            toggleSize:
                                                                            20,
                                                                            inactiveTextColor:
                                                                            Colors
                                                                                .black,
                                                                            inactiveTextFontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                            activeTextColor:
                                                                            Colors
                                                                                .black,
                                                                            activeTextFontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                            onToggle: (
                                                                                val) =>
                                                                                _popupDialog(
                                                                                    context,
                                                                                    _alllist[index]
                                                                                        .isactive,
                                                                                    _alllist[index]
                                                                                        .dishId,
                                                                                    index,
                                                                                    "all")
                                                                        ))
                                                                  ]),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ])
                                              ])),
                                        );
                                      })),
                              Container(
                                  child: ListView.builder(
                                      itemCount: (_activelist == null ||
                                          activecount == 0)
                                          ? 0
                                          : _activelist.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () => {
                                            Navigator.push(context,
                                                new MaterialPageRoute(builder: (ctxt) => new Dish_Details(dishid:_activelist[index].dishId)))
                                          },
                                          child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  15, 15, 15, 0),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(3.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.15),
                                                      spreadRadius: 5,
                                                      blurRadius: 10,
                                                      offset: Offset(0,
                                                          2), // changes position of shadow
                                                    ),
                                                  ]),
                                              child: Column(children: [
                                                Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: DishImage(
                                                              _activelist[index]
                                                                  .dishImage),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 50,
                                                              transform: Matrix4
                                                                  .translationValues(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  _activelist[
                                                                  index]
                                                                      .dishName,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      16,
                                                                      color: Color(
                                                                          0xFF656565),
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    right: 5),
                                                                child: Container(
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: Color(
                                                                        0xFFf6f6f6),
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        10.0),
                                                                  ),
                                                                  width: double
                                                                      .infinity,
                                                                  height: 72,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .fromLTRB(
                                                                                    10,
                                                                                    5,
                                                                                    0,
                                                                                    0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets
                                                                                          .fromLTRB(
                                                                                          0,
                                                                                          0,
                                                                                          5,
                                                                                          0),
                                                                                      child: Image
                                                                                          .asset(
                                                                                          "images/clock.png",width: 16),
                                                                                    ),
                                                                                    Text(
                                                                                      _activelist[index]
                                                                                          .Dishhrs +
                                                                                          " hrs",
                                                                                      style: TextStyle(
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w500,
                                                                                        fontSize: 13,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .fromLTRB(
                                                                                    0,
                                                                                    5,
                                                                                    10,
                                                                                    0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      "Rs",
                                                                                      style: TextStyle(
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w600,
                                                                                        fontSize: 10,
                                                                                      ),
                                                                                    ),
                                                                                    Text(_activelist[index].price.toString()!="null"?
                                                                                      _activelist[index]
                                                                                          .price.toString():"-",
                                                                                      style: TextStyle(
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w700,
                                                                                        fontSize: 19,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .fromLTRB(
                                                                                    10,
                                                                                    0,
                                                                                    0,
                                                                                    5),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets
                                                                                          .fromLTRB(
                                                                                          0,
                                                                                          0,
                                                                                          5,
                                                                                          0),
                                                                                      child: Image
                                                                                          .asset(
                                                                                          "images/weighing-machine.png",width: 16),
                                                                                    ),
                                                                                    Text(
                                                                                      _activelist[index]
                                                                                          .dishmeasurement +
                                                                                          " " +
                                                                                          _activelist[index]
                                                                                              .servingtype,
                                                                                      style: TextStyle(
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w500,
                                                                                        fontSize: 12,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .fromLTRB(
                                                                                    0,
                                                                                    0,
                                                                                    10,
                                                                                    5),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets
                                                                                          .fromLTRB(
                                                                                          0,
                                                                                          0,
                                                                                          5,
                                                                                          0),
                                                                                      child: Image
                                                                                          .asset(
                                                                                          "images/soup.png",width: 16),
                                                                                    ),
                                                                                    Text(_activelist[index]
                                                                                        .serves!="null"?
                                                                                      "Serves " +
                                                                                          _activelist[index]
                                                                                              .serves:"-",
                                                                                      style: TextStyle(
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w500,
                                                                                        fontSize: 12,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                  //,
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                                Column(children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(
                                                            15, 5, 10, 15),
                                                        child: Container(
                                                          width: 120,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                    "images/rating_star.png"),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      5,
                                                                      0,
                                                                      0,
                                                                      0),
                                                                  child: Text(_activelist[index]
                                                                      .rating!="0"?
                                                                    _activelist[index]
                                                                        .rating +
                                                                        " (" +
                                                                        _activelist[
                                                                        index]
                                                                            .totalrating +
                                                                        ")":"-",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        13,
                                                                        color: Color(
                                                                            0xFF656565)),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          // /crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0,
                                                                  5,
                                                                  0,
                                                                  15),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                            "images/sent.png",width: 16,),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .fromLTRB(
                                                                              5,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                          Text(
                                                                            _activelist[index]
                                                                                .numorderrs.toString() +
                                                                                " Orders",
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight
                                                                                    .w600,
                                                                                color: Color(
                                                                                    0xFF656565)),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                        transform: Matrix4
                                                                            .translationValues(
                                                                            -10.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                        FlutterSwitch(
                                                                            width:
                                                                            85.0,
                                                                            height:
                                                                            28.0,
                                                                            value: _activelist[index]
                                                                                .isactive ==
                                                                                "true"
                                                                                ? true
                                                                                : false,
                                                                            activeColor:
                                                                            Color(
                                                                                0xFF8CC248),
                                                                            inactiveColor:
                                                                            Color(
                                                                                0xFFFF4444),
                                                                            activeText:
                                                                            "Active",
                                                                            inactiveText:
                                                                            "Inactive",
                                                                            showOnOff:
                                                                            true,
                                                                            valueFontSize:
                                                                            11,
                                                                            toggleSize:
                                                                            20,
                                                                            inactiveTextColor:
                                                                            Colors
                                                                                .black,
                                                                            inactiveTextFontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                            activeTextColor:
                                                                            Colors
                                                                                .black,
                                                                            activeTextFontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                            onToggle: (
                                                                                val) =>
                                                                                _popupDialog(
                                                                                    context,
                                                                                    _activelist[index]
                                                                                        .isactive,
                                                                                    _activelist[index]
                                                                                        .dishId,
                                                                                    index,
                                                                                    "active")
                                                                        ))
                                                                  ]),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ])
                                              ])),
                                        );
                                      })),
                              Container(
                                  child: ListView.builder(
                                      itemCount: (_inactivelist == null ||
                                          inactivecount == 0)
                                          ? 0
                                          : _inactivelist.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () => {
                                            Navigator.push(context,
                                                new MaterialPageRoute(builder: (ctxt) => new Dish_Details(dishid:_inactivelist[index].dishId)))
                                          },
                                          child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  15, 15, 15, 0),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(3.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.15),
                                                      spreadRadius: 5,
                                                      blurRadius: 10,
                                                      offset: Offset(0,
                                                          2), // changes position of shadow
                                                    ),
                                                  ]),
                                              child: Column(children: [
                                                Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: DishImage(
                                                              _inactivelist[index]
                                                                  .dishImage),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 50,
                                                              transform: Matrix4
                                                                  .translationValues(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  _inactivelist[
                                                                  index]
                                                                      .dishName,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      16,
                                                                      color: Color(
                                                                          0xFF656565),
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    right: 5),
                                                                child: Container(
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: Color(
                                                                        0xFFf6f6f6),
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        10.0),
                                                                  ),
                                                                  width: double
                                                                      .infinity,
                                                                  height: 72,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .fromLTRB(
                                                                                    10,
                                                                                    5,
                                                                                    0,
                                                                                    0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets
                                                                                          .fromLTRB(
                                                                                          0,
                                                                                          0,
                                                                                          5,
                                                                                          0),
                                                                                      child: Image
                                                                                          .asset(
                                                                                          "images/clock.png",width: 16),
                                                                                    ),
                                                                                    Text(
                                                                                      _inactivelist[index]
                                                                                          .Dishhrs +
                                                                                          " hrs",
                                                                                      style: TextStyle(
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w500,
                                                                                        fontSize: 13,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .fromLTRB(
                                                                                    0,
                                                                                    5,
                                                                                    10,
                                                                                    0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      "Rs",
                                                                                      style: TextStyle(
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w600,
                                                                                        fontSize: 10,
                                                                                      ),
                                                                                    ),
                                                                                    Text(_inactivelist[index].price.toString()!="null"?
                                                                                      _inactivelist[index]
                                                                                          .price.toString():"-",
                                                                                      style: TextStyle(
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w700,
                                                                                        fontSize: 19,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .fromLTRB(
                                                                                    10,
                                                                                    0,
                                                                                    0,
                                                                                    5),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets
                                                                                          .fromLTRB(
                                                                                          0,
                                                                                          0,
                                                                                          5,
                                                                                          0),
                                                                                      child: Image
                                                                                          .asset(
                                                                                          "images/weighing-machine.png",width: 16),
                                                                                    ),
                                                                                    Text(
                                                                                      _inactivelist[index]
                                                                                          .dishmeasurement +
                                                                                          " " +
                                                                                          _inactivelist[index]
                                                                                              .servingtype,
                                                                                      style: TextStyle(
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w500,
                                                                                        fontSize: 12,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .fromLTRB(
                                                                                    0,
                                                                                    0,
                                                                                    10,
                                                                                    5),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets
                                                                                          .fromLTRB(
                                                                                          0,
                                                                                          0,
                                                                                          5,
                                                                                          0),
                                                                                      child: Image
                                                                                          .asset(
                                                                                          "images/soup.png",width: 16),
                                                                                    ),
                                                                                    Text(_inactivelist[index]
                                                                                        .serves!="null"?
                                                                                      "Serves " +
                                                                                          _inactivelist[index]
                                                                                              .serves:"-",
                                                                                      style: TextStyle(
                                                                                        color: Color(
                                                                                            0xFF656565),
                                                                                        fontWeight: FontWeight
                                                                                            .w500,
                                                                                        fontSize: 12,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                  //,
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                                Column(children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(
                                                            15, 5, 10, 15),
                                                        child: Container(
                                                          width: 120,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                    "images/rating_star.png"),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      5,
                                                                      0,
                                                                      0,
                                                                      0),
                                                                  child: Text(_inactivelist[index]
                                                                      .rating!="0"?
                                                                    _inactivelist[
                                                                    index]
                                                                        .rating +
                                                                        " (" +
                                                                        _inactivelist[
                                                                        index]
                                                                            .totalrating +
                                                                        ")":"-",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        13,
                                                                        color: Color(
                                                                            0xFF656565)),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          // /crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0,
                                                                  5,
                                                                  0,
                                                                  15),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                            "images/sent.png",width: 16),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .fromLTRB(
                                                                              5,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                          Text(
                                                                            _inactivelist[index]
                                                                                .numorderrs.toString() +
                                                                                " Orders",
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight
                                                                                    .w600,
                                                                                color: Color(
                                                                                    0xFF656565)),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                        transform: Matrix4
                                                                            .translationValues(
                                                                            -10.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                        FlutterSwitch(
                                                                            width:
                                                                            85.0,
                                                                            height:
                                                                            28.0,
                                                                            value: _inactivelist[index]
                                                                                .isactive ==
                                                                                "true"
                                                                                ? true
                                                                                : false,
                                                                            activeColor:
                                                                            Color(
                                                                                0xFF8CC248),
                                                                            inactiveColor:
                                                                            Color(
                                                                                0xFFFF4444),
                                                                            activeText:
                                                                            "Active",
                                                                            inactiveText:
                                                                            "Inactive",
                                                                            showOnOff:
                                                                            true,
                                                                            valueFontSize:
                                                                            11,
                                                                            toggleSize:
                                                                            20,
                                                                            inactiveTextColor:
                                                                            Colors
                                                                                .black,
                                                                            inactiveTextFontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                            activeTextColor:
                                                                            Colors
                                                                                .black,
                                                                            activeTextFontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                            onToggle: (
                                                                                val) =>
                                                                                _popupDialog(
                                                                                    context,
                                                                                    _inactivelist[index]
                                                                                        .isactive,
                                                                                    _inactivelist[index]
                                                                                        .dishId,
                                                                                    index,
                                                                                    "inactive")
                                                                        ))
                                                                  ]),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ])
                                              ])),
                                        );
                                      })),
                            ],
                          ),
                        )
                      ],
                    ))),
          ],
        ));
  }

  getDishes(String url, BuildContext context) async {
    if (_dishlist.length > 0) return;
    var jsonResponse;
    var response = await http.get(Uri.parse(Globals.BASE_URL + url));
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      setState(() {
        allcount = jsonResponse['alldishes'];
        activecount = jsonResponse['activecount'];
        inactivecount = jsonResponse['inactivecount'];
        List dishes = jsonResponse['result'];
        for (var data in dishes) {
          var dishid = data['_id'].toString();
          var dishname = data['name'].toString();
          var prephrs = data['advancebooking']['ordernoticehrs'].toString();
          var price = data['price'];
          var servingquantity = data['servingquantity'].toString();
          var servingtype = data['servingtype'].toString();
          var serves = data['serves'].toString();
          var img = data['photos'][0]['photo'].toString();
          var numorders = data['numorders']==null?0:data['numorders'];
          var ratingcount = data['ratingcount'].toString();
          final rating_format = new NumberFormat("#.0");
          var current_dish_rating =
          rating_format.format(data['currentrating']).toString();
          print(current_dish_rating);
          var isactive = data['isactive'].toString();
          if (current_dish_rating == ".0") {
            current_dish_rating = "0";
          }
          print("here");

          // var dishImage = data[''];
          _dishlist.add(new AlcDishesApproved(
            dishid,
            img,
            dishname,
            prephrs,
            price,
            servingquantity,
            servingtype,
            serves,
            current_dish_rating,
            ratingcount,
            numorders,
            isactive,
          ));
          _alllist.add(new AlcDishesApproved(
            dishid,
            img,
            dishname,
            prephrs,
            price,
            servingquantity,
            servingtype,
            serves,
            current_dish_rating,
            ratingcount,
            numorders,
            isactive,
          ));
          if (isactive == "false") {
            print("in if");
            _inactivelist.add(new AlcDishesApproved(
              dishid,
              img,
              dishname,
              prephrs,
              price,
              servingquantity,
              servingtype,
              serves,
              current_dish_rating,
              ratingcount,
              numorders,
              isactive,
            ));
          } else {
            _activelist.add(new AlcDishesApproved(
              dishid,
              img,
              dishname,
              prephrs,
              price,
              servingquantity,
              servingtype,
              serves,
              current_dish_rating,
              ratingcount,
              numorders,
              isactive,
            ));
          }
          print("in add");
        }
        _alllist.sort((a, b) =>
            a.dishName.toLowerCase().compareTo(b.dishName.toLowerCase()));
        _activelist.sort((a, b) =>
            a.dishName.toLowerCase().compareTo(b.dishName.toLowerCase()));
        _inactivelist.sort((a, b) =>
            a.dishName.toLowerCase().compareTo(b.dishName.toLowerCase()));
      });
    } else {
      Globals.showToast(response.toString());
    }
  }

  void _popupDialog(BuildContext context, String status, String dishid,
      int index, String list) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title:RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "Are you sure you want to make this dish ",
                        style: TextStyle(
                            color: Color(0xFF656565), fontSize: 18)),
                    TextSpan(
                        text: status != "true" ? "Active?" : "Inactive?",
                        style: TextStyle(
                            color: status != "true"
                                ? Color(0xFF8CC248)
                                : Color(0xFFFF4444),
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ])),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

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

                              FirebaseAnalytics().logEvent(name: 'Toggle',parameters: {'Category':'Toggle','Action':status=="true"?"Approved Dishes - Active":"Approved Dishes - Inactive",'Label':"No"});
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          child: Text(
                            "No",
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
                                  FirebaseAnalytics().logEvent(name: 'Toggle',parameters: {'Category':'Toggle','Action':status=="true"?"Approved Dishes - Active":"Approved Dishes - Inactive",'Label':"Yes"});
                                  dish_status(status, dishid, index, list);
                                  },
                            child: Text(
                              "Yes",
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


          //   AlertDialog(
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(2.0))),
          //     title:
          //
          //     Column(
          //       children: <Widget>[
          //         Wrap(
          //           children: [
          //             RichText(
          //                 textAlign: TextAlign.center,
          //                 text: TextSpan(children: <TextSpan>[
          //                   TextSpan(
          //                       text: "Are you sure you want to make this dish ",
          //                       style: TextStyle(
          //                           color: Color(0xFF656565), fontSize: 18)),
          //                   TextSpan(
          //                       text: status != "true" ? "Active?" : "Inactive?",
          //                       style: TextStyle(
          //                           color: status != "true"
          //                               ? Color(0xFF8CC248)
          //                               : Color(0xFFFF4444),
          //                           fontWeight: FontWeight.bold,
          //                           fontSize: 18)),
          //                 ]))
          //           ],
          //         ),
          //         Container(
          //             padding: EdgeInsets.only(top: 15),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: <Widget>[
          //                 Container(
          //                   margin: EdgeInsets.only(top: 12, bottom: 10),
          //                   child: RaisedButton(
          //                     elevation: 0.0,
          //                     color: Colors.white,
          //                     //color: Colors.black38,
          //                     shape: new RoundedRectangleBorder(
          //                         borderRadius: new BorderRadius.circular(4.0),
          //                         side: BorderSide(color: Colors.black)),
          //
          //                     disabledColor: Colors.black,
          //                     //Colors.black12,
          //                     padding: EdgeInsets.only(left: 35, right: 35),
          //                     onPressed: () {
          //
          //                                 FirebaseAnalytics().logEvent(name: 'Toggle',parameters: {'Category':'Toggle','Action':status=="true"?"Approved Dishes - Active":"Approved Dishes - Inactive",'Label':"No"});
          //                                 Navigator.of(context, rootNavigator: true).pop();
          //                               },
          //                     child: Text(
          //                       "No",
          //                       textAlign: TextAlign.center,
          //                       style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
          //                     ),
          //                   ),
          //                 ),
          //                 Container(
          //                     margin: EdgeInsets.only(
          //                         top: 12, left: 15, right: 10, bottom: 10),
          //                     child: RaisedButton(
          //                       elevation: 0.0,
          //                       color: Color(0xFFFF872F),
          //                       disabledColor: Colors.black12,
          //                       shape: new RoundedRectangleBorder(
          //                           borderRadius: new BorderRadius.circular(4.0)),
          //                       padding: EdgeInsets.only(left: 35, right: 35),
          //                       onPressed: () {
          //                         FirebaseAnalytics().logEvent(name: 'Toggle',parameters: {'Category':'Toggle','Action':status=="true"?"Approved Dishes - Active":"Approved Dishes - Inactive",'Label':"Yes"});
          //                         dish_status(status, dishid, index, list);
          //                         },
          //                       child: Text(
          //                         "Yes",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           //color: Colors.white,
          //                             color: Colors.white,
          //                             fontSize: 16),
          //                       ),
          //                     )),
          //               ],
          //             ))
          //       ],
          //     ),
          //     // content: Row(
          //     //   mainAxisSize: MainAxisSize.min,
          //     //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     //   children: [
          //     //
          //     //
          //     //
          //     //
          //     //     Padding(
          //     //       padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          //     //       child: Container(
          //     //         margin: EdgeInsets.only(top: 12, bottom: 10),
          //     //         // ignore: deprecated_member_use
          //     //         child: RaisedButton(
          //     //           elevation: 0.0,
          //     //           color: Colors.white,//Color(0xFFFF7A18)
          //     //           shape: new RoundedRectangleBorder(
          //     //               side: BorderSide(color: Colors.black),
          //     //               borderRadius: new BorderRadius.circular(4.0)),
          //     //           disabledColor: Colors.black12,
          //     //           padding: EdgeInsets.only(left: 35, right: 35),
          //     //           onPressed: () {
          //     //
          //     //             FirebaseAnalytics().logEvent(name: 'Toggle',parameters: {'Category':'Toggle','Action':status=="true"?"Approved Dishes - Active":"Approved Dishes - Inactive",'Label':"No"});
          //     //             Navigator.of(context, rootNavigator: true).pop();
          //     //           },
          //     //           child: Text(
          //     //             "No",
          //     //             textAlign: TextAlign.center,
          //     //             style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
          //     //           ),
          //     //         ),
          //     //       ),
          //     //     ),
          //     //
          //     //
          //     //                                                           // ButtonTheme(
          //     //                                                           //     child: RaisedButton(
          //     //                                                           //         elevation: 0.0,
          //     //                                                           //             color: Colors.white,
          //     //                                                           //         shape: RoundedRectangleBorder(
          //     //                                                           //           borderRadius: BorderRadius.circular(7.0),
          //     //                                                           //         ),
          //     //                                                           //
          //     //                                                           //         child: Text("No",
          //     //                                                           //             style: TextStyle(
          //     //                                                           //                 color: Color(0xFFFFFFFF),
          //     //                                                           //                 fontSize: 16,
          //     //                                                           //                 fontWeight: FontWeight.w600)),
          //     //                                                           //         onPressed: () {
          //     //                                                           //           FirebaseAnalytics().logEvent(name: 'Toggle',parameters: {'Category':'Toggle','Action':status=="true"?"Approved Dishes - Active":"Approved Dishes - Inactive",'Label':"No"});
          //     //                                                           //           Navigator.of(context).pop();
          //     //                                                           //         })),
          //     //                                                           // ButtonTheme(
          //     //                                                           //     child: RaisedButton(
          //     //                                                           //         shape: RoundedRectangleBorder(
          //     //                                                           //           borderRadius: BorderRadius.circular(7.0),
          //     //                                                           //         ),
          //     //                                                           //         color: Color(0xFFFF7A18),
          //     //                                                           //         elevation: 3,
          //     //                                                           //         child: Text("Yes",
          //     //                                                           //             style: TextStyle(
          //     //                                                           //                 color: Color(0xFFFFFFFF),
          //     //                                                           //                 fontSize: 16,
          //     //                                                           //                 fontWeight: FontWeight.w600)),
          //     //                                                           //         onPressed: ()
          //     //                                                           //         {
          //     //                                                           //         FirebaseAnalytics().logEvent(name: 'Toggle',parameters: {'Category':'Toggle','Action':status=="true"?"Approved Dishes - Active":"Approved Dishes - Inactive",'Label':"Yes"});
          //     //                                                           //             dish_status(status, dishid, index, list);})),
          //     //
          //     //     Container(
          //     //         margin: EdgeInsets.only(
          //     //             top: 12, left: 10, right: 10, bottom: 10),
          //     //         child: RaisedButton(
          //     //           elevation: 0.0,
          //     //           color: Color(0xFFFF872F),
          //     //           disabledColor: Colors.black12,
          //     //           shape: new RoundedRectangleBorder(
          //     //               borderRadius: new BorderRadius.circular(4.0)),
          //     //           padding: EdgeInsets.only(left: 35, right: 35),
          //     //           onPressed: () {
          //     //             FirebaseAnalytics().logEvent(name: 'Toggle',parameters: {'Category':'Toggle','Action':status=="true"?"Approved Dishes - Active":"Approved Dishes - Inactive",'Label':"Yes"});
          //     //             dish_status(status, dishid, index, list);
          //     //           },
          //     //           child: Text(
          //     //             "Yes",
          //     //             textAlign: TextAlign.center,
          //     //             style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w600),
          //     //           ),
          //     //         )),
          //     //
          //     //   ],
          //     // )
          // );
        });
  }

  void ApplyFilter(BuildContext context) {
    if (_selectedIndex == 0) {
      _alllist.sort((a, b) =>
          a.dishName.toLowerCase().compareTo(b.dishName.toLowerCase()));
      _activelist.sort((a, b) =>
          a.dishName.toLowerCase().compareTo(b.dishName.toLowerCase()));
      _inactivelist.sort((a, b) =>
          a.dishName.toLowerCase().compareTo(b.dishName.toLowerCase()));
      _controller.animateTo(1);
    }
    if (_selectedIndex == 1) {
      _alllist.sort((a, b) => a.rating.compareTo(b.rating));
      _alllist = _alllist.reversed.toList();

      _activelist.sort((a, b) => a.rating.compareTo(b.rating));
      _activelist = _activelist.reversed.toList();

      _inactivelist.sort((a, b) => a.rating.compareTo(b.rating));
      _inactivelist = _inactivelist.reversed.toList();
      _controller.animateTo(1);
    }
    if (_selectedIndex == 2) {
      _alllist.sort((a, b) => a.numorderrs.compareTo(b.numorderrs));
      _alllist = _alllist.reversed.toList();
      _activelist.sort((a, b) => a.numorderrs.compareTo(b.numorderrs));
      _activelist = _activelist.reversed.toList();
      _inactivelist.sort((a, b) => a.numorderrs.compareTo(b.numorderrs));
      _inactivelist = _inactivelist.reversed.toList();
      _controller.animateTo(1);
    }
    if (_selectedIndex == 3) {
      _alllist.sort((a, b) => a.price.compareTo(b.price));

      _activelist.sort((a, b) => a.price.compareTo(b.price));

      _inactivelist.sort((a, b) => a.price.compareTo(b.price));
      _controller.animateTo(1);
    }
    if (_selectedIndex == 4) {
      _alllist.sort((a, b) => a.price.compareTo(b.price));
      _alllist = _alllist.reversed.toList();

      _activelist.sort((a, b) => a.price.compareTo(b.price));
      _activelist = _activelist.reversed.toList();

      _inactivelist.sort((a, b) => a.price.compareTo(b.price));
      _inactivelist = _inactivelist.reversed.toList();
      _controller.animateTo(1);
    }
  }

  Future<http.Response> dish_status(String isactive, String id, int index,
      String list) async
  {
    var ID = id;
    var uid = user.uid;
    print(user.uid);
    if (isactive == "true") {
      if (list == "active") {
        print("true");
        await http.post(Uri.parse(
          Globals.BASE_URL + "api/chefapp/v1/dish_status"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'dishid': ID,
            'status': false,
            'chefid': uid,
          }),
        ).then((value) =>
            setState(() {
              _activelist[index].isactive = "false";
              _inactivelist.add(_activelist[index]);
              for (int i = 0; i < _alllist.length; i++) {
                if (_alllist[i].dishId == _activelist[index].dishId) {
                  _alllist[i].isactive = "false";
                  _dishlist[i].isactive = "false";
                  break;
                }
              }
              inactivecount++;
              if (activecount > 0) {
                activecount--;
              }
              _activelist.removeAt(index);
            })
        );
        Navigator.of(context, rootNavigator: true).pop();
        Flushbar(
          message: "Dish status changed successfully",
          duration: Duration(seconds: 3),
        )
          ..show(context);
      }
      else {
        print("true");
        await http.post(Uri.parse(
          Globals.BASE_URL + "api/chefapp/v1/dish_status"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'dishid': ID,
            'status': false,
            'chefid': uid,
          }),
        ).then((value) =>
            setState(() {
              _alllist[index].isactive = "false";_dishlist[index].isactive = "false";
              _inactivelist.add(_alllist[index]);
              for (int i = 0; i < _activelist.length; i++) {
                if (_activelist[i].dishId == _alllist[index].dishId) {
                  _activelist.removeAt(i);
                  break;
                }
              }
              inactivecount++;
              if (activecount > 0) {
                activecount--;
              }
            })
        );
        Navigator.of(context, rootNavigator: true).pop();
        Flushbar(
          message: "Dish Status Changed Successfully",
          duration: Duration(seconds: 3),
        )
          ..show(context);
      }
    }
    else {
      if (list == "inactive") {
        await http.post(Uri.parse(
          Globals.BASE_URL + "api/chefapp/v1/dish_status"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'dishid': id,
            'status': true,
            'chefid': uid,
          }),
        ).then((value) =>
            setState(() {
              _inactivelist[index].isactive = "true";
              _activelist.add(_inactivelist[index]);
              for (int i = 0; i < _alllist.length; i++) {
                if (_alllist[i].dishId == _inactivelist[index].dishId) {
                  _alllist[i].isactive = "true";
                  _dishlist[i].isactive = "true";
                  break;
                }
              }
              activecount++;
              if (inactivecount > 0) {
                inactivecount--;
              }
              _inactivelist.removeAt(index);
            })
        );
        Navigator.of(context, rootNavigator: true).pop();
        Flushbar(
          message: "Dish Status Changed Successfully",
          duration: Duration(seconds: 3),
        )
          ..show(context);
      }
      else {
        await http.post(Uri.parse(
          Globals.BASE_URL + "api/chefapp/v1/dish_status"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'dishid': id,
            'status': true,
            'chefid': uid,
          }),
        ).then((value) =>
            setState(() {
              _alllist[index].isactive = "true";
              _dishlist[index].isactive = "true";
              _activelist.add(_alllist[index]);
              for (int i = 0; i < _inactivelist.length; i++) {
                if (_inactivelist[i].dishId == _alllist[index].dishId) {
                  _inactivelist.removeAt(i);
                  break;
                }
              }
              activecount++;
              if (inactivecount > 0) {
                inactivecount--;
              }
            })
        );
        Navigator.of(context, rootNavigator: true).pop();
        Flushbar(
          message: "Dish Status Changed Successfully",
          duration: Duration(seconds: 3),
        )
          ..show(context);
      }
    }
    if (_selectedIndex != null) {
      if (_selectedIndex == 0) {
        _alllist.sort((a, b) =>
            a.dishName.toLowerCase().compareTo(b.dishName.toLowerCase()));
        _activelist.sort((a, b) =>
            a.dishName.toLowerCase().compareTo(b.dishName.toLowerCase()));
        _inactivelist.sort((a, b) =>
            a.dishName.toLowerCase().compareTo(b.dishName.toLowerCase()));
      }
      if (_selectedIndex == 1) {
        _alllist.sort((a, b) => a.rating.compareTo(b.rating));
        _alllist = _alllist.reversed.toList();

        _activelist.sort((a, b) => a.rating.compareTo(b.rating));
        _activelist = _activelist.reversed.toList();

        _inactivelist.sort((a, b) => a.rating.compareTo(b.rating));
        _inactivelist = _inactivelist.reversed.toList();
      }
      if (_selectedIndex == 2) {
        _alllist.sort((a, b) => a.numorderrs.compareTo(b.numorderrs));
        _alllist = _alllist.reversed.toList();

        _activelist.sort((a, b) => a.numorderrs.compareTo(b.numorderrs));
        _activelist = _activelist.reversed.toList();

        _inactivelist.sort((a, b) => a.numorderrs.compareTo(b.numorderrs));
        _inactivelist = _inactivelist.reversed.toList();
      }
      if (_selectedIndex == 3) {
        _alllist.sort((a, b) => a.price.compareTo(b.price));

        _activelist.sort((a, b) => a.price.compareTo(b.price));

        _inactivelist.sort((a, b) => a.price.compareTo(b.price));
      }
      if (_selectedIndex == 4) {
        _alllist.sort((a, b) => a.price.compareTo(b.price));
        _alllist = _alllist.reversed.toList();

        _activelist.sort((a, b) => a.price.compareTo(b.price));
        _activelist = _activelist.reversed.toList();

        _inactivelist.sort((a, b) => a.price.compareTo(b.price));
        _inactivelist = _inactivelist.reversed.toList();
      }
    }
  }
}
