import 'package:five_star_photo_framing/Screens/Frame_Stock/Dashboard.dart';
import 'package:five_star_photo_framing/Screens/Lock_Stock/Dashboard.dart';
import 'package:five_star_photo_framing/Screens/Mirror_Stock/Dashboard.dart';
import 'package:five_star_photo_framing/Screens/Track_Orders/Dashboard.dart';
import 'package:five_star_photo_framing/Screens/UpdateData/UpdatePhotos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/theme_provider.dart'; // Ensure this import is correct

class UpdateDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.primaryColor,
        title: Text(
          'Update Data',
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
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2 boxes per row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildBox(context, 'Photos', Icons.photo, themeProvider, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PhotosPage()));
            }),
            _buildBox(context, 'Lock', Icons.lock, themeProvider, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LockStockPage()));
            }),
            _buildBox(context, 'Frame', Icons.filter_frames, themeProvider, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FrameStockPage()));
            }),
            _buildBox(context, 'Order', Icons.receipt_long, themeProvider, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ManageOrders()));
            }),
            _buildBox(context, 'Mirror', Icons.receipt_long, themeProvider, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MirrorStockPage()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBox(BuildContext context, String title, IconData icon, ThemeProvider themeProvider, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(), // Call the function passed as the onTap parameter
      child: Container(
        decoration: BoxDecoration(
          color: themeProvider.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: themeProvider.primaryColor, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: themeProvider.primaryColor),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
