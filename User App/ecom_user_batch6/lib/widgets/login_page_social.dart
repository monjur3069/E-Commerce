
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user_batch6/auth/auth_service.dart';
import 'package:ecom_user_batch6/models/user_model.dart';
import 'package:ecom_user_batch6/page/launcher_page.dart';
import 'package:ecom_user_batch6/page/phone_verification_page.dart';
import 'package:ecom_user_batch6/providers/user_provider.dart';
import 'package:ecom_user_batch6/utils/constants.dart';
import 'package:ecom_user_batch6/utils/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class LoginPageSocial extends StatelessWidget {
  const LoginPageSocial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'OR',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: appPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundedButton(imageSrc: 'images/google.png', press:(){
                _signInWithGoogle(context);
              }),
              RoundedButton(
                  imageSrc: 'images/facebook.png', press: () {}),
              RoundedButton(
                  imageSrc: 'images/twitter.png', press: () {}),
            ],
          ),
        ),
        SizedBox(
          height: appPadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an Account?",
              style: TextStyle(fontSize: 16),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, PhoneVerificationPage.routeName),
              child: Text(
                "Sign Up",
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );

  }


  void _signInWithGoogle(BuildContext context) {
    AuthService.signInWithGoogle().then((credential) async {
      if(credential.user != null) {
        if(!await Provider.of<UserProvider>(context, listen: false)
            .doesUserExist(credential.user!.uid)) {
          EasyLoading.show(status: 'Please wait', dismissOnTap: false);
          final userModel = UserModel(
            uid: credential.user!.uid,
            email: credential.user!.email!,
            name: credential.user!.displayName,
            userCreationTime: Timestamp.fromDate(credential.user!.metadata.creationTime!),
          );
          await Provider.of<UserProvider>(context, listen: false)
              .addUser(userModel);
          EasyLoading.dismiss();
        }
        Navigator.pushReplacementNamed(context, LauncherPage.routeName);
      }
    });
  }
}
