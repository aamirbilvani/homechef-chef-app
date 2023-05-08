import 'package:flutter/material.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';

class Done extends StatelessWidget {
  final String doneMessage;

  Done(this.doneMessage);
  @override
  Widget build(BuildContext context) {
    return ChefAppScaffold(
      title: "",
      showNotifications: true,
      showBackButton: false,
      showHomeButton: true,
      body: Column(
        children: <Widget>[
          Container(
          child: Center(child: Image.asset("images/done.png")),
          padding: EdgeInsets.fromLTRB(0, 35, 0, 15),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(35, 25, 35, 25),
              child: Text(
                  doneMessage,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF656565),
                      fontWeight: FontWeight.w600)))
        ],
      ),
    );
  }
}
