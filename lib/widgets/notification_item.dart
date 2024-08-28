import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final String notiText;
  final String notiSubText;
  final IconData notiIcon;
  const NotificationItem(
      {super.key,
      required this.notiIcon,
      required this.notiText,
      required this.notiSubText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Color.fromARGB(139, 183, 178, 172))),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(30)),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.add_chart_sharp,
                    size: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notiText,
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  notiSubText,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
