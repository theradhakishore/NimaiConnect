import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:dr_nimai/dash/uploadMedications.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';

class UploadPrescription extends StatefulWidget {
  final String appointmentID;
  final String doctorID;

  const UploadPrescription(
      {Key? key, required this.appointmentID, required this.doctorID})
      : super(key: key);

  @override
  State<UploadPrescription> createState() => _UploadPrescriptionState();
}

class _UploadPrescriptionState extends State<UploadPrescription> {
  List<File> _imageList = [];
  bool loading = false;
  Dio dio = Dio();

  List<String> Prescriptions = [];

  bool prescriptionsAvailable = false;
  bool prescriptionsNotAvailable = false;
  bool upload=false;
  bool screenloading = true;

  void selectImage() async {
    XFile? selected = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    setState(() {
      if (selected!.path.isNotEmpty) {
        File selectedImage = File(selected.path);
        _imageList.add(selectedImage);
        uploadImage(selectedImage);
      }
    });
    print(_imageList.length);
  }

  // File? _imageFile;

  // Future<void> selectImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     if (pickedFile != null) {
  //       _imageFile = File(pickedFile.path);
  //       uploadImage(_imageFile!);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  Future<void> uploadImage(File file) async {
    setState(() {
      loading = true;
    });

    FormData formData = FormData.fromMap({
      "Files": await MultipartFile.fromFile(file.path,
          filename: '1000${widget.appointmentID}.jpg'),
    });
    try {
      Response response = await Dio().post(
        'https://nimaidev.azurewebsites.net/fileprescription/uploadfile',
        data: formData,
      );
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
      }
      print('Upload successful! Response: ${response.data}');
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  // Future<void> uploadImages(List<File> images) async {
  //
  //   List<MultipartFile> files = [];
  //   for (int i = 0; i < images.length; i++) {
  //     print(widget.appointmentID);
  //     String fileName = '1000${widget.appointmentID}.jpg';
  //     files.add(await MultipartFile.fromFile(images[i].path, filename: fileName));
  //   }
  //
  //   FormData formData = new FormData.fromMap({
  //     'Files': files,
  //   });
  //
  //
  //   try {
  //     final response = await Dio().post(
  //       'https://nimaidev.azurewebsites.net/fileprescription/uploadfile',
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           'Content-Type': 'multipart/form-data',
  //         },
  //       ),
  //     );
  //
  //     print('Response: ${response.data}');
  //   } catch (e) {
  //     print('Error uploading images: $e');
  //   }
  // }

