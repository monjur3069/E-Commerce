
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user_batch6/page/registration_page.dart';
import 'package:ecom_user_batch6/providers/user_provider.dart';
import 'package:ecom_user_batch6/utils/account_check.dart';
import 'package:ecom_user_batch6/utils/constants.dart';
import 'package:ecom_user_batch6/utils/neumorphic_text_field_container.dart';
import 'package:ecom_user_batch6/utils/rectangular_button.dart';
import 'package:ecom_user_batch6/utils/rectangular_input_field.dart';
import 'package:ecom_user_batch6/utils/rounded_button.dart';
import 'package:ecom_user_batch6/widgets/login_page_credentials.dart';
import 'package:ecom_user_batch6/widgets/login_page_headtext.dart';
import 'package:ecom_user_batch6/widgets/login_page_social.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../models/user_model.dart';
import 'launcher_page.dart';
import 'phone_verification_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {


    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                lightPrimary,
                darkPrimary,
              ]
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              LoginPageHeadText(),
              LoginPageCredentials(),
              LoginPageSocial()
            ],
          ),
        ),
      ),
    );
  }

}
