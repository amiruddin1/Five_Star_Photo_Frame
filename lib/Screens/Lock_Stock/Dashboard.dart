import 'package:five_star_photo_framing/models/DBHelper.dart';
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
  List<Lock> locks = [];

  @override
  void initState() {
    super.initState();
    _loadLocks();
  }

  Future<void> _loadLocks() async {
    List<Map<String, dynamic>> locksFromDb = await DBHelperClass.instance.getAllRecords(DBHelperClass.TBLLock);
    setState(() {
      locks = locksFromDb.map((lock) {
        return Lock(
          LockId: lock[DBHelperClass.LockId],
          LockName: lock[DBHelperClass.LockName],
          UnitPrice: lock[DBHelperClass.LockUnitPrice],
          MM: lock[DBHelperClass.LockMM],
          TotalStock: lock[DBHelperClass.LockTotalStock],
        );
      }).toList();
    });
  }

  void _showEditDialog(Lock lock) {
    final nameController = TextEditingController(text: lock.LockName);
    final mmController = TextEditingController(text: lock.MM.toString());
    final priceController = TextEditingController(text: lock.UnitPrice.toString());
    final stockController = TextEditingController(text: lock.TotalStock.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Lock ${lock.LockId}'),
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
              onPressed: () async {
                await DBHelperClass.instance.updateRecord(
                  DBHelperClass.TBLLock,
                  {
                    DBHelperClass.LockName: nameController.text,
                    DBHelperClass.LockMM: int.parse(mmController.text),
                    DBHelperClass.LockUnitPrice: int.parse(priceController.text),
                    DBHelperClass.LockTotalStock: int.parse(stockController.text),
                  },
                  DBHelperClass.LockId,
                  lock.LockId,
                );
                _loadLocks();  // Reload and refresh the list
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
              onPressed: () async {
                await DBHelperClass.instance.insertRecord(
                  DBHelperClass.TBLLock,
                  {
                    DBHelperClass.LockName: nameController.text,
                    DBHelperClass.LockMM: int.parse(mmController.text),
                    DBHelperClass.LockUnitPrice: int.parse(priceController.text),
                    DBHelperClass.LockTotalStock: int.parse(stockController.text),
                  },
                );
                _loadLocks();  // Reload and refresh the list
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

  void _deleteLock(Lock lock) async {
    await DBHelperClass.instance.deleteRecord(
      DBHelperClass.TBLLock,
      DBHelperClass.LockId,
      lock.LockId,
    );
    _loadLocks();  // Reload and refresh the list
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
        child: Padding(
          padding: EdgeInsets.only(bottom: 80.h),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
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
                                lock.LockId.toString(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: themeProvider.textColor,
                                ),
                              )),
                              DataCell(Text(
                                lock.LockName,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: themeProvider.textColor,
                                ),
                              )),
                              DataCell(Text(
                                lock.MM.toString(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: themeProvider.textColor,
                                ),
                              )),
                              DataCell(Text(
                                '₹${lock.UnitPrice}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: themeProvider.textColor,
                                ),
                              )),
                              DataCell(Text(
                                lock.TotalStock.toString(),
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
              ),
            ],
          ),
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
