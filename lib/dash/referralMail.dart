import 'package:dr_nimai/res/color.dart';
import 'package:dr_nimai/res/route.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReferralMail extends StatefulWidget {
  final String userName;
  const ReferralMail({Key? key, required this.userName}) : super(key: key);

  @override
  State<ReferralMail> createState() => _ReferralMailState();
}

class _ReferralMailState extends State<ReferralMail> {

  final List<String> designations = ['Dr.', 'Ms.', 'Mr.'];
  List<Color> selectedColor=[ApkColor.white,ApkColor.white,ApkColor.white];
  List<Color> selectedTextColor=[ApkColor.Purple,ApkColor.Purple,ApkColor.Purple];

  bool emailidfilled=false;

  TextEditingController prefilledMessage = TextEditingController(text:
  'Dear [Recipient],'
      '\nI hope this email finds you well. I am willing to extend an invitation to you to join an innovative medical providing facility app Nimai Connect that is powered by advanced artificial intelligence (AI) technology. I believe that you, as a healthcare professional, will find this app extremely beneficial in your daily practice.'
      'The app offers a wide range of medical services, including consultations, diagnosis, treatment plans, and prescriptions, all of which are powered by cutting-edge AI technology. '
      '\n\nBy joining the app, you will have the opportunity to expand your professional network and collaborate with other healthcare professionals from around the world.'
      '\nSome of the benefits of joining Nimai Connect app include:'
      '\n1. Access to a large community of healthcare professionals and patients from around the world'
      '\n2. The ability to provide quick and accurate diagnoses using advanced AI technology'
      '\n3. The ability to prescribe medications and treatments with confidence and accuracy'
      '\n4. Continuous learning and professional development through access to the latest medical research and developments'
      '\n5. Competitive rewards and incentives for providing quality care and excellent patient outcomes'
      '\n\nAs a healthcare professional, we believe that you will be a valuable addition to our community, and we would be honored to have you join us. In addition to the benefits listed above, we offer attractive rewards and incentives for healthcare professionals who provide quality care and achieve excellent patient outcomes.'
      '\nIf you are interested in joining our app or have any questions, please do not hesitate to contact us. We would be more than happy to provide you with more information and help you get started.'
      '\nThank you for considering this invitation, and we hope to hear from you soon.'
      '\nWith Regards,'
      '\n[Sender Name]',
  );
  TextEditingController cc = TextEditingController(text: 'nimaiconnect@rxone.net');
  TextEditingController subject = TextEditingController(text: 'Invitation to Join Nimai Care Provider group');
  TextEditingController toEmail=TextEditingController();
  TextEditingController fromEmail=TextEditingController(text: 'radhakishoredas2k20@gmail.com');
  TextEditingController designation=TextEditingController();
  TextEditingController name=TextEditingController();
  TextEditingController providerType=TextEditingController();

  Future launchEmail() async {
    setState(() {
      prefilledMessage.text =
      'Dear ${designation.text+' '+name.text},'
          '\n\nI hope this email finds you well. I am willing to extend an invitation to you to join an innovative medical providing facility app Nimai Connect that is powered by advanced artificial intelligence (AI) technology. I believe that you, as a healthcare professional, will find this app extremely beneficial in your daily practice.'
          'The app offers a wide range of medical services, including consultations, diagnosis, treatment plans, and prescriptions, all of which are powered by cutting-edge AI technology. '
          '\n\nBy joining the app, you will have the opportunity to expand your professional network and collaborate with other healthcare professionals from around the world.'
          '\nSome of the benefits of joining Nimai Connect app include:'
          '\n\n1. Access to a large community of healthcare professionals and patients from around the world'
          '\n\n2. The ability to provide quick and accurate diagnoses using advanced AI technology'
          '\n\n3. The ability to prescribe medications and treatments with confidence and accuracy'
          '\n\n4. Continuous learning and professional development through access to the latest medical research and developments'
          '\n\n5. Competitive rewards and incentives for providing quality care and excellent patient outcomes'
          '\n\nAs a healthcare professional, we believe that you will be a valuable addition to our community, and we would be honored to have you join us. In addition to the benefits listed above, we offer attractive rewards and incentives for healthcare professionals who provide quality care and achieve excellent patient outcomes.'
          '\nIf you are interested in joining our app or have any questions, please do not hesitate to contact us. We would be more than happy to provide you with more information and help you get started.'
          '\nThank you for considering this invitation, and we hope to hear from you soon.'
          '\n\nWith Regards,'
          '\n${widget.userName}';
    });

    final url='mailto:${toEmail.text}?cc=${cc.text}&subject=${Uri.encodeFull(subject.text)}&body=${Uri.encodeFull(prefilledMessage.text)}';
    await launchUrlString(url);
    Navigator.of(context).pushNamed(ApkRoute.HOME_FRAGMENT);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: ApkColor.appBackground,
        elevation: 0,
        iconTheme: IconThemeData(
          color: ApkColor.Purple, // <-- SEE HERE
        ),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: ApkColor.appBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(22, 0, 22, 20),
                child: Row(
                  children: [
                    Text('Referral ',
                      style: TextStyle(
                          color: ApkColor.Purple,
                          fontSize: 22,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    Text('Mail',
                      style: TextStyle(
                          color: ApkColor.lightPurple,
                          fontSize: 22,
                          fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(22, 0, 22, 22),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0,10),
                          child: SizedBox(
                            height: 50,
                            child: DropdownButtonFormField2(
                              decoration: InputDecoration(
                                //Add isDense true and zero Padding.
                                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                // border: InputBorder.none,
                                filled: true,
                                fillColor: ApkColor.white,

                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                //Add more decoration as you want here
                                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                              ),
                              isExpanded: true,
                              hint: const Text(
                                'Designation',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ApkColor.transparentBlack),
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              iconSize: 30,
                              buttonHeight: 60,
                              buttonPadding:
                              const EdgeInsets.only(left: 10, right: 10),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              items: designations
                                  .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select Designation';
                                }
                              },
                              onChanged: (value) {
                                designation.text = value.toString();
                                //Do something when changing the item if you want.
                              },
                              onSaved: (value) {},
                            ),
                          ),
                        ),
                        Container(
                          child: FittedBox(
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedColor[1]=ApkColor.white;
                                      selectedColor[2]=ApkColor.white;
                                      selectedTextColor[1]=ApkColor.Purple;
                                      selectedTextColor[2]=ApkColor.Purple;
                                      selectedColor[0]=ApkColor.Purple;
                                      selectedTextColor[0]=ApkColor.white;
                                    });

                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    width: 120,
                                    decoration:BoxDecoration(
                                        color: selectedColor[0],
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xffDDDDDD),
                                              offset: Offset(0,4),
                                              blurRadius: 10,
                                              spreadRadius: 0
                                          )]

                                    ),

