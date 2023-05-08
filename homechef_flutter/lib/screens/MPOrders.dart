import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homechefflutter/models/Order.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/ui/DishDetailPopup.dart';
import 'package:homechefflutter/ui/DishImage.dart';

class MPOrders extends StatelessWidget {

  final List<Order> _orderList;
  final String day;

  MPOrders(this._orderList, this.day);

  @override
  Widget build(BuildContext context) {
    List<Order> _mergedOrderList = List();

    for (var a = 0; a < _orderList.length; a++) {
      var found = false;
      for (var b = 0; b < _mergedOrderList.length; b++) {
        if (_mergedOrderList.elementAt(b).dishes[0].name ==
            _orderList.elementAt(a).dishes[0].name) {
          _mergedOrderList.elementAt(b).dishes[0].quantity +=
              _orderList.elementAt(a).dishes[0].quantity;
          _mergedOrderList.elementAt(b).dishes[0].sub_title =
              _orderList.elementAt(a).sub_title;
          found = true;
        }
      }
      if (!found) {
        Order o =
            Order.fromJson(jsonDecode(jsonEncode(_orderList.elementAt(a))));
        o.dishes[0].sub_title = _orderList.elementAt(a).sub_title;
        o.dishes[0].quantity = _orderList.elementAt(a).dishes[0].quantity;
        _mergedOrderList.add(o);
      }
    }

    return ChefAppScaffold(title: day,
      showHomeButton: true,
      showBackButton: true,
      showNotifications: true,
      body: Container(
        color: Colors.black12,
        child: ListView.builder(
            itemCount: _mergedOrderList == null ? 0 : _mergedOrderList.length,
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 0),
                    //width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, right: 30, left: 30),
                          child: Divider(color: Colors.black),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.access_time),
                              Text(
                                "  Pickup Details",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              /*Text(
                                "| " +
                                    (_mergedOrderList[index]
                                            .sub_title
                                            .contains("Dinner")
                                        ? "Dinner"
                                        : "Lunch"),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),*/
                              (_mergedOrderList[index].sub_chef_pickup_time == "") ? Container() : Text("| " + _mergedOrderList[index].sub_chef_pickup_time, style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, right: 30, left: 30),
                          child: Divider(color: Colors.black),
                        ),
                        Row(
                          children: <Widget>[
                            DishImage(_mergedOrderList[index].dishes[0].photo),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: 10, top: 5, bottom: 5, left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      _mergedOrderList[index].dishes[0].name,
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            /*margin: EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.lightGreen,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            "Rs: " +
                                                _mergedOrderList[index]
                                                    .dishes[0]
                                                    .price
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17),
                                          ),*/
                                            ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "Qty: ",
                                                style: TextStyle(fontSize: 17),
                                              ),
                                              Container(
                                                //margin: EdgeInsets.only(top: 5)
                                                decoration: BoxDecoration(
                                                  color: Colors.lightGreen,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  _mergedOrderList[index]
                                                      .dishes[0]
                                                      .quantity
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: InkWell(
                                          child: Text(
                                            "View dish details",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.deepOrangeAccent),
                                          ),
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (_) => DishDetailPopup(
                                                    _mergedOrderList[index]
                                                        .dishes[0],
                                                    "sub"));
                                          },
                                        ))
                                  ],
                                ),
                              ),
                              flex: 4,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
