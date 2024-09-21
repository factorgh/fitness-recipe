import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/login_screen.dart';
import 'package:voltican_fitness/screens/signup_screen.dart';
import 'package:voltican_fitness/widgets/button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List images = ['onboarding_1.png', 'onboarding_2.png', 'onboarding_3.png'];
  List mainContent = [
    'Personalized Nutrition,',
    'Stay on track,Everybite',
    'Nutrition made easy,One bite'
  ];
  List subContent = ['Tailored for you', 'count', 'at a time'];

  void _login(BuildContext ctx) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const LoginScreen(),
      ),
    );
  }

  void _signUp(BuildContext ctx) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            itemBuilder: (_, index) {
              return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/${images[index]}'),
                  ),
                ),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                    ),
                    RichText(
                      text: TextSpan(
                          text: '${mainContent[index]}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w300),
                          children: [
                            TextSpan(text: "\n${subContent[index]}.")
                          ]),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (indexDots) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: index == indexDots ? 25 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: index == indexDots
                                  ? Colors.red
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 200,
                    )
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // InkWell(
                //   onTap: () {
                //     _signUp(context);
                //   },
                //   splashColor: Colors.purple,
                //   child: const CustomButton(
                //       size: 20,
                //       width: 50,
                //       backColor: Colors.red,
                //       text: 'Skip',
                //       textColor: Colors.white),
                // ),
                GestureDetector(
                  onTap: () {
                    _signUp(context);
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    _signUp(context);
                  },
                  splashColor: Colors.purple,
                  child: const ButtonWidget(
                      backColor: Colors.red,
                      text: 'Get Started',
                      textColor: Colors.white),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    _login(context);
                  },
                  splashColor: Colors.purple,
                  child: const ButtonWidget(
                      backColor: Colors.white,
                      text: 'Login',
                      textColor: Colors.brown),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