                                    child: Column(
                                      children: [
                                        SvgPicture.asset('assets/icons/doctor.svg',width: 100,),
                                        Container(
                                          height: 20,
                                          margin: EdgeInsets.fromLTRB(0, 5, 0, 3),
                                          child: FittedBox(
                                            child: Text('Doctor',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: selectedTextColor[0],
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedColor[0]=ApkColor.white;
                                      selectedColor[2]=ApkColor.white;
                                      selectedTextColor[0]=ApkColor.Purple;
                                      selectedTextColor[2]=ApkColor.Purple;
                                      selectedColor[1]=ApkColor.Purple;
                                      selectedTextColor[1]=ApkColor.white;
                                    });

                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),

                                    width: 120,
                                    decoration:BoxDecoration(
                                        color: selectedColor[1],
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xffDDDDDD),
                                              offset: Offset(0,4),
                                              blurRadius: 10,
                                              spreadRadius: 0
                                          )]

                                    ),

                                    child: Column(
                                      children: [
                                        SvgPicture.asset('assets/icons/nurse.svg',height: 100,),
                                        Container(
                                          height: 20,
                                          margin: EdgeInsets.fromLTRB(0, 5, 0, 3),
                                          child: FittedBox(
                                            child: Text('Nurse',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: selectedTextColor[1],
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      for(int i=0;i<2;i++){
                                        selectedColor[i]=ApkColor.white;
                                        selectedTextColor[i]=ApkColor.Purple;
                                      }

                                    });
                                    selectedColor[2]=ApkColor.Purple;
                                    selectedTextColor[2]=ApkColor.white;
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    width: 120,
                                    decoration:BoxDecoration(
                                        color: selectedColor[2],
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xffDDDDDD),
                                              offset: Offset(0,4),
                                              blurRadius: 10,
                                              spreadRadius: 0
                                          )]

                                    ),

                                    child: Column(
                                      children: [
                                        SvgPicture.asset('assets/icons/pharmacist.svg',width: 100,),
                                        Container(
                                          height: 20,
                                          margin: EdgeInsets.fromLTRB(0, 5, 0, 3),
                                          child: FittedBox(
                                            child: Text('Pharmacist',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: selectedTextColor[2],
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: ApkColor.white),
                          child: TextFormField(
                            controller: name,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Doctor/Pharmacist/Nurse Name',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 0),
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: ApkColor.transparentBlack)),
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: ApkColor.white),
                          child: TextFormField(
                            onChanged: (toEmail){
                              if(toEmail!=null){
                                setState(() {
                                  emailidfilled=true;
                                });
                              }
                            },
                            controller: toEmail,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email ID',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 0),
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: ApkColor.transparentBlack)),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                          ),
                        ),
                        Visibility(
                          visible: emailidfilled,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ApkColor.white),
                            child: TextFormField(
                              controller: subject,
                              enabled: false,
                              maxLines: 2,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  // hintText: 'Doctor/Pharmacist/Nurse Name',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 0),
                                  hintStyle: TextStyle(
                                      fontSize: 12,
                                      color: ApkColor.transparentBlack)),
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                            ),
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        //   padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(100),
                        //       color: ApkColor.white),
                        //   child: TextFormField(
                        //     controller: cc,
                        //     enabled: false,
                        //     decoration: InputDecoration(
                        //         border: InputBorder.none,
                        //         // hintText: 'Doctor/Pharmacist/Nurse Name',
                        //         contentPadding: EdgeInsets.symmetric(
                        //             vertical: 10, horizontal: 0),
                        //         hintStyle: TextStyle(
                        //             fontSize: 12,
                        //             color: ApkColor.transparentBlack)),
                        //     keyboardType: TextInputType.text,
                        //     autocorrect: false,
                        //   ),
                        // ),
                        Visibility(
                          visible: emailidfilled,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ApkColor.white),
                            child: TextFormField(
                              controller: prefilledMessage,
                              enabled: false,
                              maxLines: 8,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  // hintText: 'Doctor/Pharmacist/Nurse Name',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 0),
                                  hintStyle: TextStyle(
                                      fontSize: 12,
                                      color: ApkColor.transparentBlack)),
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                            ),
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            launchEmail();
                          },
                          child: Container(
                              alignment: FractionalOffset.bottomCenter,
                              margin: EdgeInsets.fromLTRB(12, 40, 12, 0),
                              padding: EdgeInsets.fromLTRB(30, 11, 30, 11),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: ApkColor.Purple,
                              ),
                              child: Text(
                                'Send Email',
                                style: TextStyle(
                                    color: ApkColor.white, fontSize: 14),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
