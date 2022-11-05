import 'package:flutter/material.dart';

Widget customDropdownWidget(
    {required String title,
    required String value,
    required List items,
    required void Function(dynamic) onChanged,
    required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.black.withOpacity(0.3),
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButton(
              menuMaxHeight: 300,
              hint: Text(value),
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item.toString(),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: Text(item.toString())),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    ),
  );
}
