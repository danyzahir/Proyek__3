import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class DataGuruTKQAdmin extends StatefulWidget {
  final String username;

  const DataGuruTKQAdmin({super.key, required this.username});

  @override
  State<DataGuruTKQAdmin> createState() => _DataGuruTKQAdminState();
}

class _DataGuruTKQAdminState extends State<DataGuruTKQAdmin> {
  List<Map<String, dynamic>> guru = [];

  final TextEditingController namaController = TextEditingController();
  final TextEditingController jabatanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGuru();
  }

  Future<void> _loadGuru() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('guru_sdit').get();
    setState(() {
      guru = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'nama': doc['nama'],
                'jabatan': doc['jabatan'],
              })
          .toList();
    });
  }

  Future<void> _tambahGuruFirestore(String nama, String jabatan) async {
    await FirebaseFirestore.instance.collection('guru_sdit').add({
      'nama': nama,
      'jabatan': jabatan,
    });
    _loadGuru();
  }

  Future<void> _hapusGuruFirestore(String id) async {
    await FirebaseFirestore.instance.collection('guru_sdit').doc(id).delete();
    _loadGuru();
  }

  Future<void> _editGuruFirestore(
      String id, String nama, String jabatan) async {
    await FirebaseFirestore.instance.collection('guru_sdit').doc(id).update({
      'nama': nama,
      'jabatan': jabatan,
    });
    _loadGuru();
  }

  void _tambahGuru() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.purple[50],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Tambah Akun Guru",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 20),
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                      labelText: 'Nama', border: UnderlineInputBorder()),
                ),
                TextField(
                  controller: jabatanController,
                  decoration: const InputDecoration(
                      labelText: 'Jabatan', border: UnderlineInputBorder()),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text("Batal",
                          style: TextStyle(color: Colors.purple)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        _tambahGuruFirestore(
                            namaController.text, jabatanController.text);
                        namaController.clear();
                        jabatanController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text("Simpan"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _hapusGuru(int index) {
    _hapusGuruFirestore(guru[index]['id']);
  }

  void _editGuru(int index) {
    namaController.text = guru[index]['nama'];
    jabatanController.text = guru[index]['jabatan'];
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.purple[50],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Edit Akun Guru",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 20),
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                      labelText: 'Nama', border: UnderlineInputBorder()),
                ),
                TextField(
                  controller: jabatanController,
                  decoration: const InputDecoration(
                      labelText: 'Jabatan', border: UnderlineInputBorder()),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text("Batal",
                          style: TextStyle(color: Colors.purple)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        _editGuruFirestore(
                          guru[index]['id'],
                          namaController.text,
                          jabatanController.text,
                        );
                        namaController.clear();
                        jabatanController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text("Simpan"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.05,
                ),
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
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.username,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'logout') {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                    (route) => false,
                                  );
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'logout',
                                  child: Row(
                                    children: [
                                      Icon(Icons.logout, color: Colors.red),
                                      SizedBox(width: 10),
                                      Text('Logout'),
                                    ],
                                  ),
                                ),
                              ],
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 18,
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      "DATA GURU - TKQ",
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          _buildHeaderCell('Nama Guru', screenWidth, flex: 4),
                          _buildHeaderCell('Jabatan', screenWidth, flex: 4),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: _tambahGuru,
                          ),
                        ],
                      ),
                    ),
                    for (int i = 0; i < guru.length; i++)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(guru[i]['nama'] ?? ''),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(guru[i]['jabatan'] ?? ''),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () => _editGuru(i),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () => _hapusGuru(i),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, double screenWidth, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
