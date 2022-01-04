import 'package:chat/shared/styles/ico_broken.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

String? USER_ID;

void navigateTo({required context, required widget}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}


void navigateAndFinish({required context, required widget}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (route) => false,
  );
}

Widget defaultTextButton(
    {required VoidCallback onPressed, required String text}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      text.toUpperCase(),
    ),
  );
}

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType inputType,
  required String? Function(String?)? validate,
  required String label,
  required IconData prefixIcon,
  VoidCallback? onTap,
  void Function(dynamic)? onChange,
  IconData? suffixIcon,
  VoidCallback? suffixFunction,
  void Function(String)? onSubmit,
  bool obscureText = false,
}) {
  return TextFormField(
    validator: validate,
    controller: controller,
    keyboardType: inputType,
    obscureText: obscureText,
    onTap: onTap,
    onChanged: onChange,
    onFieldSubmitted: onSubmit,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        prefixIcon,
      ),
      suffixIcon: suffixIcon != null
          ? IconButton(onPressed: suffixFunction, icon: Icon(suffixIcon))
          : null,
      border: OutlineInputBorder(),
    ),
  );
}

Widget defaultButton(
    {double width = double.infinity,
    Color backgroundColor = Colors.blue,
    bool isUpperCase = true,
    required VoidCallback function,
    required String text,
    double height = 50.0,
    double radius = 3.0}) {
  return Container(
    width: width,
    height: height,
    child: MaterialButton(
      onPressed: function,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: backgroundColor,
    ),
  );
}

Widget circularProgressIndicator() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

void defaultToast(
    {required String message,
    double fontSize = 16.0,
    Color backgroundColor = Colors.black45,
    Color textColor = Colors.white,
    Toast duration = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: duration,
      gravity: gravity,
      timeInSecForIosWeb: duration == Toast.LENGTH_SHORT ? 5 : 10,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize);
}

PreferredSizeWidget defaultAppBar({required BuildContext context, String? title, List<Widget>? actions}){
  return AppBar(
    leading: IconButton(
      onPressed: (){
        Navigator.pop(context);
      },
      icon: const Icon(
          IconBroken.Arrow___Left_2
      ),
    ),
    titleSpacing: 5.0,
    title: Text(
      '$title',
    ),
    actions: actions,
  );
}
