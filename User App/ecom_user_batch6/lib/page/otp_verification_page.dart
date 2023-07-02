import 'package:ecom_user_batch6/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


import 'registration_page.dart';

class OTPVerificationPage extends StatefulWidget {
  static const String routeName = '/otp_verification';

  const OTPVerificationPage({Key? key}) : super(key: key);

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {


  final otpController = TextEditingController();
  late final vId;

  @override
  void didChangeDependencies() {
    EasyLoading.dismiss();
    final value = ModalRoute.of(context)!.settings.arguments;
    vId =  value == null ? '' : value as List;
    print(vId);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
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
              Center(child: Image.asset('images/otp_page.png',height: 275,width: 274,)),
              SizedBox(height: 30,),
              Text('Enter OTP',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.blueAccent),),
              SizedBox(height: 25,),
              Wrap(
                children: [
                  Text('Your account is already ready! Please enter the 6 digit OTP code we just send to your phone number.'),
                ],
              ),
              SizedBox(height: 25,),
              PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(2),
                  fieldHeight: 45,
                  fieldWidth: 55,

                  selectedFillColor: Colors.grey,
                  selectedBorderWidth: 1,
                  selectedColor: Colors.black,

                  activeColor: Colors.black,
                  activeBorderWidth: 1,
                  activeFillColor: Colors.white,

                  inactiveColor: Colors.black,
                  inactiveBorderWidth: 1,
                  inactiveFillColor: Colors.white,
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.white,
                enableActiveFill: true,
                //errorAnimationController: errorController,
                controller: otpController,
                onChanged: (value) {
                  if(value.length == 6) {
                    /*EasyLoading.show(status: 'Please Wait');
                    _verifyOtp();*/
                  }
                },
              ),
              SizedBox(height: 15,),
              //send button
              GestureDetector(
                onTap: _verifyOtp,
                child: Container(
                  height: 50,
                  width: double.maxFinite,
                  color: Colors.amber,
                  child: Center(child: Text('Verify',style: TextStyle(fontSize: 18),)),
                ),
              ),
              SizedBox(height: 15,),
              Wrap(
                children: [
                  Center(child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Don\'t forget your OTP yet?',style: TextStyle(color: Colors.blueAccent),),
                      SizedBox(width: 5,),
                      Text('Resend OTP',style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _verifyOtp() {
    EasyLoading.show(status: 'loading...');
    PhoneAuthCredential credential = PhoneAuthProvider
        .credential(verificationId: vId[0], smsCode: otpController.text);
    FirebaseAuth.instance.signInWithCredential(credential)
        .then((credentialUser) {
      if(credentialUser != null) {
        EasyLoading.dismiss();
        Navigator.pushReplacementNamed(context, RegistrationPage.routeName,arguments: vId[1]);
      }
    });
  }
}
