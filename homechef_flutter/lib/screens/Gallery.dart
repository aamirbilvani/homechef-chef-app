// for video recorder:
import 'dart:math';
import 'package:homechefflutter/screens/previewVid.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// for thumbnail
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/src/widgets/container.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:homechefflutter/models/ProfileUpdate.dart';
import 'package:homechefflutter/models/User.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:homechefflutter/screens/playvideo.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  User user;
  static ProgressDialog progressDialog;

  ///HUSSSAIN CONFIGURING THUMBNAIL WORK 2
  ///
  ///
  ///

  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 10;
  int _size = 0;
  String _tempDir;
  String filePath;

  @override
  void initState() {
    super.initState();
    getTemporaryDirectory().then((d) => _tempDir = d.path);
  }

  ///
  ///
  ///

  // INITIALIZATION FOR IMAGE AND VIDEO
  File _image;
  File _video;
  int _current = 0;
  String dishid;

  final List<String> imgList = [];

  _imgFromCamera(isUpdate, index) async {
    ImagePicker _picker = ImagePicker();
    final image = await _picker.getImage(
      source: ImageSource.camera,
    );

    //final File image = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 50);
    // _image = await FlutterExifRotation.rotateImage(path: image.path);;
    print("WORKING HERRR");
    final _image1 = _getCroppedImage(File(image.path));
    print("not working");
    // galleryimg(await _image1);
    if (await _image1 != null) {
      _updateImageDialog(await _image1, isUpdate, index);
    }
    // _updateImageDialog(await _image1, _current);
  }

  Future<http.Response> galleryimg(File img, isUpdate, index) async {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    setState(() {
      progressDialog.show();
    });

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
      },
    );

    print("URL AS FOLLOWS");
    print(response.data['fileurl']);
    gallerylinkimage(response.data['fileurl'], isUpdate, index);
    // setState(() {
    //   imageArrLeng--;
    // });
  }

  Future<http.Response> uploadvid(File img, isUpdate, index) async {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);

    setState(() {
      progressDialog.show();
    });
    Dio dio = new Dio();
    FormData formData = FormData.fromMap(<String, dynamic>{
      "file": await MultipartFile.fromFile(img.path, filename: img.path),
    });
    Response response =
        await dio.post(Globals.BASE_URL + "api/v1/uploadvideo", data: formData);
    print("URL AS FOLLOWS");
    print(response.data['fileurl']);
    gallerylinkvideo(response.data['fileurl'], isUpdate, index);
    // setState(() {
    //   imageArrLeng--;
    // });
  }

  Future<http.Response> editimg(File img, index) async {
    Dio dio = new Dio();
    FormData formData = FormData.fromMap(<String, dynamic>{
      "file": await MultipartFile.fromFile(img.path, filename: img.path),
    });
    Response response =
        await dio.post(Globals.BASE_URL + "api/v1/uploadimage", data: formData);
    print("URL AS FOLLOWS");
    print(response.data['fileurl']);
    editlinkimg(response.data['fileurl'], index);
    // setState(() {
    //   imageArrLeng--;
    // });
  }

  getimages() async {
    if (imageList.length > 0 || videoList.length > 0 || vidthumbs.length > 0)
      return;
    var jsonResponse;
    var response = await http.get(Uri.parse(
        Globals.BASE_URL + "api/chefapp/v1/getchefdetails?chefid=" + user.uid));
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);

      var chef = jsonResponse['details'];

      if (chef['chefprofile']['photos'].length > 0) {
        setState(() {
          if (chef['chefprofile']['photos'] != null &&
              chef['chefprofile']['photos'].length > 0) {
            for (int i = 0; i < chef['chefprofile']['photos'].length; i++) {
              imageList.add(chef['chefprofile']['photos'][i]['photo']);
            }
          }
        });
      }
      if (chef['chefprofile']['videos'].length > 0 &&
          chef['chefprofile']['videos'] != null) {
        if (chef['chefprofile']['videos'] != null &&
            chef['chefprofile']['videos'].length > 0) {
          for (int i = 0; i < chef['chefprofile']['videos'].length; i++) {
            videoList.add(chef['chefprofile']['videos'][i]['video']);
            await getthumbnail(i, false);
          }
        }
        setState(() {});
      }
    }
  }

  // IMAGE UPLOAD API
  Future<http.Response> gallerylinkimage(
      String imgpath, isUpdate, index) async {
    if (!isUpdate) {
      // setState(() {
      //   progressDialog.show();
      // });
      print(imageList.length - 1);
      await http
          .post(
            Uri.parse(Globals.BASE_URL + "api/chefapp/v1/chefuploadimg"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'index': imageList.length,
              'chefid': user.uid,
              'imgpath': imgpath,
            }),
          )
          .then((value) => setState(() {
                imageList.add(imgpath);
                progressDialog.hide();
                // if( imgList.length<3 && imgList[2]=="https://imagecdn.homechef.pk/dishImg.png" && imgList[1]=="https://imagecdn.homechef.pk/dishImg.png"){
                //   imgList.removeAt(2);
                // }

                // if(imgList.length<3 && index<2 && index!=0)
                // {
                //   imgList.add("https://imagecdn.homechef.pk/dishImg.png");
                //
                // }
                // Flushbar(
                //   message: "Dish photo updated successfully",
                //   duration: Duration(seconds: 3),
                // )
                //   ..show(context);
              }));
    } else {
      await http
          .post(
            Uri.parse(Globals.BASE_URL + "api/chefapp/v1/chefeditimg"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'index': index,
              'chefid': user.uid,
              'imgpath': imgpath,
            }),
          )
          .then((value) => setState(() {
                imageList[index] = imgpath;
                progressDialog.hide();
              }));
    }
  }

  /// updates image in the ui when Globals.galleryimage finishes execution
  void updateImageInUI(bool isUpdate, String imgpath, int index) {
    if (imgpath != null) {
      if (!isUpdate)
        setState(() {
          imageList.add(imgpath);
        });
      else
        setState(() {
          imageList[index] = imgpath;
        });
    }
  }

  getthumbnail(index, isUpdate) async {
    if (!isUpdate) {
      print("in thumbnail");
      final fileName = await VideoThumbnail.thumbnailFile(
        video: videoList[index],
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );
      print(fileName);
      setState(() {
        vidthumbs.add(fileName);
      });
    } else {
      print("in thumbnail");
      final fileName = await VideoThumbnail.thumbnailFile(
        video: videoList[index],
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        quality: 75,
      );
      print(fileName);
      setState(() {
        vidthumbs[index] = fileName;
      });
    }
  }

  Future<http.Response> gallerylinkvideo(
      String vidpath, isUpdate, index) async {
    if (!isUpdate) {
      print(videoList.length - 1);
      await http
          .post(
            Uri.parse(Globals.BASE_URL + "api/chefapp/v1/chefuploadvid"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'index': videoList.length,
              'chefid': user.uid,
              'imgpath': vidpath,
            }),
          )
          .then((value) => setState(() async {
                videoList.add(vidpath);
                await getthumbnail(videoList.length - 1, false);
                videoArrLeng++;
                progressDialog.hide();

                // if( imgList.length<3 && imgList[2]=="https://imagecdn.homechef.pk/dishImg.png" && imgList[1]=="https://imagecdn.homechef.pk/dishImg.png"){
                //   imgList.removeAt(2);
                // }

                // if(imgList.length<3 && index<2 && index!=0)
                // {
                //   imgList.add("https://imagecdn.homechef.pk/dishImg.png");
                //
                // }
                // Flushbar(
                //   message: "Dish photo updated successfully",
                //   duration: Duration(seconds: 3),
                // )
                //   ..show(context);
              }));
    } else {
      await http
          .post(
            Uri.parse(Globals.BASE_URL + "api/chefapp/v1/chefeditvid"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'index': index,
              'chefid': user.uid,
              'imgpath': vidpath,
            }),
          )
          .then((value) => setState(() async {
                videoList[index] = vidpath;
                await getthumbnail(index, true);
                progressDialog.hide();
                // if( imgList.length<3 && imgList[2]=="https://imagecdn.homechef.pk/dishImg.png" && imgList[1]=="https://imagecdn.homechef.pk/dishImg.png"){
                //   imgList.removeAt(2);
                // }

                // if(imgList.length<3 && index<2 && index!=0)
                // {
                //   imgList.add("https://imagecdn.homechef.pk/dishImg.png");
                //
                // }
                // Flushbar(
                //   message: "Dish photo updated successfully",
                //   duration: Duration(seconds: 3),
                // )
                //   ..show(context);
              }));
    }
  }

  Future<http.Response> editlinkimg(String imgpath, index) async {
    await http
        .post(
          Uri.parse(Globals.BASE_URL + "api/chefapp/v1/chefeditimg"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'index': index,
            'chefid': user.uid,
            'imgpath': imgpath,
          }),
        )
        .then((value) => setState(() {
              imageList[index] = imgpath;

              // if( imgList.length<3 && imgList[2]=="https://imagecdn.homechef.pk/dishImg.png" && imgList[1]=="https://imagecdn.homechef.pk/dishImg.png"){
              //   imgList.removeAt(2);
              // }

              // if(imgList.length<3 && index<2 && index!=0)
              // {
              //   imgList.add("https://imagecdn.homechef.pk/dishImg.png");
              //
              // }
              // Flushbar(
              //   message: "Dish photo updated successfully",
              //   duration: Duration(seconds: 3),
              // )
              //   ..show(context);
            }));
  }

  _vidFromGallery(isUpdate, index) async {
    ImagePicker _picker = ImagePicker();
    final video = await _picker.getVideo(source: ImageSource.gallery);

    print(video.path);
    _updateVideoDialog(File(video.path), isUpdate, index);
    // uploadvid(File(video.path), isUpdate, index);

    // _video = video;
    // if(await _image1 != null) {
    //   _updateImageDialog(await _image1, _current);
    // }
    // //galleryimg(await _image1);
    //
    // setState(() {
    //   _video = video;
    // });
  }

  _imgFromGallery(isUpdate, index) async {
    ImagePicker _picker = ImagePicker();
    final image = await _picker.getImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70);
    _image = File(image.path);
    final _image1 = _getCroppedImage(_image);
    if (await _image1 != null) {
      _updateImageDialog(await _image1, isUpdate, index);
      print("Value of is update");
      print(isUpdate);
    }
    //galleryimg(await _image1);

    setState(() {
      _image = File(image.path);
    });
  }

  Future<void> _showRemoveDialog(index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text("REWMOVE PHOTO"),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Are you sure you want to remove this photo?',
                textScaleFactor: 1.0,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF656565)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Padding(
                  //     padding: EdgeInsets.only(left: 15)
                  //
                  // ),
                  Container(
                    margin: EdgeInsets.only(top: 12, bottom: 10, right: 7),
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
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            height: 1.5,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  //
                  // Padding(
                  //     padding: EdgeInsets.only(right: 15)
                  //
                  // ),

                  Container(
                      margin: EdgeInsets.only(top: 12, left: 7, bottom: 10),
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
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              //color: Colors.white,
                              height: 1.5,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      )),

                  Padding(padding: EdgeInsets.only(right: 10)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  //
  // Future<void> _showRemoveVidDialog(index) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return
  //         AlertDialog(
  //           title:
  //           Center(
  //             child: Text("REMOVE VIDEO"),
  //           ),
  //
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Text('Are you sure you want to remove this Video?',textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Color(0xFF656565)),),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   // Padding(
  //                   //     padding: EdgeInsets.only(left: 15)
  //                   //
  //                   // ),
  //                   Container(
  //                     margin: EdgeInsets.only(top: 12, bottom: 10,right: 7),
  //                     child: RaisedButton(
  //                       elevation: 0.0,
  //                       color: Colors.white,
  //                       //color: Colors.black38,
  //                       shape: new RoundedRectangleBorder(
  //                           borderRadius: new BorderRadius.circular(4.0),
  //                           side: BorderSide(color: Colors.black)),
  //
  //                       disabledColor: Colors.black,
  //                       //Colors.black12,
  //                       padding: EdgeInsets.only(left: 35, right: 35),
  //                       onPressed: () {
  //
  //                         Navigator.of(context, rootNavigator: false).pop();
  //                       },
  //                       child: Text(
  //                         "No",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w600),
  //                       ),
  //                     ),
  //                   ),
  //
  //
  //
  //
  //                   //
  //                   // Padding(
  //                   //     padding: EdgeInsets.only(right: 15)
  //                   //
  //                   // ),
  //
  //
  //                   Container(
  //                       margin: EdgeInsets.only(
  //                           top: 12, left: 7, bottom: 10),
  //                       child: RaisedButton(
  //                         elevation: 0.0,
  //                         color: Color(0xFFFF872F),
  //                         disabledColor: Colors.black12,
  //                         shape: new RoundedRectangleBorder(
  //                             borderRadius: new BorderRadius.circular(4.0)),
  //                         padding: EdgeInsets.only(left: 35, right: 35),
  //                         onPressed: () {
  //
  //                           Navigator.of(context).pop();
  //
  //                           _RemoveSuccessfullyDialog(index);
  //                           //
  //                           // _popupWork();
  //                         },
  //                         child: Text(
  //                           "Yes",
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                             //color: Colors.white,
  //                               color: Colors.white,
  //                               fontSize: 16),
  //                         ),
  //                       )),
  //
  //
  //                   Padding(
  //                       padding: EdgeInsets.only(right: 10)
  //
  //                   ),
  //
  //
  //                 ],
  //               )
  //
  //             ],
  //           ),
  //
  //         );
  //
  //     },
  //   );
  // }

  Future<http.Response> removeimg(int index) async {
    await http
        .post(
          Uri.parse(Globals.BASE_URL + "api/chefapp/v1/chefremoveimg"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'chefid': user.uid,
            'index': index,
          }),
        )
        .then((value) => setState(() {
              imageList.removeAt(index);
              // else if( imgList.length<3 && index==1 && imgList[2]!="https://imagecdn.homechef.pk/dishImg.png"){
              //   imgList.add("https://imagecdn.homechef.pk/dishImg.png");
              // }
              Flushbar(
                message: "Photo removed successfully",
                duration: Duration(seconds: 4),
              )..show(context);
            }));
  }

  Future<http.Response> removevid(int index) async {
    await http
        .post(
          Uri.parse(Globals.BASE_URL + "api/chefapp/v1/chefremovevid"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'chefid': user.uid,
            'index': index,
          }),
        )
        .then((value) => setState(() {
              videoList.removeAt(index);
              videoArrLeng--;
              vidthumbs.removeAt(index);
              // else if( imgList.length<3 && index==1 && imgList[2]!="https://imagecdn.homechef.pk/dishImg.png"){
              //   imgList.add("https://imagecdn.homechef.pk/dishImg.png");
              // }
              Flushbar(
                message: "Video removed successfully",
                duration: Duration(seconds: 4),
              )..show(context);
            }));
  }

  // user defined function
  void _editPhotoDialog(croppedFile, removingIndex) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: Text(
              "Edit Photo",
              textScaleFactor: 1.0,
              style: TextStyle(
                  height: 1.5,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF656565)),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text("Add Photo",textAlign: TextAlign.center,style:TextStyle( color: Color(0xFF656565),fontSize: 20,fontWeight: FontWeight.w600)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Are you sure you want to edit this photo?",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF656565)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 12, bottom: 10, right: 7),
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
                          FirebaseAnalytics()
                              .logEvent(name: 'UploadPhoto', parameters: {
                            // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                            'Parameter': 'Edit_Photo_No'
                          });
                        },
                        child: Text(
                          "No",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              height: 1.5,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 12, bottom: 10, left: 7),
                        child: RaisedButton(
                          elevation: 0.0,
                          color: Color(0xFFFF872F),
                          disabledColor: Colors.black12,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(4.0)),
                          padding: EdgeInsets.only(left: 35, right: 35),
                          onPressed: () {
                            Navigator.of(context).pop();
                            editimg(croppedFile, removingIndex);
                            FirebaseAnalytics()
                                .logEvent(name: 'UploadPhoto', parameters: {
                              // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                              'Parameter': 'Edit_Photo_Yes'
                            });

                            //
                          },
                          child: Text(
                            "Yes",
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                height: 1.5,
                                //color: Colors.white,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        )),
                  ],
                )
              ],
            ));
      },
    );
  }

  // user defined function
  void _updateVideoDialog(path, isUpdate, index) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: (isUpdate == false)
                ? Text(
                    "Add Video",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: 20,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF656565)),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    "Update Video",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: 20,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF656565)),
                    textAlign: TextAlign.center,
                  ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text("Add Photo",textAlign: TextAlign.center,style:TextStyle( color: Color(0xFF656565),fontSize: 20,fontWeight: FontWeight.w600)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (isUpdate == false)
                      ? Text(
                          "Are you sure you want to add this video?",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF656565)),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          "Are you sure you want to update this video?",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF656565)),
                          textAlign: TextAlign.center,
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 12, bottom: 10, right: 7),
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

                          if (isUpdate == false) {
                            FirebaseAnalytics()
                                .logEvent(name: 'UploadVideo', parameters: {
                              // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                              'Parameter': 'Add_Video_No'
                            });
                          } else {
                            FirebaseAnalytics()
                                .logEvent(name: 'UploadPhoto', parameters: {
                              // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                              'Parameter': 'Update_Video_No'
                            });
                          }
                        },
                        child: Text(
                          "No",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              height: 1.5,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 12, bottom: 10, left: 7),
                        child: RaisedButton(
                          elevation: 0.0,
                          color: Color(0xFFFF872F),
                          disabledColor: Colors.black12,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(4.0)),
                          padding: EdgeInsets.only(left: 35, right: 35),
                          onPressed: () {
                            Navigator.of(context).pop();
                            //galleryimg(_image1,isUpdate,index);
                            // gallerylinkvideo(
                            //     // response.data['fileurl'],
                            //     path,isUpdate,index);
                            uploadvid(path, isUpdate, index);

                            if (isUpdate == false) {
                              FirebaseAnalytics()
                                  .logEvent(name: 'UploadVideo', parameters: {
                                // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                                'Parameter': 'Add_Video_Yes'
                              });
                            } else {
                              FirebaseAnalytics()
                                  .logEvent(name: 'UploadPhoto', parameters: {
                                // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                                'Parameter': 'Update_Video_yes'
                              });
                            }

                            //
                          },
                          child: Text(
                            "Yes",
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                //color: Colors.white,
                                height: 1.5,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        )),
                  ],
                )
              ],
            ));
      },
    );
  }

