import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Poppins',
          ),
          home: MultipleOrdersPage(),
        );
      },
    );
  }
}

class SingleOrderWidget extends StatefulWidget {
  final Function onRemove; // Callback to handle order removal

  SingleOrderWidget({required this.onRemove});

  @override
  _SingleOrderWidgetState createState() => _SingleOrderWidgetState();
}

class _SingleOrderWidgetState extends State<SingleOrderWidget> {
  // Variables for radio button
  String _selectedOption = 'Full Kit';

  // Variables for dropdown selection
  String _selectedFrame = '0.5 Inch Golden';

  // Variables for input fields
  TextEditingController heightController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController advanceController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController deliveryDateController = TextEditingController();
  TextEditingController finalPriceController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController quantityController = TextEditingController(text: '1'); // Default quantity to 1

  // Variables for calculated fields
  double totalAmount = 0.0;
  double pendingAmount = 0.0;

  // Checkbox state
  bool _isFinalPriceChecked = true;

  @override
  void initState() {
    super.initState();
    finalPriceController.text = pendingAmount.toStringAsFixed(2);
    totalAmountController.text = totalAmount.toStringAsFixed(2);
  }

  // Function to calculate total amount
  void calculateTotalAmount() {
    double height = double.tryParse(heightController.text) ?? 0.0;
    double width = double.tryParse(widthController.text) ?? 0.0;
    int quantity = int.tryParse(quantityController.text) ?? 1;

    totalAmount = (height * width) * 10 * quantity; // Replace '10' with actual factor
    totalAmountController.text = totalAmount.toStringAsFixed(2);
    calculatePendingAmount();
  }

  // Function to calculate pending amount
  void calculatePendingAmount() {
    double advanceAmount = double.tryParse(advanceController.text) ?? 0.0;
    setState(() {
      pendingAmount = totalAmount - advanceAmount;
      if (_isFinalPriceChecked) {
        finalPriceController.text = pendingAmount.toStringAsFixed(2);
      }
    });
  }

  void _onSubmit() {
    print('Submit clicked');
  }

  void _onCancel() {
    print('Cancel clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0.w),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio buttons for options
            Text(
              'Select Option',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Column(
              children: ['Full Kit', 'Only Frame', 'Frame with Glass', 'Only Glass']
                  .map((option) => RadioListTile<String>(
                title: Text(option, style: TextStyle(fontSize: 10.sp, fontFamily: 'Poppins')),
                value: option,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ))
                  .toList(),
            ),
            SizedBox(height: 16.h),

            // Dropdown for frame selection
            Text(
              'Select Frame',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            DropdownButton<String>(
              value: _selectedFrame,
              items: [
                '0.5 Inch Golden',
                '1 Inch Golden',
                '1.5 Inch Golden',
                '2 Inch Golden',
                '1 Inch Black',
                '2 Inch Black',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 10.sp, fontFamily: 'Poppins'),
                    ),
                  ),
                );
              }).toList(),
              onChanged: _selectedOption == 'Only Glass'
                  ? null
                  : (newValue) {
                setState(() {
                  _selectedFrame = newValue!;
                });
              },
            ),
            SizedBox(height: 16.h),

            // Measurement fields
            Text(
              'Measurements',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0.w),
                    child: TextField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Height (Inches)',
                        labelStyle: TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      ),
                      onChanged: (value) => calculateTotalAmount(),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0.w),
                    child: TextField(
                      controller: widthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Width (Inches)',
                        labelStyle: TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      ),
                      onChanged: (value) => calculateTotalAmount(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Quantity field
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                labelStyle: TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              ),
              onChanged: (value) => calculateTotalAmount(),
            ),
            SizedBox(height: 16.h),

            // Payment Fields
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'Payments',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            TextField(
              controller: totalAmountController,
              decoration: InputDecoration(
                labelText: 'Total Amount',
                labelStyle: TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              ),
              enabled: false,
            ),
            SizedBox(height: 16.h),

            TextField(
              controller: advanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Advance Amount',
                labelStyle: TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              ),
              onChanged: (value) => calculatePendingAmount(),
            ),
            SizedBox(height: 16.h),

            Text(
              'Pending Amount - \$${pendingAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 16.h),

            // Checkbox for final price
            CheckboxListTile(
              title: Text(
                'Is Final Price Same as Calculated Price \$${pendingAmount.toStringAsFixed(2)}',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              value: _isFinalPriceChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isFinalPriceChecked = value ?? true;
                  if (_isFinalPriceChecked) {
                    finalPriceController.text = pendingAmount.toStringAsFixed(2);
                  } else {
                    finalPriceController.clear();
                  }
                });
              },
            ),
            SizedBox(height: 16.h),

            TextField(
              controller: finalPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Final Price',
                labelStyle: TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              ),
              enabled: !_isFinalPriceChecked,
            ),
            SizedBox(height: 16.h),

            // Submit and Cancel buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _onSubmit,
                  child: Text('Submit', style: TextStyle(fontFamily: 'Poppins')),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  ),
                ),
                ElevatedButton(
                  onPressed: _onCancel,
                  child: Text('Cancel', style: TextStyle(fontFamily: 'Poppins')),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  ),
                ),
              ],
            ),

            // Remove button to delete this order widget
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => widget.onRemove(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultipleOrdersPage extends StatefulWidget {
  @override
  _MultipleOrdersPageState createState() => _MultipleOrdersPageState();
}

class _MultipleOrdersPageState extends State<MultipleOrdersPage> {
  List<Widget> _orders = [];

  @override
  void initState() {
    super.initState();
    _addOrder(); // Initialize with one order by default
  }

  void _addOrder() {
    setState(() {
      _orders.add(SingleOrderWidget(
        onRemove: () {
          setState(() {
            _orders.removeLast(); // Remove the last added order
          });
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple Orders'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0.w),
        children: [
          ..._orders,
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: _addOrder,
            child: Text('Add Another Order'),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }
}
