import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homechefflutter/models/ReviewRating.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/ui/DishImage.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DishReviewAndRating extends StatefulWidget {
  @override
  _DishReviewAndRatingState createState() => _DishReviewAndRatingState();
}

class _DishReviewAndRatingState extends State<DishReviewAndRating> {
  List<ReviewRating> _reviewRatingList = new List();
  var totalCount = 0;
  User user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    getReviews("api/v3/chefdishreviews?limit=20&chefid=" + user.uid, context);

    return ChefAppScaffold(
      title: "Dish Ratings & Review",
      showNotifications: true,
      showBackButton: false,
      showHomeButton: true,
      body: Container(
            color: Colors.white,
            child: ListView.builder(
                itemCount:
                    (_reviewRatingList == null || totalCount == 0) ? 0 : _reviewRatingList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if(index == 20 && totalCount > 20) {
                    return Container(
                      color: Color(0xFFE6E4E4),
                      padding: EdgeInsets.all(15),
                      child: Text('See more reviews on the Chef Hub',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565))),
                    ); 
                  } else {
                  return Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ]),
                    child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Column(
                              children: <Widget>[
                                DishImage(_reviewRatingList[index].dishImage),
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset("images/rating_star.png"),
                                        Container(
                                            padding:
                                                EdgeInsets.fromLTRB(5, 0, 0, 0),
                                            child: Text(
                                                _reviewRatingList[index]
                                                        .totalRating +
                                                    " (" +
                                                    _reviewRatingList[index]
                                                        .ratingCount +
                                                    ")",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Color(0xFF000000),
                                                    fontWeight:
                                                        FontWeight.normal))),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Container(
                            // alignment: CrossAxisAlignment.start,
                            margin: EdgeInsets.only(
                                left: 0.0, top: 10, right: 25, bottom: 25),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_reviewRatingList[index].dishName,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Color(0xFF656565),
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2),
                                Divider(color: Color(0xFFC4C4C4)),
                                Text(
                                  "Reviewed on: " +
                                      _reviewRatingList[index].date,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.w600),
                                ),
                                _buildRatingStar(
                                    int.parse(_reviewRatingList[index].rating)),
                                Text(
                                  _reviewRatingList[index].userName,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  _reviewRatingList[index].comment,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                          flex: 3,
                        )
                      ],
                    ),
                  );}
                }),
          ),
    );
  }

  getReviews(String url, BuildContext context) async {
    if (_reviewRatingList.length > 0) return;
    var jsonResponse;
    var response = await http.get(Uri.parse(Globals.BASE_URL + url));
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      setState(() {
        totalCount = jsonResponse['total'];
        List review = jsonResponse['reviews'];
        for (var data in review) {
          var dish = data['dish'];
          var reviewer = data['reviewer'];

          var reviewerName = reviewer['name'];
          var dishName = dish['name'];
          var rating = data['rating'];
          var remarks = data['review'];
          var img = dish['photos'][0]['photo'];

          var parsedDate = DateTime.parse(data['reviewdate']).toLocal();
          var vardateFormat = new DateFormat('d/M/yy, H:mm a');
          var reviewDate = vardateFormat.format(parsedDate);

          final rating_format = new NumberFormat("#.0");
          var current_dish_rating =
              rating_format.format(dish['currentrating']).toString();

          // var dishImage = data[''];
          _reviewRatingList.add(new ReviewRating(
              img,
              dishName,
              reviewDate,
              remarks,
              reviewerName,
              rating.toString(),
              current_dish_rating,
              dish['ratingcount'].toString()));
        }
      });
    } else {
      Globals.showToast(response.toString());
    }
  }

  Widget _buildRatingStar(int i) {
    List<Widget> arr = new List();
    for (int a = 0; a < i; a++) {
      arr.add(Container(
          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: Image.asset("images/rating_star.png")));
    }
    for (int a = i; a < 5; a++) {
      arr.add(Container(
          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: Image.asset("images/rating_no_star.png")));
    }

    var cont = Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        children: arr.toList(),
      ),
    );
    return cont;
  }
}