// user defined function
  void _updateImageDialog(_image1, isUpdate, index) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: (isUpdate == false)
                ? Text(
                    "Add Photo",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: Color(0xFF656565)),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    "Update Photo",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: 20,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF656565)),
                    textAlign: TextAlign.center,
                  ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text("Add Photo",textAlign: TextAlign.center,style:TextStyle( color: Color(0xFF656565),fontSize: 20,fontWeight: FontWeight.w600)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (isUpdate == false)
                      ? Text(
                          "Are you sure you want to add this photo?",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF656565)),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          "Are you sure you want to update this photo?",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: Color(0xFF656565)),
                          textAlign: TextAlign.center,
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 12, bottom: 10, right: 7),
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

                          if (isUpdate == false) {
                            FirebaseAnalytics()
                                .logEvent(name: 'UploadPhoto', parameters: {
                              // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                              'Parameter': 'Add_Photo_No'
                            });
                          } else {
                            FirebaseAnalytics()
                                .logEvent(name: 'UploadPhoto', parameters: {
                              // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                              'Parameter': 'Update_Photo_No'
                            });
                          }
                        },
                        child: Text(
                          "No",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              height: 1.5,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 12, bottom: 10, left: 7),
                        child: RaisedButton(
                          elevation: 0.0,
                          color: Color(0xFFFF872F),
                          disabledColor: Colors.black12,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(4.0)),
                          padding: EdgeInsets.only(left: 35, right: 35),
                          onPressed: () {
                            Navigator.of(context).pop();

                            Globals.galleryimg(_image1, isUpdate, index,
                                    imageList, user.uid, context)
                                .then((imageUrl) {
                              // ideally, this should be shifted to providers instead of setState
                              updateImageInUI(isUpdate, imageUrl, index);
                            });

//                            galleryimg(_image1, isUpdate, index);

                            if (isUpdate == false) {
                              FirebaseAnalytics()
                                  .logEvent(name: 'UploadPhoto', parameters: {
                                // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                                'Parameter': 'Add_Photo_Yes'
                              });
                            } else {
                              FirebaseAnalytics()
                                  .logEvent(name: 'UploadPhoto', parameters: {
                                // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                                'Parameter': 'Update_Photo_Yes'
                              });
                            }

                            //
                          },
                          child: Text(
                            "Yes",
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                height: 1.5,
                                //color: Colors.white,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        )),
                  ],
                )
              ],
            ));
      },
    );
  }

  Future<void> _RemoveSuccessfullyDialog(index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Center(
              child: (index == 0)
                  ? Text(
                      'Dish Photo 1 \n Removed',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.5,
                        color: Color(0xFF656565),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : (index == 1)
                      ? Text(
                          'Dish Photo 2 \n Removed',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontSize: 20,
                            height: 1.5,
                            color: Color(0xFF656565),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          'Dish Photo 3 \n Removed',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontSize: 20,
                            height: 1.5,
                            color: Color(0xFF656565),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Center(
                      child: Text(
                    'Your picture has been removed successfully!',
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF656565)),
                  )),
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
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            //color: Colors.white,
                            height: 1.5,
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

  Future<File> _EditImagee(removingIndex) async {
    // var response = await http.get(imageList[removingIndex]);
    // Directory documentDirectory = await getApplicationDocumentsDirectory();
    // File file = new File(join(documentDirectory.path, 'imagetest.png'));
    //  file.writeAsBytesSync(response.bodyBytes);

    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response =
        await http.get(Uri.parse(imageList[removingIndex]));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
    //print("IT IS IN HERE" + imageList[removingIndex]);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
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
        ));

    _editPhotoDialog(croppedFile, removingIndex);
    //editimg(croppedFile,removingIndex);
    return croppedFile;
  }

  Future<File> _getCroppedImage(File img) async {
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
        ));
    return croppedFile;
  }

