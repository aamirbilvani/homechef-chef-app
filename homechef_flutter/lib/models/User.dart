import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:homechefflutter/models/EarningsSummary.dart';
import 'package:homechefflutter/models/Order.dart';
import 'package:homechefflutter/models/UserProfile.dart';
import 'package:timeago/timeago.dart' as timeago;

class User extends ChangeNotifier{
  String mobile;
  String name;
  String token;
  String uid;
  String usertype;
  String email;
  String cheflevel;
  List<Order> allOrders;
  UserProfile userProfile;
  EarningsSummary earningsSummary;
  List<Notification> notifications;
  DateTime lastNotificationViewTime;
  DateTime lastDataCheckTime;

  User(m, n, t, u, ut, e,cl) {
    mobile = m;
    name = n;
    token = t;
    uid = u;
    usertype = ut;
    email = e;
    allOrders = new List<Order>();
    userProfile = new UserProfile(n, "", m,cl, e, "", "", "", "","", "", new List<String>(),"");
    earningsSummary = new EarningsSummary(0, 0, new LatestPayment(0, "", ""));
    notifications = new List();
    lastNotificationViewTime = DateTime.parse("2010-01-01 00:00:00");
    cheflevel = cl;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'mobile': mobile,
    'token': token,
    'uid': uid,
    'email': email,
    'usertype': usertype,
    'allOrders': allOrders,
    'userProfile': userProfile,
    'earningsSummary': earningsSummary,
    'notifications': notifications,
    'lastNotificationViewTime': lastNotificationViewTime.toString(),
    'cheflevel':  cheflevel
  };

  User.fromJson(Map<String, dynamic> json)
      :   name = json['name'],
        mobile = json['mobile'],
        token = json['token'],
        uid = json['uid'],
        email = json['email'],
        usertype = json['usertype'],
        allOrders = json['allOrders'].map<Order>((i)=>Order.fromJson(i)).toList(),
        userProfile = UserProfile.fromJson(json['userProfile']),
        earningsSummary = EarningsSummary.fromJson(json['earningsSummary']),
        notifications = json['notifications'].map<Notification>((i)=>Notification.fromJson(i)).toList(),
        lastNotificationViewTime = DateTime.parse(json['lastNotificationViewTime']),
        cheflevel = json['cheflevel'];


  String getFormattedNum() {
    if(mobile.length != 11)
      return mobile;
    return mobile.substring(0, 4) + "-" + mobile.substring(4, 7) + "-" + mobile.substring(7);
  }

  String getFormattedAlternateNum() {
    if (userProfile.alternateContact == null || userProfile.alternateContact == "") {
      return "";
    } else if (userProfile.alternateContact.length != 11) {
      return userProfile.alternateContact;
    } else {
      return userProfile.alternateContact.substring(0, 4) + "-" + userProfile.alternateContact.substring(4, 7) + "-" + userProfile.alternateContact.substring(7);
    }
  }

  String getMasterCuisines() {
    return userProfile.masterCuisine.join(", ");
  }

  String getcheflevel(){
    print("LEVEL" + cheflevel);
    return cheflevel;
  }

  void doNotifyListeners() {
    print("I'm notifying");
    notifyListeners();
  }


  int getUnconfirmedOrderCount() {
    var uc = 0;
    for (var data in allOrders) {
      if (data.status == "Pending") {
        uc++;
      }
    }
    return uc;
  }

  int getOpenMpCount() {
    var uc = 0;
    for (var data in allOrders) {
      if (data.ordertype.contains("sub")) {
        uc += data.dishes[0].quantity;
      }
    }
    return uc;
  }

  int getOpenRegCount() {
    var uc = 0;
    for (var data in allOrders) {
      if (data.status == "Confirmed" && (data.ordertype.contains("alc") || data.ordertype.contains("dm"))) {
        uc++;
      }
    }
    return uc;
  }

  int getUnreadNotificationCount() {
    if(lastNotificationViewTime == null)
      return notifications.length;

    var count = 0;

    for(int a=0; a<notifications.length; a++) {
      DateTime notime = DateTime.parse(notifications[a].time).toLocal();
      if(notime.isAfter(lastNotificationViewTime)) {
        count++;
      }
    }
    return count;
  }
}

class Notification {
  String title = "";
  String subtitle = "";
  String text = "";
  String type = "";
  String time = "";
  String entityId = "";

  Notification(t, st, tx, tp, tm, id) {
    title = t;
    subtitle = st;
    text = tx;
    type = tp;
    time = tm;
    entityId = id;
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'subtitle': subtitle,
    'text': text,
    'type': type,
    'time': time,
    'entityId': entityId
  };

  Notification.fromJson(Map<String, dynamic> json)
      :   title = json['title'],
        subtitle = json['subtitle'],
        text = json['text'],
        type = json['type'],
        time = json['time'],
        entityId = json['entityId'];

  Widget getNotificationImage() {
    if(type == "NEW_ORDER")
      return Image.asset("images/notifications/NEW_ORDER.png");
    else if(type == "RIDER_ARRIVED")
      return Image.asset("images/notifications/RIDER_ARRIVED.png");
    else if(type == "ORDER_CANCELLED")
      return Image.asset("images/notifications/ORDER_CANCELLED.png");
    else if(type == "PAYMENT_MADE")
      return Image.asset("images/notifications/PAYMENT_MADE.png");
    else //if(type == "NEW_RATING")
      return Image.asset("images/notifications/NEW_RATING.png");
  }

  String getMinutesToNow() {
    var t = DateTime.parse(time).toLocal();
    return (timeago.format(t, locale: 'en_short'));
  }

  DateTime getTime() {
    return DateTime.parse(time).toLocal();
  }

}