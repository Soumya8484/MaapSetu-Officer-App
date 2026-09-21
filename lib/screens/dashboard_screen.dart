import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:officer_app/screens/emergency_screen.dart';
import 'package:officer_app/screens/history_screen.dart';
import 'package:officer_app/screens/profile_screen.dart';

import '../features/auth/auth_service.dart';
import 'assignment_screens.dart';
import 'qr_scanner_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String currentUserId;

  const DashboardScreen({
    super.key,
    required this.currentUserId,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF174EA6);
  // static const Color deepBlue = Color(0xFF0D47A1);
  static const Color teal = Color(0xFF00897B);
  static const Color cyan = Color(0xFF00ACC1);
  static const Color saffron = Color(0xFFFFA000);
  static const Color green = Color(0xFF2E7D32);
  static const Color red = Color(0xFFD32F2F);

  static const Color lightBlue = Color(0xFFEAF3FF);
  static const Color background = Color(0xFFF4F7FB);

  static const Color textDark = Color(0xFF172B4D);
  static const Color textGrey = Color(0xFF64748B);

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: background,

        // ======================================================
        // APP BAR
        // ======================================================

        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: background,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 18,

          title: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryBlue,
                      teal,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.20),
                      blurRadius: 15,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.balance_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MaapSetu',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'OFFICER PORTAL',
                    style: TextStyle(
                      color: Colors.blueGrey.shade500,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),

          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFE4EAF2),
                ),
              ),
              child: IconButton(
                tooltip: 'Notifications',
                onPressed: () {
                  _showMessage(
                    'Notifications will appear here.',
                  );
                },
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.notifications_none_rounded,
                      color: primaryBlue,
                      size: 24,
                    ),

                    Positioned(
                      right: -1,
                      top: -1,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: saffron,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ======================================================
        // BODY
        // ======================================================

        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildDashboard(),

            MyAssignmentsContent(
              currentUserId: widget.currentUserId,
            ),

            HistoryContent(
              currentUserId: widget.currentUserId,
            ),

            ProfileScreen(
              currentUserId: widget.currentUserId,
            ),
          ],
        ),

        // ======================================================
        // BOTTOM NAVIGATION
        // ======================================================

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 25,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: NavigationBar(
            height: 74,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            selectedIndex: _selectedIndex,

            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },

            indicatorColor:
                primaryBlue.withOpacity(0.10),

            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Icons.dashboard_outlined,
                ),
                selectedIcon: Icon(
                  Icons.dashboard_rounded,
                  color: primaryBlue,
                ),
                label: 'Dashboard',
              ),

              NavigationDestination(
                icon: Icon(
                  Icons.assignment_outlined,
                ),
                selectedIcon: Icon(
                  Icons.assignment_rounded,
                  color: primaryBlue,
                ),
                label: 'Assignments',
              ),

              NavigationDestination(
                icon: Icon(
                  Icons.history_rounded,
                ),
                selectedIcon: Icon(
                  Icons.history_rounded,
                  color: primaryBlue,
                ),
                label: 'History',
              ),

              NavigationDestination(
                icon: Icon(
                  Icons.person_outline_rounded,
                ),
                selectedIcon: Icon(
                  Icons.person_rounded,
                  color: primaryBlue,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DASHBOARD
  // ============================================================

  Widget _buildDashboard() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        18,
        8,
        18,
        30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOfficerHeader(),

          const SizedBox(height: 22),

          _buildSectionHeader(
            title: 'Verification Overview',
            subtitle: 'Your current field activity',
          ),

          const SizedBox(height: 14),

          _buildStatistics(),

          const SizedBox(height: 26),

          _buildSectionHeader(
            title: "Today's Verifications",
            subtitle: 'Upcoming field activities',
            actionText: 'View all',
            onAction: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),

          const SizedBox(height: 14),

          _buildVerificationCard(
            applicationId: 'LM-2026-00125',
            businessName: 'ABC Traders',
            instrument: 'Digital Weighing Machine',
            location: 'Kolkata, West Bengal',
            time: '10:30 AM',
            status: 'SCHEDULED',
          ),

          const SizedBox(height: 12),

          _buildVerificationCard(
            applicationId: 'LM-2026-00126',
            businessName: 'XYZ Stores',
            instrument: 'Platform Weighing Scale',
            location: 'Howrah, West Bengal',
            time: '02:00 PM',
            status: 'IN PROGRESS',
          ),

          const SizedBox(height: 28),

          _buildSectionHeader(
            title: 'Quick Actions',
            subtitle: 'Frequently used tools',
          ),

          const SizedBox(height: 14),

          _buildQuickActions(),

          const SizedBox(height: 28),

          _buildDigitalServiceCard(),

          const SizedBox(height: 20),

          _buildFooter(),
        ],
      ),
    );
  }

  // ============================================================
  // OFFICER HEADER
  // ============================================================

  Widget _buildOfficerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF174EA6),
            Color(0xFF1261B5),
            Color(0xFF00897B),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 31,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: AuthService().getInspectorProfile(),
              builder: (context, snapshot) {
                String name =
                    'Legal Metrology Officer';

                String employeeId = '';
                String district = '';
                String state = '';

                if (snapshot.hasData) {
                  final data = snapshot.data!;

                  name =
                      data['name']?.toString() ??
                          name;

                  employeeId =
                      data['employeeId']
                              ?.toString() ??
                          '';

                  district =
                      data['district']
                              ?.toString() ??
                          '';

                  state =
                      data['state']?.toString() ??
                          '';
                }

                final locationParts = [
                  if (district.isNotEmpty) district,
                  if (state.isNotEmpty) state,
                ];

                return Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME BACK',
                      style: TextStyle(
                        color:
                            Colors.white.withOpacity(
                          0.70,
                        ),
                        fontSize: 9.5,
                        fontWeight:
                            FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        if (employeeId.isNotEmpty) ...[
                          const Icon(
                            Icons.badge_outlined,
                            color: Colors.white70,
                            size: 13,
                          ),

                          const SizedBox(width: 4),

                          Flexible(
                            child: Text(
                              employeeId,
                              overflow:
                                  TextOverflow.ellipsis,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],

                        if (employeeId.isNotEmpty &&
                            locationParts.isNotEmpty)
                          const Padding(
                            padding:
                                EdgeInsets.symmetric(
                              horizontal: 7,
                            ),
                            child: Text(
                              '•',
                              style: TextStyle(
                                color:
                                    Colors.white54,
                              ),
                            ),
                          ),

                        if (locationParts.isNotEmpty)
                          Flexible(
                            child: Text(
                              locationParts.join(
                                ', ',
                              ),
                              overflow:
                                  TextOverflow.ellipsis,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(width: 8),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.14),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                  size: 17,
                ),

                SizedBox(height: 2),

                Text(
                  'VERIFIED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 7.5,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.5,
                  color:
                      Colors.blueGrey.shade500,
                ),
              ),
            ],
          ),
        ),

        if (actionText != null)
          GestureDetector(
            onTap: onAction,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(
                    actionText,
                    style: const TextStyle(
                      color: primaryBlue,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const SizedBox(width: 3),

                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: primaryBlue,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStatistics() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Assigned',
                value: '12',
                icon: Icons.assignment_rounded,
                color: primaryBlue,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildStatCard(
                title: 'Today',
                value: '4',
                icon: Icons.today_rounded,
                color: teal,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'In Progress',
                value: '3',
                icon: Icons.pending_actions_rounded,
                color: saffron,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildStatCard(
                title: 'Completed',
                value: '8',
                icon: Icons.check_circle_rounded,
                color: green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE6EBF2),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color:
                      color.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),

              Icon(
                Icons.more_horiz_rounded,
                color:
                    Colors.blueGrey.shade300,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            value,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w800,
              color: textDark,
              letterSpacing: -0.7,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              color:
                  Colors.blueGrey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VERIFICATION CARD
  // ============================================================

  Widget _buildVerificationCard({
    required String applicationId,
    required String businessName,
    required String instrument,
    required String location,
    required String time,
    required String status,
  }) {
    final bool isProgress =
        status == 'IN PROGRESS' ||
        status == 'IN_PROGRESS';

    final Color accent =
        isProgress ? primaryBlue : saffron;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5EAF1),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: Text(
                  applicationId,
                  style: const TextStyle(
                    color: primaryBlue,
                    fontSize: 10.5,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              const Spacer(),

              _statusWidget(status),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color:
                      accent.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.scale_rounded,
                  color: accent,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      businessName,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight:
                            FontWeight.w800,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      instrument,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            Colors.blueGrey.shade600,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color:
                  const Color(0xFFF7F9FC),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 17,
                  color: teal,
                ),

                const SizedBox(width: 7),

                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: textGrey,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                ),

                Container(
                  width: 1,
                  height: 18,
                  color:
                      const Color(0xFFDCE2EA),
                ),

                const SizedBox(width: 10),

                const Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: primaryBlue,
                ),

                const SizedBox(width: 5),

                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: textDark,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  Widget _statusWidget(String status) {
    Color background;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'COMPLETED':
        background =
            const Color(0xFFEAF7ED);
        textColor = green;
        icon =
            Icons.check_circle_outline_rounded;
        break;

      case 'IN PROGRESS':
      case 'IN_PROGRESS':
        background =
            const Color(0xFFEAF2FF);
        textColor = primaryBlue;
        icon = Icons.timelapse_rounded;
        break;

      case 'SCHEDULED':
        background =
            const Color(0xFFFFF5E5);
        textColor =
            const Color(0xFFE65100);
        icon = Icons.schedule_rounded;
        break;

      case 'ASSIGNED':
        background =
            const Color(0xFFF2EAF8);
        textColor =
            const Color(0xFF6A1B9A);
        icon =
            Icons.assignment_ind_outlined;
        break;

      default:
        background =
            const Color(0xFFF1F3F5);
        textColor =
            Colors.blueGrey.shade700;
        icon =
            Icons.info_outline_rounded;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
            BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: textColor,
          ),

          const SizedBox(width: 4),

          Text(
            status.replaceAll('_', ' '),
            style: TextStyle(
              fontSize: 8.5,
              fontWeight:
                  FontWeight.w800,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.65,
      children: [
        _buildQuickAction(
          icon: Icons.assignment_rounded,
          title: 'Assignments',
          subtitle: 'View assigned work',
          color: primaryBlue,
          onTap: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
        ),

        _buildQuickAction(
          icon: Icons.history_rounded,
          title: 'History',
          subtitle: 'Past verifications',
          color: teal,
          onTap: () {
            setState(() {
              _selectedIndex = 2;
            });
          },
        ),

        _buildQuickAction(
          icon: Icons.location_on_rounded,
          title: 'Locations',
          subtitle: 'Nearby businesses',
          color: cyan,
          onTap: () {
            _showMessage(
              'Location section will be added here.',
            );
          },
        ),

        _buildQuickAction(
          icon: Icons.person_rounded,
          title: 'Profile',
          subtitle: 'Officer account',
          color:
              const Color(0xFF7B1FA2),
          onTap: () {
            setState(() {
              _selectedIndex = 3;
            });
          },
        ),

        _buildQuickAction(
          icon:
              Icons.qr_code_scanner_rounded,
          title: 'Scan Certificate',
          subtitle: 'Verify QR certificate',
          color: saffron,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const QrScannerScreen(),
              ),
            );
          },
        ),

        _buildQuickAction(
          icon: Icons.emergency_rounded,
          title: 'Emergency Help',
          subtitle: 'Get assistance',
          color: red,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const EmergencyHelpScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // QUICK ACTION CARD
  // ============================================================

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(18),
        child: Container(
          padding:
              const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color:
                  const Color(0xFFE5EAF1),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(
                  0.025,
                ),
                blurRadius: 14,
                offset:
                    const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color:
                      color.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(
                    13,
                  ),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight:
                            FontWeight.w800,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.5,
                        color:
                            Colors.blueGrey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DIGITAL SERVICE CARD
  // ============================================================

  Widget _buildDigitalServiceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEAF3FF),
            Color(0xFFEAF8F5),
          ],
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              const Color(0xFFD8E6F5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color:
                      primaryBlue.withOpacity(
                    0.08,
                  ),
                  blurRadius: 12,
                  offset:
                      const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.verified_rounded,
              color: primaryBlue,
              size: 25,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Digital Verification',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w800,
                    color: textDark,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Secure • Digital • Verifiable',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: textGrey,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 14,
                  color: teal,
                ),

                SizedBox(width: 4),

                Text(
                  'SECURE',
                  style: TextStyle(
                    fontSize: 8,
                    color: teal,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration:
                    const BoxDecoration(
                  color: primaryBlue,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 6),

              const Text(
                'MaapSetu',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w800,
                  color: textDark,
                ),
              ),

              const SizedBox(width: 5),

              Text(
                '•',
                style: TextStyle(
                  color:
                      Colors.blueGrey.shade400,
                ),
              ),

              const SizedBox(width: 5),

              Text(
                'Legal Metrology',
                style: TextStyle(
                  fontSize: 10.5,
                  color:
                      Colors.blueGrey.shade500,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            'Digital Verification & Certification System',
            style: TextStyle(
              fontSize: 9.5,
              color:
                  Colors.blueGrey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        behavior:
            SnackBarBehavior.floating,
        margin:
            const EdgeInsets.fromLTRB(
          18,
          0,
          18,
          18,
        ),
        elevation: 8,
        backgroundColor: textDark,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15),
        ),
        content: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 20,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}