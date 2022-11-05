import 'package:flutter/material.dart';

Widget customNextButton(
    {String title = 'Next', required void Function()? onPressed, IconData iconData = Icons.arrow_forward_ios}) {
  return TextButton(
    onPressed: onPressed,
    child: Container(
      color: Colors.black,
      width: double.infinity,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            width: 10,
          ),
           Icon(
            iconData,
            color: Colors.white,
          )
        ],
      ),
    ),
  );
}
