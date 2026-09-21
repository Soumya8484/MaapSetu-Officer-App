import 'package:flutter/material.dart';

import 'package:officer_app/screens/login_screen.dart';
import 'package:officer_app/features/auth/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;

  const ProfileScreen({
    super.key,
    required this.currentUserId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // =========================================================
  // SERVICES
  // =========================================================

  final AuthService _authService = AuthService();

  // =========================================================
  // NAVIGATION
  // =========================================================

  int _selectedIndex = 3;

  // =========================================================
  // COLORS
  // =========================================================

  final Color primaryColor = const Color(0xFF123B6D);
  final Color secondaryColor = const Color(0xFF1E5A96);
  final Color backgroundColor = const Color(0xFFF5F7FA);

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevent Android back button from going
      // back to the Login screen.
      canPop: false,

      child: Scaffold(
        backgroundColor: backgroundColor,

        // =====================================================
        // APP BAR
        // =====================================================

        // appBar: AppBar(
          // automaticallyImplyLeading: false,

          // elevation: 0,

          // backgroundColor: Colors.white,

          // surfaceTintColor: Colors.white,

          // titleSpacing: 20,

          // title: Row(
          //   children: [
          //     Container(
          //       width: 40,
          //       height: 40,

          //       decoration: BoxDecoration(
          //         color: primaryColor,
          //         borderRadius: BorderRadius.circular(10),
          //       ),

          //       child: const Icon(
          //         Icons.balance,
          //         color: Colors.white,
          //         size: 22,
          //       ),
          //     ),

          //     const SizedBox(width: 12),

          //     Column(
          //       crossAxisAlignment:
          //           CrossAxisAlignment.start,

          //       children: [
          //         Text(
          //           'Legal Metrology',
          //           style: TextStyle(
          //             color: primaryColor,
          //             fontSize: 17,
          //             fontWeight: FontWeight.w700,
          //           ),
          //         ),

          //         Text(
          //           'Officer Portal',
          //           style: TextStyle(
          //             color: Colors.grey.shade600,
          //             fontSize: 11,
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),

          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(
          //           content: Text(
          //             'Notifications will appear here.',
          //           ),
          //         ),
          //       );
          //     },

          //     icon: Icon(
          //       Icons.notifications_none,
          //       color: primaryColor,
          //     ),
          //   ),

          //   const SizedBox(width: 8),
          // ],
        // ),

        // =====================================================
        // BODY
        // =====================================================

        body: SafeArea(
          child: _buildSelectedPage(),
        ),

        // =====================================================
        // BOTTOM NAVIGATION
        // =====================================================

        // bottomNavigationBar: NavigationBar(
        //   height: 70,

        //   backgroundColor: Colors.white,

        //   surfaceTintColor: Colors.white,

        //   elevation: 8,

        //   selectedIndex: _selectedIndex,

        //   onDestinationSelected: (index) {
        //     setState(() {
        //       _selectedIndex = index;
        //     });
        //   },

        //   indicatorColor:
        //       primaryColor.withOpacity(0.10),

          // destinations: [
          //   // -------------------------------------------------
          //   // DASHBOARD
          //   // -------------------------------------------------

          //   NavigationDestination(
          //     icon: Icon(
          //       Icons.dashboard_outlined,
          //       color: Colors.grey.shade600,
          //     ),

          //     selectedIcon: Icon(
          //       Icons.dashboard,
          //       color: primaryColor,
          //     ),

          //     label: 'Dashboard',
          //   ),

          //   // -------------------------------------------------
          //   // ASSIGNMENTS
          //   // -------------------------------------------------

          //   NavigationDestination(
          //     icon: Icon(
          //       Icons.assignment_outlined,
          //       color: Colors.grey.shade600,
          //     ),

          //     selectedIcon: Icon(
          //       Icons.assignment,
          //       color: primaryColor,
          //     ),

          //     label: 'Assignments',
          //   ),

          //   // -------------------------------------------------
          //   // HISTORY
          //   // -------------------------------------------------

          //   NavigationDestination(
          //     icon: Icon(
          //       Icons.history_outlined,
          //       color: Colors.grey.shade600,
          //     ),

          //     selectedIcon: Icon(
          //       Icons.history,
          //       color: primaryColor,
          //     ),

          //     label: 'History',
          //   ),

          //   // -------------------------------------------------
          //   // PROFILE
          //   // -------------------------------------------------

          //   NavigationDestination(
          //     icon: Icon(
          //       Icons.person_outline,
          //       color: Colors.grey.shade600,
          //     ),

          //     selectedIcon: Icon(
          //       Icons.person,
          //       color: primaryColor,
          //     ),

          //     label: 'Profile',
          //   ),
          //],
    //     ),
    //   ),
    )
    );
  }

  // =========================================================
  // SELECTED PAGE
  // =========================================================

  Widget _buildSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();

      case 1:
        return _buildAssignments();

      case 2:
        return _buildHistory();

      case 3:
        return _buildProfile();

      default:
        return _buildProfile();
    }
  }

  // =========================================================
  // DASHBOARD
  // =========================================================

  Widget _buildDashboard() {
    return const Center(
      child: Text(
        'Dashboard',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // =========================================================
  // ASSIGNMENTS
  // =========================================================

  Widget _buildAssignments() {
    return const Center(
      child: Text(
        'Assignments',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // =========================================================
  // HISTORY
  // =========================================================

  Widget _buildHistory() {
    return const Center(
      child: Text(
        'Verification History',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // =========================================================
  // PROFILE
  // =========================================================

  Widget _buildProfile() {
  return FutureBuilder<Map<String, dynamic>>(
    future: _authService.getInspectorProfile(),
    builder: (context, snapshot) {
      // -----------------------------------------------------
      // LOADING
      // -----------------------------------------------------

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // -----------------------------------------------------
      // DEFAULT VALUES
      // -----------------------------------------------------

      String name = 'Legal Metrology Officer';
      String email = '';
      String employeeId = '';
      String district = '';
      String state = '';
      String status = 'Active Officer';

      // -----------------------------------------------------
      // GET BACKEND DATA
      // -----------------------------------------------------

      if (snapshot.hasData) {
        final data = snapshot.data!;

        name = data['name']?.toString() ?? name;
        employeeId = data['employeeId']?.toString() ?? '';

        // Backend currently returns "region"
        // We use it as the officer's district/region.
        district = data['region']?.toString() ?? '';

        status = data['status']?.toString() ?? 'Active Officer';
      }

      // -----------------------------------------------------
      // PROFILE UI
      // -----------------------------------------------------

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // =================================================
            // PROFILE HEADER
            // =================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [

                  // PROFILE ICON

                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor.withOpacity(0.15),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // NAME

                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF172B4D),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // DESIGNATION

                  const Text(
                    'Legal Metrology Officer',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ACTIVE STATUS

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 15,
                          color: Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          status,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =================================================
            // OFFICER INFORMATION
            // =================================================

            const Text(
              'Officer Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 12),

            // EMPLOYEE ID

            _profileInfoCard(
              icon: Icons.badge_outlined,
              title: 'Employee ID',
              value: employeeId.isEmpty
                  ? 'Not available'
                  : employeeId,
            ),

            // EMAIL

            _profileInfoCard(
              icon: Icons.email_outlined,
              title: 'Email Address',
              value: email.isEmpty
                  ? 'Not available'
                  : email,
            ),

            // DISTRICT / REGION

            _profileInfoCard(
              icon: Icons.location_city_outlined,
              title: 'District / Region',
              value: district.isEmpty
                  ? 'Not available'
                  : district,
            ),

            // STATE

            _profileInfoCard(
              icon: Icons.map_outlined,
              title: 'State',
              value: state.isEmpty
                  ? 'Not available'
                  : state,
            ),

            const SizedBox(height: 14),

            // =================================================
            // ACCOUNT
            // =================================================

            const Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [

                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.security_outlined,
                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(width: 13),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account ID',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Authenticated Backend Account',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF172B4D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =================================================
            // LOGOUT
            // =================================================

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(
                  Icons.logout,
                ),
                label: const Text(
                  'LOGOUT',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(
                    color: Colors.red.shade200,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // FOOTER

            Center(
              child: Text(
                'Legal Metrology Officer Portal',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

  // =========================================================
  // PROFILE INFORMATION CARD
  // =========================================================

  Widget _profileInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,

      margin:
          const EdgeInsets.only(bottom: 12),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),

        border: Border.all(
          color:
              const Color(0xFFE2E8F0),
        ),
      ),

      child: Row(
        children: [

          // ICON
          Container(
            width: 42,
            height: 42,

            decoration:
                BoxDecoration(
              color:
                  primaryColor
                      .withOpacity(0.08),

              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: Icon(
              icon,

              color: primaryColor,

              size: 21,
            ),
          ),

          const SizedBox(width: 14),

          // INFORMATION
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 12,

                    color:
                        Color(0xFF64748B),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,

                  style: const TextStyle(
                    fontSize: 15,

                    fontWeight:
                        FontWeight.w600,

                    color:
                        Color(0xFF172B4D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> _logout() async {
    final shouldLogout =
        await showDialog<bool>(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),

          title: const Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.red,
              ),

              SizedBox(width: 10),

              Text('Logout'),
            ],
          ),

          content: const Text(
            'Are you sure you want to logout from the Officer Portal?',
          ),

          actions: [

            // CANCEL
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },

              child: const Text(
                'CANCEL',
              ),
            ),

            // LOGOUT
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red.shade700,

                foregroundColor:
                    Colors.white,
              ),

              child: const Text(
                'LOGOUT',
              ),
            ),
          ],
        );
      },
    );

    // User cancelled
    if (shouldLogout != true) {
      return;
    }

    // Firebase logout
    await _authService.logout();

    if (!mounted) {
      return;
    }

    // Remove all previous screens
    // and go to Login.
    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),

      (route) => false,
    );
  }
}