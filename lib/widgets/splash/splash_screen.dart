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
  late Future<void> _initData;

  @override
  void initState() {
    super.initState();
    _initData = _loadData();
  }

  Future<void> _loadData() async {
    final providerMusic = context.read<ProviderMusic>();
    await providerMusic.getDataIsLoaded();

    if (!providerMusic.isLoaded) {
      await providerMusic.preloadDurations();
      providerMusic.saveDataIsLoaded();
    } else {
      await Future.delayed(const Duration(milliseconds: 3600));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          });
          return _buildSplashScreenContent();
        } else {
          return _buildSplashScreenContent(); // Optionally show a loading indicator
        }
      },
    );
  }

  Widget _buildSplashScreenContent() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppIcon.avatar),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: LinearProgressIndicator(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
