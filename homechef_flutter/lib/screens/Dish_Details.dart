import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homechefflutter/ui/DishImage.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:homechefflutter/models/AlcDishesApproved.dart';
import 'package:homechefflutter/models/Dish.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:homechefflutter/utils/Globals.dart';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flushbar/flushbar.dart';
import 'dart:async';import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';



class Dish_Details extends StatefulWidget {

  final String dishid;
  Dish_Details({Key key, @required this.dishid}) : super(key: key);
  @override
  _Dish_DetailsState createState() => _Dish_DetailsState(dishid);
}

class _Dish_DetailsState extends State<Dish_Details> {
  File _image;
  int _current = 0;
  String dishid;
  User user;
  List<Dish> _dishlist = new List();
  final List<String> imgList = [];

  _Dish_DetailsState(this.dishid);


  @override
  void initState() {

    super.initState();
  }

  _imgFromCamera() async {
    ImagePicker _picker = ImagePicker();
     final image = await _picker.getImage(
        source: ImageSource.camera, maxWidth: 800,
        maxHeight: 800,imageQuality: 50
    );
    _image = await FlutterExifRotation.rotateImage(path: image.path);
    //_image = await
    final _image1 = _getCroppedImage(File(image.path));
    //dishimg(await _image1);
    if(await _image1 != null) {

      _updateImageDialog(await _image1, _current);
    }
    // _updateImageDialog(await _image1, _current);
  }

  _imgFromGallery() async {
    ImagePicker _picker = ImagePicker();
    final image = await _picker.getImage(
        source: ImageSource.gallery, maxWidth: 800,
        maxHeight: 800,imageQuality: 50
    );
    _image = File(image.path);
    final _image1 = _getCroppedImage(_image);
    if(await _image1 != null) {
      _updateImageDialog(await _image1, _current);
    }
    //dishimg(await _image1);

    setState(() {
      _image = File(image.path);
    });
  }

  void _showPicker(context, index) {
    if(index == 0){
      print("index = $index");
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Center(
                          child:imgList[0]!="https://imagecdn.homechef.pk/dishImg.png"?Text("Update 1st Photo",style: TextStyle(fontSize: 20,color: Color(0xFF656565),fontWeight:FontWeight.w600),):Text("Add 1st Photo",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Color(0xFF656565),fontWeight:FontWeight.w600),)
                      ),
                    ),
                    new ListTile(
                      leading: Image.asset('images/camera_icon.png', height:35, width: 35,),
                      title: new Text('Take Photo'),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),

