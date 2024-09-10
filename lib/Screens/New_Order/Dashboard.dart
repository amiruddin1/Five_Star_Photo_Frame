import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewOrderPage extends StatefulWidget {
  @override
  _NewOrderPageState createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
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

  // Variables for calculated fields
  double totalAmount = 0.0;
  double pendingAmount = 0.0;

  // Checkbox state
  bool _isFinalPriceChecked = true;

  @override
  void initState() {
    super.initState();
    // Initialize the finalPriceController with pendingAmount when the checkbox is checked
    finalPriceController.text = pendingAmount.toStringAsFixed(2);
    totalAmountController.text = totalAmount.toStringAsFixed(2); // Initialize total amount
  }

  // Function to calculate total amount
  void calculateTotalAmount() {
    // Assume a formula for total amount based on height and width
    double height = double.tryParse(heightController.text) ?? 0.0;
    double width = double.tryParse(widthController.text) ?? 0.0;

    // Simple formula example: total = (height * width) * a factor
    totalAmount = (height * width) * 10; // Replace '10' with the actual factor
    totalAmountController.text = totalAmount.toStringAsFixed(2); // Update total amount
    calculatePendingAmount();
  }

  // Function to calculate pending amount
  void calculatePendingAmount() {
    double advanceAmount = double.tryParse(advanceController.text) ?? 0.0;
    setState(() {
      pendingAmount = totalAmount - advanceAmount;
      // Update final price if the checkbox is checked
      if (_isFinalPriceChecked) {
        finalPriceController.text = pendingAmount.toStringAsFixed(2);
      }
    });
  }

  void _onSubmit() {
    // Handle the submit action
    print('Submit clicked');
  }

  void _onCancel() {
    // Handle the cancel action
    print('Cancel clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Order'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0.w), // Add padding around the ListView
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
            onChanged: _selectedOption == 'Only Glass' // Check if 'Only Glass' is selected
                ? null // Disable dropdown
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
          // Total amount field (dynamically updated)
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

          // Advance paid amount field
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

          // Pending amount label
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
                // If checked, set the final price to pending amount
                if (_isFinalPriceChecked) {
                  finalPriceController.text = pendingAmount.toStringAsFixed(2);
                } else {
                  finalPriceController.clear(); // Clear the field if unchecked
                }
              });
            },
          ),
          SizedBox(height: 16.h),

          // Final price field
          TextField(
            controller: finalPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Final Price',
              labelStyle: TextStyle(fontFamily: 'Poppins'),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            ),
            enabled: !_isFinalPriceChecked, // Disable editing when checkbox is checked
            onChanged: (value) {
              if (!_isFinalPriceChecked) {
                // Update the state only if the checkbox is not checked
                setState(() {
                  finalPriceController.text = value;
                });
              }
            },
          ),
          SizedBox(height: 16.h),

          // Buttons for submit and cancel
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _onSubmit,
                child: Text('Save this Product'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor, // Use the primary color
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
              ),
              OutlinedButton(
                onPressed: _onCancel,
                child: Text('Cancel'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
