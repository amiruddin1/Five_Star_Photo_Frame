import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/theme_provider.dart';
import '../../models/DBHelper.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PhotosCatalogPage extends StatefulWidget {
  final String selectedRow;

  PhotosCatalogPage({required this.selectedRow});

  @override
  _PhotosCatalogPageState createState() => _PhotosCatalogPageState();
}

class _PhotosCatalogPageState extends State<PhotosCatalogPage> {
  late Future<List<Map<String, dynamic>>> _godRecordsFuture;

  @override
  void initState() {
    super.initState();
    _godRecordsFuture = DBHelperClass.instance.getAllRecords(DBHelperClass.TBLGod);
  }
  void _showAddGodDialog() {
    String newGodName = '';
    String newGodGender = 'Male';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New God'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newGodName = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter god name',
                ),
              ),
              DropdownButton<String>(
                value: newGodGender,
                onChanged: (String? newValue) {
                  setState(() {
                    newGodGender = newValue!;
                  });
                },
                items: <String>['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newGodName.isNotEmpty) {
                  await DBHelperClass.instance.insertRecord(
                    DBHelperClass.TBLGod,
                    {
                      DBHelperClass.GodName: newGodName,
                      DBHelperClass.GodGender: newGodGender,
                    },
                  );
                  setState(() {
                    _godRecordsFuture = DBHelperClass.instance.getAllRecords(DBHelperClass.TBLGod);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }


  void _showEditDialog(int id, String godName, String godGender) {
    String newGodName = godName;
    String newGodGender = godGender;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit God'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: godName),
                onChanged: (value) {
                  newGodName = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter god name',
                ),
              ),
              DropdownButton<String>(
                value: newGodGender,
                onChanged: (String? newValue) {
                  setState(() {
                    newGodGender = newValue!;
                  });
                },
                items: <String>['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newGodName.isNotEmpty) {
                  await DBHelperClass.instance.updateRecord(
                    DBHelperClass.TBLGod,
                    {
                      DBHelperClass.GodName: newGodName,
                      DBHelperClass.GodGender: newGodGender,
                    },
                    DBHelperClass.GodId, // Replace with your actual ID column
                    id,
                  );
                  setState(() {
                    _godRecordsFuture = DBHelperClass.instance.getAllRecords(DBHelperClass.TBLGod);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () async {
                await DBHelperClass.instance.deleteRecord(
                  DBHelperClass.TBLGod,
                  DBHelperClass.GodId, // Replace with your actual ID column
                  id,
                );
                setState(() {
                  _godRecordsFuture = DBHelperClass.instance.getAllRecords(DBHelperClass.TBLGod);
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
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
          'Photos Catalog - ${widget.selectedRow}',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: themeProvider.textColor,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _godRecordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No gods found.'));
          }

          List<Map<String, dynamic>> records = snapshot.data!;
          List<String> catalogItems = records
              .map((record) => '${record[DBHelperClass.GodName]} : 0') // Placeholder count
              .toList();

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Stack(
              children: [
                GridView.builder(
                  padding: EdgeInsets.only(bottom: 80.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return GestureDetector(
                      onTap: () {
                        _showEditDialog(
                          record[DBHelperClass.GodId], // Replace with your actual ID
                          record[DBHelperClass.GodName],
                          record[DBHelperClass.GodGender],
                        );
                      },
                      child: _buildGridItem('${record[DBHelperClass.GodName]} : 0', themeProvider),
                    );
                  },
                ),
                // Ensure FAB is on top
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGodDialog,
        backgroundColor: themeProvider.primaryColor,
        child: Icon(Icons.add),
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
            fontSize: 12.sp,
            color: themeProvider.textColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
