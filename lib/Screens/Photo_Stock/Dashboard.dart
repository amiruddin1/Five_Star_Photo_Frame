import 'package:five_star_photo_framing/Screens/Photo_Stock/PhotosCatalog.dart';
import 'package:five_star_photo_framing/models/DBHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/theme_provider.dart';

class PhotoStockPage extends StatefulWidget {
  @override
  _PhotoStockPageState createState() => _PhotoStockPageState();
}

class _PhotoStockPageState extends State<PhotoStockPage> {
  List<String> rowValues = ['4x6','5x7', '9x12', '12x16', '12x18', '16x24'];
  Map<String, int> photoCounts = {};

  @override
  void initState() {
    super.initState();
    _loadPhotoCounts(); // Fetch photo counts when the page initializes
  }

  Future<void> _loadPhotoCounts() async {
    Map<String, int> counts = {};
    for (String size in rowValues) {
      int count = await DBHelperClass.instance.getPhotoCountBySize(size) ?? 0; // Ensure count is not null
      counts[size] = count;
    }
    setState(() {
      photoCounts = counts;
    });
  }

  void _showAddRowDialog() {
    String newValue = ''; // Variable to store the user input

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Row'),
          content: TextField(
            onChanged: (value) {
              newValue = value; // Capture the input from the user
            },
            decoration: InputDecoration(
              hintText: 'Enter new size (e.g., 10x15)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newValue.isNotEmpty) {
                  setState(() {
                    rowValues.add(newValue); // Add new value to the list
                    photoCounts[newValue] = 0; // Initialize the count for new size
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.primaryColor,
        title: Text(
          'Photo Stock',
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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: rowValues
                    .map((value) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotosCatalogPage(
                          selectedRow: value, // Pass the selected row value
                        ),
                      ),
                    );
                  },
                  child: _buildRow(value, themeProvider),
                ))
                    .toList(),
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _showAddRowDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Add More Size',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: themeProvider.textColor,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String value, ThemeProvider themeProvider) {
    int count = photoCounts[value] ?? 0;

    return Container(
      width: double.infinity, // Full width of the screen
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: themeProvider.primaryColor.withOpacity(0.1), // Light background
        border: Border.all(
          color: themeProvider.primaryColor,
          width: 1.5.w,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and number
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              color: themeProvider.textColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            '$count', // Display the dynamic count
            style: TextStyle(
              fontSize: 16.sp,
              color: themeProvider.textColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
