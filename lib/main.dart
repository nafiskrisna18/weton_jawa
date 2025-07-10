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
  DateTime? _selectedDate;
  String? _wetonResult;

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
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _wetonResult = _hitungWeton(picked);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender Jawa & Weton'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _pickDate,
              child: const Text('Pilih Tanggal'),
            ),
            const SizedBox(height: 24),
            if (_selectedDate != null)
              Text(
                'Tanggal: ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            if (_wetonResult != null) ...[
              const SizedBox(height: 16),
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
