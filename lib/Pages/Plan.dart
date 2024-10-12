import 'package:flutter/material.dart';
import 'package:travel_app/Pages/TripDetailsPage.dart';

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  String? _selectedDestination; // Variable to hold the selected dropdown value
  String? _selectedGroupSize; // Variable to hold the selected group size value
  DateTimeRange? _selectedDateRange; // Variable to hold the selected date range

  bool _isDestinationError = false; // Flag for destination validation
  bool _isGroupSizeError = false; // Flag for group size validation
  bool _isDateRangeError = false; // Flag for date range validation

  final List<String> _destinations = ['Kandy', 'Jaffna', 'Colombo', 'Galle']; // Dropdown options
  final List<String> _groupSizes = [
    'Single (01 Person)',
    'Couple (02 Persons)',
    'Family (04 Persons)',
    'Group (10 Persons)'
  ]; // Group size options

  // Method to show the date range picker
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(Duration(days: 7)), // Default end date is one week later
      ),
      firstDate: DateTime(2000), // Set the earliest date
      lastDate: DateTime(2101), // Set the latest date
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked; // This updates the selected date range
      });
    }
  }


  // Validate inputs
  bool _validateInputs() {
    setState(() {
      _isDestinationError = _selectedDestination == null;
      _isGroupSizeError = _selectedGroupSize == null;
      _isDateRangeError = _selectedDateRange == null;
    });

    // Return true if all fields are selected
    return !_isDestinationError && !_isGroupSizeError && !_isDateRangeError;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Center(
                  child: Text(
                    'Plan Your Next Journey',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Where do you want to go?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isDestinationError ? Colors.red : Colors.green,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedDestination,
                    hint: Text('Select a destination'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDestination = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    items: _destinations.map((String destination) {
                      return DropdownMenuItem<String>(
                        value: destination,
                        child: Text(destination),
                      );
                    }).toList(),
                  ),
                ),
                if (_isDestinationError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Destination is required',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                SizedBox(height: 40),

                Text(
                  'How many people are going?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 15,
                  children: _groupSizes.map((groupSize) {
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 42) / 2,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGroupSize = groupSize;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xff1a5317),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: _selectedGroupSize == groupSize ? Colors.green[100] : Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              groupSize,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: _selectedGroupSize == groupSize ? Colors.green : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (_isGroupSizeError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Group size is required',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                SizedBox(height: 40),

                Text(
                  'When do you want to go?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),

                GestureDetector(
                  onTap: () => _selectDateRange(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _isDateRangeError ? Colors.red : Colors.green,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDateRange == null
                              ? 'Select a date range'
                              : 'Selected: ${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month}/${_selectedDateRange!.start.year} to ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}/${_selectedDateRange!.end.year}',
                          style: TextStyle(
                            fontSize: 16,
                            color: _selectedDateRange == null ? Colors.grey : Colors.black,
                          ),
                        ),
                        Icon(Icons.calendar_today, color: Color(0xff1a5317)),
                      ],
                    ),
                  ),
                ),
                if (_isDateRangeError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Date range is required',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                SizedBox(height: 40),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_validateInputs()) {
                        // Navigate to TripDetailsPage with selected data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripDetailsPage(
                              selectedDestination: _selectedDestination,
                              selectedGroupSize: _selectedGroupSize,
                              selectedDateRange: _selectedDateRange, // Pass the selected date range
                            ),
                          ),
                        );
                      } else {
                        print('Required fields are missing.');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff1a5317),
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Create New Trip',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
