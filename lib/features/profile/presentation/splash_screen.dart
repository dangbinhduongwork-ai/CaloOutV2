import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Splash screen displayed while loading local profile data to prevent UI flickering.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContainerFlameLogo(),
            SizedBox(height: 24),
            Text(
              'CaloOut',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerFlameLogo extends StatelessWidget {
  const ContainerFlameLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.calorieBurnGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.calorieOrange.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.local_fire_department,
        size: 50,
        color: Colors.white,
      ),
    );
  }
}
