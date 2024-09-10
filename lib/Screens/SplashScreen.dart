import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../models/theme_provider.dart'; // Create a ThemeProvider to manage colors
import 'Home_Screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _colorAnimation = ColorTween(begin: Colors.transparent, end: Colors.red.withOpacity(0.5)).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);

    Future.delayed(Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>( // Use ThemeProvider for interactive color changes
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.bgColor,
          body: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Container(
                        width: 200.w, // Increased width for larger image
                        height: 280.h, // Increased height for vertical elongation
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Keeps the image oval
                          border: Border.all(
                            color: themeProvider.primaryColor, // Attractive border color
                            width: 6.0.w, // Increased border width
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _colorAnimation.value ?? Colors.transparent, // Use fallback color
                              blurRadius: 30.0,
                              spreadRadius: 10.0,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/logo.png',
                                width: 200.w, // Match container width
                                height: 280.h, // Match container height
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 1200),
                                  width: _animationController.value * 300.w, // Pulsating width
                                  height: _animationController.value * 300.h, // Pulsating height
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.red.withOpacity(0.6), // Pulsating color red
                                      width: 2.0.w,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30.h), // Increased space between image and text
                  Text(
                    '5 Star Photo Framing',
                    textAlign: TextAlign.center, // Center text horizontally
                    style: TextStyle(
                      fontSize: 26.sp, // Increased font size
                      fontWeight: FontWeight.bold,
                      color: themeProvider.textColor,
                      fontFamily: 'SourceSansPro', // Updated font family
                      shadows: [
                        Shadow(
                          blurRadius: 8.0,
                          color: themeProvider.primaryColor.withOpacity(0.7),
                          offset: Offset(4.0, 4.0),
                        ),
                      ],
                    ), // Responsive text with shadow for better contrast
                  ),
                  SizedBox(height: 10.h), // Space between title and proprietor text
                  Text(
                    'Proprietor: Ibrahim Samlayawala (23-06-1967 to 23-07-2024)',
                    textAlign: TextAlign.center, // Center text horizontally
                    style: TextStyle(
                      fontSize: 16.sp, // Adjust font size as needed
                      fontWeight: FontWeight.normal,
                      color: themeProvider.textColor.withOpacity(0.7),
                      fontFamily: 'SourceSansPro', // Updated font family
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: themeProvider.primaryColor.withOpacity(0.5),
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ), // Responsive text with shadow for better contrast
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
