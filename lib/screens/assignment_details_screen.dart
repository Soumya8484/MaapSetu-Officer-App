import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:officer_app/features/auth/auth_service.dart';
import 'package:officer_app/screens/document_screen.dart';
import 'package:officer_app/screens/verification_screen.dart';

class AssignmentDetailsScreen extends StatelessWidget {
  final String assignmentId;

  const AssignmentDetailsScreen({
    super.key,
    required this.assignmentId,
  });

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF174EA6);
  static const Color deepBlue = Color(0xFF0D47A1);
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
    // Create AuthService locally.
    //
    // Do NOT create it as a class field because this widget
    // has a const constructor.
    final authService = AuthService();

    return Scaffold(
      backgroundColor: background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 4,

        iconTheme: const IconThemeData(
          color: primaryBlue,
        ),

        title: const Text(
          'Assignment Details',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: textDark,
            letterSpacing: -0.3,
          ),
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 14,
            ),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
              ),
            ),
            child: const Icon(
              Icons.assignment_rounded,
              color: primaryBlue,
              size: 19,
            ),
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: FutureBuilder<Map<String, dynamic>>(
        future: authService.getInspectorApplicationDetails(
          assignmentId,
        ),

        builder: (context, snapshot) {
          // ====================================================
          // LOADING
          // ====================================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryBlue,
                strokeWidth: 2.5,
              ),
            );
          }

          // ====================================================
          // ERROR
          // ====================================================

          if (snapshot.hasError) {
            return _emptyState(
              icon: Icons.cloud_off_rounded,
              title: 'Unable to load assignment',
              subtitle:
                  'Please check your connection and try again.',
            );
          }

          // ====================================================
          // NOT FOUND
          // ====================================================

          if (!snapshot.hasData) {
            return _emptyState(
              icon: Icons.assignment_outlined,
              title: 'Assignment not found',
              subtitle:
                  'This assignment could not be found.',
            );
          }

          // Backend returns Map<String, dynamic>
          final data = snapshot.data!;

          // ====================================================
          // CONTENT
          // ====================================================

          return SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(),

            padding: const EdgeInsets.fromLTRB(
              18,
              8,
              18,
              35,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // =================================================
                // ASSIGNMENT HEADER
                // =================================================

                _assignmentHeader(data),

                const SizedBox(height: 18),

                // =================================================
                // APPLICATION
                // =================================================

                _sectionCard(
                  title: 'Application',
                  subtitle:
                      'Appointment and application information',
                  icon:
                      Icons.description_rounded,
                  color: primaryBlue,
                  children: [
                    _detailRow(
                      icon: Icons.tag_rounded,
                      label: 'Application ID',
                      value:
                          data['applicationId'] ??
                              'Not available',
                    ),

                    _detailRow(
                      icon:
                          Icons.calendar_month_rounded,
                      label: 'Appointment Date',
                      value:
                          data['appointmentDate'] ??
                              'Not available',
                    ),

                    _detailRow(
                      icon:
                          Icons.access_time_rounded,
                      label: 'Appointment Time',
                      value:
                          data['appointmentTime'] ??
                              'Not available',
                      showDivider: false,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // =================================================
                // BUSINESS
                // =================================================

                _sectionCard(
                  title: 'Business',
                  subtitle:
                      'Applicant and location details',
                  icon:
                      Icons.storefront_rounded,
                  color: teal,
                  children: [
                    _detailRow(
                      icon:
                          Icons.storefront_rounded,
                      label: 'Business Name',
                      value:
                          data['applicant'] ??
                              'Not available',
                    ),

                    _detailRow(
                      icon:
                          Icons.location_on_rounded,
                      label: 'Location',
                      value:
                          data['location'] ??
                              'Not available',
                      showDivider: false,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // =================================================
                // INSTRUMENT
                // =================================================

                _sectionCard(
                  title: 'Instrument',
                  subtitle:
                      'Measuring instrument information',
                  icon:
                      Icons.scale_rounded,
                  color: saffron,
                  children: [
                    _detailRow(
                      icon:
                          Icons.category_rounded,
                      label: 'Instrument Type',
                      value:
                          data['instrumentType'] ??
                              'Not available',
                    ),

                    _detailRow(
                      icon:
                          Icons.factory_rounded,
                      label: 'Manufacturer',
                      value:
                          data['manufacturer'] ??
                              'Not available',
                    ),

                    _detailRow(
                      icon:
                          Icons.devices_rounded,
                      label: 'Model',
                      value:
                          data['model'] ??
                              'Not available',
                    ),

                    _detailRow(
                      icon:
                          Icons.confirmation_number_rounded,
                      label: 'Serial Number',
                      value:
                          data['instrumentId'] ??
                              'Not available',
                    ),

                    _detailRow(
                      icon:
                          Icons.speed_rounded,
                      label: 'Capacity',
                      value:
                          data['capacity'] ??
                              'Not available',
                      showDivider: false,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // =================================================
                // VERIFICATION
                // =================================================

                _sectionCard(
                  title: 'Verification',
                  subtitle:
                      'Verification type and current status',
                  icon:
                      Icons.verified_rounded,
                  color: green,
                  children: [
                    _detailRow(
                      icon:
                          Icons.fact_check_rounded,
                      label: 'Type',
                      value:
                          data['applicationType'] ??
                              'Not available',
                    ),

                    _statusRow(
                      status:
                          data['status'] ??
                              'UNKNOWN',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // =================================================
                // ACTIONS TITLE
                // =================================================

                const Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Manage this verification assignment',
                  style: TextStyle(
                    fontSize: 11.5,
                    color:
                        Colors.blueGrey.shade500,
                  ),
                ),

                const SizedBox(height: 14),

                // =================================================
                // START VERIFICATION
                // =================================================

                _primaryActionButton(
                  icon:
                      Icons.play_arrow_rounded,
                  title: 'Start Verification',
                  subtitle:
                      'Begin the instrument verification process',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VerificationScreen(
                          assignmentId:
                              assignmentId,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // =================================================
                // VIEW DOCUMENTS
                // =================================================

                _secondaryActionButton(
                  icon:
                      Icons.folder_open_rounded,
                  title: 'View Documents',
                  subtitle:
                      'Review submitted application documents',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DocumentsScreen(
                          applicationId:
                              assignmentId,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // =================================================
                // VIEW HISTORY
                // =================================================

                _secondaryActionButton(
                  icon:
                      Icons.history_rounded,
                  title: 'View History',
                  subtitle:
                      'Review previous verification activity',
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        behavior:
                            SnackBarBehavior.floating,
                        backgroundColor:
                            textDark,
                        margin:
                            const EdgeInsets.fromLTRB(
                          18,
                          0,
                          18,
                          18,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                        content: const Text(
                          'Assignment history will be available here.',
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // =================================================
                // SECURITY CARD
                // =================================================

                _buildSecurityCard(),

                const SizedBox(height: 20),

                // =================================================
                // FOOTER
                // =================================================

                Center(
                  child: Text(
                    'MaapSetu • Legal Metrology Officer Portal',
                    style: TextStyle(
                      fontSize: 10.5,
                      color:
                          Colors.blueGrey.shade400,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // ASSIGNMENT HEADER
  // ============================================================

  Widget _assignmentHeader(
    Map<String, dynamic> data,
  ) {
    final String status =
        data['status']?.toString() ??
            'UNKNOWN';

    final String applicationId =
        data['applicationId']?.toString() ??
            'Assignment';

    final String applicant =
        data['applicant']?.toString() ??
            'Business Name';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryBlue,
            Color(0xFF1261B5),
            teal,
          ],
        ),
        borderRadius:
            BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color:
                primaryBlue.withOpacity(0.20),
            blurRadius: 24,
            offset: const Offset(0, 10),
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      Colors.white.withOpacity(
                    0.15,
                  ),
                  borderRadius:
                      BorderRadius.circular(15),
                  border: Border.all(
                    color:
                        Colors.white.withOpacity(
                      0.20,
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.scale_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),

              const Spacer(),

              _modernStatusWidget(status),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            applicationId,
            style: TextStyle(
              color:
                  Colors.white.withOpacity(0.75),
              fontSize: 11,
              fontWeight:
                  FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            applicant,
            maxLines: 2,
            overflow:
                TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight:
                  FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.white70,
                size: 16,
              ),

              const SizedBox(width: 5),

              Expanded(
                child: Text(
                  data['location']
                          ?.toString() ??
                      'Location not available',
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11.5,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION CARD
  // ============================================================

  Widget _sectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              const Color(0xFFE4EAF2),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.035,
            ),
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                      color.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 21,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        fontSize: 15.5,
                        fontWeight:
                            FontWeight.w800,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Colors
                            .blueGrey
                            .shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ...children,
        ],
      ),
    );
  }

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _detailRow({
    required IconData icon,
    required String label,
    required dynamic value,
    bool showDivider = true,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 12,
      ),
      decoration: showDivider
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      Color(0xFFF0F3F7),
                ),
              ),
            )
          : null,
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color:
                  const Color(0xFFF4F7FB),
              borderRadius:
                  BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 16,
              color:
                  Colors.blueGrey.shade600,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                color:
                    Colors.blueGrey.shade600,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            flex: 6,
            child: Text(
              value.toString(),
              textAlign:
                  TextAlign.right,
              style: const TextStyle(
                fontSize: 12.5,
                color: textDark,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS ROW
  // ============================================================

  Widget _statusRow({
    required String status,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color:
                  const Color(0xFFF4F7FB),
              borderRadius:
                  BorderRadius.circular(9),
            ),
            child: Icon(
              Icons.flag_rounded,
              size: 16,
              color:
                  Colors.blueGrey.shade600,
            ),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Status',
              style: TextStyle(
                fontSize: 11.5,
                color: textGrey,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),

          _modernStatusWidget(status),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS CHIP
  // ============================================================

  Widget _modernStatusWidget(
    String status,
  ) {
    final normalized =
        status.toUpperCase();

    Color background;
    Color textColor;
    IconData icon;

    switch (normalized) {
      case 'COMPLETED':
        background =
            const Color(0xFFEAF7ED);
        textColor = green;
        icon =
            Icons.check_circle_rounded;
        break;

      case 'IN PROGRESS':
      case 'IN_PROGRESS':
        background =
            const Color(0xFFEAF2FF);
        textColor = primaryBlue;
        icon =
            Icons.timelapse_rounded;
        break;

      case 'SCHEDULED':
        background =
            const Color(0xFFFFF5E5);
        textColor =
            const Color(0xFFE65100);
        icon =
            Icons.schedule_rounded;
        break;

      case 'ASSIGNED':
        background =
            const Color(0xFFF3EAF8);
        textColor =
            const Color(0xFF6A1B9A);
        icon =
            Icons.assignment_ind_rounded;
        break;

      default:
        background =
            Colors.white.withOpacity(0.15);
        textColor = Colors.white;
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
            BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: textColor,
          ),

          const SizedBox(width: 4),

          Text(
            normalized.replaceAll(
              '_',
              ' ',
            ),
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
  // PRIMARY ACTION
  // ============================================================

  Widget _primaryActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius:
            BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient:
                const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryBlue,
                teal,
              ],
            ),
            borderRadius:
                BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color:
                    primaryBlue.withOpacity(
                  0.18,
                ),
                blurRadius: 18,
                offset:
                    const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color:
                      Colors.white.withOpacity(
                    0.15,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    13,
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 25,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style:
                          const TextStyle(
                        color: Colors.white70,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECONDARY ACTION
  // ============================================================

  Widget _secondaryActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius:
            BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color:
                  const Color(0xFFE3E9F1),
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
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius:
                      BorderRadius.circular(
                    13,
                  ),
                ),
                child: Icon(
                  icon,
                  color: primaryBlue,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        color: textDark,
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color:
                            Colors.blueGrey
                                .shade500,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECURITY CARD
  // ============================================================

  Widget _buildSecurityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            const Color(0xFFEAF8F5),
        borderRadius:
            BorderRadius.circular(17),
        border: Border.all(
          color:
              const Color(0xFFD1ECE6),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(
                11,
              ),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: teal,
              size: 20,
            ),
          ),

          const SizedBox(width: 11),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Verification Workspace',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight:
                        FontWeight.w800,
                    color: textDark,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'All verification actions are securely recorded.',
                  style: TextStyle(
                    fontSize: 10,
                    color: textGrey,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.verified_rounded,
            color: teal,
            size: 19,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color:
                    primaryBlue.withOpacity(
                  0.08,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 34,
                color: primaryBlue,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w800,
                color: textDark,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color:
                    Colors.blueGrey.shade600, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}