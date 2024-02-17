import 'package:flutter/material.dart';

class CustomTitleWidget extends StatefulWidget {
  final String title;
  const CustomTitleWidget({Key? key, required this.title}) : super(key: key);

  @override
  _CustomTitleWidgetState createState() => _CustomTitleWidgetState();
}

class _CustomTitleWidgetState extends State<CustomTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
