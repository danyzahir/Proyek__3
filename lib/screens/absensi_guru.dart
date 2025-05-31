import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';
import 'absensi.dart';
import 'nilai.dart';
import 'data_guru_anak.dart';
import 'rekap_absensi.dart';

class AbsensiGuruPage extends StatefulWidget {
  final String username;

  const AbsensiGuruPage({super.key, required this.username});

  @override
  State<AbsensiGuruPage> createState() => _AbsensiGuruPageState();
}

class _AbsensiGuruPageState extends State<AbsensiGuruPage> {
  File? _capturedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _openCamera();
    });
  }

  Future<void> _openCamera() async {
    try {
      final tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final docRef = FirebaseFirestore.instance
          .collection('absensi_guru')
          .doc('${widget.username}_$tanggal');

      final snapshot = await docRef.get();

      if (snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda sudah melakukan absensi hari ini.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _capturedImage = File(photo.path);
        });

        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Pilih Status Absensi:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statusButton("H", Colors.green),
                      _statusButton("I", Colors.orange),
                      _statusButton("S", Colors.blue),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      print('Error opening camera: $e');
    }
  }

Future<void> _pilihUnit(String status) async {
  Navigator.pop(context); // tutup modal status H/I/S

  String? selectedUnit = await showModalBottomSheet<String>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Pilih Unit",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, "TKQ"),
                icon: const Icon(Icons.school),
                label: const Text("TKQ"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white, // Teks & ikon jadi putih
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, "SDIT"),
                icon: const Icon(Icons.menu_book),
                label: const Text("SDIT"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white, // Teks & ikon jadi putih
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );

  if (selectedUnit != null) {
    await _simpanAbsensi(status, selectedUnit);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Absensi disimpan: $status ($selectedUnit)')),
    );
  }
}

  Future<void> _simpanAbsensi(String status, String unit) async {
    final tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final docRef = FirebaseFirestore.instance
        .collection('absensi_guru')
        .doc('${widget.username}_$tanggal');

    await docRef.set({
      'nama': widget.username,
      'tanggal': tanggal,
      'status': status,
      'unit': unit,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Widget _statusButton(String status, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () => _pilihUnit(status),
      child: Text(status, style: const TextStyle(fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 45),
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        Text(widget.username,
                            style: const TextStyle(fontSize: 16, color: Colors.white)),
                        const SizedBox(width: 10),
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18,
                          child: Icon(Icons.person, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text("ABSENSI GURU",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.2,
                      children: [
                        _capturedImage != null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(_capturedImage!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : _menuItem("Kamera", Icons.camera),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.361,
                        child: GestureDetector(
                          onTap: _openCamera,
                          child: _menuItem("Capture", Icons.camera_alt),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem("Dashboard", Icons.home, () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => HomeScreen(username: widget.username)));
                }, false),
                _navItem("Absensi", Icons.assignment_ind_rounded, () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => AbsensiScreen(username: widget.username)));
                }, true),
                _navItem("Nilai", Icons.my_library_books_rounded, () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => NilaiScreen(username: widget.username)));
                }, false),
                _navItem("Data Guru & Anak", Icons.person, () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => DataScreen(username: widget.username)));
                }, false),
                _navItem("Rekap Absensi", Icons.receipt_long, () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => RekapScreen(username: widget.username)));
                }, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 35, color: Colors.black),
          const SizedBox(height: 5),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _navItem(String title, IconData icon, VoidCallback onTap, bool isActive) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 26, color: isActive ? Colors.green : Colors.black54),
          const SizedBox(height: 2),
          Text(title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.green : Colors.black54,
              )),
        ],
      ),
    );
  }
}