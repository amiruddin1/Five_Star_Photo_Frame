import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultipleOrdersPage();
  }
}
class SingleOrderWidget extends StatefulWidget {
  final Function onRemove;
  final Function(double) onFinalPriceChanged;

  SingleOrderWidget({required this.onRemove, required this.onFinalPriceChanged});

  @override
  _SingleOrderWidgetState createState() => _SingleOrderWidgetState();
}

class _SingleOrderWidgetState extends State<SingleOrderWidget> {
  String _selectedOption = 'Full Kit';
  String _selectedFrame = '0.5 Inch Golden';

  TextEditingController heightController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController advanceController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController deliveryDateController = TextEditingController();
  TextEditingController finalPriceController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController quantityController = TextEditingController(text: '1');

  double totalAmount = 0.0;
  double pendingAmount = 0.0;

  bool _isFinalPriceChecked = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      finalPriceController.text = pendingAmount.toStringAsFixed(2);
      widget.onFinalPriceChanged(double.tryParse(finalPriceController.text) ?? 0.0);
    });
  }

  void _updateFinalPrice(double price) {
    widget.onFinalPriceChanged(price);
  }

  void calculateTotalAmount() {
    double height = double.tryParse(heightController.text) ?? 0.0;
    double width = double.tryParse(widthController.text) ?? 0.0;
    int quantity = int.tryParse(quantityController.text) ?? 1;

    setState(() {
      totalAmount = (height * width) * 10 * quantity;
      totalAmountController.text = totalAmount.toStringAsFixed(2);
      calculatePendingAmount();
    });
  }

  void calculatePendingAmount() {
    double advanceAmount = double.tryParse(advanceController.text) ?? 0.0;
    setState(() {
      pendingAmount = totalAmount - advanceAmount;
      if (_isFinalPriceChecked) {
        finalPriceController.text = pendingAmount.toStringAsFixed(2);
        _updateFinalPrice(pendingAmount);
      }
    });
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
            Text(
              'Select Option',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Column(
              children: ['Full Kit', 'Only Frame', 'Frame with Glass', 'Only Glass', 'Plastic Lamination']
                  .map((option) => RadioListTile<String>(
                title: Text(option, style: TextStyle(fontSize: 10.sp, fontFamily: 'Poppins')),
                value: option,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                    if (_selectedOption == 'Only Glass') {
                      _selectedFrame = '0.5 Inch Golden';
                    }
                  });
                },
              ))
                  .toList(),
            ),
            SizedBox(height: 16.h),
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
              onChanged: (_selectedOption == 'Only Glass' || _selectedOption == 'Plastic Lamination')
                  ? null
                  : (newValue) {
                setState(() {
                  _selectedFrame = newValue!;
                });
              },
            ),

            SizedBox(height: 16.h),
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
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.sp, // Adjust this value to make the font smaller or larger
                        ),
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
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.sp, // Adjust this value to make the font smaller or larger
                        ),
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
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.sp, // Adjust this value to make the font smaller or larger
                ),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              ),
              onChanged: (value) => calculatePendingAmount(),
            ),
            SizedBox(height: 16.h),
            CheckboxListTile(
              title: Text('Final Price Same as Pending Amount', style: TextStyle(fontFamily: 'Poppins')),
              value: _isFinalPriceChecked,
              onChanged: (value) {
                setState(() {
                  _isFinalPriceChecked = value!;
                  if (_isFinalPriceChecked) {
                    finalPriceController.text = pendingAmount.toStringAsFixed(2);
                  } else {
                    finalPriceController.clear();
                  }
                  _updateFinalPrice(double.tryParse(finalPriceController.text) ?? 0.0);
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
              onChanged: (value) {
                double finalPrice = double.tryParse(value) ?? 0.0;
                _updateFinalPrice(finalPrice);
              },
            ),
            SizedBox(height: 16.h),
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
  List<SingleOrderWidget> _orders = [];
  List<double> _finalPrices = [];

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
            int index = _orders.indexOf(_orders.last);
            if (index >= 0) {
              _orders.removeAt(index); // Remove the last added order
              _finalPrices.removeAt(index); // Remove the last final price
            }
          });
        },
        onFinalPriceChanged: (price) {
          int index = _orders.indexOf(_orders.last);
          if (index >= 0) {
            if (index < _finalPrices.length) {
              _finalPrices[index] = price;
            } else {
              _finalPrices.add(price);
            }
            setState(() {}); // Trigger rebuild to update grand total
          }
        },
      ));
    });
  }

  double get _grandTotal {
    return _finalPrices.fold(0.0, (sum, price) => sum + price);
  }

  void _onSubmit() {
    // Handle submit logic here
    print('Submit clicked');
  }

  void _onCancel() {
    // Handle cancel logic here
    print('Cancel clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple Orders'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0.w),
              children: [
                ..._orders,
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: Text(
                    'Grand Total: ₹${_grandTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: _addOrder,
                  child: Text('Add Another Order'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _onSubmit,
                        child: Text('Submit', style: TextStyle(fontFamily: 'Poppins')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _onCancel,
                        child: Text('Cancel', style: TextStyle(fontFamily: 'Poppins')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
