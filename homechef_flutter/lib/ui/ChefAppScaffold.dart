import 'package:flutter/material.dart';
import 'package:homechefflutter/screens/Dashboard.dart';
import 'package:homechefflutter/screens/NavDrawer.dart';
import 'package:homechefflutter/ui/NotificationBadge.dart';

class ChefAppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final bool showNotifications;
  final bool showHomeButton;
  final bool showBackButton;
  final bool showMenuButton;

  ChefAppScaffold(
      {this.title,
      this.showNotifications,
      this.showBackButton,
      this.showHomeButton,
      this.body,
      this.showMenuButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xFFFFFF),
            //image: DecorationImage(
            //    image: AssetImage("images/app_bg.png"), fit: BoxFit.cover)
        ),
        child: Scaffold(
            drawer: (showMenuButton) ? NavDrawer() : null,
            appBar: AppBar(
              leading: !showBackButton
                  ? null
                  : IconButton(
                      icon: Image.asset("images/navbar/back.png"),
                      onPressed: () => Navigator.pop(context),
                    ),
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white, // status bar color
              title: Center(
                child:
                    Text(title, style: Theme.of(context).textTheme.headline1),
              ),
              actions: <Widget>[
                showNotifications ? NotificationBadge() : SizedBox.shrink(),
                showHomeButton
                    ? IconButton(
                        icon: Image.asset("images/navbar/home.png"),
                        onPressed: () {
                          // do something
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (ctxt) => new Dashboard()));
                        },
                      )
                    : SizedBox(width: 10)
              ],
            ),
            //backgroundColor: Colors.transparent,
            body: body));
  }
}
