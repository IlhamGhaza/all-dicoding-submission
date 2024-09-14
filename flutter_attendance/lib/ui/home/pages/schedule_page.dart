import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime selectedDate = DateTime.now();
  bool isDetailVisible = false;
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDateSelector(),
            _buildAttendanceSummary(),
            if (isDetailVisible) _buildScheduleDetails(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    final daysOfWeek = [
      'Jum\'at',
      'Sabtu',
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis'
    ];
    final currentWeekDay = DateTime.now().weekday;
    final firstDayOfWeek =
        DateTime.now().subtract(Duration(days: currentWeekDay % 7));

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(7, (index) {
          final date = firstDayOfWeek.add(Duration(days: index));
          final isSelected = date.day == selectedDate.day;
          return GestureDetector(
            onTap: () => setState(() => selectedDate = date),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    daysOfWeek[date.weekday % 7],
                    style: TextStyle(
                      color: isSelected ? Colors.blue : Colors.grey,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAttendanceSummary() {
    return GestureDetector(
      onTap: () => setState(() => isDetailVisible = !isDetailVisible),
      child: const Card(
        margin: EdgeInsets.all(16),
        color: Colors.blue,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jadwal Kerja',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.work, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Shift Pagi',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '08:00 - 17:00',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '4 Maret 2024',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleDetails() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.blue[300],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Jadwal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Shift',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 16),
                Text(
                  'Pagi',
                  style: TextStyle(color: Colors.green[200]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Jam Masuk',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 16),
                Text(
                  '08:00',
                  style: TextStyle(color: Colors.green[200]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Jam Pulang',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 16),
                Text(
                  '17:00',
                  style: TextStyle(color: Colors.green[200]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add schedule edit functionality here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[100],
              ),
              child: const Text('Edit Jadwal',
                  style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
