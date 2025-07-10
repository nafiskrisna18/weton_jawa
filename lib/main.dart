import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: KalenderJawaPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class KalenderJawaPage extends StatefulWidget {
  const KalenderJawaPage({super.key});

  @override
  State<KalenderJawaPage> createState() => _KalenderJawaPageState();
}


class _KalenderJawaPageState extends State<KalenderJawaPage> {
  DateTime _selectedDate = DateTime.now();
  String? _wetonResult;
  DateTime _displayedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  static const List<String> hariPasaran = [
    'Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'
  ];
  static const List<String> hariJawa = [
    'Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'
  ];

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _wetonResult = _hitungWeton(picked);
        _displayedMonth = DateTime(picked.year, picked.month);
      });
    }
  }

  String _hitungWeton(DateTime date) {
    // Algoritma sederhana: patokan 1 Januari 1900 = Senin Legi
    final baseDate = DateTime(1900, 1, 1);
    final diff = date.difference(baseDate).inDays;
    final hariIndex = (diff + 1) % 7; // +1 karena 1 Jan 1900 = Senin
    final pasaranIndex = (diff + 1) % 5; // +1 karena 1 Jan 1900 = Legi
    final hari = hariJawa[hariIndex < 0 ? hariIndex + 7 : hariIndex];
    final pasaran = hariPasaran[pasaranIndex < 0 ? pasaranIndex + 5 : pasaranIndex];
    return '$hari $pasaran';
  }

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  List<Widget> _buildCalendar() {
    final firstDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final lastDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0: Minggu, 6: Sabtu

    List<Widget> rows = [];
    List<Widget> dayHeaders = hariJawa.map((h) => Expanded(child: Center(child: Text(h, style: const TextStyle(fontWeight: FontWeight.bold))))).toList();
    rows.add(Row(children: dayHeaders));

    int day = 1;
    for (int week = 0; day <= daysInMonth; week++) {
      List<Widget> days = [];
      for (int wd = 0; wd < 7; wd++) {
        if (week == 0 && wd < firstWeekday) {
          days.add(const Expanded(child: SizedBox.shrink()));
        } else if (day > daysInMonth) {
          days.add(const Expanded(child: SizedBox.shrink()));
        } else {
          final thisDate = DateTime(_displayedMonth.year, _displayedMonth.month, day);
          final isSelected = _selectedDate.year == thisDate.year && _selectedDate.month == thisDate.month && _selectedDate.day == thisDate.day;
          days.add(
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = thisDate;
                    _wetonResult = _hitungWeton(thisDate);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent : null,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      Text(
                        hariPasaran[((thisDate.difference(DateTime(1900, 1, 1)).inDays + 1) % 5 + 5) % 5],
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? Colors.white70 : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          day++;
        }
      }
      rows.add(Row(children: days));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender Jawa & Weton'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _goToPreviousMonth,
                ),
                Text(
                  '${_displayedMonth.month.toString().padLeft(2, '0')}-${_displayedMonth.year}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _goToNextMonth,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._buildCalendar(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickDate,
              child: const Text('Pilih Tanggal (DatePicker)'),
            ),
            const SizedBox(height: 16),
            Text(
              'Tanggal: ${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            if (_wetonResult != null) ...[
              const SizedBox(height: 12),
              Text(
                'Weton: $_wetonResult',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