                    new ListTile(
                        leading: Image.asset('images/gallery_icon.png', height:35, width: 35,),
                        title: new Text('Choose from Gallery'),
                        onTap: () {
                          _imgFromGallery();
                          Navigator.of(context).pop();
                        }),

                  ],
                ),
              ),
            );
          }
      );
    } else if(index == 1){

      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Center(
                          child:(index==1)?Text(imgList[1]!="https://imagecdn.homechef.pk/dishImg.png"?"Update 2nd Photo":"Add 2nd Photo",style: TextStyle(fontSize: 20,color: Color(0xFF656565),fontWeight:FontWeight.w600),):
                          Text(imgList[2]!="https://imagecdn.homechef.pk/dishImg.png"?"Update 3rd Photo":"Add 3rd Photo",style: TextStyle(fontSize: 20,color: Color(0xFF656565),fontWeight:FontWeight.w600),)
                      ),
                    ),
                    new ListTile(
                      leading: Image.asset('images/camera_icon.png', height:35, width: 35,),
                      title: new Text('Take Photo'),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),

                    new ListTile(
                        leading: Image.asset('images/gallery_icon.png', height:35, width: 35,),
                        title: new Text('Choose from Gallery'),
                        onTap: () {
                          _imgFromGallery();
                          Navigator.of(context).pop();
                        }),

                    (imgList[1]=="https://imagecdn.homechef.pk/dishImg.png")?Container(): ListTile(
                      leading: Image.asset('images/remove_icon.png', height:35, width: 35,),
                      title: new Text('Remove Photo'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _showRemoveDialog(_current);
                      },
                    ),


                  ],
                ),
              ),
            );
          }
      );

    }
    else if(index == 2){

      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Center(
                          child:(index==1)?Text(imgList[1]!="https://imagecdn.homechef.pk/dishImg.png"?"Update 2nd Photo":"Add 2nd Photo",style: TextStyle(fontSize: 20,color: Color(0xFF656565),fontWeight:FontWeight.bold),):
                          Text(imgList[2]!="https://imagecdn.homechef.pk/dishImg.png"?"Update 3rd Photo":"Add 3rd Photo",style: TextStyle(fontSize: 20,color: Color(0xFF656565),fontWeight:FontWeight.bold),)
                      ),
                    ),
                    new ListTile(
                      leading: Image.asset('images/camera_icon.png', height:35, width: 35,),
                      title: new Text('Take Photo'),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),

                    new ListTile(
                        leading: Image.asset('images/gallery_icon.png', height:35, width: 35,),
                        title: new Text('Choose from Gallery'),
                        onTap: () {
                          _imgFromGallery();
                          Navigator.of(context).pop();
                        }),

                    (imgList[2]=="https://imagecdn.homechef.pk/dishImg.png")?Container(): ListTile(
                      leading: Image.asset('images/remove_icon.png', height:35, width: 35,),
                      title: new Text('Remove Photo'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _showRemoveDialog(_current);
                      },
                    ),


                  ],
                ),
              ),
            );
          }
      );

    }

  }



  Future<void> _showRemoveDialog(index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return
          AlertDialog(
            title:
            Center(
              child: (index==0)?Text('Remove 1st Photo'  ,textAlign: TextAlign.center,style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,color: Color(0xFF656565)),):(index==1)?Text('Remove 2nd Photo',textAlign: TextAlign.center,style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,color: Color(0xFF656565))):Text('Remove 3rd Photo',textAlign: TextAlign.center,style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,color: Color(0xFF656565)),),
            ),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Are you sure you want to remove this photo?',textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Color(0xFF656565)),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Padding(
                    //     padding: EdgeInsets.only(left: 15)
                    //
                    // ),
                    Container(
                      margin: EdgeInsets.only(top: 12, bottom: 10,right: 7),
                      child: RaisedButton(
                        elevation: 0.0,
                        color: Colors.white,
                        //color: Colors.black38,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0),
                            side: BorderSide(color: Colors.black)),

                        disabledColor: Colors.black,
                        //Colors.black12,
                        padding: EdgeInsets.only(left: 35, right: 35),
                        onPressed: () {

                          Navigator.of(context, rootNavigator: false).pop();
                        },
                        child: Text(
                          "No",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),




                    //
                    // Padding(
                    //     padding: EdgeInsets.only(right: 15)
                    //
                    // ),


                    Container(
                        margin: EdgeInsets.only(
                            top: 12, left: 7, bottom: 10),
                        child: RaisedButton(
                          elevation: 0.0,
                          color: Color(0xFFFF872F),
                          disabledColor: Colors.black12,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(4.0)),
                          padding: EdgeInsets.only(left: 35, right: 35),
                          onPressed: () {

                            Navigator.of(context).pop();
                            removeimg(index);
                            // _RemoveSuccessfullyDialog(index);
                            //
                            // _popupWork();
                          },
                          child: Text(
                            "Yes",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //color: Colors.white,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        )),


                    Padding(
                        padding: EdgeInsets.only(right: 10)

                    ),


                  ],
                )

              ],
            ),

          );

      },
    );
  }



