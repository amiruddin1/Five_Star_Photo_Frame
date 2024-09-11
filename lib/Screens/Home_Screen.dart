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
      {'name': 'New Order', 'route': MyApp(), 'icon': Icons.add_shopping_cart},
      {'name': 'Lock Stock', 'route': LockStockPage(), 'icon': Icons.lock},
      {'name': 'Frame Stock', 'route': FrameStockPage(), 'icon': Icons.filter_frames},
      {'name': 'Photo Stock', 'route': PhotoStockPage(), 'icon': Icons.photo_library},
      {'name': 'Track Orders', 'route': PhotoStockPage(), 'icon': Icons.task_rounded},
      {'name': 'Update Data', 'route': PhotoStockPage(), 'icon': Icons.query_stats},
    ];

    return Scaffold(
      backgroundColor: themeProvider.bgColor, // Set background color
      appBar: AppBar(
        backgroundColor: themeProvider.primaryColor, // Use primary color for AppBar
        centerTitle: true, // Center the AppBar title
        title: Text(
          'Home Screen',
          style: TextStyle(
            fontSize: 20.sp, // Increased font size
            fontWeight: FontWeight.bold, // Bold text
            color: themeProvider.textColor, // Use text color from ThemeProvider
            fontFamily: 'poppins', // Use desired font family
          ),
        ),
        elevation: 4.0, // Add shadow to AppBar for a subtle effect
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w), // Add padding around the grid
        child: GridView.count(
          crossAxisCount: 2, // Two boxes per row
          crossAxisSpacing: 16.w, // Space between columns
          mainAxisSpacing: 16.h, // Space between rows
          children: List.generate(6, (index) { // Generates four boxes
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => boxData[index]['route']),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: themeProvider.primaryColor.withOpacity(0.1), // Light color for boxes
                  border: Border.all(
                    color: themeProvider.primaryColor, // Border color
                    width: 2.0.w,
                  ),
                  borderRadius: BorderRadius.circular(10.0.w), // Rounded corners
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        boxData[index]['icon'], // Display the icon
                        color: themeProvider.primaryColor, // Icon color
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w), // Space between icon and text
                      Text(
                        boxData[index]['name'], // Use unique box names
                        style: TextStyle(
                          fontSize: 16.sp, // Responsive text size
                          color: themeProvider.textColor, // Use text color from ThemeProvider
                          fontFamily: 'poppins', // Use desired font family
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
