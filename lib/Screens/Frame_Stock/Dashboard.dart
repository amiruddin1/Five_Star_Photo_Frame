import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/Frame.dart';
import '../../models/theme_provider.dart';

class FrameStockPage extends StatefulWidget {
  @override
  _FrameStockPageState createState() => _FrameStockPageState();
}

class _FrameStockPageState extends State<FrameStockPage> {
  List<Frame> frames = List.generate(10, (index) {
    return Frame(
      FrameID: index + 1,
      FramePetName: 'Frame ${index + 1}',
      FrameActualName: 'Actual Name ${index + 1}',
      unitPrice: 50 + (index * 10),
      size: 20.0 + (index * 2),
      totalStock: 100 - (index * 5),
    );
  });

  void _showEditDialog(Frame frame) {
    final petNameController = TextEditingController(text: frame.FramePetName);
    final actualNameController =
        TextEditingController(text: frame.FrameActualName);
    final sizeController = TextEditingController(text: frame.size.toString());
    final priceController =
        TextEditingController(text: frame.unitPrice.toString());
    final stockController =
        TextEditingController(text: frame.totalStock.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Frame ${frame.FrameID}'),
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  frame.FramePetName = petNameController.text;
                  frame.FrameActualName = actualNameController.text;
                  frame.size = double.parse(sizeController.text);
                  frame.unitPrice = int.parse(priceController.text);
                  frame.totalStock = int.parse(stockController.text);
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
            fontFamily: 'poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Center(
            child: Text(
              "Price List of Frame",
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
                          'Edit',
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
                              frame.FramePetName,
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
                              frame.size.toString(),
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
                              '₹${frame.unitPrice}',
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
                              frame.totalStock.toString(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: themeProvider.textColor,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: themeProvider.primaryColor,
                                size: 18.sp,
                              ),
                              onPressed: () {
                                _showEditDialog(frame);
                              },
                            ),
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
      ]),
    );
  }
}
