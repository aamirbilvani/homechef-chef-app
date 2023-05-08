import 'package:homechefflutter/models/User.dart';
import 'package:intl/intl.dart';

import 'ProfileUpdate.dart';

class UserProfile {

  String name;
  String buisnessName;
  String mobileNum;
  String email;
  String facebookProfile;
  String alternateContact;
  String aboutMe;
  String rating;
  String foodStory;
  String mySpeciality;
  List<String> masterCuisine;
  String img;
  bool isactive;
  ChefRating chefScore;
  Alerts alerts;
  KitchenHours kitchen_hours;
  List<ProfileUpdate> profileChangeRequests;
  List galleryimg;
  String profileurl;
  String profilelevel;

  UserProfile(n, bn, pl, mob, eml, fb, ac, abt,rt, fs, ms, mc, cu) {
    name = n;
    profileurl=cu;
    buisnessName = bn;
    profilelevel = pl;
    mobileNum = mob;
    email = eml;
    facebookProfile = fb;
    alternateContact = ac;
    aboutMe = abt;
    rating = rt;
    foodStory = fs;
    mySpeciality = ms;
    masterCuisine = mc;
    chefScore = new ChefRating();
    img = "";
    isactive = false;
    alerts = null;
    kitchen_hours = null;
    profileChangeRequests = new List();
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'profileurl':profileurl,
    'buisnessName': buisnessName,
    'profilelevel': profilelevel,
    'mobileNum': mobileNum,
    'email': email,
    'facebookProfile': facebookProfile,
    'alternateContact': alternateContact,
    'aboutMe': aboutMe,
    'currentrating': rating,
    'foodStory': foodStory,
    'mySpeciality': mySpeciality,
    'masterCuisine': masterCuisine,
    'chefrating': chefScore,
    'img': img,
    'isactive': isactive,
    'alerts': alerts,
    'kitchen_hours': kitchen_hours,
    'profileChangeRequests': profileChangeRequests
  };

  UserProfile.fromJson(Map<String, dynamic> json)
      :   name = json['name'],
        buisnessName = json['buisnessName'],
        profilelevel = json['profilelevel'],
        mobileNum = json['mobileNum'],
        email = json['email'],
        facebookProfile = json['facebookProfile'],
        alternateContact = json['alternateContact'],
        aboutMe = json['aboutMe'],
        rating = json['currentrating'].toString(),
        foodStory = json['foodStory'],
        mySpeciality = json['mySpeciality'],
        masterCuisine = json['masterCuisine'].map<String>((i)=>i.toString()).toList(),
        chefScore = ChefRating.fromJson(json['chefrating']),
        img = json['img'],
        isactive = json['isactive'],
        alerts = Alerts.fromJson(json['alerts']),
        kitchen_hours = KitchenHours.fromJson(json['kitchen_hours']),
        profileChangeRequests = json['profileChangeRequests'].map<ProfileUpdate>((i)=>ProfileUpdate.fromJson(i)).toList(),
        galleryimg = json['galleryimg'],
        profileurl = json['profileurl'];

  List<ProfileUpdate> getSortedProfileUpdates() {
    this.profileChangeRequests.sort((a, b) {
      DateTime dtA = DateTime.parse(a.requestDate).toLocal();
      DateTime dtB = DateTime.parse(b.requestDate).toLocal();
      if(dtA.isAtSameMomentAs(dtB)) {
        return 0;
      }
      if(dtA.isBefore(dtB)) {
        return 1;
      }
      return -1;
    });
    return this.profileChangeRequests;
  }

  ProfileUpdate getPendingProfileUpdate() {
    for(var a=0; a< this.profileChangeRequests.length; a++) {
      if(this.profileChangeRequests[a].approvalStatus == "Pending") {
        return this.profileChangeRequests[a];
      }
    }
    return null;
  }
}

class ChefRating {
  double alc_rating;
  int alc_count;
  double ds_rating;
  int ds_count;
  double mp_rating;
  int mp_count;
  int cancelled_orders;
  int completed_orders;
  int complaint_score;
  int num_complaints;
  int rating;
  int cutoff_time;
  String cutoff_time_string;
  String rating_string;

