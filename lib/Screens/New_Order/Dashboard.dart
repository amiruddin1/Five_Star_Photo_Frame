import 'package:five_star_photo_framing/models/DBHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/theme_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.primaryColor,
        title: Text(
          'Add Order',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: themeProvider.textColor,
            fontFamily: 'poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleOrderWidget(
            onRemove: () {},
            onFinalPriceChanged: (double price) {},
      ),
    );
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
  String? _selectedFrame;

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
  List<String> _frameOptions = [];

  bool _isDropdownEnabled = true;

  List<Widget> priceWidgets = [];

  @override
  void initState() {
    super.initState();
    _loadFrames();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_frameOptions.isNotEmpty) {
        setState(() {
          _selectedFrame = _frameOptions.first;
          finalPriceController.text = pendingAmount.toStringAsFixed(2);
          widget.onFinalPriceChanged(double.tryParse(finalPriceController.text) ?? 0.0);
        });
      }
    });
  }

  Future<void> _loadFrames() async {
    List<Map<String, dynamic>> frameRecords = await DBHelperClass.instance.getAllRecords(DBHelperClass.TBLFrame);

    List<String> frames = frameRecords.map((record) {
      return record[DBHelperClass.FrameSize] as String;
    }).toList();

    setState(() {
      _frameOptions = frames;
      if (_frameOptions.isNotEmpty) {
        _selectedFrame = _frameOptions.first;
      }
    });
  }

  void _updateFinalPrice(double price) {
    widget.onFinalPriceChanged(price);
  }

  void calculateTotalAmount() {
    priceWidgets.clear();
    double height = double.tryParse(heightController.text) ?? 0.0;
    double width = double.tryParse(widthController.text) ?? 0.0;
    int quantity = int.tryParse(quantityController.text) ?? 1;

    setState(() {
      double intermediateValue = (height * width) / 144;
      intermediateValue = double.parse(intermediateValue.toStringAsFixed(2));

      if (_selectedOption == 'Only Glass') {
        totalAmount = intermediateValue * 30 * quantity;
        priceWidgets.add(
          Text(
            'Total : ₹${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (_selectedOption == 'Plastic Lamination') {
        totalAmount = intermediateValue * 120 * quantity;
        priceWidgets.add(
          Text(
            'Total : ₹${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (_selectedOption == 'Only Frame') {
        if(_selectedFrame =="0.5"){
          totalAmount = intermediateValue * (7*7) * quantity;
          priceWidgets.add(
            Text(
              'Total : ₹${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }else if(_selectedFrame =="1.0"){
          totalAmount = intermediateValue * (9*9) * quantity;
          priceWidgets.add(
            Text(
              'Total : ₹${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if(_selectedFrame =="1.5"){
          totalAmount = intermediateValue * (12*12) * quantity;
          priceWidgets.add(
            Text(
              'Total : ₹${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else{
          totalAmount = intermediateValue * (14*14) * quantity;
          priceWidgets.add(
            Text(
              'Total : ₹${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      } else if (_selectedOption == 'Frame with Glass') {
        if(_selectedFrame =="0.5"){
          totalAmount = (intermediateValue * 30 * quantity) + (intermediateValue * (7*7) * quantity);
          priceWidgets.add(
            Text(
              'Glass : ₹${(intermediateValue * 30 * quantity).toStringAsFixed(2)}', // Price of glass
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
          priceWidgets.add(
            Text(
              'Frame : ₹${(intermediateValue * (7*7) * quantity).toStringAsFixed(2)}', // Price of frame
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }else if(_selectedFrame =="1.0"){
          totalAmount = (intermediateValue * 30 * quantity) + (intermediateValue * (9*9) * quantity);
          priceWidgets.add(
            Text(
              'Glass : ₹${(intermediateValue * 30 * quantity).toStringAsFixed(2)}', // Price of glass
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
          priceWidgets.add(
            Text(
              'Frame : ₹${(intermediateValue * (9*9) * quantity).toStringAsFixed(2)}', // Price of frame
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if(_selectedFrame =="1.5"){
          totalAmount = (intermediateValue * 30 * quantity) + (intermediateValue * (12*12) * quantity);
          priceWidgets.add(
            Text(
              'Glass : ₹${(intermediateValue * 30 * quantity).toStringAsFixed(2)}', // Price of glass
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
          priceWidgets.add(
            Text(
              'Frame : ₹${(intermediateValue * (12*12) * quantity).toStringAsFixed(2)}', // Price of frame
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else{
          totalAmount = (intermediateValue * 30 * quantity) + (intermediateValue * (14*14) * quantity);
          priceWidgets.add(
            Text(
              'Glass : ₹${(intermediateValue * 30 * quantity).toStringAsFixed(2)}', // Price of glass
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
          priceWidgets.add(
            Text(
              'Frame : ₹${(intermediateValue * (14*14) * quantity).toStringAsFixed(2)}', // Price of frame
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      } else if (_selectedOption == 'Full Kit') {
        if(_selectedFrame =="0.5"){
          totalAmount = (intermediateValue * 30 * quantity) + (intermediateValue * (7*7) * quantity) + (intermediateValue * (6.5*6.5) * quantity);
          priceWidgets.add(
            Text(
              'Glass : ₹${(intermediateValue * 30 * quantity).toStringAsFixed(2)}', // Price of glass
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
          priceWidgets.add(
            Text(
              'Frame : ₹${(intermediateValue * (7*7) * quantity).toStringAsFixed(2)}', // Price of frame
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
          priceWidgets.add(
            Text(
              'Board : ₹${(intermediateValue * (6.5*6.5) * quantity).toStringAsFixed(2)}', // Extra frame cost
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }else if(_selectedFrame =="1.0"){
          totalAmount = (intermediateValue * 30 * quantity) + (intermediateValue * (9*9) * quantity)+ (intermediateValue * (6.5*6.5) * quantity);
          priceWidgets.add(
            Text(
              'Glass : ₹${(intermediateValue * 30 * quantity).toStringAsFixed(2)}', // Price of glass
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
          priceWidgets.add(
            Text(
              'Frame : ₹${(intermediateValue * (9*9) * quantity).toStringAsFixed(2)}', // Price of frame
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
          priceWidgets.add(
            Text(
              'Board : ₹${(intermediateValue * (6.5*6.5) * quantity).toStringAsFixed(2)}', // Extra frame cost
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if(_selectedFrame =="1.5"){
          totalAmount = (intermediateValue * 30 * quantity) + (intermediateValue * (12*12) * quantity)+ (intermediateValue * (6.5*6.5) * quantity);
          priceWidgets.add(
            Text(
              'Glass : ₹${(intermediateValue * 30 * quantity).toStringAsFixed(2)}', // Price of glass
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
          priceWidgets.add(
            Text(
              'Frame : ₹${(intermediateValue * (12*12) * quantity).toStringAsFixed(2)}', // Price of frame
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
          priceWidgets.add(
            Text(
              'Board : ₹${(intermediateValue * (6.5*6.5) * quantity).toStringAsFixed(2)}', // Extra frame cost
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else{
          totalAmount = (intermediateValue * 30 * quantity) + (intermediateValue * (14*14) * quantity)+ (intermediateValue * (6.5*6.5) * quantity);
          priceWidgets.add(
            Text(
              'Glass : ₹${(intermediateValue * 30 * quantity).toStringAsFixed(2)}', // Price of glass
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
          priceWidgets.add(
            Text(
              'Frame : ₹${(intermediateValue * (14*14) * quantity).toStringAsFixed(2)}', // Price of frame
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
          priceWidgets.add(
            Text(
              'Board : ₹${(intermediateValue * (6.5*6.5) * quantity).toStringAsFixed(2)}', // Extra frame cost
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      }

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
    return ListView(
      children:[
        Card(
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
                        _isDropdownEnabled = !['Only Glass', 'Plastic Lamination'].contains(_selectedOption);
                        calculateTotalAmount();
                      });
                    },
                  ))
                      .toList(),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Select Frame Size',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedFrame,
                  items: _frameOptions.map((String value) {
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
                  onChanged: _isDropdownEnabled ? (String? newValue) {
                    setState(() {
                      _selectedFrame = newValue;
                      calculateTotalAmount();
                    });
                  } : null,
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: heightController,
                  decoration: InputDecoration(
                    labelText: 'Height (inches)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => calculateTotalAmount(),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: widthController,
                  decoration: InputDecoration(
                    labelText: 'Width (inches)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => calculateTotalAmount(),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => calculateTotalAmount(),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: advanceController,
                  decoration: InputDecoration(
                    labelText: 'Advance Amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => calculatePendingAmount(),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: finalPriceController,
                  decoration: InputDecoration(
                    labelText: 'Final Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  readOnly: true,
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: totalAmountController,
                  decoration: InputDecoration(
                    labelText: 'Total Amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  readOnly: true,
                ),
                SizedBox(height: 16.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...priceWidgets, // Display the dynamically generated Text widgets
                    SizedBox(height: 16.h),
                    // Your other components (TextFields, Dropdowns, etc.)
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        widget.onRemove();
                      },
                      child: Text('Remove'),
                    ),
                    SizedBox(width: 16.w),
                    ElevatedButton(
                      onPressed: () {
                        // Handle save or submit action here
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }
}