  Future checkPrescriptionUploaded() async {
    try {
      final queryParameters = {
        'AppointmentId': '1000${widget.appointmentID}',
      };
      var response = await http.get(
        Uri.https('nimaidev.azurewebsites.net',
            'filemedication/ListMedications', queryParameters),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Connection": "Keep-Alive",
          "Keep-Alive": "timeout=5, max=1000"
        },
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        for (var c in jsonData) {
          Prescriptions.add(c);
        }
        print(Prescriptions);
        setState(() {
          prescriptionsAvailable = true;
          upload=false;
          screenloading = false;
        });
      } else {
        setState(() {
          prescriptionsNotAvailable = true;
          upload=true;
          screenloading = false;
        });
      }
    } catch (error) {
      print('$error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPrescriptionUploaded();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ApkColor.appBackground,
        elevation: 0,
        iconTheme: IconThemeData(
          color: ApkColor.Purple, // <-- SEE HERE
        ),
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            color: ApkColor.appBackground,
            child: Column(
              children: [
                Visibility(
                  visible: prescriptionsAvailable,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(22, 0, 22, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Your ',
                                    style: TextStyle(
                                        color: ApkColor.Purple,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Prescriptions',
                                    style: TextStyle(
                                        color: ApkColor.lightPurple,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              TextButton(

                                style: TextButton.styleFrom(
                                  backgroundColor: ApkColor.Purple,
                                  foregroundColor: ApkColor.white,
                                  elevation: 2,
                                  padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),


                                ),

                                onPressed: () {
                                  setState(() {
                                    upload=true;
                                    prescriptionsAvailable=false;
                                  });
                                },

                                child: Text(
                                  '+ Add',
                                  style: TextStyle(

                                      fontSize: 14
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              aspectRatio: 1,
                              viewportFraction: 2,
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              reverse: false,
                              autoPlay: false,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: Prescriptions.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Image(
                                          image: CachedNetworkImageProvider(i)));
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: upload,
                  child: Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(22, 0, 22, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Upload ',
                                      style: TextStyle(
                                          color: ApkColor.Purple,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Prescription',
                                      style: TextStyle(
                                          color: ApkColor.lightPurple,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                if (_imageList.isNotEmpty) ...[
                                  TextButton(

                                    style: TextButton.styleFrom(
                                      backgroundColor: ApkColor.darkPurple,
                                      foregroundColor: ApkColor.white,
                                      elevation: 2,
                                      padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100),
                                      ),


                                    ),

                                    onPressed: () {
                                      setState(() {
                                        upload=false;
                                        prescriptionsAvailable=true;
                                      });

                                      CoolAlert.show(
                                        backgroundColor: ApkColor.black,
                                        confirmBtnColor: ApkColor.black,
                                        context: context,
                                        type: CoolAlertType.success,
                                        text:
                                        'Prescription Saved',
                                        loopAnimation: false,
                                      );
                                    },

                                    child: Text(
                                      'Save',
                                      style: TextStyle(

                                          fontSize: 14
                                      ),
                                    ),
                                  )
                                ]
                              ],
                            ),
                          ),
                          if (_imageList.isEmpty) ...[
                            Container(
                              margin: EdgeInsets.fromLTRB(22, 0, 22, 0),
                              child: Text(
                                'Add your Prescriptions below ',
                                style: TextStyle(
                                    color: ApkColor.transparentBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(22, 0, 22, 30),
                                    child: GridView.count(
                                        crossAxisCount: 2,
                                        shrinkWrap: true,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        scrollDirection: Axis.vertical,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: List.generate(_imageList.length,
                                            (index) {
                                          return Container(
                                              child: Image.file(
                                            File(_imageList[index].path),
                                            fit: BoxFit.cover,
                                          ));
                                        })),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FittedBox(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(22, 0, 22, 20),
                              child: Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: ApkColor.transparentBlack3,
                                      foregroundColor: ApkColor.white,
                                      elevation: 2,
                                      padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                    ),
                                    onPressed: () async {
                                      selectImage();
                                      // uploadImages(_imageList);
                                      // uploadImages(_imageList.map((e) => e.path).toList());
                                    },
                                    child: Text(
                                      'Capture',
                                      style: TextStyle(
                                          color: ApkColor.white, fontSize: 16),
                                    ),
                                  ),
                                  if (_imageList.isNotEmpty) ...[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: ApkColor.darkPurple,
                                          foregroundColor: ApkColor.white,
                                          elevation: 2,
                                          padding:
                                              EdgeInsets.fromLTRB(20, 10, 20, 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UploadMedications(
                                                          appointmentID:
                                                              widget.appointmentID,
                                                          doctorID:
                                                              widget.doctorID)));
                                        },
                                        child: Text(
                                          'Medications',
                                          style: TextStyle(
                                              color: ApkColor.white, fontSize: 16),
                                        ),
                                      ),
                                    )
                                  ]
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
              visible: screenloading,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: SizedBox(
                    height: 40,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballPulse,

                      /// Required, The loading type of the widget
                      colors: const [ApkColor.lightPurple, ApkColor.Purple],

                      /// Optional, The color collections
                      strokeWidth: 4,

                      /// Optional, The stroke of the line, only applicable to widget which contains line
                    ),
                  ),
                ),
              )),
          if (loading)
            Center(
                child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(20),
                  color: ApkColor.transparentBlack3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballPulse,

                      /// Required, The loading type of the widget
                      colors: const [
                        ApkColor.white,
                      ],

                      /// Optional, The color collections
                      strokeWidth: 4,

                      /// Optional, The stroke of the line, only applicable to widget which contains line
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        'Uploading',
                        style: TextStyle(color: ApkColor.white, fontSize: 14),
                      ))
                ],
              ),
            )),
        ],
      )),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.camera_alt_rounded),
      //     backgroundColor: ApkColor.lightPurple,
      //   onPressed: () {
      //     selectImage();
      //   },
      // ),
    );
  }
}
