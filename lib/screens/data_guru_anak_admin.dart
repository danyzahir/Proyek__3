import 'package:flutter/material.dart';
import 'package:proyek3/screens/data_anak_tkq_admin.dart';
import 'package:proyek3/screens/data_guru_tkq_admin.dart';
import '../widgets/user_menu.dart';
import 'data_guru_sdit_admin.dart';
import 'data_anak_sdit_admin.dart';

class DataScreenAdmin extends StatelessWidget {
  final String username;

  const DataScreenAdmin({super.key, required this.username});

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
              // Header
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
                            UserMenu(username: username),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      "DATA GURU & ANAK",
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

              // Info Box
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.035),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Colors.black54, size: screenWidth * 0.04),
                      SizedBox(width: screenWidth * 0.025),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Senin, 15 April 2024",
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "Penerimaan Siswa Baru",
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Menu
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Wrap(
                  spacing: screenWidth * 0.04,
                  runSpacing: screenHeight * 0.02,
                  alignment: WrapAlignment.center,
                  children: [
                    _menuCard(context, "Data Guru SDIT", Icons.people,
                        screenWidth, screenHeight, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataGuruSDITAdmin(
                            username: username,
                          ),
                        ),
                      );
                    }),
                    _menuCard(context, "Data Guru TKQ", Icons.people,
                        screenWidth, screenHeight, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataGuruTKQAdmin(
                            username: username,
                          ),
                        ),
                      );
                    }),
                    _menuCard(context, "Data Murid SDIT", Icons.people,
                        screenWidth, screenHeight, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataAnakSDITAdmin(
                            username: username,
                          ),
                        ),
                      );
                    }),
                    _menuCard(context, "Data Murid TKQ", Icons.people,
                        screenWidth, screenHeight, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataAnakTKQAdmin(
                            username: username,
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

  Widget _menuCard(BuildContext context, String title, IconData icon,
      double screenWidth, double screenHeight, VoidCallback onTap) {
    return SizedBox(
      width: (screenWidth - (screenWidth * 0.08 * 2 + screenWidth * 0.04)) / 2,
      height: screenHeight * 0.16,
      child: GestureDetector(
        onTap: onTap,
        child: _menuItem(title, icon, screenWidth),
      ),
    );
  }

  Widget _menuItem(String title, IconData icon, double screenWidth) {
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
    );
  }
}
