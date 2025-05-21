
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recordings1/features/employee/models/employee.dart';
import 'package:recordings1/core/utils/constants.dart';

class EmployeeTab extends StatefulWidget {
  const EmployeeTab({super.key});

  @override
  State<EmployeeTab> createState() => _EmployeeTabState();
}

class _EmployeeTabState extends State<EmployeeTab> {
  List<Employee> employees = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  int page = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchEmployees();
      }
    });
  }

  Future<void> _fetchEmployees() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl?results=20&page=$page'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API Response: $data'); // Debug print to verify the response
        final List<dynamic> results = data['results'];
        setState(() {
          employees.addAll(results.map((e) => Employee.fromJson(e)).toList());
          page++;
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          errorMessage = 'Failed to load employees';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  // Helper function to darken a color
  Color _darkenColor(Color color, [double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);
    final red = (color.red * (1 - amount)).round().clamp(0, 255);
    final green = (color.green * (1 - amount)).round().clamp(0, 255);
    final blue = (color.blue * (1 - amount)).round().clamp(0, 255);
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: hasError
          ? Center(child: Text(errorMessage))
          : employees.isEmpty && isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        controller: _scrollController,
        itemCount: employees.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == employees.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final employee = employees[index];
          final cardColor = _getPastelColor(index);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Stack(
              clipBehavior: Clip.none, // Allow the avatar to overflow the card
              children: [
                // Card with employee details
                Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: _darkenColor(cardColor),
                      width: 1.5,
                    ),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 180, // Fixed height for uniformity
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          // Left side: Employee details
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Employee name
                                Text(
                                  employee.fullName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10), // Increased spacing for uniformity
                                // Email
                                Text(
                                  employee.email ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10), // Increased spacing for uniformity
                                // Date of Birth
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Date of Birth',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    // const SizedBox(width: 108),
                                    Text(
                                      employee.dobDate,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff113C6D),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10), // Increased spacing for uniformity
                                // Registered on
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Registered on',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    // const SizedBox(width: 8),
                                    Text(
                                      employee.registeredDate,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff113C6D),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10), // Increased spacing for uniformity
                                // Phone number
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Phone No.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    // const SizedBox(width: 8),
                                    Text(
                                      employee.phone ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff113C6D),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10), // Increased spacing for uniformity
                                // Gender
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Gender',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    // const SizedBox(width: 8),
                                    Row(
                                      children: [
                                        if (employee.gender != null) ...[
                                          const SizedBox(width: 4),
                                          Icon(
                                            employee.gender == Gender.FEMALE ? Icons.female : Icons.male,
                                            size: 16,
                                            color: Color(0xff113C6D),
                                          ),
                                        Text(
                                          employee.genderString,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff113C6D),
                                          ),
                                        ),

                                        ],
                                      ],
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Add an empty space to the right to prevent text from overlapping with the avatar
                          // const SizedBox(width: 80), // Matches the avatar's diameter (radius * 2)
                        ],
                      ),
                    ),
                  ),
                ),
                // Positioned CircleAvatar to overlap the right border of the card
                Positioned(
                  right: 30,
                  top: -20, // Adjust to vertically center the avatar (height/2 - radius)
                  child: CircleAvatar(
                    radius: 30, // Same radius as before
                    backgroundImage: NetworkImage(employee.pictureUrl),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper function to assign pastel colors to cards
  Color _getPastelColor(int index) {
    const pastelColors = [
      Color(0xFFFFE6E6), // Light Pink
      Color(0xFFE6E6FF), // Light Purple
      Color(0xFFFFE6F0), // Light Red
      Color(0xFFE6FFE6), // Light Green
      Color(0xFFE6F0FF), // Light Blue
      Color(0xFFFFF0E6), // Light Orange
    ];
    return pastelColors[index % pastelColors.length];
  }
}

