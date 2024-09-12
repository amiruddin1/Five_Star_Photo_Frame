import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/DBHelper.dart';
import '../../models/theme_provider.dart';

class PhotosPage extends StatefulWidget {
  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  List<Map<String, dynamic>> _photos = [];
  List<Map<String, dynamic>> _gods = [];
  final DBHelperClass _dbHelper = DBHelperClass.instance;

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
    _fetchGods();
  }

  Future<void> _fetchPhotos() async {
    List<Map<String, dynamic>> photos = await _dbHelper.getAllRecords(DBHelperClass.TBLPhotos);
    setState(() {
      _photos = photos;
    });
  }

  Future<void> _fetchGods() async {
    List<Map<String, dynamic>> gods = await _dbHelper.getAllRecords(DBHelperClass.TBLGod);
    setState(() {
      _gods = gods;
    });
  }

  String _getGodNameById(int godId) {
    return _gods.firstWhere(
          (god) => god[DBHelperClass.GodId] == godId,
      orElse: () => {DBHelperClass.GodName: 'Unknown'},  // Fallback if not found
    )[DBHelperClass.GodName];
  }

  void _showAddPhotoDialog() {
    String selectedGod = "";
    String size = "4x6"; // Default value
    int stock = 0;
    int price = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Photo'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    isExpanded: true,
                    value: size,
                    items: <String>['4x6', '5x7', '9x12', '12x16', '16x24'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        size = value ?? "4x6";
                      });
                    },
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedGod.isNotEmpty ? selectedGod : null,
                    hint: Text('Select God'),
                    items: _gods.map((god) {
                      return DropdownMenuItem<String>(
                        value: god[DBHelperClass.GodId].toString(),
                        child: Text(god[DBHelperClass.GodName]),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGod = value ?? "";
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Number of Stock'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => stock = int.tryParse(value) ?? 0,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => price = int.tryParse(value) ?? 0,
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedGod.isNotEmpty && size.isNotEmpty && stock > 0 && price > 0) {
                  await _dbHelper.insertRecord(DBHelperClass.TBLPhotos, {
                    DBHelperClass.PhotoGodId: int.parse(selectedGod),
                    DBHelperClass.PhotoSize: size,
                    DBHelperClass.PhotoTotalStock: stock,
                    DBHelperClass.PhotoUnitPrice: price,
                  });
                  Navigator.of(context).pop();
                  _fetchPhotos();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditPhotoDialog(Map<String, dynamic> photo) {
    String selectedGod = photo[DBHelperClass.PhotoGodId].toString();
    String size = photo[DBHelperClass.PhotoSize];
    int stock = photo[DBHelperClass.PhotoTotalStock];
    int price = photo[DBHelperClass.PhotoUnitPrice];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Photo'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    isExpanded: true,
                    value: size,
                    items: <String>['4x6', '9x12', '5x7', '12x16', '16x24'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        size = value ?? "4x6";
                      });
                    },
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedGod,
                    hint: Text('Select God'),
                    items: _gods.map((god) {
                      return DropdownMenuItem<String>(
                        value: god[DBHelperClass.GodId].toString(),
                        child: Text(god[DBHelperClass.GodName]),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGod = value ?? "";
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Number of Stock'),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: stock.toString()),
                    onChanged: (value) => stock = int.tryParse(value) ?? 0,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: price.toString()),
                    onChanged: (value) => price = int.tryParse(value) ?? 0,
                  ),
                ],
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (selectedGod.isNotEmpty && size.isNotEmpty && stock > 0 && price > 0) {
                      await _dbHelper.updateRecord(
                        DBHelperClass.TBLPhotos,
                        {
                          DBHelperClass.PhotoGodId: int.parse(selectedGod),
                          DBHelperClass.PhotoSize: size,
                          DBHelperClass.PhotoTotalStock: stock,
                          DBHelperClass.PhotoUnitPrice: price,
                        },
                        DBHelperClass.PhotoId,
                        photo[DBHelperClass.PhotoId],
                      );
                      Navigator.of(context).pop();
                      _fetchPhotos();
                    }
                  },
                  child: Text('Update'),
                ),
                TextButton(
                  onPressed: () async {
                    await _dbHelper.deleteRecord(
                      DBHelperClass.TBLPhotos,
                      DBHelperClass.PhotoId, // columnId
                      photo[DBHelperClass.PhotoId], // id
                    );
                    Navigator.of(context).pop();
                    _fetchPhotos();
                  },
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
              ],
            )
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
          'Photos',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: themeProvider.textColor,
            fontFamily: 'Poppins',
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
                    "Price List of Photos",
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
                              'Size',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.textColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'God Name',
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
                              'Actions',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.textColor,
                              ),
                            ),
                          ),
                        ],
                        rows: _photos.map((photo) {
                          return DataRow(
                            cells: [
                              DataCell(Text(
                                photo[DBHelperClass.PhotoSize],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: themeProvider.textColor,
                                ),
                              )),
                              DataCell(Text(
                                _getGodNameById(photo[DBHelperClass.PhotoGodId]),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: themeProvider.textColor,
                                ),
                              )),
                              DataCell(Text(
                                photo[DBHelperClass.PhotoTotalStock].toString(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: themeProvider.textColor,
                                ),
                              )),
                              DataCell(Text(
                                '₹${photo[DBHelperClass.PhotoUnitPrice]}',
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
                                      _showEditPhotoDialog(photo);
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
        onPressed: _showAddPhotoDialog,
        backgroundColor: themeProvider.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
