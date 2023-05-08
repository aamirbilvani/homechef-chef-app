import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homechefflutter/models/Order.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/screens/MPOrders.dart';
import 'package:homechefflutter/screens/Orders.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OpenOrders extends StatefulWidget {
  @override
  _OpenOrdersState createState() => _OpenOrdersState();
}

class _OpenOrdersState extends State<OpenOrders> {
  Map<DateTime, List<Order>> orderDateMpThisWeek = new Map();
  Map<DateTime, List<Order>> orderDateMpNextWeek = new Map();
  Map<DateTime, List<Order>> orderDateReg = new Map();
  List<Order> _list = new List();
  var dateFormat = new DateFormat('E, d MMM');
  var dayFormat = new DateFormat('E');
  var weekFormat = new DateFormat('d MMM');
  var thisWeekStart = DateTime.now();
  var thisWeekEnd = DateTime.now();
  var nextWeekStart = DateTime.now();
  var nextWeekEnd = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    getOrders(user);
    return ChefAppScaffold(
      title: "Open Orders",
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
                  child: Text(
                    "DISHES (" + user.getOpenRegCount().toString() + ")",
                    style: TextStyle(color: Color(0xFF656565),fontSize: 20),
                  ),
                ),
                Tab(
                  child: Text(
                    "MEALS (" + user.getOpenMpCount().toString() + ")",
                    style: TextStyle(color: Color(0xFF656565), fontSize: 20),
                  ),
                ),
              ],
            )),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(
                                  left: 0.0,
                                  top: 50.0,
                                  right: 0.0,
                                  bottom: 0.0),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Colors.lightGreen)),
                              child: Center(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        user.getOpenRegCount().toString(),
                                        style: TextStyle(
                                            fontSize: 44,
                                            color: Color(0xFF656565)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height:500,
                          margin: EdgeInsets.only(
                              left: 20.0, top: 30.0, right: 20.0, bottom: 0.0),
                          child: Scaffold(
                            body: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: orderDateReg == null
                                    ? 0
                                    : orderDateReg.length,
                                itemBuilder: (BuildContext context, int index) {
                                  DateTime key =
                                      orderDateReg.keys.elementAt(index);
                                  return Card(
                                    color: Colors.white,
                                    child: InkWell(
                                      child: Row(children: [
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0)),
                                        Expanded(
                                          child: Text(
                                            dateFormat.format(key),
                                            style: TextStyle(
                                                color: Color(0xFF758E9A),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Text(
                                          orderDateReg[key].length.toString(),
                                          style: TextStyle(
                                              color: Color(0xFF758E9A),
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0)),
                                        (orderDateReg[key].length > 0)
                                            ? Container(
                                                height: 45,
                                                decoration: BoxDecoration(
                                                    color:
                                                        Colors.deepOrangeAccent,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    8),
                                                            bottomRight: Radius
                                                                .circular(8))),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : Container(height: 45),
                                      ]),
                                      onTap: (orderDateReg[key].length > 0)
                                          ? () => {
                                                Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                      builder: (context) =>
                                                          new Orders(
                                                              orderDateReg[key],
                                                              dateFormat
                                                                  .format(key)),
                                                    ))
                                              }
                                          : () => {},
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //second Tab View
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(
                                  left: 120.0,
                                  top: 50.0,
                                  right: 120.0,
                                  bottom: 0.0),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Colors.lightGreen)),
                              child: Center(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        user.getOpenMpCount().toString(),
                                        style: TextStyle(
                                            fontSize: 44,
                                            color: Color(0xFF656565)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 0.0, top: 20.0, right: 0.0, bottom: 0.0),
                          child: Center(
                            child: Text(
                              "This Week (" +
                                  weekFormat.format(thisWeekStart) +
                                  " to " +
                                  weekFormat.format(thisWeekEnd) +
                                  ")",
                              style: TextStyle(
                                  fontSize: 21,
                                  color: Color(0xFF656565),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        //current week list
                        Container(
                          height: 60.0 * orderDateMpThisWeek.length,
                          margin: EdgeInsets.only(
                              left: 20.0, top: 30.0, right: 20.0, bottom: 0.0),
                          child: Scaffold(
                            body: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: orderDateMpThisWeek == null
                                    ? 0
                                    : orderDateMpThisWeek.length,
                                itemBuilder: (BuildContext context, int index) {
                                  DateTime key =
                                      orderDateMpThisWeek.keys.elementAt(index);
                                  return Card(
                                    color: Colors.white,
                                    child: InkWell(
                                      child: Row(children: [
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0)),
                                        Expanded(
                                          child: Text(
                                            dayFormat.format(key),
                                            style: TextStyle(
                                                color: Color(0xFF758E9A),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Text(
                                          getMpDayOrderCount(orderDateMpThisWeek[key]).toString(),
                                          style: TextStyle(
                                              color: Color(0xFF758E9A),
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0)),
                                        (orderDateMpThisWeek[key].length > 0)
                                            ? Container(
                                                height: 45,
                                                decoration: BoxDecoration(
                                                    color:
                                                        Colors.deepOrangeAccent,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    8),
                                                            bottomRight: Radius
                                                                .circular(8))),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : Container(height: 45),
                                      ]),
                                      onTap: (orderDateMpThisWeek[key].length >
                                              0)
                                          ? () => {
                                                Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                      builder: (ctxt) =>
                                                          new MPOrders(
                                                              orderDateMpThisWeek[
                                                                  key],
                                                              dayFormat
                                                                  .format(key)),
                                                    ))
                                              }
                                          : () => {},
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 20.0, top: 15.0, right: 20.0, bottom: 0.0),
                          child: Divider(color: Colors.black),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 0.0, top: 15.0, right: 0.0, bottom: 0.0),
                          child: Center(
                            child: Text(
                              "Next Week (" +
                                  weekFormat.format(nextWeekStart) +
                                  " to " +
                                  weekFormat.format(nextWeekEnd) +
                                  ")",
                              style: TextStyle(
                                  fontSize: 21,
                                  color: Color(0xFF656565),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        //next week list
                        Container(
                          height: 60.0 * orderDateMpNextWeek.length,
                          margin: EdgeInsets.only(
                              left: 20.0, top: 30.0, right: 20.0, bottom: 0.0),
                          child: Scaffold(
                            body: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: orderDateMpNextWeek == null
                                    ? 0
                                    : orderDateMpNextWeek.length,
                                itemBuilder: (BuildContext context, int index) {
                                  DateTime key =
                                      orderDateMpNextWeek.keys.elementAt(index);
                                  return Card(
                                    color: Colors.white,
                                    child: InkWell(
                                      child: Row(children: [
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0)),
                                        Expanded(
                                          child: Text(
                                            dayFormat.format(key),
                                            style: TextStyle(
                                                color: Color(0xFF758E9A),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Text(
                                          getMpDayOrderCount(orderDateMpNextWeek[key]).toString(),
                                          style: TextStyle(
                                              color: Color(0xFF758E9A),
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0)),
                                        (orderDateMpNextWeek[key].length > 0)
                                            ? Container(
                                                height: 45,
                                                decoration: BoxDecoration(
                                                    color:
                                                        Colors.deepOrangeAccent,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    8),
                                                            bottomRight: Radius
                                                                .circular(8))),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : Container(height: 45),
                                      ]),
                                      onTap: (orderDateMpNextWeek[key].length >
                                              0)
                                          ? () => {
                                                Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                      builder: (ctxt) =>
                                                          new MPOrders(
                                                              orderDateMpNextWeek[
                                                                  key],
                                                              dateFormat
                                                                  .format(key)),
                                                    ))
                                              }
                                          : () => {},
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ));
  }

  getOrders(user) {
    _list.clear();
    orderDateMpThisWeek.clear();
    orderDateMpNextWeek.clear();
    orderDateReg.clear();

    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final d0 = DateTime(now.year, now.month, now.day);
    orderDateReg[d0] = new List<Order>();
    final d1 = DateTime(now.year, now.month, now.day + 1);
    orderDateReg[d1] = new List<Order>();
    final d2 = DateTime(now.year, now.month, now.day + 2);
    orderDateReg[d2] = new List<Order>();
    final d3 = DateTime(now.year, now.month, now.day + 3);
    orderDateReg[d3] = new List<Order>();
    final d4 = DateTime(now.year, now.month, now.day + 4);
    orderDateReg[d4] = new List<Order>();
    final d5 = DateTime(now.year, now.month, now.day + 5);
    orderDateReg[d5] = new List<Order>();
    final d6 = DateTime(now.year, now.month, now.day + 6);
    orderDateReg[d6] = new List<Order>();

    DateTime today_dt = DateTime(now.year, now.month, now.day);
    DateTime _firstDayOfThisWeek =
        today_dt.subtract(new Duration(days: today_dt.weekday - 1));
    thisWeekStart = _firstDayOfThisWeek;
    if(_firstDayOfThisWeek.isAfter(yesterday))
      orderDateMpThisWeek[_firstDayOfThisWeek] = new List<Order>();
    _firstDayOfThisWeek = _firstDayOfThisWeek.add(new Duration(days: 1));
    if(_firstDayOfThisWeek.isAfter(yesterday))
      orderDateMpThisWeek[_firstDayOfThisWeek] = new List<Order>();
    _firstDayOfThisWeek = _firstDayOfThisWeek.add(new Duration(days: 1));
    if(_firstDayOfThisWeek.isAfter(yesterday))
      orderDateMpThisWeek[_firstDayOfThisWeek] = new List<Order>();
    _firstDayOfThisWeek = _firstDayOfThisWeek.add(new Duration(days: 1));
    if(_firstDayOfThisWeek.isAfter(yesterday))
      orderDateMpThisWeek[_firstDayOfThisWeek] = new List<Order>();
    _firstDayOfThisWeek = _firstDayOfThisWeek.add(new Duration(days: 1));
    if(_firstDayOfThisWeek.isAfter(yesterday))
      orderDateMpThisWeek[_firstDayOfThisWeek] = new List<Order>();
    _firstDayOfThisWeek = _firstDayOfThisWeek.add(new Duration(days: 1));
    if(_firstDayOfThisWeek.isAfter(yesterday))
      orderDateMpThisWeek[_firstDayOfThisWeek] = new List<Order>();
    _firstDayOfThisWeek = _firstDayOfThisWeek.add(new Duration(days: 1));
    if(_firstDayOfThisWeek.isAfter(yesterday))
      orderDateMpThisWeek[_firstDayOfThisWeek] = new List<Order>();
    thisWeekEnd = _firstDayOfThisWeek;
    _firstDayOfThisWeek = _firstDayOfThisWeek.add(new Duration(days: 1));
    nextWeekStart = _firstDayOfThisWeek;
    orderDateMpNextWeek[_firstDayOfThisWeek] = new List<Order>();
    _firstDayOfThisWeek = _firstDayOfThisWeek.add(new Duration(days: 1));
    orderDateMpNextWeek[_firstDayOfThisWeek] = new List<Order>();
    _firstDayOfThisWeek = _firstDayOfThisWeek.add(new Duration(days: 1));
    orderDateMpNextWeek[_firstDayOfThisWeek] = new List<Order>();
    _firstDayOfThisWeek = _firstDayOfThisWeek.add(new Duration(days: 1));
    orderDateMpNextWeek[_firstDayOfThisWeek] = new List<Order>();
    _firstDayOfThisWeek = _firstDayOfThisWeek.add(new Duration(days: 1));
    orderDateMpNextWeek[_firstDayOfThisWeek] = new List<Order>();
    _firstDayOfThisWeek = _firstDayOfThisWeek.add(new Duration(days: 1));
    orderDateMpNextWeek[_firstDayOfThisWeek] = new List<Order>();
    _firstDayOfThisWeek = _firstDayOfThisWeek.add(new Duration(days: 1));
    orderDateMpNextWeek[_firstDayOfThisWeek] = new List<Order>();
    _firstDayOfThisWeek = _firstDayOfThisWeek.add(new Duration(days: 1));
    nextWeekEnd = _firstDayOfThisWeek;

    for (var data in user.allOrders) {
      print(data.pickuptimestamp);
      if (data.status == 'Confirmed') {
        _list.add(data);
      }

      DateTime dt = DateTime.parse(data.pickuptimestamp).toLocal();
      DateTime dtZero = DateTime(dt.year, dt.month, dt.day);
      if (orderDateReg.containsKey(dtZero) && data.status == 'Confirmed' &&
          (data.ordertype.contains("alc") || data.ordertype.contains("dm"))) {
        orderDateReg[dtZero].add(data);
      }
      if (orderDateMpThisWeek.containsKey(dtZero) &&
          data.ordertype.contains("sub")) {
        orderDateMpThisWeek[dtZero].add(data);
      }
      if (orderDateMpNextWeek.containsKey(dtZero) &&
          data.ordertype.contains("sub")) {
        orderDateMpNextWeek[dtZero].add(data);
      }
    }
  }

  getMpDayOrderCount(List<Order> key) {
    var totes = 0;
    for(int a=0; a<key.length; a++) {
      totes += key[a].dishes[0].quantity;
    }
    return totes;
  }
}
