import 'dart:ui';

import 'User.dart';

class ProfileUpdate {
  String _id;
  String businessname;
  String facebookurl;
  String altnumber;
  String about;
  List<String> cuisines;
  String speciality;
  String foodstory;
  String chefId;
  String approvalStatus;
  String requestDate;
  List<Approval> approvals;

  ProfileUpdate() {
    _id = null;
    businessname = null;
    facebookurl = null;
    altnumber = null;
    about = null;
    cuisines = [];
    speciality = null;
    foodstory = null;
    chefId = null;
    approvalStatus = null;
    requestDate = null;
    approvals = null;
  }

  Map<String, dynamic> toJson() => {
        '_id': _id,
        'businessname': businessname,
        'facebookurl': facebookurl,
        'altnumber': altnumber,
        'about': about,
        'cuisines': cuisines,
        'speciality': speciality,
        'foodstory': foodstory,
        'chefId': chefId,
        'approvalStatus': approvalStatus,
        'requestDate': requestDate,
        'approvals': approvals
      };

  ProfileUpdate.fromJson(Map<String, dynamic> json)
      : _id = json['_id'],
        businessname = json['businessname'],
        facebookurl = json['facebookurl'],
        altnumber = json['altnumber'],
        about = json['about'],
        cuisines = (json['cuisines'] != null)
            ? json['cuisines'].map<String>((i) => i.toString()).toList()
            : null,
        speciality = json['speciality'],
        foodstory = json['foodstory'],
        chefId = json['chefId'],
        approvalStatus = json['approvalStatus'],
        requestDate = json['requestDate'],
        approvals = json['approvals']
            .map<Approval>((i) => Approval.fromJson(i))
            .toList();

  void setId(i) {
    _id = i;
  }

  String getId() {
    return _id;
  }


  void resetToChefProfile(User chef) {
    this.businessname = chef.userProfile.buisnessName;
    this.altnumber = chef.userProfile.alternateContact;
    this.about = chef.userProfile.aboutMe;
    this.foodstory = chef.userProfile.foodStory;
    this.cuisines = chef.userProfile.masterCuisine;
    this.facebookurl = chef.userProfile.facebookProfile;
    this.speciality = chef.userProfile.mySpeciality;
    this.setId('');
  }

  void mergeWithChefProfile(User chef) {
    if(this.businessname == null) {
      this.businessname = chef.userProfile.buisnessName;
    }
    if(this.altnumber == null) {
      this.altnumber = chef.userProfile.alternateContact;
    }
    if(this.about == null) {
      this.about = chef.userProfile.aboutMe;
    }
    if(this.foodstory == null) {
      this.foodstory = chef.userProfile.foodStory;
    }
    if(this.cuisines == null) {
      this.cuisines = chef.userProfile.masterCuisine;
    }
    if(this.facebookurl == null) {
      this.facebookurl = chef.userProfile.facebookProfile;
    }
    if(this.speciality == null) {
      this.speciality = chef.userProfile.mySpeciality;
    }
  }

  bool isSame(User u) {
    if (businessname != u.userProfile.buisnessName) {
      return false;
    }

    if (facebookurl != u.userProfile.facebookProfile) {
      return false;
    }

    if (altnumber != u.userProfile.alternateContact) {
      return false;
    }

    if (about != u.userProfile.aboutMe) {
      return false;
    }

    if (speciality != u.userProfile.mySpeciality) {
      return false;
    }

    if (foodstory != u.userProfile.foodStory) {
      return false;
    }

    if (cuisines != u.userProfile.masterCuisine) {
      if (cuisines.length != u.userProfile.masterCuisine.length) {
        return false;
      }
      for (int i = 0; i < this.cuisines.length; ++i) {
        if (this.cuisines[i] != u.userProfile.masterCuisine[i]) {
          return false;
        }
      }
    }
    return true;
  }

  String getUpdatedHeads() {
    String retS = '';
    if (businessname != null) {
      retS += 'Business Name, ';
    }
    if (facebookurl != null) {
      retS += 'Facebook URL, ';
    }
    if (this.altnumber != null) {
      retS += 'Alternate Contact Number, ';
    }
    if (this.about != null) {
      retS += 'About Me, ';
    }
    if (this.cuisines != null) {
      retS += 'Mastered Cuisines, ';
    }
    if (this.speciality != null) {
      retS += 'Speciality, ';
    }
    if (this.foodstory != null) {
      retS += 'Food Story, ';
    }
    return retS;
  }

  String getApprovalStatus() {
    if (this.approvalStatus == 'Pending') {
      return 'Up for Review';
    } else {
      return this.approvalStatus;
    }
  }

  Color getApprovalStatusColor() {
    if (this.approvalStatus == 'Pending') {
      return Color(0xFF040EFE);
    } else if (this.approvalStatus == 'Rejected') {
      return Color(0xFFAA0000);
    } else {
      return Color(0xFF6CA91F);
    }
  }

  String getFieldStatus(field) {
    for (int a = 0; a < this.approvals.length; a++) {
      if (this.approvals[a].field == field) {
        return this.approvals[a].status;
      }
    }
    return '';
  }

  String getFieldNotes(field) {
    for (int a = 0; a < this.approvals.length; a++) {
      if (this.approvals[a].field == field) {
        return (this.approvals[a].notes != null) ? this.approvals[a].notes : "";
      }
    }
    return '';
  }
}

class Approval {
  String field;
  String status;
  String notes;

  Approval(f, s, n) {
    field = f;
    status = s;
    notes = n;
  }

  Map<String, dynamic> toJson() =>
      {'field': field, 'status': status, 'notes': notes};

  Approval.fromJson(Map<String, dynamic> json)
      : field = json['field'],
        status = json['status'],
        notes = json['notes'];
}
