import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:pinput/pinput.dart';
import 'package:video_player_app/constants.dart';
import 'package:video_player_app/screens/MyHome_Page.dart';

import '../CustomWidgets/Custom_flushBar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final numController = TextEditingController();
  final otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  String? _phoneNumber;
  String? _smsCode;
  bool _isCodeSent = false;

  void _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91 $_phoneNumber",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        CustomFlushBar.customFlushBar(
            context, "Verified", "Phone verifiation completed");
        ;
        if (kDebugMode) {
          print(
              "Phone number automatically verified and user signed in: ${_auth.currentUser!.uid}");
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          CustomFlushBar.customFlushBar(context, "Invalid phone number",
              "The provided phone number is not valid");
          if (kDebugMode) {
            print('The provided phone number is not valid.');
          }
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        CustomFlushBar.customFlushBar(
            context, "verification code", "send successfully");
        setState(() {
          _verificationId = verificationId;
          _isCodeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  void _signInWithPhoneNumber() async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _smsCode!,
    );

    await _auth.signInWithCredential(credential).then((UserCredential user) {
      Get.off(() => MyHomePage());
      Future.delayed(const Duration(seconds: 3));
      CustomFlushBar.customFlushBar(context, "sign in", "Successfull");
    }).catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var defaultPinTheme = PinTheme(
      width: 70,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 3),
      ),
    );
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width(context) * 0.06,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header

                  SizedBox(
                    height: height(context) * 0.1,
                  ),

                  !_isCodeSent
                      ? const Text(
                          "Enter Your\nMobile Number",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                          ),
                        )
                      : const Text(
                          "Enter Your\nOne Time Password",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                          ),
                        ),

                  // Textfied

                  SizedBox(
                    height: height(context) * 0.04,
                  ),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: height(context) * 0.06,
                        // width: width(context) * 0.15,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "+91",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width(context) * 0.035,
                      ),
                      Container(
                        height: height(context) * 0.06,
                        width: width(context) * 0.64,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width(context) * 0.03),
                          child: TextField(
                            controller: numController,
                            onChanged: (value) {
                              _phoneNumber = value;
                              if (kDebugMode) {
                                print(_phoneNumber);
                              }
                            },
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Enter your Number",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  _isCodeSent
                      ? SizedBox(
                          height: height(context) * 0.1,
                          child: Pinput(
                            controller: otpController,
                            length: 6,
                            focusNode: FocusNode(),
                            closeKeyboardWhenCompleted: true,
                            defaultPinTheme: defaultPinTheme,
                            onChanged: (value) {
                              _smsCode = value;
                              if (kDebugMode) {
                                print(_smsCode);
                              }
                            },
                            focusedPinTheme: defaultPinTheme.copyWith(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.grey, width: 3),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  SizedBox(
                    height: width(context) * 0.8,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  HapticFeedback.lightImpact();
                  _isCodeSent ? _signInWithPhoneNumber() : _verifyPhoneNumber();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: height(context) * 0.06,
                  //width: width(context) * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isCodeSent
                          ? const Text(
                              "Sign in",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            )
                          : const Text(
                              "Verify phone number",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                      SizedBox(
                        width: width(context) * 0.03,
                      ),
                      Container(
                        height: height(context) * 0.09,
                        width: width(context) * 0.09,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
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
