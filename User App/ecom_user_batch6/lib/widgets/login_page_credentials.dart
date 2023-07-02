import 'package:ecom_user_batch6/auth/auth_service.dart';
import 'package:ecom_user_batch6/page/launcher_page.dart';
import 'package:ecom_user_batch6/utils/constants.dart';
import 'package:ecom_user_batch6/utils/helper_functions.dart';
import 'package:ecom_user_batch6/utils/neumorphic_text_field_container.dart';
import 'package:ecom_user_batch6/utils/rectangular_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginPageCredentials extends StatefulWidget {
  LoginPageCredentials({Key? key}) : super(key: key);

  @override
  State<LoginPageCredentials> createState() => _LoginPageCredentialsState();
}

class _LoginPageCredentialsState extends State<LoginPageCredentials> {


  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isObscureText = true;
  final formKey = GlobalKey<FormState>();
  String errMsg = '';

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(appPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NeumorphicTextFieldContainer(
              child: TextFormField(
                controller: emailController,
                cursorColor: black,
                decoration: InputDecoration(
                  hintText: 'Email',
                  helperStyle: TextStyle(
                    color: black.withOpacity(0.7),
                    fontSize: 18,
                  ),
                  prefixIcon: Icon(Icons.email_rounded,color: black.withOpacity(0.7),size: 20,),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: appPadding / 2,
            ),
            NeumorphicTextFieldContainer(
              child: TextFormField(
                controller: passController,
                cursorColor: black,
                obscureText: isObscureText,
                decoration: InputDecoration(
                  hintText: 'Password',
                  helperStyle: TextStyle(
                    color: black.withOpacity(0.7),
                    fontSize: 18,
                  ),
                  prefixIcon: Icon(Icons.lock,color: black.withOpacity(0.7),size: 20,),
                  suffixIcon: IconButton(
                    icon: Icon(
                        isObscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() {
                      isObscureText = !isObscureText;
                    }),
                  ),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: appPadding / 2,
            ),
            Center(
              child: Text(
                'Forget Password?',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
              ),
            ),
            RectangularButton(text: 'Sign In', press: authenticate)
          ],
        ),
      ),
    );
  }
  authenticate() async {
    EasyLoading.show(status: 'Please Wait',dismissOnTap: false);
    if(formKey.currentState!.validate()) {
      try {
        final status = await AuthService.login(emailController.text, passController.text);
        if(status) {
          if(!mounted) return;
          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        } else {
          await AuthService.logout();
          EasyLoading.dismiss();
          setState(() {
            errMsg = 'This email does not belong to an Admin account';
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errMsg = e.message!;
          showMsg(context, errMsg);
          EasyLoading.dismiss();
        });
      }
    }
    else
      EasyLoading.dismiss();
  }
}