  ChefRating() {
    alc_rating = 0.0;
    alc_count = 0;
    ds_rating = 0.0;
    ds_count = 0;
    mp_rating = 0.0;
    mp_count = 0;
    cancelled_orders = 0;
    completed_orders = 0;
    complaint_score = 0;
    num_complaints = 0;
    rating = 0;
    cutoff_time = 0;
    cutoff_time_string = "";
    rating_string = "";
  }

  Map<String, dynamic> toJson() => {
    'alc_rating': alc_rating,
    'alc_count': alc_count,
    'ds_rating': ds_rating,
    'ds_count': ds_count,
    'mp_rating': mp_rating,
    'mp_count': mp_count,
    'cancelled_orders': cancelled_orders,
    'completed_orders': completed_orders,
    'complaint_score': complaint_score,
    'num_complaints': num_complaints,
    'rating': rating,
    'cutoff_time': cutoff_time,
    'cutoff_time_string': cutoff_time_string,
    'rating_string': rating_string
  };

  ChefRating.fromJson(Map<String, dynamic> json)
      :   alc_rating = (json['alc_rating']).toDouble(),
        alc_count = json['alc_count'],
        ds_rating = (json['ds_rating']).toDouble(),
        ds_count = json['ds_count'],
        mp_rating = (json['mp_rating']).toDouble(),
        mp_count = json['mp_count'],
        cancelled_orders = json['cancelled_orders'],
        completed_orders = json['completed_orders'],
        complaint_score = json['complaint_score'],
        num_complaints = json['num_complaints'],
        rating = (json['rating']).round(),
        cutoff_time = json['cutoff_time'],
        cutoff_time_string = json['cutoff_time_string'],
        rating_string = json['rating_string'];
}

class Alerts {
  bool ring_alert_on;
  bool set_dnd;
  String ring_alert_dnd_start;
  String  ring_alert_dnd_end;

  Alerts(this.ring_alert_on, this.set_dnd, this.ring_alert_dnd_start, this.ring_alert_dnd_end);


  Map<String, dynamic> toJson() => {
    'ring_alert_on': ring_alert_on,
    'set_dnd': set_dnd,
    'ring_alert_dnd_start': ring_alert_dnd_start,
    'ring_alert_dnd_end': ring_alert_dnd_end
  };

  Alerts.fromJson(Map<String, dynamic> json)
      :   ring_alert_on = json['ring_alert_on'],
        set_dnd = json['set_dnd'],
        ring_alert_dnd_start = json['ring_alert_dnd_start'],
        ring_alert_dnd_end = json['ring_alert_dnd_end'];
}

class KitchenHours {
  List<Schedule> schedule;
  List<DaysOff> days_off;

  KitchenHours(this.schedule, this.days_off);

  Map<String, dynamic> toJson() => {
    'schedule': schedule,
    'days_off': days_off
  };

  KitchenHours.fromJson(Map<String, dynamic> json)
      :   schedule = json['schedule'].map<Schedule>((i)=>Schedule.fromJson(i)).toList(),
        days_off = json['days_off'].map<DaysOff>((i)=>DaysOff.fromJson(i)).toList();

  bool hasDay(day) {
    for(int a=0; a<schedule.length; a++) {
      if(schedule[a].day == day && schedule[a].available)
        return true;
    }
    return false;
  }

  void setHours(day, startTime, endTime, available) {
    var done = false;
    for(int a=0; a<schedule.length; a++) {
      if(schedule[a].day == day) {
        schedule[a].start_time = startTime;
        schedule[a].end_time = endTime;
        schedule[a].available = available;
        done = true;
      }
    }
    if(!done) {
      schedule.add(new Schedule(day, startTime, endTime, available));
    }
  }
}

class Schedule {
  String day;
  String start_time;
  String end_time;
  bool available;

  Schedule(this.day, this.start_time, this.end_time, this.available);


  Map<String, dynamic> toJson() => {
    'day': day,
    'start_time': start_time,
    'end_time': end_time,
    'available': available
  };

  Schedule.fromJson(Map<String, dynamic> json)
      :   day = json['day'],
        start_time = json['start_time'],
        end_time = json['end_time'],
        available = json['available'];

}

class DaysOff {
  String start_date;
  String end_date;
  String notes;
  final offDateFormat = new DateFormat('d MMM');
  final dateFormatOfEnd = new DateFormat('EEE, d MMM ''yyyy');
  final endDateForDashboard= new DateFormat('EEE, d MMM ');
  final dateFormat = new DateFormat('E, d MMM');

