import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/theme_provider.dart';
import '../../models/DBHelper.dart'; // Ensure this import is correct

class MirrorStockPage extends StatefulWidget {
  @override
  _MirrorStockPageState createState() => _MirrorStockPageState();
}

class _MirrorStockPageState extends State<MirrorStockPage> {
  late Future<List<Map<String, dynamic>>> _mirrorsFuture;

  @override
  void initState() {
    super.initState();
    _mirrorsFuture = DBHelperClass.instance.getAllRecords(DBHelperClass.TBLMirror);
  }

  Future<void> _showEditDialog(Map<String, dynamic> mirror) async {
    final descriptionController = TextEditingController(text: mirror['Description']);
    final measurementController = TextEditingController(text: mirror['Measurement']);
    final priceController = TextEditingController(text: mirror['UnitPrice'].toString());
    final stockController = TextEditingController(text: mirror['TotalStock'].toString());
    final MirrorId = mirror['MirrorId'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Mirror ${MirrorId}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: measurementController,
                decoration: InputDecoration(labelText: 'Measurement'),
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await DBHelperClass.instance.updateRecord(
                  DBHelperClass.TBLMirror,
                  {
                    'Description': descriptionController.text,
                    'Measurement': measurementController.text,
                    'UnitPrice': int.parse(priceController.text),
                    'TotalStock': int.parse(stockController.text),
                  },
                  'MirrorId',
                  MirrorId,
                );
                setState(() {
                  _mirrorsFuture = DBHelperClass.instance.getAllRecords(DBHelperClass.TBLMirror);
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () async {
                await DBHelperClass.instance.deleteRecord(DBHelperClass.TBLMirror, 'Mirror_id', MirrorId);
                setState(() {
                  _mirrorsFuture = DBHelperClass.instance.getAllRecords(DBHelperClass.TBLMirror);
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
    final descriptionController = TextEditingController();
    final measurementController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Mirror'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: measurementController,
                decoration: InputDecoration(labelText: 'Measurement'),
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await DBHelperClass.instance.insertRecord(
                  DBHelperClass.TBLMirror,
                  {
                    'Description': descriptionController.text,
                    'Measurement': measurementController.text,
                    'UnitPrice': int.parse(priceController.text),
                    'TotalStock': int.parse(stockController.text),
                  },
                );
                setState(() {
                  _mirrorsFuture = DBHelperClass.instance.getAllRecords(DBHelperClass.TBLMirror);
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
          'Mirror Stock',
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
          future: _mirrorsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No mirrors available.'));
            }

            final mirrors = snapshot.data!;

            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Center(
                    child: Text(
                      "Price List of Mirrors",
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
                                  'Detail',
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
                          rows: mirrors.map((mirror) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Center(
                                    child: Text(
                                      mirror['Description'],
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
                                      mirror['Measurement'],
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
                                      '₹${mirror['UnitPrice']}',
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
                                      mirror['TotalStock'].toString(),
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
                                        onPressed: () => _showEditDialog(mirror),
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
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
        backgroundColor: themeProvider.primaryColor,
      ),
    );
  }
}
