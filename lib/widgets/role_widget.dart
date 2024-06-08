import 'package:flutter/material.dart';

class RoleItemWidget extends StatefulWidget {
  final String labelText;

  const RoleItemWidget({super.key, required this.labelText});

  @override
  State<RoleItemWidget> createState() => _RoleItemWidgetState();
}

class _RoleItemWidgetState extends State<RoleItemWidget> {
  bool value = false;
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          value = !value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.white,
                    offset: Offset(5.0, 5.0),
                    blurRadius: 0.3,
                    spreadRadius: 2)
              ],
              borderRadius: BorderRadius.circular(28),
              border: value
                  ? Border.all(width: 3, color: Colors.red)
                  : Border.all(
                      width: 3,
                      color: const Color.fromARGB(255, 250, 233, 233),
                    )),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      shape: const CircleBorder(),
                      activeColor: Colors.red,
                      value: value,
                      onChanged: (value) {
                        setState(() {
                          this.value = value!;
                        });
                      },
                    ),
                  ],
                ),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/onboarding_1.png"),
                      )),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 50),
                  child: Text(
                    widget.labelText,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
