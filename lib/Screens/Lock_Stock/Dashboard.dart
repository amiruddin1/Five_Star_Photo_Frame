import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/Lock.dart';
import '../../models/theme_provider.dart';

class LockStockPage extends StatefulWidget {
  @override
  _LockStockPageState createState() => _LockStockPageState();
}

class _LockStockPageState extends State<LockStockPage> {
  List<Lock> locks = List.generate(20, (index) {
    return Lock(
      serialNumber: index + 1,
      lockName: 'Lock ${index + 1}',
      unitPrice: 50 + (index * 10),
      mm: 25 + (index * 5),
      totalStock: 100 - (index * 5),
    );
  });

  void _showEditDialog(Lock lock) {
    final nameController = TextEditingController(text: lock.lockName);
    final mmController = TextEditingController(text: lock.mm.toString());
    final priceController = TextEditingController(text: lock.unitPrice.toString());
    final stockController = TextEditingController(text: lock.totalStock.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Lock ${lock.serialNumber}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Lock Name'),
              ),
              TextField(
                controller: mmController,
                decoration: InputDecoration(labelText: 'MM'),
                keyboardType: TextInputType.number,
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
              onPressed: () {
                setState(() {
                  lock.lockName = nameController.text;
                  lock.mm = int.parse(mmController.text);
                  lock.unitPrice = int.parse(priceController.text);
                  lock.totalStock = int.parse(stockController.text);
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
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

  void _showAddDialog() {
    final nameController = TextEditingController();
    final mmController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Lock'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Lock Name'),
              ),
              TextField(
                controller: mmController,
                decoration: InputDecoration(labelText: 'MM'),
                keyboardType: TextInputType.number,
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
              onPressed: () {
                setState(() {
                  int newSerialNumber = locks.length + 1;
                  locks.add(
                    Lock(
                      serialNumber: newSerialNumber,
                      lockName: nameController.text,
                      mm: int.parse(mmController.text),
                      unitPrice: int.parse(priceController.text),
                      totalStock: int.parse(stockController.text),
                    ),
                  );
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

  void _deleteLock(Lock lock) {
    setState(() {
      locks.remove(lock);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.primaryColor,
        title: Text(
          'Lock Stock',
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
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Center(
                child: Text(
                  "Price List of Lock",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: themeProvider.textColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                        label: Text(
                          'No.',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '(mm)',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Price',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Stock',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Actions',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                          ),
                        ),
                      ),
                    ],
                    rows: locks.map((lock) {
                      return DataRow(
                        cells: [
                          DataCell(Text(
                            lock.serialNumber.toString(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: themeProvider.textColor,
                            ),
                          )),
                          DataCell(Text(
                            lock.lockName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: themeProvider.textColor,
                            ),
                          )),
                          DataCell(Text(
                            lock.mm.toString(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: themeProvider.textColor,
                            ),
                          )),
                          DataCell(Text(
                            '₹${lock.unitPrice}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: themeProvider.textColor,
                            ),
                          )),
                          DataCell(Text(
                            lock.totalStock.toString(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: themeProvider.textColor,
                            ),
                          )),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: themeProvider.primaryColor,
                                  size: 18.sp,
                                ),
                                onPressed: () {
                                  _showEditDialog(lock);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 18.sp,
                                ),
                                onPressed: () {
                                  _deleteLock(lock);
                                },
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: themeProvider.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
