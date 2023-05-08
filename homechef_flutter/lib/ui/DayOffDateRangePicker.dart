import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/models/UserProfile.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';


class DayOffDateRangePicker extends StatefulWidget {
  DayOffDateRangePicker();

  @override
  _DayOffDateRangePickerState createState() => _DayOffDateRangePickerState();
}

class _DayOffDateRangePickerState extends State<DayOffDateRangePicker> {

  DateTime newOffStart;
  DateTime newOffEnd;
  User user;
  int count = 0;
  final dateFormat = new DateFormat('d MMM yyyy');
  final dayOffController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);

    return AlertDialog(



      content: SingleChildScrollView(child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white)),
        child: Container(
          //height: MediaQuery.of(context).size.height *.6,
          child:
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 15.0)),
                Align(
                    alignment: Alignment.center,
                    //height: 100,
                    //width: 100,

                    child: Center(
                        child: Text(
                      "Add Days Off",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF656565)),
                          textAlign: TextAlign.center,
                  ),
                )),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => {
                            Navigator.of(context, rootNavigator: true).pop(),
                          }),
                )
              ],
            ),
            Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("Select dates:",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565))),

                    MaterialButton(
                        elevation: 1.0,
                        shape: (newOffStart == null)? new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            side: BorderSide(color: Color(0xFFFF872F))):RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(3.0),side: BorderSide(color: Color(0xFF656565))),

                      color: (newOffStart == null)
                          ? Color(0xFFFF872F)
                          : Colors.white,
                      onPressed: () async {
                        final List<DateTime> picked =
                        await DateRangePicker.showDatePicker(
                            context: context,
                            initialFirstDate: new DateTime.now(),
                            initialLastDate: new DateTime.now()
                                .add(new Duration(days: 7)),
                            firstDate: new DateTime.now().subtract(new Duration(days: 1)),
                            lastDate: new DateTime.now().add(const Duration(days: 120)));
                        if (picked != null && picked.length == 2) {
                          newOffStart = DateTime.utc(picked[0].year, picked[0].month, picked[0].day, 0, 0, 0, 0, 0);
                          newOffEnd = DateTime.utc(picked[1].year, picked[1].month, picked[1].day, 23, 59, 59, 0, 0);

                          // Provider.of<StringProvider>(context, listen: false).setOffStart(newOffStart);
                          // Provider.of<StringProvider>(context, listen: false).setOffEnd(newOffEnd);

                          setState(() {
                            //DONT REMOVE THIS SET STATE
                          });
                        }
                      },
                      child: (newOffStart == null)
                          ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0.0)
                        ),

                        //padding: EdgeInsets.fromLTRB(36, 10, 36, 10),
                          child:
                          Center(child:Text("Select Date Range",
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600))
                            ))
                          : Container(
                          //padding: EdgeInsets.fromLTRB(0, 10, 45, 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 188.0,
                          child:
                            Text(dateFormat.format(newOffStart) +
                                  " to " + dateFormat.format(newOffEnd) , style: TextStyle(fontSize: 16, color: Color(0xFF656565)),),
                              )
                            ],
                          ))),

                    (newOffStart == null)?Container() :Container(
                        margin: const EdgeInsets.fromLTRB(0,5, 5, 0),
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green)
                        ),
                        child:
                        Text(
                            (newOffEnd.difference(newOffStart).inDays + 1).toString() + " Days Off",
                            style: TextStyle(fontSize: 16, color: Color(0xFF656565), fontWeight: FontWeight.w600))
                    ),

                // MaterialButton(
                //   child:
                //     (newOffStart == null)
                // ),

                  Padding(padding: EdgeInsets.only(top: 25)),
                  Text("Reason for leave *: ",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF656565))),
                    Padding(padding: EdgeInsets.only(top: 5)),


                    TextFormField(
                      controller: dayOffController,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF656565)
                       ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    minLines: 3,
                    autofocus: false,

                    onChanged: (text){
                        setState(() {

                        });
                    },

                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      hintText: 'Eg: Public Holidays ',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFC4C4C4),
                            width: 2.0,
                          )
                      ),
                      border: OutlineInputBorder(
                          //borderSide: new BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(3.0)),

                    ),
                  ),

                  Text(dayOffController.text == "" && count > 0?"\n Please add a reason for your leave.":"",
                  style:TextStyle(
                      color:Colors.red,
                    fontSize: 12,
                  )),

                  Padding(padding: EdgeInsets.only(top: 25)),
                  Center(child: MaterialButton(
                    color: Color(0xFFFF872F),
                    elevation: 0.0,
                    disabledColor: Color(0xFFFF872F),
                    onPressed:() {
                      setState(() {
                        count++;
                      });


                      if(dayOffController.text == "" || newOffStart == null){

                        FirebaseAnalytics().logEvent(name:'ApplyVacations',
                            parameters: {
                              'Parameter':'Fail',
                            });

                      }


                      if(dayOffController.text != "" && newOffStart != null)
                        {
                          // FirebaseAnalytics().logEvent(name: 'Button',
                          //     parameters: {'Category':'Button','Action':'Add Days Off',
                          //       'Label':newOffEnd.difference(newOffStart).inDays+1});


                          FirebaseAnalytics().logEvent(name: 'ApplyVacations',
                              parameters: {
                                'Parameter':'Success',
                              });

                          print(newOffStart);
                          // if dayOffController.text.isEmpty ? Text("IS EMPTY"):
                          DaysOff newOff = new DaysOff(newOffStart.toString(),
                              newOffEnd.toString(), dayOffController.text);
                          user.userProfile.kitchen_hours.days_off.insert(0, newOff);
                          saveKitchenHours(user);
                          print(dayOffController.text);
                          user.doNotifyListeners();
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                    },
                    child: Text("Apply", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color:Colors.white)),)
                  ),
                ])),
          ],
        ),),
      ),
    ));
  }









  void saveKitchenHours(user) async {
    Map data = {
      'chefId': user.uid,
      'kitchen_hours': user.userProfile.kitchen_hours,
      'istype':"break"
    };
    var body = json.encode(data);
    print(body);
    var response = await http.post(Uri.parse(
        Globals.BASE_URL + "api/chefapp/v1/kitchen_hours"),
        headers: {"Content-Type": "application/json"},
        body: body);
    print(response.body);
    if (response.statusCode == 200) {
      user.doNotifyListeners();
    } else {}
  }
}