// initialization
  List imageList = new List();
  List videoList = new List();
  List recordingList = new List();
  List vidthumbs = new List();
  int imageArrLeng;
  int videoArrLeng = 0;
  int recordingArrLeng = 0;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    getimages();

    setState(() {
      imageArrLeng = imageList.length;
      videoArrLeng = videoList.length;
      recordingArrLeng = recordingList.length;
      // imageList.removeAt(0);
      // imageList.add("k");
      // recordingList.add("value");
      // recordingList.removeLast();removeLast();
    });

    return ChefAppScaffold(
        title: "My Gallery",
        showNotifications: true,
        showBackButton: false,
        showHomeButton: true,
        body: DefaultTabController(
          length: 2,
          child: Column(children: [
            Container(
              child: TabBar(
                tabs: [
                  Tab(
                    child: Center(
                        child: Text(
                      "PHOTOS",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: Color(0xFF656565),
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: FontWeight.w600),
                    )),
                  ),
                  Tab(
                    child: Center(
                        child: Text(
                      "VIDEOS",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: Color(0xFF656565),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )),
                  ),
                ],
              ),
            ),
            Expanded(
                child: TabBarView(children: [
              //PHOTOS PAGE

              Container(
                  // First Element in Value Which means all will be empty
                  child: (imageList.isEmpty)
                      ? Column(
                          children: <Widget>[
                            // Text("IMAGE LENGTH IS ZERO"),

                            Center(
                                child: InkWell(
                              child: Image.asset(
                                "images/gallery/Addbutton9.png",
                                width: MediaQuery.of(context).size.width * 0.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                              ),
                              onTap: () {
                                showBottomSheetofImageUpload(context, false, 0);
                                FirebaseAnalytics()
                                    .logEvent(name: 'UploadPhoto', parameters: {
                                  // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                                  'Parameter': 'Add_Photo_Clicks'
                                });
                              },
                            )),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width * 0.25,
                                  0,
                                  MediaQuery.of(context).size.width * 0.26,
                                  0),
                              child: Center(
                                child: Text(
                                  "The photos that you will add here will be displayed on your chef profile!",
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                      fontSize: 14,
                                      color: Color(0xFF656565)),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width * 0.25,
                                  25,
                                  MediaQuery.of(context).size.width * 0.25,
                                  5),
                              child: Center(
                                  child: Text(
                                "You can add upto 10 photos.",
                                textScaleFactor: 1.0,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                    fontSize: 12,
                                    color: Color(0xFF656565)),
                              )),
                            )
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(0.25),
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),
                                    // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),

                                    (imageArrLeng < 10)
                                        ? Container(
                                            child: InkWell(
                                              child: Image.asset(
                                                  "images/gallery/Addbutton9.png",
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.49,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25),
                                              onTap: () {
                                                setState(() {
                                                  showBottomSheetofImageUpload(
                                                      context, false, 0);
                                                });

                                                FirebaseAnalytics().logEvent(
                                                    name: 'UploadPhoto',
                                                    parameters: {
                                                      // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                                                      'Parameter':
                                                          'Add_Photo_Clicks'
                                                    });
                                              },
                                            ),
                                          )
                                        : Container(
                                            child: InkWell(
                                              child: Image.asset(
                                                  "images/gallery/AddbuttonDisabled.png",
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.49,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25),
                                              onTap: () {
                                                setState(() {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          AddbuttonDisabledPopup());
                                                });
                                              },
                                            ),
                                          ),
                                    // Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.01)),

                                    (imageArrLeng >= 1)
                                        ? Container(
                                            // decoration: BoxDecoration(
                                            //   borderRadius: BorderRadius.all(Radius.circular(20)),
                                            //
                                            // ),

                                            child: InkWell(
                                              child:
                                                  // ClipRRect(
                                                  //   borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  //   child:
                                                  //https://dummyimage.com/400x400/000/fff
                                                  Image.network(imageList[0],
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.49,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.25),
                                              // ),
                                              onTap: () {
                                                showBottomSheetofImages(
                                                    context, 0);
                                              },
                                            ),
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.49,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.25),
                                  ],
                                ),
                              ),
                              (imageArrLeng >= 2)
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),
                                          // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),

                                          (imageArrLeng >= 2)
                                              ? Container(
                                                  child: InkWell(
                                                    child: Image.network(
                                                        imageList[1],
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.49,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.25),
                                                    onTap: () {
                                                      showBottomSheetofImages(
                                                          context, 1);
                                                    },
                                                  ),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.49,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25),
                                          // Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.01)),
                                          (imageArrLeng >= 3)
                                              ? Container(
                                                  child: InkWell(
                                                    child: Image.network(
                                                        imageList[2],
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.49,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.25),
                                                    onTap: () {
                                                      showBottomSheetofImages(
                                                          context, 2);
                                                    },
                                                  ),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.49,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              (imageArrLeng >= 4)
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),
                                          // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),

                                          (imageArrLeng >= 4)
                                              ? Container(
                                                  child: InkWell(
                                                    child: Image.network(
                                                        imageList[3],
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.49,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.25),
                                                    onTap: () {
                                                      showBottomSheetofImages(
                                                          context, 3);
                                                    },
                                                  ),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.49,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25),
                                          // Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.01)),
                                          (imageArrLeng >= 5)
                                              ? Container(
                                                  child: InkWell(
                                                    child: Image.network(
                                                        imageList[4],
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.49,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.25),
                                                    onTap: () {
                                                      showBottomSheetofImages(
                                                          context, 4);
                                                    },
                                                  ),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.49,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              (imageArrLeng >= 6)
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),
                                          // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),

                                          (imageArrLeng >= 6)
                                              ? Container(
                                                  child: InkWell(
                                                      child: Image.network(
                                                          imageList[5],
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.49,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.25),
                                                      onTap: () {
                                                        showBottomSheetofImages(
                                                            context, 5);
                                                      }),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.49,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25),
                                          // Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.01)),
                                          (imageArrLeng >= 7)
                                              ? Container(
                                                  child: InkWell(
                                                      child: Image.network(
                                                          imageList[6],
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.49,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.25),
                                                      onTap: () {
                                                        showBottomSheetofImages(
                                                            context, 6);
                                                      }),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.49,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              (imageArrLeng >= 8)
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),
                                          // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),

                                          (imageArrLeng >= 8)
                                              ? Container(
                                                  child: InkWell(
                                                      child: Image.network(
                                                          imageList[7],
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.49,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.25),
                                                      onTap: () {
                                                        showBottomSheetofImages(
                                                            context, 7);
                                                      }),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.49,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25),
                                          // Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.01)),
                                          (imageArrLeng >= 9)
                                              ? Container(
                                                  child: InkWell(
                                                      child: Image.network(
                                                          imageList[8],
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.49,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.25),
                                                      onTap: () {
                                                        showBottomSheetofImages(
                                                            context, 8);
                                                      }),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.49,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              (imageArrLeng >= 10)
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),
                                          // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),

                                          (imageArrLeng >= 10)
                                              ? Container(
                                                  child: InkWell(
                                                      child: Image.network(
                                                          imageList[9],
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.49,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.25),
                                                      onTap: () {
                                                        showBottomSheetofImages(
                                                            context, 9);
                                                      }),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.49,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25),
                                          // Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.01)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.49,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              (imageArrLeng >= 10)
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                          left: 15.0,
                                          bottom: 15.0),
                                      child: Text(
                                        "You can have upto 10 photos",
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF656565)),
                                      ),
                                    )
                                  : (imageArrLeng == 7 ||
                                          imageArrLeng == 6 ||
                                          imageArrLeng == 8 ||
                                          imageArrLeng == 9)
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                              left: 15.0,
                                              bottom: 10.0),
                                          child: Text(
                                            "You can have upto 10 photos",
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF656565)),
                                          ),
                                        )
                                      : (imageArrLeng == 5 || imageArrLeng == 4)
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                  left: 15.0,
                                                  bottom: 10.0),
                                              child: Text(
                                                "You can have upto 10 photos",
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF656565)),
                                              ),
                                            )
                                          : (imageArrLeng == 3 ||
                                                  imageArrLeng == 2)
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.26,
                                                      left: 15.0,
                                                      bottom: 10.0),
                                                  child: Text(
                                                    "You can have upto 10 photos",
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFF656565)),
                                                  ),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.52,
                                                      left: 15.0,
                                                      bottom: 10.0),
                                                  child: Text(
                                                    "You can have upto 10 photos",
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFF656565)),
                                                  ),
                                                ),
                            ],
                          ),
                        )

                  // Column(
                  //   mainAxisSize: MainAxisSize.max,
                  //
                  //   //Text("IMAGE LENGTH IS NOT ZERO"),
                  //
                  //   children: <Widget>[
                  //     Expanded(
                  //       child: GridView.builder(
                  //           padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  //           itemCount: 10, //images.length
                  //
                  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //               crossAxisSpacing: 1.5, mainAxisSpacing: 1.5,
                  //               crossAxisCount: 2),
                  //           itemBuilder: (BuildContext context, int index) {
                  //
                  //
                  //            // return Image.asset("images/gallery/Addbutton6.png");
                  //             // Image.network(imageList[index+1]);
                  //              return Card(
                  //               child: InkResponse(
                  //                 child: Container(
                  //                     child:
                  //                     Image.asset("images/gallery/Addbutton6.png")
                  //                     // Image.network(imageList[index])
                  //
                  //                   // height: MediaQuery.of(context).size.height *0.3,
                  //                   // width: MediaQuery.of(context).size.width *0.45,
                  //                 ),
                  //
                  //                 onTap: () {
                  //
                  //
                  //                 },
                  //               ),
                  //             );
                  //           }),
                  //     ),
                  //   ],
                  //
                  // )
                  ),

              //VIDEOS PAGEE

              Container(
                  child:
                      //Text("Page2")
                      (videoList.isEmpty)
                          ? Column(
                              children: <Widget>[
                                // Text("IMAGE LENGTH IS ZERO"),

                                Center(
                                    child: InkWell(
                                  child: Image.asset(
                                    "images/gallery/Addvideo2.png",
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                  ),
                                  onTap: () {
                                    showBottomSheetofVideoUpload(
                                        context, false, 0);

                                    FirebaseAnalytics().logEvent(
                                        name: 'UploadVideo',
                                        parameters: {
                                          // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                                          'Parameter': 'add_video_clicks'
                                        });
                                  },
                                )),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width * 0.25,
                                      0,
                                      MediaQuery.of(context).size.width * 0.26,
                                      0),
                                  child: Center(
                                    child: Text(
                                      "The videos that you will add here will be displayed on your chef profile!",
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                          fontSize: 14,
                                          color: Color(0xFF656565)),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width * 0.25,
                                      25,
                                      MediaQuery.of(context).size.width * 0.25,
                                      5),
                                  child: Center(
                                      child: Text(
                                    " You can add upto 5 videos.",
                                    textScaleFactor: 1.0,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                        fontSize: 12,
                                        color: Color(0xFF656565)),
                                  )),
                                )
                              ],
                            )
                          :
                          //vid works

                          Padding(
                              padding: const EdgeInsets.all(0.25),
                              child: ListView(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),
                                        // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),

                                        (videoArrLeng < 5)
                                            ? Container(
                                                child: InkWell(
                                                  child: Image.asset(
                                                      "images/gallery/Addvideo2.png",
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.49,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.25),
                                                  onTap: () {
                                                    setState(() {
                                                      showBottomSheetofVideoUpload(
                                                          context, false, 0);
                                                    });
                                                    FirebaseAnalytics()
                                                        .logEvent(
                                                            name: 'UploadVideo',
                                                            parameters: {
                                                          // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                                                          'Parameter':
                                                              'add_video_clicks'
                                                        });
                                                  },
                                                ),
                                              )
                                            : Container(
                                                child: InkWell(
                                                  child: Image.asset(
                                                      "images/gallery/AddvideoDisabled.png",
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.49,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.25),
                                                  onTap: () {
                                                    setState(() {
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) =>
                                                              addVideobuttonDisabledPopup());
                                                    });
                                                  },
                                                ),
                                              ),
                                        // Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.01)),
                                        (videoArrLeng >= 1 &&
                                                vidthumbs.length >= 1)
                                            ? Container(
                                                child: InkWell(
                                                  child: Image.file(
                                                      File(vidthumbs[0]),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.49,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.25),
                                                  onTap: () async {
                                                    showBottomSheetofvideoUpdateRemUpd(
                                                        context, 0);

                                                    // showBottomSheetofVideos(context,0);
                                                  },
                                                ),
                                              )
                                            : Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.49,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),
                                        // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),

                                        (videoArrLeng >= 2 &&
                                                vidthumbs.length >= 2)
                                            ? Container(
                                                child: InkWell(
                                                  child: Image.file(
                                                      File(vidthumbs[1]),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.49,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.25),
                                                  onTap: () {
                                                    showBottomSheetofvideoUpdateRemUpd(
                                                        context, 1);
                                                  },
                                                ),
                                              )
                                            : Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.49,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25),
                                        // Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.01)),
                                        (videoArrLeng >= 3 &&
                                                vidthumbs.length >= 3)
                                            ? Container(
                                                child: InkWell(
                                                  child: Image.file(
                                                      File(vidthumbs[2]),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.49,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.25),
                                                  onTap: () {
                                                    showBottomSheetofvideoUpdateRemUpd(
                                                        context, 2);
                                                  },
                                                ),
                                              )
                                            : Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.49,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),
                                        // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),

                                        (videoArrLeng >= 4 &&
                                                vidthumbs.length >= 4)
                                            ? Container(
                                                child: InkWell(
                                                  child: Image.file(
                                                      File(vidthumbs[3]),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.49,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.25),
                                                  onTap: () {
                                                    showBottomSheetofvideoUpdateRemUpd(
                                                        context, 3);
                                                  },
                                                ),
                                              )
                                            : Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.49,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25),
                                        // Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.01)),
                                        (videoArrLeng >= 5 &&
                                                vidthumbs.length >= 5)
                                            ? Container(
                                                child: InkWell(
                                                  child: Image.file(
                                                      File(vidthumbs[4]),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.49,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.25),
                                                  onTap: () {
                                                    showBottomSheetofvideoUpdateRemUpd(
                                                        context, 4);
                                                  },
                                                ),
                                              )
                                            : Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.49,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25),
                                      ],
                                    ),
                                  ),

                                  (videoArrLeng >= 5)
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.0, bottom: 20.0),
                                          child: Text(
                                            "You can have upto 5 videos",
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF656565)),
                                          ),
                                        )
                                      : (videoArrLeng == 4 || videoArrLeng == 3)
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                  left: 15.0,
                                                  bottom: 10.0),
                                              child: Text(
                                                "You can have upto 5 videos",
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF656565)),
                                              ),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                  left: 15.0,
                                                  bottom: 10.0),
                                              child: Text(
                                                "You can have upto 5 videos",
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF656565)),
                                              ),
                                            ),

                                  // Padding(
                                  //   padding: const EdgeInsets.only(top:10),
                                  //   child:
                                  //   Row(
                                  //     mainAxisSize: MainAxisSize.max,
                                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //
                                  //     children: <Widget> [
                                  //
                                  //       // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),
                                  //       // InkWell(child: Image.network('https://picsum.photos/250?image=9',width: MediaQuery.of(context).size.width *0.47, height: MediaQuery.of(context).size.height *0.25),
                                  //
                                  //       (imageArrLeng>=10)?Container(
                                  //         child: InkWell( child:Image.network('https://picsum.photos/250?image=9',
                                  //             width: MediaQuery.of(context).size.width *0.49,
                                  //             height: MediaQuery.of(context).size.height *0.25),
                                  //
                                  //             onTap: (){
                                  //               showBottomSheetofImages(context,9);
                                  //             }
                                  //
                                  //         ),
                                  //       ):
                                  //       Container(
                                  //           width: MediaQuery.of(context).size.width *0.49,
                                  //           height: MediaQuery.of(context).size.height *0.25),
                                  //       // Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.01)),
                                  //       Container(
                                  //           width: MediaQuery.of(context).size.width *0.49,
                                  //           height: MediaQuery.of(context).size.height *0.25),
                                  //     ],
                                  //   ),
                                  //
                                  // ),
                                ],
                              ),
                            )

                  // vid works

                  // Column(
                  //   mainAxisSize: MainAxisSize.max,
                  //
                  //   //Text("IMAGE LENGTH IS NOT ZERO"),
                  //
                  //   children: <Widget>[
                  //     Expanded(
                  //       child: GridView.builder(
                  //           padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  //           itemCount: 10, //images.length
                  //
                  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //               crossAxisSpacing: 1.5, mainAxisSpacing: 1.5,
                  //               crossAxisCount: 2),
                  //           itemBuilder: (BuildContext context, int index) {
                  //
                  //
                  //             return Image.asset("images/gallery/Addvideo.png");
                  //             // Image.network(imageList[index+1]);
                  //             //   Card(
                  //             //   child: InkResponse(
                  //             //     child: Container(
                  //             //
                  //             //       // height: MediaQuery.of(context).size.height *0.3,
                  //             //       // width: MediaQuery.of(context).size.width *0.45,
                  //             //     ),
                  //             //     onTap: () {
                  //             //
                  //             //     },
                  //             //   ),
                  //
                  //
                  //           }),
                  //     ),
                  //   ],
                  //
                  // )
                  ),

