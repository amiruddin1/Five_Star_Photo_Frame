import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/Frame.dart';
import '../../models/theme_provider.dart';
import '../../models/DBHelper.dart'; // Ensure this import is correct

class ManageOrders extends StatefulWidget {
  @override
  _ManageOrdersState createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  late Future<List<Map<String, dynamic>>> _ordersFuture;
  final ScrollController _scrollController = ScrollController(); // ScrollController added

  @override
  void initState() {
    super.initState();
    _ordersFuture =
        DBHelperClass.instance.getAllRecords(DBHelperClass.TBLOrders);
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  void _showEditStatusDialog(BuildContext context, int orderId, String? currentStatus) {
    String dropdownValue = (currentStatus == null || currentStatus.toLowerCase() != 'ready') ? 'Pending' : 'Ready';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Update Status'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: dropdownValue,
                    items: ['Ready', 'Pending'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          dropdownValue = newValue; // Use setState to update the dropdown value
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Update Status'),
                  onPressed: () async {
                    // Call the update method and close the dialog
                    await _updateOrderStatus(orderId, dropdownValue);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }


  Future<void> _updateOrderStatus(int orderId, String newStatus) async {
    final row = {'Status': newStatus}; // Update status data
    int updated = await DBHelperClass.instance.updateRecord(
        DBHelperClass.TBLOrders, row, 'Order_Id', orderId);

    if (updated > 0) {
      setState(() {
        _ordersFuture = DBHelperClass.instance.getAllRecords(DBHelperClass.TBLOrders); // Refresh orders
      });
    } else {
      print('Failed to update status');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.primaryColor,
        title: Text(
          'User Orders',
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
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Orders available.'));
            }

            final orders = snapshot.data!;

            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Center(
                    child: Text(
                      "User orders",
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
                    child: Scrollbar(
                      controller: _scrollController,
                      // Attach the controller here
                      thumbVisibility: true,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          // Attach the same controller here
                          scrollDirection: Axis.horizontal,
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
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
                                        'Frame',
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
                                        'Type',
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
                                        'W',
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
                                        'H',
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
                                        'Qty',
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
                                        'Paid',
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
                                        'Status',
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
                                rows: orders.map((order) {
                                  // Determine the value for the 'Frame' column based on the condition
                                  final frameValue = (order['ServiceType'] == "Only Glass" || order['ServiceType'] == "Plastic Lamination") ? 'N/A' : order['FrameIdFK'].toString();

                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Center(
                                          child: Text(
                                            frameValue,
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
                                            order['ServiceType'],
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
                                            order['Width'].toString(),
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
                                            '${order['Height']}',
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
                                            order['FinalPrice'].toString(),
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
                                            order['Quantity'].toString(),
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
                                            order['AdvancePrice'].toString(),
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
                                            (order['Status'] == null || order['Status'].toString().toLowerCase() != 'ready')
                                                ? 'Pending'
                                                : 'Completed',
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
                                              onPressed: () {
                                                _showEditStatusDialog(context, order['Order_Id'], order['Status']);
                                              },
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
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
