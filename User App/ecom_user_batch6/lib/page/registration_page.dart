
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import 'launcher_page.dart';
import 'phone_verification_page.dart';

class RegistrationPage extends StatefulWidget {
  static const String routeName = '/registration';

  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  bool isObscureText = true;
  final formKey = GlobalKey<FormState>();
  String errMsg = '';

  @override
  void didChangeDependencies() {
    final value = ModalRoute.of(context)!.settings.arguments;
    phoneController.text =  value == null ? '' : value.toString();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    phoneController.dispose();
    nameController.dispose();
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
                controller: nameController,
                decoration: const InputDecoration(
                    hintText: 'Enter Full Name',
                    prefixIcon: Icon(Icons.person),
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
                enabled: false,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    hintText: 'Mobile Number',
                    prefixIcon: Icon(Icons.phone),
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
                  child: const Text('REGISTER'),
                ),
              ),

              const SizedBox(height: 20,),

              Text(errMsg, style: TextStyle(color: Theme.of(context).errorColor),)
            ],
          ),
        ),
      ),
    );
  }

  authenticate() async {
    if(formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please Wait', dismissOnTap: false);
      try {
        if(await AuthService.register(emailController.text, passController.text)) {
          final userModel = UserModel(
            uid: AuthService.user!.uid,
            email: AuthService.user!.email!,
            name: nameController.text,
            mobile: phoneController.text,
            userCreationTime: Timestamp.fromDate(AuthService.user!.metadata.creationTime!),
          );
          if(!mounted) return;
          Provider.of<UserProvider>(context, listen: false)
            .addUser(userModel).then((value) {
              EasyLoading.dismiss();
              Navigator.pushNamedAndRemoveUntil(context, LauncherPage.routeName, (route) => false);
          });

        };
      } on FirebaseAuthException catch (e) {
        setState(() {
          errMsg = e.message!;
        });
      }
    }
  }
}
