
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user_batch6/providers/user_provider.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    fillColor: Colors.white,
                    filled: true),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: isObscureText,
                controller: passController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        isObscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() {
                      isObscureText = !isObscureText;
                    }),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue.shade900,
                  ),
                  onPressed: () {
                    authenticate();
                  },
                  child: const Text('LOGIN'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Forgot Password?'),
                  TextButton(
                    onPressed: () {

                    },
                    child: const Text('Click Here', style: const TextStyle(color: Colors.white),),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New User?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, PhoneVerificationPage.routeName);
                    },
                    child: const Text('REGISTER', style: const TextStyle(color: Colors.white),),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              const Center(child: Text('OR', style: TextStyle(color: Colors.white, fontSize: 18),)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: () {
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
                },
                child: const Text('SIGN IN WITH GOOGLE', style: const TextStyle(color: Colors.black),),
              ),
              const SizedBox(height: 10,),
              Text(errMsg, style: TextStyle(color: Theme.of(context).errorColor),)
            ],
          ),
        ),
      ),
    );
  }

  authenticate() async {
    if(formKey.currentState!.validate()) {
      try {
        final status = await AuthService.login(emailController.text, passController.text);
        if(status) {
          if(!mounted) return;
          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        } else {
          await AuthService.logout();
          setState(() {
            errMsg = 'This email does not belong to an Admin account';
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errMsg = e.message!;
        });
      }
    }
  }
}