  User user;


  DaysOff(this.start_date, this.end_date, this.notes);


  Map<String, dynamic> toJson() => {
    'start_date': start_date,
    'end_date': end_date,
    'notes': notes
  };

  DaysOff.fromJson(Map<String, dynamic> json)
      :   start_date = json['start_date'],
        end_date = json['end_date'],
        notes = json['notes'];

  DateTime getStartDate() {
    return DateTime.parse(start_date);
  }

  DateTime getEnDate() {
    return DateTime.parse(end_date);
  }

  String getDisplayString() {
    final DateTime starty = DateTime.parse(start_date);
    final DateTime endy = DateTime.parse(end_date);
    final diff = endy.difference(starty);
    String retStr = offDateFormat.format(starty);
    retStr += " - ";
    retStr += offDateFormat.format(endy);
    retStr += " (" + (diff.inDays + 1).toString() + " days)";

    return retStr;
  }

  // //for Leaves Management getting start date of leave and end date in seperate functions
  // String getStartDateof(){
  //   final DateTime starty = DateTime.parse(start_date);
  //   String retStr = offDateFormat.format(starty);
  //   return retStr;
  // }





// getting end date to print on Leaves
  String getEndDateOfLeave(){
    DateTime enddate = DateTime.parse(end_date);
    String eDate= dateFormatOfEnd.format(enddate);
    return eDate;
  }
//get end date for LEAVES
  String getEndDateOfLeaveForDashboard(){
    DateTime enddate = DateTime.parse(end_date);
    String eDate= endDateForDashboard.format(enddate);
    return eDate;
  }

  // getting end date of leave
  String getSmallestDate(){
    List <DateTime>endDate = [];
    if (user.userProfile.kitchen_hours.days_off.isEmpty == false) {
      for(int i=0;i<user.userProfile.kitchen_hours.days_off.length;i++)
      {
        if (user.userProfile.kitchen_hours.days_off[i].checkingOldVacations() ==
            true) {
          endDate.add(user.userProfile.kitchen_hours.days_off[i].getEnDate()) ;
        }
      }
    } //else return "error";
    endDate.sort();
    return dateFormat.format(endDate[0]).toString();
  }











  bool checkingOldVacations(){
    DateTime currDt = DateTime.now();
    DateTime starty = DateTime.parse(start_date);
    DateTime enddate = DateTime.parse(end_date);

    DateTime date = new DateTime.now();
    //DateTime newDate = new DateTime(date.year, date.month, date.day+2);

    Duration differenceSinceStartDate = currDt.difference(starty);
    Duration differenceSinceEndDate = currDt.difference(enddate);



    //if ( differenceSinceStartDate.inMinutes < 0){
      if(differenceSinceEndDate.inMinutes < 0){
        return true;
      }

      return false;
    }


  bool checkingFutureVacations(){
    DateTime currDt = DateTime.now();
    DateTime starty = DateTime.parse(start_date);
    DateTime enddate = DateTime.parse(end_date);

    DateTime date = new DateTime.now();
    //DateTime newDate = new DateTime(date.year, date.month, date.day+2);

    Duration differenceSinceStartDate = currDt.difference(starty);
    Duration differenceSinceEndDate = currDt.difference(enddate);

    if ( differenceSinceStartDate.inMinutes < 0){
      if(differenceSinceEndDate.inMinutes < 0){
        return true;
      }

    return false;
  }}


  bool checkingLeaves(){
    DateTime currDt = DateTime.now();
    DateTime starty = DateTime.parse(start_date);
    DateTime enddate = DateTime.parse(end_date);

    DateTime date = new DateTime.now();
    DateTime newDate = new DateTime(date.year, date.month, date.day+2);


    Duration differenceSinceStartDate = currDt.difference(starty);
    Duration differenceSinceEndDate = currDt.difference(enddate);


    if ( differenceSinceStartDate.inMinutes >= 0){
      if(differenceSinceEndDate.inMinutes < 0){
        return true;
      }
    }
    if (differenceSinceStartDate.inMinutes > 0){
      if(differenceSinceEndDate.inMinutes == 0){
        return true;
      }
    }
    return false;

  }
}