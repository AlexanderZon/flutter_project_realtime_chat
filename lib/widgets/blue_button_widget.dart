import 'package:flutter/material.dart';

class BlueButtonWidget extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const BlueButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(2),
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.blue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27.0),
          ),
        ),
      ),
      child: Container(
        height: 55,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
