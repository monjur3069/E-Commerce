import 'package:ecom_user_batch6/utils/constants.dart';
import 'package:flutter/material.dart';

class LoginPageHeadText extends StatelessWidget {
  const LoginPageHeadText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:  EdgeInsets.symmetric(
        horizontal: appPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.05),
          Text('Welcome',style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),),
          Text('SIGN IN',style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),),
        ],
      ),
    );
  }
}