// audio CONtainer start
              //AUDIOS PAGE
              // Container(
              //     child:
              //     // Center(child: Text("3rd page"),)
              //     (recordingList.isEmpty) ?Column(
              //       children: <Widget>[
              //         // Text("IMAGE LENGTH IS ZERO"),
              //
              //
              //         Center(
              //             child:
              //             InkWell(
              //               child: Image.asset("images/gallery/soundWaves2.png",
              //                 width: MediaQuery.of(context).size.width * 0.4,
              //                 height:MediaQuery.of(context).size.height* 0.3,),
              //
              //               onTap: (){
              //                 //showBottomSheetofImageUpload(context);
              //               },
              //
              //
              //             )
              //
              //         ),
              //         Padding(
              //           padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width *0.25, 0, MediaQuery.of(context).size.width *0.26, 0),
              //           child: Center(
              //             child: Text("The audios that you will add here will be uploaded to your chef profile!", textAlign: TextAlign.center,style: TextStyle( fontWeight: FontWeight.w600, fontSize: 14,color: Color(0xFF656565)),),
              //           ),
              //         ),
              //
              //
              //         Padding(
              //           padding:  EdgeInsets.fromLTRB(MediaQuery.of(context).size.width *0.25, 25, MediaQuery.of(context).size.width *0.25, 5),
              //           child: Center(
              //               child: Text("You can add upto 3 audios.", textAlign: TextAlign.center,style: TextStyle( fontWeight: FontWeight.w600, fontSize: 12,color: Color(0xFF656565)),)),
              //         ),
              //
              //         Padding(
              //           padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height *0.25, 0, 0),
              //           child: Divider(
              //             color: Color(0xff656565),
              //             thickness: 1,
              //
              //           ),
              //         ),
              //
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              //           child: Center(
              //               child:
              //               GestureDetector(
              //                 behavior: HitTestBehavior.translucent,
              //                 onTapDown: (details) {
              //                   startRecording();
              //
              //                 },
              //                           // ICON FOR RECORDING  \/ \/ \/ \/
              //                           // Image.asset("images/gallery/micIcon.png",
              //                           // //       width:70, height: 70),
              //
              //                 onTapUp: isRecording
              //                     ? (details) {
              //                   print("recording stopped");
              //                   audioRecorder.stop();
              //                   setState(() {
              //                     isRecording = false;
              //                   });
              //                 }
              //                     : null,
              //                 child: Icon(
              //                   Icons.mic_none_sharp,
              //                   color: isRecording ? Colors.red : Colors.indigo,
              //                   size: 35,
              //                 ),
              //               ),
              //
              //
              //
              //               // comment gesture detector to see next page's UI
              //
              //               //
              //               // InkWell(
              //               //   child: Image.asset("images/gallery/micIcon.png",
              //               //       width:70, height: 70),
              //               //
              //               //   onTap: (){
              //               //     //showBottomSheetofImageUpload(context);
              //               //
              //               //
              //               //     setState(() {
              //               //       recordingList.add('ss');
              //               //       recordingArrLeng++;
              //               //     });
              //               //
              //               //      // startRecording();
              //               //
              //               //
              //               //
              //               //   },
              //               //
              //               //
              //               // )
              //
              //           ),
              //         ),
              //
              //
              //
              //       ],
              //     )
              //         :
              //
              //     Column(
              //       mainAxisSize: MainAxisSize.max,
              //
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       //Text("IMAGE LENGTH IS NOT ZERO"),
              //
              //       children: <Widget>[
              //         Padding(
              //           padding: const EdgeInsets.all(10.0),
              //           child: Text("Recordings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF212529)),),
              //         ),
              //         // ListTile(
              //         //
              //         //   leading: Icon(Icons.map),
              //         //   trailing: Icon(Icons.ac_unit_outlined),
              //         //   title: Text('Map'),
              //         //
              //         //
              //         //
              //         // ),
              //
              //
              //         (recordingArrLeng>=1)? Padding(
              //           padding: const EdgeInsets.all(12.0),
              //           child: Container(
              //             height: MediaQuery.of(context).size.height *0.1,
              //             decoration:
              //             BoxDecoration( border: Border.all(
              //               color: Color(0xFFC4C4C4),
              //             ), ),
              //             // BoxDecoration(
              //             //   border: Border.all(
              //             //       color: Color(0xFF656565),
              //             //       width: 1,
              //             //       ),
              //             //
              //             // ),
              //             child: Padding(
              //               padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              //               child: InkWell(
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Column(
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Text("Audio 1" ,style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF212529)),),
              //                         Text("UPLOAD DATE",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF656565).withOpacity(0.7),),)
              //                       ],
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.all(8.0),
              //                       child: Row(
              //                           children: [
              //                             Text("02:30:21",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF656565),)),
              //                             Padding(
              //                               padding: const EdgeInsets.all(8.0),
              //                               child: InkWell(
              //                                 child: Image.asset("images/gallery/playIcon.png",
              //                                     width:20, height: 20),
              //                                 onTap: (){
              //                                   // On tap Audio
              //
              //                                   AudioPlayer player = new AudioPlayer();
              //                                   player.play("https://bit.ly/2CH50TO");
              //                                 },
              //                               ),
              //                             )
              //
              //                           ]
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //
              //                 onTap: (){
              //                   showBottomSheetofRemoveAudio(context,0);
              //
              //
              //                 },
              //
              //
              //               ),
              //             ),
              //           ),
              //         ): Container(),
              //
              //         (recordingArrLeng == 1) ? Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.264),): Container(),
              //
              //         (recordingArrLeng>=2)? InkWell(
              //           child: Padding(
              //             padding: const EdgeInsets.all(12.0),
              //             child:Container(
              //               height: MediaQuery.of(context).size.height *0.1,
              //               decoration:
              //               BoxDecoration( border: Border.all(
              //                 color: Color(0xFFC4C4C4),
              //               ), ),
              //               // BoxDecoration(
              //               //   border: Border.all(
              //               //       color: Color(0xFF656565),
              //               //       width: 1,
              //               //       ),
              //               //
              //               // ),
              //               child: Padding(
              //                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Column(
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Text("Audio 2" ,style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF212529)),),
              //                         Text("UPLOAD DATE",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF656565).withOpacity(0.7),),)
              //                       ],
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.all(8.0),
              //                       child: Row(
              //                           children: [
              //                             Text("02:30:21",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF656565),)),
              //                             Padding(
              //                               padding: const EdgeInsets.all(8.0),
              //                               child: InkWell(
              //                                 child: Image.asset("images/gallery/playIcon.png",
              //                                     width:20, height: 20),
              //                                 onTap: (){
              //                                   AudioPlayer player = new AudioPlayer();
              //                                   player.play("https://bit.ly/2CH50TO");
              //                                   // On tap Audio 2
              //                                 },
              //                               ),
              //                             )
              //
              //                           ]
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //           onTap: (){
              //             showBottomSheetofRemoveAudio(context,1);
              //           },
              //         ): Container(),
              //
              //         (recordingArrLeng == 2) ? Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.133),): Container(),
              //
              //         (recordingArrLeng>=3)? InkWell(
              //           child: Padding(
              //             padding: const EdgeInsets.all(12.0),
              //             child: Container(
              //               height: MediaQuery.of(context).size.height *0.1,
              //               decoration:
              //               BoxDecoration( border: Border.all(
              //                 color: Color(0xFFC4C4C4),
              //               ), ),
              //               // BoxDecoration(
              //               //   border: Border.all(
              //               //       color: Color(0xFF656565),
              //               //       width: 1,
              //               //       ),
              //               //
              //               // ),
              //               child: Padding(
              //                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Column(
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Text("Audio 3" ,style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF212529)),),
              //                         Text("UPLOAD DATE",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF656565).withOpacity(0.7),),)
              //                       ],
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.all(8.0),
              //                       child: Row(
              //                           children: [
              //                             Text("02:30:21",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF656565),)),
              //                             Padding(
              //                               padding: const EdgeInsets.all(8.0),
              //                               child: InkWell(
              //                                 child: Image.asset("images/gallery/playIcon.png",
              //                                     width:20, height: 20),
              //                                 onTap: (){
              //                                   // On tap Audio 3
              //                                 },
              //                               ),
              //                             )
              //
              //                           ]
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //           onTap: (){
              //             showBottomSheetofRemoveAudio(context,1);
              //           },
              //         ): Container(),
              //
              //         Padding(
              //           padding: EdgeInsets.fromLTRB(0,MediaQuery.of(context).size.height *0.2, 0, 0),
              //           child: Divider(
              //             color: Color(0xff656565),
              //             thickness: 1,
              //
              //           ),
              //         ),
              //
              //
              //
              //         (recordingArrLeng<=2)?
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children:<Widget> [
              //             Padding(
              //               padding: const EdgeInsets.all(15.0),
              //               child:
              //               InkWell(child: Image.asset('images/gallery/micIcon.png', height:55, width: 55,),
              //                 onTap: (){
              //                   //AppBody();
              //                   setState(() {
              //                     recordingList.add('ss');
              //                     recordingArrLeng++;
              //                   });
              //
              //
              //                 },
              //               ),
              //
              //             )
              //
              //           ],
              //         ):
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children:<Widget> [
              //             Padding(
              //               padding: const EdgeInsets.all(15.0),
              //               child:
              //               InkWell(child: Image.asset('images/gallery/MicIconDisabled.png', height:55, width: 55,),
              //                 onTap: (){
              //                   // micInactivePopup
              //                   showDialog(
              //                       context: context,
              //                       builder: (_) =>
              //                           micInactivePopup());
              //
              //
              //                 },
              //               ),
              //
              //             )
              //
              //           ],
              //         )
              //
              //
              //
              //
              //
              //
              //       ],
              //
              //     )
              // )

              // Audio Container ENDS
            ]))
          ]),
        ));
  }

  void showBottomSheetofImageUpload(context, isUpdate, index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Center(
                      child:

                          //Text("Add Photo",style: TextStyle(fontSize: 20,color: Color(0xFF656565),fontWeight:FontWeight.w600),)
                          InkWell(
                        child: Image.asset(
                          'images/gallery/rectangle.png',
                          height: 35,
                          width: 45,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                  new ListTile(
                    leading: Image.asset(
                      'images/camera_icon.png',
                      height: 35,
                      width: 35,
                    ),
                    title: new Text('Take Photo',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF656565))),
                    onTap: () {
                      _imgFromCamera(isUpdate, index);
                      // setState(() {
                      //   imageList.add("ss");
                      //   imageArrLeng++;
                      // });
                      Navigator.of(context).pop();

                      FirebaseAnalytics()
                          .logEvent(name: 'UploadPhoto', parameters: {
                        // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                        'Parameter': 'Take_Photo_Clicks'
                      });
                    },
                  ),
                  new ListTile(
                      leading: Image.asset(
                        'images/gallery_icon.png',
                        height: 35,
                        width: 35,
                      ),
                      title: new Text('Choose from Gallery',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF656565))),
                      onTap: () {
                        _imgFromGallery(isUpdate, index);
                        print("he");
                        Navigator.of(context).pop();

                        FirebaseAnalytics()
                            .logEvent(name: 'UploadPhoto', parameters: {
                          // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                          'Parameter': 'Choose_From_Gallery_Clicks'
                        });
                      }),
                ],
              ),
            ),
          );
        });
  }

  void showBottomSheetofVideos(context, int removingIndex) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Center(
                      child:

                          //Text("Add Photo",style: TextStyle(fontSize: 20,color: Color(0xFF656565),fontWeight:FontWeight.w600),)
                          InkWell(
                        child: Image.asset(
                          'images/gallery/rectangle.png',
                          height: 35,
                          width: 45,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                  new ListTile(
                      leading: Image.asset(
                        'images/remove_icon.png',
                        height: 35,
                        width: 35,
                      ),
                      title: new Text('Remove Video',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF656565))),
                      onTap: () {
                        //_imgFromGallery();
                        Navigator.of(context).pop();
                        _showRemoveVideoDialog(removingIndex);

                        // setState(() {
                        //   videoList.removeAt(removingIndex);
                        //   videoArrLeng--;
                        // });
                      }),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showRemovePhotoDialog(removingIndex) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            'Remove Photo',
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF656565)),
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Are you sure you want to remove this photo?',
                textScaleFactor: 1.0,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF656565)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12, bottom: 10, right: 7),
                    child: RaisedButton(
                      elevation: 0.0,
                      color: Colors.white,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(4.0),
                          side: BorderSide(color: Colors.black)),

                      disabledColor: Colors.black,
                      //Colors.black12,
                      padding: EdgeInsets.only(left: 35, right: 35),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: false).pop();

                        FirebaseAnalytics()
                            .logEvent(name: 'UploadPhoto', parameters: {
                          // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                          'Parameter': 'Remove_Photo_No'
                        });
                      },
                      child: Text(
                        "No",
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 12, left: 7, bottom: 10),
                      child: RaisedButton(
                        elevation: 0.0,
                        color: Color(0xFFFF872F),
                        disabledColor: Colors.black12,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0)),
                        padding: EdgeInsets.only(left: 35, right: 35),
                        onPressed: () {
                          removeimg(removingIndex);
                          Navigator.of(context).pop();

                          // _RemoveSuccessfullyDialog(index);
                          //
                          // _popupWork();
                          FirebaseAnalytics()
                              .logEvent(name: 'UploadPhoto', parameters: {
                            // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                            'Parameter': 'Remove_Photo_Yes'
                          });
                        },
                        child: Text(
                          "Yes",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              //color: Colors.white,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      )),
                  Padding(padding: EdgeInsets.only(right: 10)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _showRemoveVideoDialog(removingIndex) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            'Remove Video',
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF656565)),
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Are you sure you want to remove this video?',
                textScaleFactor: 1.0,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF656565)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12, bottom: 10, right: 7),
                    child: RaisedButton(
                      elevation: 0.0,
                      color: Colors.white,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(4.0),
                          side: BorderSide(color: Colors.black)),

                      disabledColor: Colors.black,
                      //Colors.black12,
                      padding: EdgeInsets.only(left: 35, right: 35),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: false).pop();

                        FirebaseAnalytics()
                            .logEvent(name: 'UploadVideo', parameters: {
                          // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                          'Parameter': 'remove_video_no'
                        });
                      },
                      child: Text(
                        "No",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 12, left: 7, bottom: 10),
                      child: RaisedButton(
                        elevation: 0.0,
                        color: Color(0xFFFF872F),
                        disabledColor: Colors.black12,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0)),
                        padding: EdgeInsets.only(left: 35, right: 35),
                        onPressed: () {
                          Navigator.pop(context);
                          removevid(removingIndex);
                          // setState(() {
                          //   videoList.removeAt(removingIndex);
                          //   videoArrLeng--;
                          // });
                          // _RemoveSuccessfullyDialog(index);
                          //
                          // _popupWork();

                          FirebaseAnalytics()
                              .logEvent(name: 'UploadVideo', parameters: {
                            // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                            'Parameter': 'remove_video_yes'
                          });
                        },
                        child: Text(
                          "Yes",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              //color: Colors.white,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      )),
                  Padding(padding: EdgeInsets.only(right: 10)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void showBottomSheetofImages(context, int removingIndex) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Center(
                      child:

                          //Text("Add Photo",style: TextStyle(fontSize: 20,color: Color(0xFF656565),fontWeight:FontWeight.w600),)
                          InkWell(
                        child: Image.asset(
                          'images/gallery/rectangle.png',
                          height: 35,
                          width: 45,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                  new ListTile(
                    leading: Image.asset(
                      'images/gallery/editImage.png',
                      height: 35,
                      width: 35,
                    ),
                    title: new Text('Edit Photo',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF656565))),
                    onTap: () {
                      //_imgFromCamera();
                      // File image= imageList[removingIndex];
                      // final _image1 = _getCroppedImage(image);

                      final image2 = _EditImagee(removingIndex);

                      setState(() {
                        // imageList.add("ss");
                        // imageArrLeng++;
                      });
                      FirebaseAnalytics()
                          .logEvent(name: 'UploadPhoto', parameters: {
                        // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                        'Parameter': 'Edit_Photo_Click'
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                      leading: Image.asset(
                        'images/gallery_icon.png',
                        height: 35,
                        width: 35,
                      ),
                      title: new Text('Update Photo',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF656565))),
                      onTap: () {
                        //_imgFromGallery();
                        Navigator.of(context).pop();
                        showBottomSheetofImageUpload(
                            context, true, removingIndex);

                        FirebaseAnalytics()
                            .logEvent(name: 'UploadPhoto', parameters: {
                          // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                          'Parameter': 'Update_Photo_clicks'
                        });
                      }),
                  new ListTile(
                      leading: Image.asset(
                        'images/remove_icon.png',
                        height: 35,
                        width: 35,
                      ),
                      title: new Text('Remove Photo',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF656565))),
                      onTap: () {
                        //_imgFromGallery();

                        // setState(() {
                        //   imageList.removeAt(removingIndex);
                        //   imageArrLeng--;
                        // });

                        Navigator.of(context).pop();
                        _showRemovePhotoDialog(removingIndex);

                        FirebaseAnalytics()
                            .logEvent(name: 'UploadPhoto', parameters: {
                          // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                          'Parameter': 'Remove_Photo_Click'
                        });
                      }),
                ],
              ),
            ),
          );
        });
  }

  void showBottomSheetofvideoUpdateRemUpd(context, removingindex) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Center(
                      child:

                          //Text("Add Video",style: TextStyle(fontSize: 20,color: Color(0xFF656565),fontWeight:FontWeight.w600),)
                          InkWell(
                        child: Image.asset(
                          'images/gallery/rectangle.png',
                          height: 35,
                          width: 45,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),

                  //_imgFromCamera();

                  new ListTile(
                      leading: Image.asset(
                        'images/gallery/playIcon.png',
                        height: 35,
                        width: 35,
                      ),
                      title: new Text('Play Video',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF656565))),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new VideoApp(
                                    video: videoList[removingindex])));

                        FirebaseAnalytics()
                            .logEvent(name: 'UploadVideo', parameters: {
                          // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                          'Parameter': 'play_video_clicks'
                        });

                        //_imgFromGallery();
                      }),

                  new ListTile(
                      leading: Image.asset(
                        'images/gallery_icon.png',
                        height: 35,
                        width: 35,
                      ),
                      title: new Text('Update Video',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF656565))),
                      onTap: () {
                        Navigator.of(context).pop();
                        showBottomSheetofVideoUpload(
                            context, true, removingindex);

                        FirebaseAnalytics()
                            .logEvent(name: 'UploadVideo', parameters: {
                          // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                          'Parameter': 'update_video_clicks'
                        });
                      }),

                  new ListTile(
                      leading: Image.asset(
                        'images/remove_icon.png',
                        height: 35,
                        width: 35,
                      ),
                      title: new Text('Remove Video',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF656565))),
                      onTap: () {
                        //_imgFromGallery();
                        Navigator.pop(context);
                        _showRemoveVideoDialog(removingindex);
                        // setState(() {
                        //   imageList.removeAt(removingIndex);
                        //   imageArrLeng--;
                        // });

                        FirebaseAnalytics()
                            .logEvent(name: 'UploadVideo', parameters: {
                          // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                          'Parameter': 'remove_video_clicks'
                        });
                      }),
                ],
              ),
            ),
          );
        });
  }

  void showBottomSheetofVideoUpload(context, isUpdate, index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Center(
                      child:

                          //Text("Add Video",style: TextStyle(fontSize: 20,color: Color(0xFF656565),fontWeight:FontWeight.w600),)
                          InkWell(
                        child: Image.asset(
                          'images/gallery/rectangle.png',
                          height: 35,
                          width: 45,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                  // new ListTile(
                  //   leading: Image.asset('images/camera_icon.png', height:35, width: 35,),
                  //   title: new Text('Take Photo'),
                  //   onTap: () {
                  //     //_imgFromCamera();
                  //     Navigator.of(context).pop();
                  //   },
                  // ),

                  new ListTile(
                    leading: Image.asset(
                      'images/gallery/videoIcon.png',
                      height: 35,
                      width: 35,
                    ),
                    title: new Text('Choose from Gallery',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF656565))),
                    onTap: () {
                      //_imgFromCamera(); previewVid();

                      _vidFromGallery(isUpdate, index);

                      //doingggggg now
                      // setState(() {
                      //   videoList.add("ss");
                      //   videoArrLeng++;});
                      Navigator.of(context).pop();

                      FirebaseAnalytics()
                          .logEvent(name: 'UploadVideo', parameters: {
                        // 'Category':'Toggle','Action':"Kitchen Status",'Label':"Open",
                        'Parameter': 'choose_from_gallery_clicks'
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showBottomSheetofRemoveAudio(context, int removingIndex) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Center(
                      child:

                          //Text("Add Video",style: TextStyle(fontSize: 20,color: Color(0xFF656565),fontWeight:FontWeight.w600),)
                          InkWell(
                        child: Image.asset(
                          'images/gallery/rectangle.png',
                          height: 35,
                          width: 45,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                  new ListTile(
                      leading: Image.asset(
                        'images/gallery/micIcon.png',
                        height: 35,
                        width: 35,
                      ),
                      title: new Text(
                        'Remove Audio',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF656565)),
                      ),
                      onTap: () {
                        //_imgFromGallery();
                        setState(() {
                          recordingList.removeAt(removingIndex);
                          recordingArrLeng--;
                        });
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }
}

//
// class AppBody extends StatefulWidget {
//   final LocalFileSystem localFileSystem;
//
//   AppBody({localFileSystem})
//       : this.localFileSystem = localFileSystem ?? LocalFileSystem();
//
//   @override
//   State<StatefulWidget> createState() => new AppBodyState();
// }
//
// class AppBodyState extends State<AppBody> {
//   Recording _recording = new Recording();
//   bool _isRecording = false;
//   Random random = new Random();
//   TextEditingController _controller = new TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return new Center(
//       child: new Padding(
//         padding: new EdgeInsets.all(8.0),
//         child: new Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               new FlatButton(
//                 onPressed: _isRecording ? null : _start,
//                 child: new Text("Start"),
//                 color: Colors.green,
//               ),
//               new FlatButton(
//                 onPressed: _isRecording ? _stop : null,
//                 child: new Text("Stop"),
//                 color: Colors.red,
//               ),
//               new TextField(
//                 controller: _controller,
//                 decoration: new InputDecoration(
//                   hintText: 'Enter a custom path',
//                 ),
//               ),
//               new Text("File path of the record: ${_recording.path}"),
//               new Text("Format: ${_recording.audioOutputFormat}"),
//               new Text("Extension : ${_recording.extension}"),
//               new Text(
//                   "Audio recording duration : ${_recording.duration.toString()}")
//             ]),
//       ),
//     );
//   }
//
//   _start() async {
//     try {
//       if (await AudioRecorder.hasPermissions) {
//         if (_controller.text != null && _controller.text != "") {
//           String path = _controller.text;
//           if (!_controller.text.contains('/')) {
//             io.Directory appDocDirectory =
//             await getApplicationDocumentsDirectory();
//             path = appDocDirectory.path + '/' + _controller.text;
//           }
//           print("Start recording: $path");
//           await AudioRecorder.start(
//               path: path, audioOutputFormat: AudioOutputFormat.AAC);
//         } else {
//           await AudioRecorder.start();
//         }
//         bool isRecording = await AudioRecorder.isRecording;
//         setState(() {
//           _recording = new Recording(duration: new Duration(), path: "");
//           _isRecording = isRecording;
//         });
//       } else {
//         Scaffold.of(context).showSnackBar(
//             new SnackBar(content: new Text("You must accept permissions")));
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   _stop() async {
//     var recording = await AudioRecorder.stop();
//     print("Stop recording: ${recording.path}");
//     bool isRecording = await AudioRecorder.isRecording;
//     File file = widget.localFileSystem.file(recording.path);
//     print("  File length: ${await file.length()}");
//     setState(() {
//       _recording = recording;
//       _isRecording = isRecording;
//     });
//     _controller.text = recording.path;
//   }
// }

// OpenKitchenConfirmationDialog
class micInactivePopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("images/gallery/volumeIcon.png",
                  width: 40, height: 40),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
              child: Text(
                "You have reached your maximum audio limit of 3 audios.",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF212529)),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
              child: Text(" Please remove some audios to add new ones.",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF212529)),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

// OpenKitchenConfirmationDialog
class AddbuttonDisabledPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Image.asset("images/gallery_icon.png", width: 40, height: 40),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
              child: Text(
                "You have reached your maximum photo limit of 10 photos.",
                textScaleFactor: 1.0,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    fontSize: 16,
                    color: Color(0xFF212529)),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
              child: Text(" Please remove some photos to add new ones.",
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      fontSize: 16,
                      color: Color(0xFF212529)),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

class addVideobuttonDisabledPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("images/gallery/videoIcon.png",
                  width: 40, height: 40),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
              child: Text(
                "You have reached your maximum video limit of 5 videos.",
                textScaleFactor: 1.0,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    fontSize: 16,
                    color: Color(0xFF212529)),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
              child: Text(" Please remove some videos to add new ones.",
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      fontSize: 16,
                      color: Color(0xFF212529)),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