// user defined function
  void _updateImageDialog(_image1,index) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title:(index==0)? Text(imgList[0]!="https://imagecdn.homechef.pk/dishImg.png"?
            "Update 1st Photo":"Add 1st Photo",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Color(0xFF656565) ),textAlign: TextAlign.center,):
            (index==1)?Text(imgList[1]!="https://imagecdn.homechef.pk/dishImg.png"?
            "Update 2nd Photo":"Add 2nd Photo",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Color(0xFF656565)) ,textAlign: TextAlign.center,):
            Text(imgList[2]!="https://imagecdn.homechef.pk/dishImg.png"?"Update 3rd Photo":"Add 3rd Photo",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600, color: Color(0xFF656565)) ,textAlign: TextAlign.center,),


            // (index==0)? Text(imgList[0]!="https://imagecdn.homechef.pk/dishImg.png"?"Update 1st Photo":"Add 1st Photo",
            //   textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600, color: Color(0xFF6565)),)
            //     :(index==1)?Text(imgList[1]!="https://imagecdn.homechef.pk/dishImg.png"?"Update 2nd Photo":"Add 2nd Photo" ,
            //   textAlign: TextAlign.center,style:TextStyle(fontSize: 20,fontWeight: FontWeight.w600 , color: Color(0xFF6565)))
            //     :Text(imgList[2]!="https://imagecdn.homechef.pk/dishImg.png"?"Update 3rd Photo":"Add 3rd Photo" ,
            //   style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600, color: Color(0xFF6565)),textAlign: TextAlign.center,),




            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (index==0)? Text(imgList[0]!="https://imagecdn.homechef.pk/dishImg.png"?"Are you sure you want to update this photo? The new photo will replace the existing one." :"Are you sure you want to add this photo?",textAlign: TextAlign.center,):(index==1)?Text(imgList[1]!="https://imagecdn.homechef.pk/dishImg.png"?"Are you sure you want to update this photo? The new photo will replace the existing one. ":""
                    "Are you sure you want to add this photo?" ,textAlign: TextAlign.center,):Text(imgList[2]!="https://imagecdn.homechef.pk/dishImg.png"?"Are you sure you want to update this photo? The new photo will replace the existing one. ":"Are you sure you want to add this photo?" ,textAlign: TextAlign.center,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 12, bottom: 10,right: 7),
                      child: RaisedButton(
                        elevation: 0.0,
                        color: Colors.white,
                        //color: Colors.black38,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0),
                            side: BorderSide(color: Colors.black)),

                        disabledColor: Colors.black,
                        //Colors.black12,
                        padding: EdgeInsets.only(left: 35, right: 35),
                        onPressed: () {

                          Navigator.of(context, rootNavigator: false).pop();
                        },
                        child: Text(
                          "No",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    Container(
                        margin: EdgeInsets.only(
                            top: 12, bottom: 10,left: 7),
                        child: RaisedButton(
                          elevation: 0.0,
                          color: Color(0xFFFF872F),
                          disabledColor: Colors.black12,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(4.0)),
                          padding: EdgeInsets.only(left: 35, right: 35),
                          onPressed: () {

                            dishimg(_image1);
                            Navigator.of(context).pop();

                            //
                          },
                          child: Text(
                            "Yes",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //color: Colors.white,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        )),
                  ],
                )
              ],
            )
        );
      },
    );

  }

  void _popupWork() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title:Text("Update to Continue", style: TextStyle(
              fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black,
            ),),
            // insetPadding: EdgeInsets.symmetric(vertical: 70),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Update to the latest version to continue using the Chef app.",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 12, bottom: 10,right: 7),
                      child: RaisedButton(
                        elevation: 0.0,
                        color: Colors.white,
                        //color: Colors.black38,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0),
                            side: BorderSide(color: Colors.black)),

                        disabledColor: Colors.black,
                        //Colors.black12,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: false).pop();
                        },
                        child: Text(
                          "Later",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    Container(
                        margin: EdgeInsets.only(
                            top: 12, bottom: 10,left: 7),
                        child: RaisedButton(
                          elevation: 0.0,
                          color: Color(0xFFFF872F),
                          disabledColor: Colors.black12,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(4.0)),
                          padding: EdgeInsets.only(left: 15, right: 15),
                          onPressed: () {
                            // Navigator.of(context).pop();
                          },
                          child: Text(
                            "Update Now",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //color: Colors.white,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        )),
                  ],
                )
              ],
            )
        );
      },
    );

  }


  //FLEXIBLE UPDATE

  void _flexiblePopup() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title:Text("Update the chef App?", style: TextStyle(
              fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black,
            ),),
            // insetPadding: EdgeInsets.symmetric(vertical: 70),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Update to the latest version to use the newest features and services.",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 12, bottom: 10,right: 7),
                      child: RaisedButton(
                        elevation: 0.0,
                        color: Colors.white,
                        //color: Colors.black38,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0),
                            side: BorderSide(color: Colors.black)),

                        disabledColor: Colors.black,
                        //Colors.black12,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: false).pop();
                        },
                        child: Text(
                          "Later",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    Container(
                        margin: EdgeInsets.only(
                            top: 12, bottom: 10,left: 7),
                        child: RaisedButton(
                          elevation: 0.0,
                          color: Color(0xFFFF872F),
                          disabledColor: Colors.black12,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(4.0)),
                          padding: EdgeInsets.only(left: 15, right: 15),
                          onPressed: () {
                            // Navigator.of(context).pop();
                            launch('https://play.google.com/store/apps/details?id=pk.homechef.chefapp&hl=en&gl=US');

                          },
                          child: Text(
                            "Update",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //color: Colors.white,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        )),
                  ],
                )
              ],
            )
        );
      },
    );

  }


  //FORCED UPDATE
  void _forcedPopup() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title:Text("Update to Continue", style: TextStyle(
              fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black,
            ),),
            // insetPadding: EdgeInsets.symmetric(vertical: 70),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Update to the latest version to continue using the Chef app.",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Container(
                      margin: EdgeInsets.only(top: 12, bottom: 10,right: 7),
                      child: RaisedButton(
                        elevation: 0.0,
                        color: Colors.white,
                        //color: Colors.black38,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0),
                            side: BorderSide(color: Colors.black)),

                        disabledColor: Colors.black,
                        //Colors.black12,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        onPressed: () {
                          exit(0);
                          //Navigator.of(context, rootNavigator: false).pop();
                        },
                        child: Text(
                          "Close",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            top: 12, bottom: 10,left: 7),
                        child: RaisedButton(
                          elevation: 0.0,
                          color: Color(0xFFFF872F),
                          disabledColor: Colors.black12,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(4.0)),
                          padding: EdgeInsets.only(left: 15, right: 15),
                          onPressed: () {
                            // Navigator.of(context).pop();
                            launch('https://play.google.com/store/apps/details?id=pk.homechef.chefapp&hl=en&gl=US');

                          },
                          child: Text(
                            "Update Now",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //color: Colors.white,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        )),
                  ],
                )
              ],
            )
        );
      },
    );

  }




  Future<void> _RemoveSuccessfullyDialog(index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Center(
              child:
              (index==0)?Text('Dish Photo 1 \n Removed' ,style: TextStyle(
                fontSize: 20,color: Color(0xFF656565),
                fontWeight: FontWeight.w600,), textAlign: TextAlign.center,):(index==1)?Text('Dish Photo 2 \n Removed',style:TextStyle(
                fontSize: 20,color: Color(0xFF656565),
                fontWeight: FontWeight.w600,),textAlign: TextAlign.center,):Text('Dish Photo 3 \n Removed',style: TextStyle(
                fontSize: 20,color: Color(0xFF656565),
                fontWeight: FontWeight.w600,),textAlign: TextAlign.center,),

            ),
          ),

          content: SingleChildScrollView(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Center(child: Text('Your picture has been removed successfully!',textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Color(0xFF656565)),)),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Image(image: AssetImage('images/check.png')),
                // ),
                Container(
                    margin: EdgeInsets.only(
                        top: 12, left: 10, right: 10, bottom: 10),
                    child: RaisedButton(
                      elevation: 0.0,
                      color: Color(0xFFFF872F),
                      disabledColor: Colors.black12,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(4.0)),
                      padding: EdgeInsets.only(left: 35, right: 35),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "OK",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          //color: Colors.white,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    )),

                // Image.asset('images/checktick.svg'),
              ],
            ),
          ),

        );
      },
    );
  }


  //
  // Future<File> _getCroppedImage(File img) async{
  //   File croppedFile= await ImageCropper.cropImage(
  //     sourcePath: img.path,
  //     aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
  //     compressQuality: 100,
  //     maxHeight: 700,
  //     maxWidth: 700,
  //     compressFormat: ImageCompressFormat.jpg,
  //     androidUiSettings: AndroidUiSettings(
  //       toolbarColor: Colors.deepOrangeAccent,
  //       toolbarTitle: "",
  //     ),
  //   );
  //
  //   return croppedFile;
  // }



  //test123
  //test123


  Future<File> _getCroppedImage(File img) async{
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: img.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          // CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.original,
          // CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );
    return croppedFile;
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    getDetails("api/chefapp/v1/getdishdetails?dishid=" + dishid, context);
    return ChefAppScaffold(
        title: "Dish Details",
        showNotifications: true,
        showBackButton: true,
        showHomeButton: true,
        body: Container(
          child: ListView.builder(itemCount: _dishlist.length,
              itemBuilder: (BuildContext context, int index){
                if(_dishlist==0)
                  return Container();
                else
                  return Column(
                      children: [Padding(
                        padding: const EdgeInsets.fromLTRB(0,8,0,8),
                        child: CarouselSlider(
                          options: CarouselOptions(
                              height: 200,
                              enableInfiniteScroll: false,
                              autoPlay: false,
                              aspectRatio: 16/9,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                  //print("INDEX:$_current");
                                  // for(int i=0;i<3;i++){
                                  //
                                  //   if(imgList[i].)
                                  //
                                  //
                                  // }



                                });
                              }
                          ),
                          items: imgList.map((item) => Container(
                            child: Center(
                                child: Image.network(item,fit:BoxFit.cover,width: 1000,)
                            ),
                          )).toList(),
                        ),
                      ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: imgList.map((url) {
                            int index = imgList.indexOf(url);

                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? Color.fromRGBO(255, 122, 24, 1)
                                    : Color.fromRGBO(0, 0, 0, 0.4),
                              ),
                            );
                          }).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10,15,10,0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(width: 180,child: Text(_dishlist[0].dishName,textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),maxLines: 3, overflow: TextOverflow.ellipsis,))
                                  ],
                                ),
                              ),

                              InkWell(
                                child:Image.asset('images/Camera_button.png', height:45, width: 45,),
                                onTap: (){
                                  _showPicker(context,_current);

                                },
                              ),

                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: Row(
                                children: [
                                  Image.asset(
                                      "images/rating_star.png"),
                                  Padding(
                                    padding:
                                    const EdgeInsets
                                        .fromLTRB(
                                        5,
                                        0,
                                        0,
                                        0),
                                    child: Text(
                                      _dishlist[0].rating!="0"?
                                      _dishlist[0]
                                          .rating +
                                          " (" +
                                          _dishlist[0]
                                              .totalrating +
                                          ")":"-",textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontSize:
                                          13,
                                          height: 1.5,
                                          color: Color(
                                              0xFF656565)),
                                    ),
                                  )
                                ],
                              ),
                            ),


                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                              child: Row(
                                children: [

                                  Padding(
                                    padding: const EdgeInsets
                                        .fromLTRB(
                                        5,
                                        0,
                                        0,
                                        0),
                                    child:
                                    Text("Total Orders: "+
                                        _dishlist[0]
                                            .numorderrs +
                                        " Orders",textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontSize: 13, fontWeight: FontWeight
                                              .w600,
                                          height: 1.5,
                                          color: Color(
                                              0xFF656565)),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets
                                        .fromLTRB(
                                        0,
                                        0,
                                        5,
                                        0),
                                    child: Image
                                        .asset(
                                        "images/soup.png",width: 16),
                                  ),
                                  Text(_dishlist[0]
                                      .serves!="null"?
                                  "Serves " +
                                      _dishlist[0]
                                          .serves:"-",textScaleFactor: 1.0,
                                    style: TextStyle(
                                      height: 1.5,
                                      color: Color(
                                          0xFF656565),
                                      fontWeight: FontWeight
                                          .w500,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),



                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets
                                        .fromLTRB(
                                        0,
                                        0,
                                        5,
                                        0),
                                    child: Image
                                        .asset(
                                        "images/weighing-machine.png",width: 16),
                                  ),
                                  Text(
                                    _dishlist[0]
                                        .dishmeasurement +
                                        " " +
                                        _dishlist[0]
                                            .servingtype,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      height: 1.5,
                                      color: Color(
                                          0xFF656565),
                                      fontWeight: FontWeight
                                          .w500,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 10, 0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets
                                        .fromLTRB(
                                        0,
                                        0,
                                        5,
                                        0),
                                    child: InkWell(
                                      onTap: () {
                                        // _showPicker(context);
                                        // _popupWork();
                                        //_flexiblePopup();
                                        //_forcedPopup();
                                      },
                                      child: Image
                                          .asset(
                                          "images/clock.png",width: 16),
                                    ),
                                  ),
                                  Text(
                                    _dishlist[0]
                                        .Dishhrs +
                                        " hrs",textScaleFactor: 1.0,
                                    style: TextStyle(
                                      height: 1.5,
                                      color: Color(
                                          0xFF656565),
                                      fontWeight: FontWeight
                                          .w500,
                                      fontSize: 13,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        Text("Rs",textScaleFactor: 1.0,style: TextStyle(fontWeight: FontWeight.w600,height: 1.5, fontSize: 12,)),
                                        Text(_dishlist[0].price,textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.bold,height: 1.5, fontSize: 18))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),




                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Dietary Needs: ",textScaleFactor: 1.0,style: TextStyle(fontWeight: FontWeight.w600,height:1.5, fontSize: 12,color: Color(0xFF656565)),),
                              Expanded(child: Column( crossAxisAlignment:CrossAxisAlignment.start,children: [Container(child:Text(_dishlist[0].features!=""?_dishlist[0].features:"Not Specified",textScaleFactor: 1.0, style: TextStyle(fontSize: 12,height:1.5,color: Color(0xFF656565))))]))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Row(
                            children: [
                              Text("Dish Type: ",textScaleFactor: 1.0,style: TextStyle(fontWeight: FontWeight.w600,height: 1.5, fontSize: 12,color: Color(0xFF656565)),),
                              Text(_dishlist[0].DishType,textScaleFactor: 1.0, style: TextStyle(fontSize: 12,height:1.5,color: Color(0xFF656565)))
                            ],
                          ),
                        ),


                        Container(
                            margin: EdgeInsets.fromLTRB(
                                10, 15, 10, 0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFFF1F1F1),
                              borderRadius:
                              BorderRadius.circular(10.0),
                            ),
                            child:Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Text(_dishlist[0].Description,textScaleFactor: 1.0,style: TextStyle(color:Color(0xFF656565),height: 1.5),),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 7),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Cuisine: ",textScaleFactor: 1.0,style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, height:1.5,color: Color(0xFF656565)),),
                                      Expanded(child: Column( crossAxisAlignment:CrossAxisAlignment.start,children: [Text(_dishlist[0].cuisine,textScaleFactor: 1.0, style: TextStyle(fontSize: 12,height:1.5,color: Color(0xFF656565)))]))
                                    ],
                                  ),
                                )]),
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(alignment:Alignment.centerLeft,child: Text("Reviews",textScaleFactor: 1.0, style: TextStyle(fontSize: 14,height: 1.5, fontWeight: FontWeight.w600, color: Color(0xFF000000)),)),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              if(_dishlist[0].Reviews.length==0)
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Align(alignment:Alignment.centerLeft,child: Text("No Reviews Yet",textScaleFactor: 1.0,style: TextStyle(color: Color(0xFF656565),height: 1.5),)),
                                )
                              else
                                for(var review in _dishlist[0].Reviews)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(review['reviewer']['name'],textScaleFactor: 1.0,style: TextStyle(fontWeight: FontWeight.w600,height:1.5,fontSize: 15, color: Color(0xFF656565)),),
                                            _buildRatingStar(
                                                int.parse(review['rating'].toString())),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                transform: Matrix4.translationValues(0.0, -8.0, 0.0),
                                                child: Text("Reviewed on: " + review['reviewdate'],textScaleFactor: 1.0, style: TextStyle(fontSize: 13, color: Color(0xFF656565)),)),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top:5),
                                            child: Container(child: Text(review['review'],textScaleFactor: 1.0,style: TextStyle(fontSize: 15,height: 1.5, color: Color(0xFF656565)))),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:10),
                                          child: Divider(color: Color(0xFFC4C4C4)),
                                        ),
                                      ],
                                    ),
                                  ),

                            ],
                          ),
                        )
                      ]
                  );
              }),
        )
    );
  }

  getDetails(String url, BuildContext context) async
  {
    if (_dishlist.length > 0) return;
    var jsonResponse;
    var response = await http.get(Uri.parse(Globals.BASE_URL + url));
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      setState(() {
        print("getting data");
        String features = "";
        String type = "";
        String cuisine = "";
        List reviews = new List();
        var dishes = jsonResponse['details'];
        var img2 = null;
        var img3 = null;
        var dishid = dishes['_id'].toString();
        var dishname = dishes['name'].toString();
        var prephrs = dishes['advancebooking']['ordernoticehrs'].toString();
        var price = dishes['price'].toString();
        var servingquantity = dishes['servingquantity'].toString();
        var servingtype = dishes['servingtype'].toString();
        var serves = dishes['serves'].toString();
        var img1 = dishes['photos'][0]['photo'].toString();
        var desc = dishes['description'].toString();
        for(int i=0;i<dishes['features'].length;i++)
        {

          if(i<dishes['features'].length - 1)
            features = features + dishes['features'][i].toString()+", ";
          else
            features = features + dishes['features'][i].toString();
        }
        for(int i=0;i<dishes['cuisines'].length;i++)
        {
          if(i<dishes['cuisines'].length - 1)
            cuisine = cuisine + dishes['cuisines'][i].toString()+", ";
          else
            cuisine = cuisine + dishes['cuisines'][i].toString();
        }
        type = dishes['type'].toString();
        for(int i=0;i<dishes['photos'].length;i++)
        {
          imgList.add(dishes['photos'][i]['photo'].toString());
        }
        if(dishes['photos'].length<3 )
        {
          imgList.add("https://imagecdn.homechef.pk/dishImg.png");
        }
        var numorders = dishes['numorders'].toString();
        var ratingcount = dishes['ratingcount'].toString();
        final rating_format = new NumberFormat("#.0");
        var current_dish_rating =
        rating_format.format(dishes['currentrating']).toString();
        print(current_dish_rating);
        var isactive = dishes['isactive'].toString();
        if (current_dish_rating == ".0") {
          current_dish_rating = "0";
        }
        for(int i=0;i<dishes['reviews'].length;i++)
        {
          print(dishes['reviews'][i]['reviewdate']);

          // review[i]['name'] = dishes['reviews'][i]['reviewer']['name'];
          // review[i]['rating'] = dishes['reviews'][i]['rating'];
          var parsedDate = DateTime.parse(dishes['reviews'][i]['reviewdate']).toLocal();
          var vardateFormat = new DateFormat('d/M/yy, H:mm a');
          dishes['reviews'][i]['reviewdate'] = vardateFormat.format(parsedDate);
          // review[i]['review'] = dishes['reviews'][i]['review'];
          // reviews.add(review[i]);
        }
        reviews = dishes['reviews'];
        print(dishname);
        _dishlist.add(new Dish(
            dishid,
            img1,
            img2,
            img3,
            dishname,
            prephrs,
            price,
            servingquantity,
            servingtype,
            serves,
            current_dish_rating,
            ratingcount,
            numorders,
            isactive,
            cuisine,
            features,
            type,
            desc,
            reviews,
            "null",
            "null"
        ));
        print("added data");
        print(features);
      });
      print(_dishlist[0]);
      _dishlist[0].Reviews = _dishlist[0].Reviews.reversed.toList();
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
  Future<http.Response> dishimg(File img) async
  {
    // await http.post(
    //   Globals.BASE_URL + "api/chefapp/v1/uploadimage",
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: {
    //     'file': img,
    //   },
    // ).then((value) =>
    //     setState(() {
    //       print("uploaded");
    //     })
    // );
    Dio dio = new Dio();
    FormData formData = FormData.fromMap(<String, dynamic>{ "file": await MultipartFile.fromFile(img.path, filename:img.path), });
    Response response = await dio.post(Globals.BASE_URL + "api/v1/uploadimage", data: formData);
    print(response.data['fileurl']);
    updateimg(response.data['fileurl'], _current);
  }


  Future<http.Response> updateimg(String imgpath, int index) async
  {
    await http.post(Uri.parse(
      Globals.BASE_URL + "api/chefapp/v1/uploadimg"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'dishid': dishid,
        'index': index,
        'imgpath': imgpath,
      }),
    ).then((value) => setState(() {
      imgList[index] = imgpath;

      // if( imgList.length<3 && imgList[2]=="https://imagecdn.homechef.pk/dishImg.png" && imgList[1]=="https://imagecdn.homechef.pk/dishImg.png"){
      //   imgList.removeAt(2);
      // }


      if(imgList.length<3 && index<2 && index!=0)
      {
        imgList.add("https://imagecdn.homechef.pk/dishImg.png");

      }
      Flushbar(
        message: "Dish photo updated successfully",
        duration: Duration(seconds: 3),
      )
        ..show(context);
    }));
  }

  Future<http.Response> removeimg( int index) async
  {

    if(index==0)
    {
      setState(() {

        Flushbar(
          message: "Main image cannot be removed",
          duration: Duration(seconds: 5),
        )
          ..show(context);
        setState(() {});
      });
    }
    else {
      await http.post(Uri.parse(
        Globals.BASE_URL + "api/chefapp/v1/removeimg"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'dishid': dishid,
          'index': index,
        }),
      ).then((value) =>
          setState(() {
            imgList.removeAt(index);

            if(imgList.length<3 && index<=2)
            {
              if(!imgList.contains("https://imagecdn.homechef.pk/dishImg.png")) {
                imgList.add("https://imagecdn.homechef.pk/dishImg.png");
              }
            }
            // else if( imgList.length<3 && index==1 && imgList[2]!="https://imagecdn.homechef.pk/dishImg.png"){
            //   imgList.add("https://imagecdn.homechef.pk/dishImg.png");
            // }
            Flushbar(
              message: "Dish photo removed successfully",
              duration: Duration(seconds: 4),
            )
              ..show(context);
          }));
    }
  }
}






// Conformation dialog
class ConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          Text(
              "Are you sure you ",textScaleFactor: 1.0,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.5,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF656565)
                //Color(0xFF656565)
              )),
          Container(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 12, bottom: 10),
                    child: RaisedButton(
                      elevation: 0.0,
                      color: Colors.white,
                      //color: Colors.black38,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(4.0),
                          side: BorderSide(color: Colors.black)),

                      disabledColor: Colors.black,
                      //Colors.black12,
                      padding: EdgeInsets.only(left: 35, right: 35),
                      onPressed: () {

                        Navigator.of(context, rootNavigator: false).pop();
                      },
                      child: Text(
                        "No",textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black,height: 1.5, fontSize: 16,fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          top: 12, left: 10, right: 10, bottom: 10),
                      child: RaisedButton(
                        elevation: 0.0,
                        color: Color(0xFFFF872F),
                        disabledColor: Colors.black12,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0)),
                        padding: EdgeInsets.only(left: 35, right: 35),
                        onPressed: () {

                          Navigator.of(context, rootNavigator: false).pop();
                        },
                        child: Text(
                          "Yes",textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.5
                              ,
                            //color: Colors.white,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      )),
                ],
              ))
        ],
      ),
    );
  }
}

