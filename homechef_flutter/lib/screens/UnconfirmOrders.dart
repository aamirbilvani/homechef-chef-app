import 'package:flutter/material.dart';
import 'package:homechefflutter/models/Order.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/ui/DishDetailPopup.dart';
import 'package:homechefflutter/ui/DishImage.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UnConfirmOrders extends StatefulWidget {
  @override
  _UnConfirmOrdersState createState() => _UnConfirmOrdersState();
}

class _UnConfirmOrdersState extends State<UnConfirmOrders> {
  List<Order> _orderList = new List();
  User user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    getOrders(user);
    return Container(child: buildMe(context));
  }

  Widget buildMe(BuildContext context) {
    return ChefAppScaffold(
      title: "Unconfirmed Orders",
      showNotifications: true,
      showBackButton: false,
      showHomeButton: true,
      body: (_orderList == null || _orderList.length == 0)
          ? Container(
              alignment: Alignment.center,
              child: Text("You have no unconfirmed orders",
                  style: Theme.of(context).textTheme.headline1))
          : Container(
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
                            (!_orderList[index].isChefConfirmed())
                                ? SizedBox.shrink()
                                : Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    margin: EdgeInsets.only(
                                        bottom: 20, right: 10, left: 10),
                                    decoration: BoxDecoration(
                                        color: (_orderList[index]
                                                    .confirmations
                                                    .chef ==
                                                "Confirmed")
                                            ? Color(0xFFFF7A18)
                                            : Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: (_orderList[index]
                                                .confirmations
                                                .chef ==
                                            "Confirmed")
                                        ? Text(
                                            "Chef Confirmed, Awaiting Foodie Confirmation",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                fontSize: 13))
                                        : Text(
                                            "Chef Refused, Awaiting HomeChef Cancellation",
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
                            //nested list work here
                            Container(
                              height: (150 * _orderList[index].dishes.length)
                                  .roundToDouble(),
                              //margin: EdgeInsets.only(top: 5),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _orderList[index].dishes.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Stack(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            DishImage(_orderList[index]
                                                .dishes[i]
                                                .photo),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: 10,
                                                    top: 5,
                                                    bottom: 5,
                                                    left: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      _orderList[index]
                                                          .dishes[i]
                                                          .name,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color:
                                                              Color(0xFF656565),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .lightGreen,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Text(
                                                            "Rs: " +
                                                                _orderList[
                                                                        index]
                                                                    .dishes[i]
                                                                    .price
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 17,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Text("Qty: "),
                                                              Container(
                                                                //margin: EdgeInsets.only(top: 5)
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .lightGreen,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child: Text(
                                                                  _orderList[
                                                                          index]
                                                                      .dishes[i]
                                                                      .quantity
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          17,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 15),
                                                      child: InkWell(
                                                        child: Text(
                                                          "View dish details",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                  0xFFFF7A18)),
                                                        ),
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (_) => DishDetailPopup(
                                                                  _orderList[
                                                                          index]
                                                                      .dishes[i],
                                                                  "alc"));
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              flex: 4,
                                            )
                                          ],
                                        )
                                      ],
                                    );
                                  }),
                            ),
                            //nested lit work end here
                            //bottom design work
                            Container(
                              margin: EdgeInsets.only(
                                  top: 3, bottom: 3, right: 25, left: 25),
                              child: Divider(color: Colors.black),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.access_time),
                                    Text(
                                      " Pickup Details",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF656565)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                _orderList[index].getFormattedPickup(),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF656565)),
                              ),
                            ),
                            (!_orderList[index].hasOrderNotes())
                                ? Container()
                                : Container(
                                    margin: EdgeInsets.only(
                                        right: 30, left: 20, top: 20),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: RaisedButton(
                                        elevation: 5.0,
                                        color: (_orderList[index]
                                                .chef_ordernotes_viewed)
                                            ? Colors.white
                                            : Colors.deepOrangeAccent,
                                        shape: new RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.deepOrangeAccent),
                                            borderRadius:
                                                new BorderRadius.circular(8.0)),
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        onPressed: () {
                                          markOrderNotesViewed(
                                              _orderList[index].getId(),
                                              user.uid);
                                          showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                                content: SingleChildScrollView(
                                                    child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
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
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: IconButton(
                                                                icon: Icon(Icons
                                                                    .close),
                                                                onPressed:
                                                                    () => {
                                                                          Navigator.of(context, rootNavigator: true)
                                                                              .pop(),
                                                                        }),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
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
                                                          padding:
                                                              EdgeInsets.only(
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
                                                              EdgeInsets.all(
                                                                  5.0),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            "OK",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                              ));
                                        },
                                        child: Text(
                                          (_orderList[index]
                                                  .chef_ordernotes_viewed)
                                              ? "Special Instructions"
                                              : "Read Special Instructions",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: (_orderList[index]
                                                      .chef_ordernotes_viewed)
                                                  ? Color(0xFF656565)
                                                  : Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                            (_orderList[index].isChefConfirmed())
                                ? Container()
                                : Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        // Container(
                                        //   margin: EdgeInsets.only(
                                        //       top: 12, bottom: 10),
                                        //   child: RaisedButton(
                                        //     elevation: 5.0,
                                        //     color: Colors.black38,
                                        //     shape: new RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             new BorderRadius.circular(
                                        //                 8.0)),
                                        //     disabledColor: Colors.black12,
                                        //     padding: EdgeInsets.only(
                                        //         left: 35, right: 35),
                                        //     onPressed: (_orderList[index]
                                        //                 .hasOrderNotes() &&
                                        //             !_orderList[index]
                                        //                 .chef_ordernotes_viewed)
                                        //         ? null
                                        //         : () {
                                        //             showDialog(
                                        //                 context: context,
                                        //                 builder: (_) => CancelDialog(
                                        //                     _orderList[index]
                                        //                         .ordernum));
                                        //           },
                                        //     child: Text(
                                        //       "Decline",
                                        //       textAlign: TextAlign.center,
                                        //       style: TextStyle(
                                        //           color: Colors.white,
                                        //           fontSize: 16),
                                        //     ),
                                        //   ),
                                        // ),


                                        // Container(
                                        //     margin: EdgeInsets.only(
                                        //         top: 12,
                                        //         left: 10,
                                        //         right: 10,
                                        //         bottom: 10),
                                        //     child: RaisedButton(
                                        //       elevation: 5.0,
                                        //       color: Colors.deepOrangeAccent,
                                        //       disabledColor: Colors.black12,
                                        //       shape: new RoundedRectangleBorder(
                                        //           borderRadius:
                                        //               new BorderRadius.circular(
                                        //                   8.0)),
                                        //       padding: EdgeInsets.only(
                                        //           left: 35, right: 35),
                                        //       onPressed: (_orderList[index]
                                        //                   .hasOrderNotes() &&
                                        //               !_orderList[index]
                                        //                   .chef_ordernotes_viewed)
                                        //           ? null
                                        //           : () {
                                        //               changeOrderStatus(
                                        //                   _orderList[index]
                                        //                       .ordernum,
                                        //                   "Confirmed",
                                        //                   "",
                                        //                   "");
                                        //             },
                                        //       child: Text(
                                        //         "Confirm",
                                        //         textAlign: TextAlign.center,
                                        //         style: TextStyle(
                                        //             color: Colors.white,
                                        //             fontSize: 16),
                                        //       ),
                                        //     )),

                                        Container(
                                          margin: EdgeInsets.only(top: 12, bottom: 10),
                                          // ignore: deprecated_member_use
                                          child: RaisedButton(
                                            elevation: 0.0,
                                            color: Colors.white,//Color(0xFFFF7A18)
                                            shape: new RoundedRectangleBorder(
                                                side: BorderSide(color: Colors.black),
                                                borderRadius: new BorderRadius.circular(4.0)),
                                            disabledColor: Colors.black12,
                                            padding: EdgeInsets.only(left: 23, right:23),
                                              onPressed: (_orderList[index]
                                                              .hasOrderNotes() &&
                                                          !_orderList[index]
                                                              .chef_ordernotes_viewed)
                                                      ? null
                                                      : () {
                                                          showDialog(
                                                            barrierDismissible: false,
                                                              context: context,
                                                              builder: (_) => CancelDialog(
                                                                  _orderList[index]
                                                                      .ordernum));
                                                        },
                                            child: Text(
                                              "Decline",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
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
                                                  borderRadius: new BorderRadius.circular(4.0)),
                                              padding: EdgeInsets.only(left: 23, right: 23),
                                                onPressed: (_orderList[index]
                                                                  .hasOrderNotes() &&
                                                              !_orderList[index]
                                                                  .chef_ordernotes_viewed)
                                                          ? null
                                                          : () {
                                                              changeOrderStatus(
                                                                  _orderList[index]
                                                                      .ordernum,
                                                                  "Confirmed",
                                                                  "",
                                                                  "");
                                                            },
                                              child: Text(
                                                "Confirm",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w600),
                                              ),
                                            )),





                                      ],
                                    ),
                                  )
                          ],
                        ));
                  }),
            ),
    );
  }

  changeOrderStatus(String orderNumber, String status, String cancelReason,
      String cancelComments) async {
        Globals.showLoading(context);
    Map data = {
      'ordernum': orderNumber,
      'state': status,
      'source': "chefapp",
      'chef_cancel_reason': cancelReason,
      'chef_cancel_comments': cancelComments
    };
    var response = await http
        .post(Uri.parse(Globals.BASE_URL + "api/v3/chef_order_confirmation"), body: data);
    print(response.body);
    if (response.statusCode == 200) {
      Globals.hideLoading();
      Globals.showToast("Thank you for confirming your order");
      Navigator.of(context, rootNavigator: true).pop();
      Globals.getData(user, force: true);
    } else {
      Globals.hideLoading();
      Globals.showToast("An error occurred");
    }
  }

  markOrderNotesViewed(String orderId, String chefId) async {
    Map data = {'orderId': orderId, 'chefId': chefId};
    var response = await http.post(Uri.parse(
        Globals.BASE_URL + "api/chefapp/v1/ordernotes_viewed"),
        body: data);
    if (response.statusCode == 200) {
      for (int a = 0; a < _orderList.length; a++) {
        if (_orderList[a].getId() == orderId) {
          setState(() {
            _orderList[a].chef_ordernotes_viewed = true;
          });
        }
      }
      Globals.getData(user);
    } else {
      Globals.showToast("An error occurred");
    }
  }

  getOrders(User user) {
    setState(() {
      _orderList.clear();

      for (var order in user.allOrders) {
        if (order.status == "Pending") {
          if (order.isChefConfirmed())
            _orderList.add(order);
          else
            _orderList.insert(0, order);
        }
      }
    });
  }
}

