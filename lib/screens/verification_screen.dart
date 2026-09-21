import 'package:flutter/material.dart';
import 'inspection_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String assignmentId;

  const VerificationScreen({
    super.key,
    required this.assignmentId,
  });

  @override
  State<VerificationScreen> createState() =>
      _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF174EA6);
  // static const Color deepBlue = Color(0xFF0D47A1);
  static const Color teal = Color(0xFF00897B);
  static const Color cyan = Color(0xFF00ACC1);
  static const Color saffron = Color(0xFFFFA000);
  static const Color green = Color(0xFF2E7D32);

  // static const Color lightBlue = Color(0xFFEAF3FF);
  static const Color background = Color(0xFFF4F7FB);
  static const Color textDark = Color(0xFF172B4D);
  // static const Color textGrey = Color(0xFF64748B);

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,

        iconTheme: const IconThemeData(
          color: primaryBlue,
        ),

        titleSpacing: 0,

        title: const Text(
          'Verification',
          style: TextStyle(
            color: textDark,
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
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

              // ==================================================
              // HEADER CARD
              // ==================================================

              _buildHeaderCard(),

              const SizedBox(height: 26),

              // ==================================================
              // SECTION HEADER
              // ==================================================

              _buildSectionHeader(
                title: 'Verification Process',
                subtitle: 'Complete each step before submitting',
              ),

              const SizedBox(height: 14),

              // ==================================================
              // VERIFICATION STEPS
              // ==================================================

              _buildVerificationSteps(),

              const SizedBox(height: 26),

              // ==================================================
              // START BUTTON
              // ==================================================

              _buildStartButton(),

              const SizedBox(height: 14),

              // ==================================================
              // FOOTER NOTE
              // ==================================================

              _buildFooterNote(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER CARD
  // ============================================================

  Widget _buildHeaderCard() {
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
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.20),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ----------------------------------------------------
          // TOP ICON + STATUS
          // ----------------------------------------------------

          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.22),
                  ),
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                  size: 29,
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'SECURE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ----------------------------------------------------
          // TITLE
          // ----------------------------------------------------

          const Text(
            'Start Verification',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Begin the verification process for this assignment.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.76),
              fontSize: 12.5,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 18),

          // ----------------------------------------------------
          // ASSIGNMENT ID
          // ----------------------------------------------------

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.assignment_rounded,
                  color: Colors.white70,
                  size: 18,
                ),

                const SizedBox(width: 8),

                const Text(
                  'Assignment',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                Flexible(
                  child: Text(
                    widget.assignmentId,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                    ),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            color: Colors.blueGrey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // VERIFICATION STEPS
  // ============================================================

  Widget _buildVerificationSteps() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5EAF1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          _flowItem(
            number: '1',
            title: 'Inspection',
            subtitle:
                'Inspect the instrument and its condition.',
            icon: Icons.search_rounded,
            color: primaryBlue,
          ),

          _flowLine(),

          _flowItem(
            number: '2',
            title: 'Testing',
            subtitle:
                'Record test observations and measurements.',
            icon: Icons.science_rounded,
            color: teal,
          ),

          _flowLine(),

          _flowItem(
            number: '3',
            title: 'Evidence',
            subtitle:
                'Capture photographs as evidence.',
            icon: Icons.camera_alt_rounded,
            color: cyan,
          ),

          _flowLine(),

          _flowItem(
            number: '4',
            title: 'Location',
            subtitle:
                'Capture the verification GPS location.',
            icon: Icons.location_on_rounded,
            color: saffron,
          ),

          _flowLine(),

          _flowItem(
            number: '5',
            title: 'Result',
            subtitle:
                'Select the final verification result.',
            icon: Icons.rule_rounded,
            color: green,
          ),

          _flowLine(),

          _flowItem(
            number: '6',
            title: 'Review & Submit',
            subtitle:
                'Review everything and submit verification.',
            icon: Icons.fact_check_rounded,
            color: primaryBlue,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FLOW ITEM
  // ============================================================

  Widget _flowItem({
    required String number,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ------------------------------------------------------
        // NUMBER
        // ------------------------------------------------------

        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.18),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // ------------------------------------------------------
        // ICON
        // ------------------------------------------------------

        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.09),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            size: 21,
            color: color,
          ),
        ),

        const SizedBox(width: 12),

        // ------------------------------------------------------
        // TEXT
        // ------------------------------------------------------

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 1,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.4,
                    color: Colors.blueGrey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FLOW LINE
  // ============================================================

  Widget _flowLine() {
    return Container(
      height: 18,
      margin: const EdgeInsets.only(
        left: 16,
        top: 4,
        bottom: 4,
      ),
      alignment: Alignment.centerLeft,
      child: Container(
        width: 2,
        height: 18,
        decoration: BoxDecoration(
          color: const Color(0xFFD9E2EC),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // ============================================================
  // START BUTTON
  // ============================================================

  Widget _buildStartButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            primaryBlue,
            Color(0xFF1261B5),
          ],
        ),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.20),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _startVerification,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_arrow_rounded,
              size: 25,
            ),

            SizedBox(width: 8),

            Text(
              'START INSPECTION',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FOOTER NOTE
  // ============================================================

  Widget _buildFooterNote() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: primaryBlue,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 6),

              const Text(
                'MaapSetu',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                ),
              ),

              const SizedBox(width: 5),

              Text(
                '•',
                style: TextStyle(
                  color: Colors.blueGrey.shade400,
                ),
              ),

              const SizedBox(width: 5),

              Text(
                'Legal Metrology',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blueGrey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            'Digital Verification & Certification System',
            style: TextStyle(
              fontSize: 9.5,
              color: Colors.blueGrey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // START VERIFICATION
  // ============================================================

  void _startVerification() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => InspectionScreen(
          assignmentId: widget.assignmentId,
        ),
      ),
    );
  }
}