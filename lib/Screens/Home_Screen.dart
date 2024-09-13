import 'package:five_star_photo_framing/Screens/Mirror_Stock/Dashboard.dart';
import 'package:five_star_photo_framing/Screens/Track_Orders/Dashboard.dart';
import 'package:five_star_photo_framing/Screens/UpdateData/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../models/theme_provider.dart';
import './New_Order/Dashboard.dart';
import './Lock_Stock/Dashboard.dart';
import './Frame_Stock/Dashboard.dart';
import './Photo_Stock/Dashboard.dart';
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider instance
    final themeProvider = Provider.of<ThemeProvider>(context);

    // List of box names with unique labels, corresponding routes, and icons
    final List<Map<String, dynamic>> boxData = [
      {'name': 'New Order', 'route': MyApp(), 'icon': Icons.receipt_long},
      {'name': 'Lock Stock', 'route': LockStockPage(), 'icon': Icons.lock},
      {'name': 'Frame Stock', 'route': FrameStockPage(), 'icon': Icons.filter_frames},
      {'name': 'Photo Stock', 'route': PhotoStockPage(), 'icon': Icons.photo_library},
      {'name': 'Mirror Stock', 'route': MirrorStockPage(), 'icon': Icons.flip_camera_ios},
      {'name': 'Calculate Price', 'route': PhotoStockPage(), 'icon': Icons.analytics},
      {'name': 'Track Orders', 'route': ManageOrders(), 'icon': Icons.task_rounded},
      {'name': 'Update Data', 'route': UpdateDataPage(), 'icon': Icons.query_stats},
    ];

    return Scaffold(
      backgroundColor: themeProvider.bgColor,
      appBar: AppBar(
        backgroundColor: themeProvider.primaryColor,
        centerTitle: true,
        title: Text(
          'Home Screen',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: themeProvider.textColor,
            fontFamily: 'poppins',
          ),
        ),
        elevation: 4.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          children: List.generate(8, (index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => boxData[index]['route']),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: themeProvider.primaryColor.withOpacity(0.1),
                  border: Border.all(
                    color: themeProvider.primaryColor,
                    width: 2.0.w,
                  ),
                  borderRadius: BorderRadius.circular(10.0.w),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        boxData[index]['icon'],
                        color: themeProvider.primaryColor,
                        size: 24.sp,
                      ),
                      SizedBox(height: 8.h), // Adjust the space between icon and text
                      Text(
                        boxData[index]['name'],
                        textAlign: TextAlign.center, // Center-align the text
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: themeProvider.textColor,
                          fontFamily: 'poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