class CancelDialog extends StatefulWidget {
  final orderNumber;

  CancelDialog(this.orderNumber);

  @override
  _CancelDialogState createState() => _CancelDialogState(orderNumber);
}

class _CancelDialogState extends State<CancelDialog> {
  String _cancelRadioValue = "";
  final TextEditingController cancelFeedbackController =
      new TextEditingController();
  final orderNumber;

  _CancelDialogState(this.orderNumber);

  @override
  void initState() {
    super.initState();
  }

  void _handleRadioValueChange(String value) {
    setState(() {
      _cancelRadioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Declining Reason",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => {
                          Navigator.of(context, rootNavigator: true).pop(),
                        }),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(3.0),
                border: Border.all(color: Color(0xFFC4C4C4))),
            child: Column(
              children: <Widget>[
                RadioListTile(
                  dense: true,
                  isThreeLine: false,
                  value: "Personal Reason",
                  groupValue: _cancelRadioValue,
                  onChanged: _handleRadioValueChange,
                  title: Text(
                    "Personal Reason",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF656565),
                        fontWeight: FontWeight.w600),
                  ),
                ),
                RadioListTile(
                    dense: true,
                    isThreeLine: false,
                    value: "Kitchen Closed",
                    groupValue: _cancelRadioValue,
                    onChanged: _handleRadioValueChange,
                    title: Text(
                      "Kitchen Closed",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF656565),
                          fontWeight: FontWeight.w600),
                    )),
                RadioListTile(
                    dense: true,
                    isThreeLine: false,
                    value: "Ingredients Unavailable",
                    groupValue: _cancelRadioValue,
                    onChanged: _handleRadioValueChange,
                    title: Text(
                      "Ingredients Unavailable",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF656565),
                          fontWeight: FontWeight.w600),
                    )),
                RadioListTile(
                    dense: true,
                    isThreeLine: false,
                    value: "Other",
                    groupValue: _cancelRadioValue,
                    onChanged: _handleRadioValueChange,
                    title: Text(
                      "Other",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF656565),
                          fontWeight: FontWeight.w600),
                    )),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: TextField(
                keyboardType: TextInputType.multiline,
                controller: cancelFeedbackController,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF979797)),
                maxLines: 3,
                minLines: 3,
                cursorColor: Colors.transparent,
                decoration: InputDecoration(
                  hintText: 'Please Enter Your Order Declining Reason',
                  focusColor: Colors.black38,
                  hoverColor: Colors.black38,
                  border: new OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC4C4C4)),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(8.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF8CC248))),
                ),
              )),
          Center(
              child: Material(
            borderRadius: BorderRadius.circular(3.0),
            child: MaterialButton(
              elevation: 4.0,
              disabledColor: Color(0xFFADAAA7),
              color: Color(0xFFFF7A18),
              padding: EdgeInsets.all(5.0),
              onPressed: (_cancelRadioValue == "")
                  ? null
                  : () {
                      changeOrderStatus();
                    },

              child: Text("Decline Order",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w600)),
            ),
          )),
          Container(
              padding: EdgeInsets.only(top: 15),
              child: Row(children: [
                Image.asset("images/alert-triangle.png"),
                Padding(padding: EdgeInsets.all(5)),
                Expanded(
                    child: Text(
                        "Declining an order will reduce your chef score",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF990000),
                            fontSize: 14)))
              ]))
        ],
      )),
    );
  }

  changeOrderStatus() async {
    Globals.showLoading(context);
    Map data = {
      'ordernum': orderNumber,
      'state': "Refused",
      'source': "chefapp",
      'chef_cancel_reason': _cancelRadioValue,
      'chef_cancel_comments': cancelFeedbackController.text
    };
    var response = await http
        .post(Uri.parse(Globals.BASE_URL + "api/v3/chef_order_confirmation"), body: data);
    print(response.body);
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      User user = Provider.of<User>(context, listen: false);
      Globals.getData(user, force: true);
      Globals.hideLoading();
    } else {
      Globals.hideLoading();
      Globals.showToast("An error occurred");
    }
  }
}
