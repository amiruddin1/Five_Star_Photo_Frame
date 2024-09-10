import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/theme_provider.dart';

class FrameStockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.primaryColor,
        title: Text(
          'Frame Stock',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: themeProvider.textColor,
            fontFamily: 'poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Frame Stock Page',
          style: TextStyle(
            fontSize: 18.sp,
            color: themeProvider.textColor,
            fontFamily: 'poppins',
          ),
        ),
      ),
    );
  }
}
