
import 'package:flutter/material.dart';
import 'package:recordings1/features/employee/screens/employee_tab.dart';
import 'package:recordings1/features/recordings/screens/recording_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF113C6D),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Handle menu tap
          },
        ),
        title: const Text(
          'My Recorder',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Material(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF113C6D),
              indicatorWeight: 3,
              labelColor: const Color(0xFF113C6D),
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'RECORDING'),
                Tab(text: 'EMPLOYEE'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                RecordingTab(),
                EmployeeTab(),
              ],
            ),
          ),
        ],
      ),

    );
  }
}

