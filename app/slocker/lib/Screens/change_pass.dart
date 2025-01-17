import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:slocker/Screens/loading.dart';
import 'package:slocker/Screens/pass_reset.dart';
import 'package:slocker/Screens/signin_screen.dart';
import 'package:slocker/Screens/signup_screen.dart';
import 'package:slocker/Screens/verifyemail.dart';
import 'package:slocker/net/auth.dart';
import 'package:slocker/reusable.dart';

import '../constants.dart';

class changePass extends StatefulWidget {
  const changePass({super.key});

  @override
  State<changePass> createState() => _changePassState();
}

class _changePassState extends State<changePass> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';
  AuthClass auth = AuthClass();

  final TextEditingController _emailTextController = TextEditingController();

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      home: Form(
        key: _key,
        child: Scaffold(
          //key: formKey,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      "Change Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 4.h,
                        color: mSecondTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Image.asset("assets/images/passreset.png",
                        fit: BoxFit.fitWidth,
                        width: 35.h,
                        height: 35.h,
                        color: Color(0xFF6892c9)
                        //color: mSecondTextColor,
                        ),
                    SizedBox(
                      height: 3.h,
                    ),
                    reusableTextField(
                        "Enter the e-mail",
                        Icons.person_sharp,
                        false,
                        _emailTextController,
                        validateEmail,
                        "password-field"),
                    SizedBox(
                      height: 2.h,
                    ),
                    firebaseUIButton(context, "Change", () async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              Center(child: CircularProgressIndicator()));
                      if (_key.currentState!.validate()) {
                        try {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(
                                  email: _emailTextController.text.trim())
                              .then((value) {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            Fluttertoast.showToast(
                                msg: 'Password Change mail sent',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: mSecondColor,
                                textColor: Colors.black);
                            // Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Loading()));
                          });
                          errorMessage = '';
                        } on FirebaseAuthException catch (error) {
                          errorMessage = error.message!;
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                              msg: errorMessage,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: mSecondColor,
                              textColor: Colors.black);
                        }
                        setState(() {});
                      }
                    }),
                    // signUpOption()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
          },
          child: Text(
            "Sign In".tr,
            style: TextStyle(
                color: mPrimaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
        ),
        Text(" with account ", style: TextStyle(color: mPrimaryTextColor)),
      ],
    );
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'E-mail address is required.';
  }

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';

  return null;
}
