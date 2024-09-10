import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/theme_provider.dart';

class PhotosCatalogPage extends StatelessWidget {
  final String selectedRow; // Add a parameter to receive the selected row value

  PhotosCatalogPage({required this.selectedRow}); // Constructor to accept the row value

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Dummy data for the grid items
    List<String> catalogItems = [
      'God 1 : 12',
      'God 2 : 29',
      'God 3 : 4',
      'God 4 : 12',
      'God 5 : 29',
      'God 6 : 4',
      'God 7 : 12',
      'God 8 : 4',
      'God 9 : 29',
      'God 10 : 4'
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.primaryColor,
        title: Text(
          'Photos Catalog - $selectedRow', // Display the selected row value
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: themeProvider.textColor,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 2.5, // Aspect ratio to control the item size
          ),
          itemCount: catalogItems.length,
          itemBuilder: (context, index) {
            return _buildGridItem(catalogItems[index], themeProvider);
          },
        ),
      ),
    );
  }

  Widget _buildGridItem(String value, ThemeProvider themeProvider) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: themeProvider.primaryColor.withOpacity(0.1),
        border: Border.all(
          color: themeProvider.primaryColor,
          width: 1.5.w,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            color: themeProvider.textColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
