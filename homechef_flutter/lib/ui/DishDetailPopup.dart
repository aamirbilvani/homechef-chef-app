import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homechefflutter/models/Order.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DishDetailPopup extends StatefulWidget {
  final OrderDish d;
  final String dishType;

  DishDetailPopup(this.d, this.dishType);

  @override
  _DishDetailPopupState createState() => _DishDetailPopupState(d, dishType);
}

class _DishDetailPopupState extends State<DishDetailPopup> {
  final OrderDish d;
  final String dishType;
  final ratingFormat = new NumberFormat("#.0");
  var rating = "0.0";
  var ratingCount = 0;

  _DishDetailPopupState(this.d, this.dishType);

  @override
  void initState() {
    getDishRating();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(d.name.toString(),
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 17,
                            height:1.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF656565))),
                  )),
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
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    (d.price != 0)
                        ? Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                color: Color(0xCCFF7A18),
                                child: Text(
                                  "Rs: " + d.price.toString(),
                                  // textScaleFactor: 1.0,
                                  style: TextStyle(
                                    height: 1.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Expanded(child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 10, right: 10),
                          color: Color(0xCCFF7A18),
                          child: Wrap(children: [Text(
                              rating.toString() +
                                  " (" +
                                  ratingCount.toString() +
                                  ")",
                              style: TextStyle(color: Colors.white)
                            ),
                            Padding(padding: EdgeInsets.only(right:5)),
                            Image.asset("images/rating_star.png")
                          ]),
                        ),
                      ),)
                  ],
                ),
                height: 190.0,
                width: MediaQuery.of(context).size.width - 100.0,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                        image: new NetworkImage(d.photo.toString()),
                        fit: BoxFit.fill)),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Text(d.description.toString(),
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565),
                          fontSize: 14))),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Divider(
                  color: Color(0xFF999999),
                ),
              ),
              (dishType == "sub")
                  ? Container(
                      padding: EdgeInsets.all(10),
                      child: Row(children: [
                        Text("MP Title: ",
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xFF656565),
                                height: 1.5,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                        Text(d.sub_title.toString(),
                            style:
                                TextStyle(color: Color(0xFF656565), fontSize: 14))
                      ]))
                  : Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //DishType Circle
                          (d.type == null || d.type == "")
                              ? SizedBox.shrink()
                              : Column(
                                  children: <Widget>[
                                    Container(
                                        width: 55,
                                        height: 55,
                                        margin: EdgeInsets.only(
                                            bottom: 5, right: 5, left: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(70),
                                          border: Border.all(
                                              color: Colors.deepOrangeAccent),
                                        ),
                                        child: d.getDishTypeImage()),
                                    Container(
                                        constraints: BoxConstraints(maxWidth: 55),
                                        child: Text(
                                          d.type,
                                          textScaleFactor: 1.0,
                                          style: TextStyle(fontSize: 12,
                                          height: 1.5),
                                          textAlign: TextAlign.center,
                                        ))
                                  ],
                                ),
                          //Serves Circle
                          Column(
                            children: <Widget>[
                              Container(
                                width: 55,
                                height: 55,
                                margin:
                                    EdgeInsets.only(bottom: 5, right: 5, left: 5),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(70),
                                  border:
                                      Border.all(color: Colors.deepOrangeAccent),
                                ),
                                child: Center(
                                  child: Text(d.serves.toString(),
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                        height: 1.5,
                                          color: Colors.deepOrangeAccent,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                              Container(
                                  constraints: BoxConstraints(maxWidth: 55),
                                  child: Text(
                                    "Serves " + d.serves.toString(),
                                    textScaleFactor: 1.0,
                                    style: TextStyle(fontSize: 12,
                                    height: 1.5),

                                    textAlign: TextAlign.center,
                                  ))
                            ],
                          ),
                          //ServingType Circle
                          Column(
                            children: <Widget>[
                              Container(
                                  width: 55,
                                  height: 55,
                                  margin: EdgeInsets.only(
                                      bottom: 5, right: 5, left: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(70),
                                    border: Border.all(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                  child: Image.asset("images/servingtype.png")),
                              Container(
                                  constraints: BoxConstraints(maxWidth: 55),
                                  child: Text(
                                    d.servingquantity.toString() +
                                        " " +
                                        d.servingtype.toString(),
                                    textScaleFactor: 1.0,
                                    style: TextStyle(fontSize: 12,height: 1.5),
                                    textAlign: TextAlign.center,
                                  ))
                            ],
                          ),
                          //Dietary Needs Circle
                          (d.features == null || d.features.length == 0)
                              ? SizedBox.shrink()
                              : Column(
                                  children: <Widget>[
                                    Container(
                                        width: 55,
                                        height: 55,
                                        margin: EdgeInsets.only(
                                            bottom: 5, right: 5, left: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(70),
                                          border: Border.all(
                                              color: Colors.deepOrangeAccent),
                                        ),
                                        child: d.getDietaryNeedsImage()),
                                    Container(
                                        constraints: BoxConstraints(maxWidth: 55),
                                        child: Text(
                                          d.getFirstDietaryNeed(),
                                          textScaleFactor: 1.0,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12,height: 1.5),
                                        ))
                                  ],
                                ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  getDishRating() async {
    var jsonResponse;
    var response = await http
        .get(Uri.parse(Globals.BASE_URL + "api/chefapp/v1/dish_rating?dish=" + d.dish));
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      setState(() {
        rating = ratingFormat.format(jsonResponse['currentrating']);
        ratingCount = jsonResponse['ratingcount'];
      });
    }
  }
}
