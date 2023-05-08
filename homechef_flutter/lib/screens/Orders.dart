import 'package:flutter/material.dart';
import 'package:homechefflutter/models/Order.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/ui/DishDetailPopup.dart';
import 'package:homechefflutter/ui/DishImage.dart';
import 'package:intl/intl.dart';

class Orders extends StatelessWidget {
  final List<Order> _orderList;
  final String day;

  Orders(this._orderList, this.day);

  Widget build(BuildContext context) {
    var timeFormat = new DateFormat('h:mm a');

    return ChefAppScaffold(
      showHomeButton: true,
      showBackButton: true,
      showNotifications: true,
      title: day,
      body: Container(
        color: Colors.black12,
        child: ListView.builder(
            itemCount: _orderList == null ? 0 : _orderList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                //width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.only(top: 15, bottom: 15, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    (_orderList[index].rider_pickup_arrived_time == null)
                        ? SizedBox.shrink()
                        : Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                            margin: EdgeInsets.only(
                                bottom: 20, right: 10, left: 10),
                            decoration: BoxDecoration(
                                color: Color(0xFFFF7A18),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text(
                                "Order Picked Up at " +
                                    timeFormat.format(DateTime.parse(
                                            _orderList[index]
                                                .rider_pickup_arrived_time)
                                        .toLocal()),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 13)),
                          ),
                    Text(
                      "Order #" + _orderList[index].ordernum,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF656565)),
                    ),
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
                            " Pickup Details",
                            style: TextStyle(
                                fontSize: 18, color: Color(0xFF656565)),
                          ),
                          Text(
                            " | " +
                                timeFormat.format(DateTime.parse(
                                        _orderList[index].pickuptimestamp)
                                    .toLocal()),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF656565)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, bottom: 10, right: 30, left: 30),
                      child: Divider(color: Colors.black),
                    ),
                    //nested list work here
                    Container(
                      height: (150 * _orderList[index].dishes.length)
                          .roundToDouble(),
                      //margin: EdgeInsets.only(top: 5),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _orderList[index].dishes == null
                              ? 0
                              : _orderList[index].dishes.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Stack(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    DishImage(
                                        _orderList[index].dishes[i].photo),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _orderList[index]
                                                .dishes[i]
                                                .name
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF656565)),
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
                                                margin: EdgeInsets.only(top: 5),
                                                decoration: BoxDecoration(
                                                  color: Colors.lightGreen,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  "Rs. " +
                                                      _orderList[index]
                                                          .dishes[i]
                                                          .price
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 5, right: 10),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text("Qty: ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 17,
                                                            color: Color(
                                                                0xFF656565))),
                                                    Container(
                                                      //margin: EdgeInsets.only(top: 5)
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.lightGreen,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Text(
                                                        _orderList[index]
                                                            .dishes[i]
                                                            .quantity
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
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
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFFFF7A18)),
                                              ),
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) => DishDetailPopup(
                                                        _orderList[index]
                                                            .dishes[i],
                                                        "alc"));
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      flex: 4,
                                    )
                                  ],
                                )
                              ],
                            );
                          }),
                    ),
                    //nested list work end here
                    (_orderList[index].ordernotes != null &&
                            _orderList[index].ordernotes != "" &&
                            _orderList[index].ordernotes != "null")
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.deepOrangeAccent)),
                            margin:
                                EdgeInsets.only(right: 45, left: 45, top: 20),
                            child: Center(
                              child: InkWell(
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(10.0),
                                  //  color:  Colors.deepOrangeAccent,
                                  child: MaterialButton(
                                    // minWidth: MediaQuery.of(context).size.width,
                                    minWidth: MediaQuery.of(context).size.width,
                                    padding:
                                        EdgeInsets.only(left: 25, right: 25),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            content: SingleChildScrollView(
                                                child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  border: Border.all(
                                                      color: Colors.white)),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Text(
                                                          "Special Instructions",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                  0xFF656565)),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: IconButton(
                                                            icon: Icon(
                                                                Icons.close),
                                                            onPressed: () => {
                                                                  Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pop(),
                                                                }),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              5, 15, 5, 5),
                                                      child: Text(
                                                        _orderList[index]
                                                            .ordernotes
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Color(
                                                                0xFF656565)),
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 20)),
                                                  Center(
                                                    child: RaisedButton(
                                                      elevation: 5.0,
                                                      shape: new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  8.0)),
                                                      color: Colors
                                                          .deepOrangeAccent,
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      onPressed: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        "OK",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                          ));
                                    },
                                    child: Text(
                                      "Special Instructions",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              );
            }),
      ),
    );
  }

  getOrders(User user) {
    _orderList.clear();
    for (var order in user.allOrders) {
      if (order.status == "Confirmed") {
        if (order.rider_pickup_arrived_time != null &&
            order.rider_pickup_arrived_time != "")
          _orderList.add(order);
        else
          _orderList.insert(0, order);
      }
    }
  }
}
