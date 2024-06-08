import 'package:flutter/material.dart';

class OrDividerWidget extends StatelessWidget {
  const OrDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Divider(
                color: Color(0xFFD9C7C7),
                height: 10,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'OR',
              style: TextStyle(
                  color: Color.fromARGB(255, 249, 189, 189),
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Divider(
                color: Color.fromARGB(255, 249, 189, 189),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
