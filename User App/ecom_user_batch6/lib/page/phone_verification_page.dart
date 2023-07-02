import 'package:ecom_user_batch6/auth/auth_service.dart';
import 'package:ecom_user_batch6/page/otp_verification_page.dart';
import 'package:ecom_user_batch6/utils/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


import 'registration_page.dart';

class PhoneVerificationPage extends StatefulWidget {
  static const String routeName = '/phone_verification';

  const PhoneVerificationPage({Key? key}) : super(key: key);

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {

  String vId = '';
  PhoneNumber number = PhoneNumber(isoCode: 'BD');
  String phoneNumber = '';
  bool numberValidate = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Center(child: Image.asset('images/phone_verification_page.png',height: 275,width: 274,)),
              SizedBox(height: 30,),
              Text('Your Phone Number',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.blueAccent),),
              SizedBox(height: 25,),
              Wrap(
                children: [
                  Text('Welcome to GM Express! Please enter your phone number below, we\'ll send a verification code at complete your registration'),
                ],
              ),
              SizedBox(height: 25,),
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  print(number.phoneNumber);
                  phoneNumber = number.phoneNumber!;
                  print(phoneNumber);
                },
                onInputValidated: (bool value) {
                  numberValidate = value;
                  print(numberValidate);

                },

                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                selectorTextStyle: TextStyle(color: Colors.black),
                spaceBetweenSelectorAndTextField: 0,
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,

                initialValue: number,
                formatInput: false,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                inputDecoration: InputDecoration(
                  hintText: 'e.g +88016123153',
                  labelText: 'Enter Your Phone Number',
                  prefixIcon: Icon(Icons.phone_android),
                  floatingLabelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Color(0xff9b9b9b)),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Color(0xff9b9b9b)),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Color.fromARGB(255, 66, 125, 145)),
                  ),
                ),

              ),
              SizedBox(height: 15,),
              //send button
              GestureDetector(
                onTap: (){
                  if(!numberValidate) {
                    showMsg(context, 'Invalid Phone Number');
                    return;
                  }
                  _verifyPhone();
                },
                child: Container(
                  height: 50,
                  width: double.maxFinite,
                  color: Colors.amber,
                  child: Center(child: Text('Send',style: TextStyle(fontSize: 18),)),
                ),
              ),
              SizedBox(height: 15,),
              Wrap(
                children: [
                  Center(child: Text('We will send a 6-digit verification code to your number',style: TextStyle(color: Colors.blueAccent),)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _verifyPhone() async {
    EasyLoading.show(status: 'loading...');
    print(phoneNumber);
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async{},
      verificationFailed: (FirebaseAuthException e) {
        showMsg(context, e.toString());
        EasyLoading.dismiss();
      },
      codeSent: (String verificationId, int? resendToken) {
        vId = verificationId;
        Navigator.pushNamed(context, OTPVerificationPage.routeName,arguments: [vId,phoneNumber]);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
      },
    );

  }

}
