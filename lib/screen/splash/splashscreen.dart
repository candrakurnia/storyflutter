import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  static const routeName = '/SplashScreen';
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  // startsplashscreen() {
  //   var duration = const Duration(seconds: 3);

  //   return Timer(
  //     duration,
  //     () {
  //       Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (context) => const LoginScreen()));
  //     },
  //   );
  // }

  //  @override
  // void initState() {
  //   super.initState();
  //   startsplashscreen();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ic_background.png'),
            fit: BoxFit.cover
          ),
        ),
        child: Center(child: Image.asset('assets/images/ic_splash.png')),
      ),
    );
  }
}
