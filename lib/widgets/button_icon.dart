import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonWithIconWidget extends StatelessWidget {
  final Color backColor;
  final Color textColor;
  final String text;
  final String svgData;
  final void Function() goToRole;
  const ButtonWithIconWidget(
      {super.key,
      required this.backColor,
      required this.text,
      required this.textColor,
      required this.svgData,
      required this.goToRole});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height / 16,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          color: backColor),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgData,
            height: 20,
            width: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: goToRole,
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
          ),
        ],
      )),
    );
  }
}
