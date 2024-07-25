import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TraineesScreen extends StatelessWidget {
  final String userRole;
  final String userImgUrl;

  const TraineesScreen({
    Key? key,
    this.userRole = 'Trainee',
    this.userImgUrl = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE5ECF9), Color(0xFFF6F7F9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trainees',
                      style: TextStyle(
                        fontFamily: 'CustomFontBold',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      
                        children: [
                          userImgUrl.isNotEmpty
                              ? CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(userImgUrl),
                                )
                              : CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.grey[400],
                                  child: Icon(Icons.person, color: Colors.white),
                                ),
                          SizedBox(width: 5),
                          Text(
                            userRole,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Placeholder content for demonstration
                Expanded(
                  child: Center(
                    child: Text('No trainees available'),
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
