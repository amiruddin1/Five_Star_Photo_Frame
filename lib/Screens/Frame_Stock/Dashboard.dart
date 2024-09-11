import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/Frame.dart';
import '../../models/theme_provider.dart';
import '../../models/DBHelper.dart'; // Ensure this import is correct

class FrameStockPage extends StatefulWidget {
  @override
  _FrameStockPageState createState() => _FrameStockPageState();
}

class _FrameStockPageState extends State<FrameStockPage> {
  late Future<List<Map<String, dynamic>>> _framesFuture;

  @override
  void initState() {
    super.initState();
    _framesFuture = DBHelperClass.instance.getAllRecords(DBHelperClass.TBLFrame);
  }

  Future<void> _showEditDialog(Map<String, dynamic> frame) async {
    final petNameController = TextEditingController(text: frame['FramePetName']);
    final actualNameController = TextEditingController(text: frame['FrameActualName']);
    final sizeController = TextEditingController(text: frame['FrameSize'].toString());
    final priceController = TextEditingController(text: frame['FrameUnitPrice'].toString());
    final stockController = TextEditingController(text: frame['FrameTotalStock'].toString());
    final colorController = TextEditingController(text: frame['FrameColor'].toString());
    final frameID = frame['FrameId'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Frame ${frameID}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: petNameController,
                decoration: InputDecoration(labelText: 'Frame Pet Name'),
              ),
              TextField(
                controller: actualNameController,
                decoration: InputDecoration(labelText: 'Frame Actual Name'),
              ),
              TextField(
                controller: sizeController,
                decoration: InputDecoration(labelText: 'Size'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: colorController,
                decoration: InputDecoration(labelText: 'Color'),
                keyboardType: TextInputType.text,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await DBHelperClass.instance.updateRecord(
                  DBHelperClass.TBLFrame,
                  {
                    'FramePetName': petNameController.text,
                    'FrameActualName': actualNameController.text,
                    'FrameSize': double.parse(sizeController.text),
                    'FrameUnitPrice': int.parse(priceController.text),
                    'FrameTotalStock': int.parse(stockController.text),
                    'FrameColor': colorController.text
                  },
                  'FrameId',
                  frameID,
                );
                setState(() {
                  _framesFuture = DBHelperClass.instance.getAllRecords(DBHelperClass.TBLFrame);
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () async {
                await DBHelperClass.instance.deleteRecord(DBHelperClass.TBLFrame, 'FrameID', frameID);
                setState(() {
                  _framesFuture = DBHelperClass.instance.getAllRecords(DBHelperClass.TBLFrame);
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddDialog() async {
    final petNameController = TextEditingController();
    final actualNameController = TextEditingController();
    final sizeController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    final colorController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Frame'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: petNameController,
                decoration: InputDecoration(labelText: 'Frame Pet Name'),
              ),
              TextField(
                controller: actualNameController,
                decoration: InputDecoration(labelText: 'Frame Actual Name'),
              ),
              TextField(
                controller: sizeController,
                decoration: InputDecoration(labelText: 'Size'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: colorController,
                decoration: InputDecoration(labelText: 'Color'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await DBHelperClass.instance.insertRecord(
                  DBHelperClass.TBLFrame,
                  {
                    'FramePetName': petNameController.text,
                    'FrameActualName': actualNameController.text,
                    'FrameSize': double.parse(sizeController.text),
                    'FrameUnitPrice': int.parse(priceController.text),
                    'FrameTotalStock': int.parse(stockController.text),
                    'FrameColor': colorController.text
                  },
                );
                setState(() {
                  _framesFuture = DBHelperClass.instance.getAllRecords(DBHelperClass.TBLFrame);
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
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
          'Frame Stock',
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
        padding: EdgeInsets.only(bottom: 80.h),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _framesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No frames available.'));
            }

            final frames = snapshot.data!;

            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Center(
                    child: Text(
                      "Price List of Frames",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: themeProvider.textColor,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: themeProvider.primaryColor,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        child: DataTable(
                          columnSpacing: 10.w,
                          headingRowHeight: 40.h,
                          dataRowHeight: 48.h,
                          columns: [
                            DataColumn(
                              label: Center(
                                child: Text(
                                  'Name',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.textColor,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Center(
                                child: Text(
                                  'Size',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.textColor,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Center(
                                child: Text(
                                  'Price',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.textColor,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Center(
                                child: Text(
                                  'Stock',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.textColor,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Center(
                                child: Text(
                                  'Actions',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.textColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          rows: frames.map((frame) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Center(
                                    child: Text(
                                      frame['FramePetName'],
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: themeProvider.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      frame['FrameSize'].toString(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: themeProvider.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      '₹${frame['FrameUnitPrice']}',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: themeProvider.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      frame['FrameTotalStock'].toString(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: themeProvider.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, color: themeProvider.primaryColor),
                                        onPressed: () => _showEditDialog(frame),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeProvider.primaryColor,
        onPressed: _showAddDialog,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
