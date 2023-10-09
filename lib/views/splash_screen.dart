import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';
import './home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // checks if the internet is connected or not and send result to homepage
  getconnectivity() async {
    await context.read<NetworkProvider>().checkconnectivity();
    final result = context.read<NetworkProvider>().isconnected;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(isconnected: result),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), getconnectivity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: SvgPicture.asset(
          'assets/icons/subspace_hor.svg',
          semanticsLabel: 'logo',
          width: 140,
        ),
      ),
    );
  }
}
