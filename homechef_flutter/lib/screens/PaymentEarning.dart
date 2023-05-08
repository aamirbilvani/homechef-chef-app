import 'package:flutter/material.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PaymentEarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String lastPaymentAmount = "-";
    String lastPaymentDate = "";
    String lastPaymentNotes = "";
    String paymentOutstanding = "-";
    String earningMonth = "-";
    User user = Provider.of<User>(context);
    final formatter = new NumberFormat("#,###");
    if (user.earningsSummary.last_payment.amount != null &&
        user.earningsSummary.last_payment.amount != 0) {
      lastPaymentAmount = "Rs. " +
          formatter.format(user.earningsSummary.last_payment.amount.abs());
      lastPaymentNotes = user.earningsSummary.last_payment.notes;
      var parsedDate =
      DateTime.parse(user.earningsSummary.last_payment.date).toLocal();
      var vardateFormat = new DateFormat('E, d MMM yy');
      lastPaymentDate = "Paid on " + vardateFormat.format(parsedDate);
    }
    if (user.earningsSummary.balance != null) {
      paymentOutstanding =
          "Rs. " + formatter.format(user.earningsSummary.balance);
    }
    if (user.earningsSummary.earnings_this_month != null) {
      earningMonth =
          "Rs. " + formatter.format(user.earningsSummary.earnings_this_month);
    }

    return ChefAppScaffold(
      title: "Payments & Earnings",
      showNotifications: true,
      showBackButton: false,
      showHomeButton: true,
      body: Container(
          height: MediaQuery.of(context).size.height*.89,
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('images/Bg_5.png'),

              fit: BoxFit.fill,
            ),
          ),
          // color: Colors.white,
          child: ListView(
            children: <Widget>[
              Container(
                height: 180,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        child: Text(
                          "Payment Outstanding",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.all(25),
                          padding: EdgeInsets.all(12),
                          width: 70,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.green)),
                          child: Text(
                            paymentOutstanding,
                            style: TextStyle(fontSize: 22, color: Colors.black),
                          ),
                          alignment: Alignment.center),
                      flex: 2,
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.only(bottom: 10,top: 10),
                                child: Text(
                                  "Last Payment Made",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )),
                            Text(
                              lastPaymentDate,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                lastPaymentNotes,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ]),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                          margin: EdgeInsets.all(25),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.green)),
                          child: Text(
                            lastPaymentAmount,
                            style: TextStyle(fontSize: 22, color: Colors.black),
                          ),
                          alignment: Alignment.center),
                      flex: 1,
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black),
              Container(
                height: 150,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        child: Text(
                          "Earnings This Month",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.all(25),
                          padding: EdgeInsets.all(12),
                          width: 70,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.green)),
                          child: Text(
                            earningMonth,
                            style: TextStyle(fontSize: 22, color: Colors.black),
                          ),
                          alignment: Alignment.center),
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}