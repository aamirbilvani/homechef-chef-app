import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homechefflutter/models/EarningsSummary.dart';
import 'package:homechefflutter/models/Order.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/models/User.dart' as Notification;
import 'package:homechefflutter/models/UserProfile.dart';
import 'package:homechefflutter/screens/Notifications.dart';
import 'package:homechefflutter/ui/percentDialog.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notifiers.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class Globals {
  static final BASE_URL = "https://api-cdn.homechef.pk/";

  //static final BASE_URL = "http://qa.homechef.pk/";
  //static final BASE_URL = "http://192.168.18.40:3000/";
  Map<String, String> orderDate = new Map();
  static String app_version = "";
  static String build = "";
  static String firebaseToken = "";
  static FirebaseMessaging _firebaseMessaging = FirebaseMessaging();



  //static Audio backgroundAudio;
  static Timer dataTimer;
  static ProgressDialog progressDialog;

  static getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    app_version = packageInfo.version;
  }

  static getbuildversion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    build = packageInfo.buildNumber;
  }

  static showLoading(BuildContext context) {
    progressDialog = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
    );
    progressDialog.show();
  }

  static hideLoading() {
    if (progressDialog != null) {
      progressDialog.hide();
    }
  }

  static getData(user, {force = false}) {
    if (dataTimer == null)
      dataTimer = new Timer.periodic(Duration(seconds: 30), (dataTimer) {
        Globals.getData(user);
      });

    if (user.lastDataCheckTime != null) {
      int diffSecs =
          user.lastDataCheckTime.difference(DateTime.now()).inSeconds.abs();
      if (diffSecs < 60 && !force) {
        return;
      }
    }
    user.lastDataCheckTime = DateTime.now();
    Globals.getPendingOrders(user);
    Globals.getEarningsSummary(user);
    Globals.getUserProfile(user);
    Globals.getNotifications(user);
  }

  static getPendingOrders(user) async {
    var jsonResponse;
    print(Globals.BASE_URL +
        "api/v3/chefPendingOrders?ordertype=alc,dm,sub&chef=" +
        user.uid);
    var response = await http.get(Uri.parse(Globals.BASE_URL +
        "api/v3/chefPendingOrders?ordertype=alc,dm,sub&chef=" +
        user.uid));
    if (response.statusCode == 200) {
      user.allOrders.clear();
      print(response.body);
      jsonResponse = json.decode(response.body);
      for (var data in jsonResponse) {
        var order = Order.fromJson(data);
        user.allOrders.add(order);
      }
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("user", jsonEncode(user));
      user.doNotifyListeners();
    }
  }

  static getEarningsSummary(user) async {
    var jsonResponse;
    print(Globals.BASE_URL + "api/chefapp/v1/earnings?chefid=" + user.uid);
    var response = await http.get(Uri.parse(
        Globals.BASE_URL + "api/chefapp/v1/earnings?chefid=" + user.uid));
    if (response.statusCode == 200) {
      print(response.body);
      jsonResponse = json.decode(response.body);
      user.earningsSummary = EarningsSummary.fromJson(jsonResponse['data']);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("user", jsonEncode(user));
      user.doNotifyListeners();
    }
  }

  static getUserProfile(user) async {
    var jsonResponse;
    var response = await http.get(Uri.parse(
        Globals.BASE_URL + "api/chefapp/v1/profile?chefid=" + user.uid));
    var oldNotificationViewDate = user.lastNotificationViewTime;
    print(Globals.BASE_URL + "api/chefapp/v1/profile?chefid=" + user.uid);
    if (response.statusCode == 200) {
      print(response.body);
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      user.userProfile = UserProfile.fromJson(jsonResponse['data']['profile']);
      if (oldNotificationViewDate != null)
        user.lastNotificationViewTime = oldNotificationViewDate;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("user", jsonEncode(user));
      user.doNotifyListeners();
    }
  }

  /// makes a [POST] call to uploadimage,
  /// displays a PercentDialog with the upload percentage,
  /// upon successful execution, calls [_gallerylinkimage],
  /// returns fileUrl to be displayed in the UI.
  static Future<String> galleryimg(
    File img,
    isUpdate,
    index,
    List imageList,
    uid,
    BuildContext context,
  ) async {
    final ProgressValueNotifier progressValueNotifier = ProgressValueNotifier();

    // open the PercentDialog with progressValueNotifier to update the progress as and when received
    showDialog(
      context: context,
      builder: (context) => PercentDialog(progressValueNotifier),
    );

    Dio dio = new Dio();
    FormData formData = FormData.fromMap(<String, dynamic>{
      "file": await MultipartFile.fromFile(img.path, filename: img.path),
    });

    Response response = await dio.post(
      Globals.BASE_URL + "api/v1/uploadimage",
      data: formData,
      onReceiveProgress: (received, total) {
        print('received: $received');
        print('total: $total');
      },
      onSendProgress: (sent, total) {
        print('sent: $sent');
        print('total: $total');

        // update progress in the dialog
        progressValueNotifier
            .updateProgress(DownloadUploadProgress(sent, total));
      },
    );

    if (response.statusCode == 200) {
      print("URL AS FOLLOWS");
      print(response.data['fileurl']);
      _gallerylinkimage(
          response.data['fileurl'], isUpdate, index, imageList, uid);

      return response.data['fileurl'];
    } else {
      // todo: close PercentDialog and display error message
    }
  }

  // IMAGE UPLOAD API
  static _gallerylinkimage(
      String imgpath, isUpdate, index, List imageList, String uid) async {
    if (!isUpdate) {
      print(imageList.length - 1);
      await http
          .post(
        Uri.parse(Globals.BASE_URL + "api/chefapp/v1/chefuploadimg"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'index': imageList.length,
          'chefid': uid,
          'imgpath': imgpath,
        }),
      )
          .onError((error, stackTrace) {
        // todo: close PercentDialog and display error message
        return;
      });
    } else {
      await http
          .post(
        Uri.parse(Globals.BASE_URL + "api/chefapp/v1/chefeditimg"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'index': index,
          'chefid': uid,
          'imgpath': imgpath,
        }),
      )
          .onError((error, stackTrace) {
        // todo: close PercentDialog and display error message
        return;
      });
    }
  }

  static getNotifications(user) async {
    if (user == null || user.uid == "") return;
    var jsonResponse;
    print(Globals.BASE_URL + "api/chefapp/v1/notifications?chefid=" + user.uid);
    var response = await http.get(Uri.parse(
        Globals.BASE_URL + "api/chefapp/v1/notifications?chefid=" + user.uid));
    print(response.body);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      user.notifications.clear();
      for (var n in jsonResponse["data"]) {
        String title = n["title"];
        String subtitle = n["subtitle"];
        String text = n["text"];
        String type = n["type"];
        String time = n["time"];
        String entityId = n["entityId"];

        var noti = Notification.Notification(
            title, subtitle, text, type, time, entityId);

        user.notifications.add(noti);
      }
      user.doNotifyListeners();
    }
  }

  static void playOrderNotification() async {
    // backgroundAudio = Audio.load('images/order_alert.mp3',
    //     playInBackground: true, looping: false);
    // backgroundAudio.play();
  }

  static void _handleOnPosition(secs) async {
    if (secs.round() % 10 != 0) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool data = prefs.getBool("play_alert");
    print("Play alert status: " + data.toString());
    // if (data != null && data == false && backgroundAudio != null) {
    //   print("About to stop");
    //   // backgroundAudio.pause();
    //   // backgroundAudio.dispose();
    // }
  }

  static void showToast(var text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void getMessage(context) {
    print(FlutterAppBadger.isAppBadgeSupported());
    _firebaseMessaging.requestNotificationPermissions();
    User user = Provider.of<User>(context, listen: false);
    print("Configuring firebase");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        Globals.getData(user);
        print(message["data"]);
        if (message["data"]["type"] == "NEW_ORDER") {
          print("Yayy new order");
          //if (user.userProfile.alerts.ring_alert_on)
          Globals.playOrderNotification();
        }
        print("GOT FIREBASE 1");
        print('on message $message');
        //setState(() => _message = message["notification"]["title"]);
        FlutterAppBadger.updateBadgeCount(1);
      },
      onResume: (Map<String, dynamic> message) async {
        Globals.getData(user);
        print("GOT FIREBASE 2");
        print('on resume $message');
        Navigator.push(context,
            new MaterialPageRoute(builder: (ctxt) => new Notifications()));
        //setState(() => _message = message["notification"]["title"]);
      },
      onLaunch: (Map<String, dynamic> message) async {
        Globals.getData(user);
        print("GOT FIREBASE 3");
        print('on launch $message');
        FlutterAppBadger.removeBadge();
        //setState(() => _message = message["notification"]["title"]);
        Navigator.push(context,
            new MaterialPageRoute(builder: (ctxt) => new Notifications()));
      },
      onBackgroundMessage: myBackgroundMessageHandler,
    );
  }

  static void getToken(user) async {
    Globals.firebaseToken = await _firebaseMessaging.getToken();

    print(Globals.firebaseToken);
    if (user != null && user.uid != null && user.uid != "") {
      Map data = {'chefId': user.uid, ''
          '': Globals.firebaseToken};
      var response = await http.post(
          Uri.parse(Globals.BASE_URL + "api/chefapp/v1/firebase_token"),
          body: data);
      print(response.body);
    }
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print(message["data"]);
  /*if (message["data"]["type"] == "NEW_ORDER") {
      print("Yayy new order");
      //if (user.userProfile.alerts.ring_alert_on)
      Globals.playOrderNotification();
    }*/
  print("GOT FIREBASE 1");
  print('on message $message');
  FlutterAppBadger.updateBadgeCount(1);

  return Future<void>.value();
}
