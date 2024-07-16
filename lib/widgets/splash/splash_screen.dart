import 'package:flutter/material.dart';
import 'package:hilola_gayratova/database/music_data.dart';
import 'package:provider/provider.dart';
import '../../provider/music_provider.dart';
import '../../styles/app_color.dart';
import '../../styles/app_icon.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    final providerMusic = Provider.of<ProviderMusic>(context, listen: false);
    await providerMusic.preloadDurations();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppIcon.avatar),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: [AppColors.blue, AppColors.blueAcc],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                $name,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
