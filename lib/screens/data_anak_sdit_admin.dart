import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyek3/screens/data_anak_sdit_kelas_admin.dart';
import 'login.dart';

class DataAnakSDITAdmin extends StatelessWidget {
  final String username;

  const DataAnakSDITAdmin({super.key, required this.username});

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
                              username,
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
                                      builder: (context) => const LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                      "DATA MURID - SDIT",
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
                child: Wrap(
                  spacing: screenWidth * 0.04,
                  runSpacing: screenHeight * 0.02,
                  alignment: WrapAlignment.center,
                  children: [
                    _menuBox("Kelas 1", Icons.looks_one_outlined, screenWidth,
                        screenHeight, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataAnakSDITAdminKelas(
                            username: username,
                            kelas: "1",
                          ),
                        ),
                      );
                    }),
                    _menuBox("Kelas 2", Icons.looks_two_outlined, screenWidth,
                        screenHeight, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataAnakSDITAdminKelas(
                            username: username,
                            kelas: "2",
                          ),
                        ),
                      );
                    }),
                    _menuBox("Kelas 3", Icons.looks_3_outlined, screenWidth,
                        screenHeight, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataAnakSDITAdminKelas(
                            username: username,
                            kelas: "3",
                          ),
                        ),
                      );
                    }),
                    _menuBox("Kelas 4", Icons.looks_4_outlined, screenWidth,
                        screenHeight, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataAnakSDITAdminKelas(
                            username: username,
                            kelas: "4",
                          ),
                        ),
                      );
                    }),
                    _menuBox("Kelas 5", Icons.looks_5_outlined, screenWidth,
                        screenHeight, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataAnakSDITAdminKelas(
                            username: username,
                            kelas: "5",
                          ),
                        ),
                      );
                    }),
                    _menuBox("Kelas 6", Icons.looks_6_outlined, screenWidth,
                        screenHeight, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataAnakSDITAdminKelas(
                            username: username,
                            kelas: "6",
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuBox(
    String title,
    IconData icon,
    double screenWidth,
    double screenHeight,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: (screenWidth - (screenWidth * 0.08 * 2 + screenWidth * 0.04)) / 2,
      height: screenHeight * 0.16,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
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
              Icon(icon, size: screenWidth * 0.09, color: Colors.black),
              SizedBox(height: screenWidth * 0.01),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
