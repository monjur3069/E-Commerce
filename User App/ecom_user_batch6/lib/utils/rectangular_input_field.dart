import 'package:ecom_user_batch6/utils/constants.dart';
import 'package:ecom_user_batch6/utils/neumorphic_text_field_container.dart';
import 'package:flutter/material.dart';


class RectangularInputField extends StatelessWidget {

  final String hintText;
  final IconData icon;
  final bool obscureText;
  TextEditingController controller;
  RectangularInputField({Key? key, required this.hintText, required this.icon, required this.obscureText,required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicTextFieldContainer(
      child: TextField(
        controller: controller,
        cursorColor: black,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          helperStyle: TextStyle(
            color: black.withOpacity(0.7),
            fontSize: 18,
          ),
          prefixIcon: Icon(icon,color: black.withOpacity(0.7),size: 20,),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
