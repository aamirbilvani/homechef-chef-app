import 'package:flutter/material.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:badges/badges.dart';
import 'package:homechefflutter/screens/Notifications.dart';
import 'package:provider/provider.dart';

class NotificationBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return InkWell(
        onTap: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (ctxt) => new Notifications()));
        },
        child: Badge(
          badgeContent: Text(
            user.getUnreadNotificationCount().toString(),
            style: TextStyle(
              fontSize: 9
            )
          ),
          //borderRadius: BorderRadius.circular(8.0),
          child: Image.asset("images/navbar/alert.png"),
          showBadge: user.getUnreadNotificationCount() == 0 ? false : true,
          position: BadgePosition.topEnd(top: 5, end: -5),
        ));
  }
}
