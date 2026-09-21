import 'package:flutter/material.dart';
import 'package:officer_app/screens/testing_screen.dart';

class InspectionScreen extends StatefulWidget {
  final String assignmentId;

  const InspectionScreen({
    super.key,
    required this.assignmentId,
  });

  @override
  State<InspectionScreen> createState() =>
      _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF174EA6);
  // static const Color deepBlue = Color(0xFF0D47A1);
  static const Color teal = Color(0xFF00897B);
  static const Color cyan = Color(0xFF00ACC1);
  // static const Color saffron = Color(0xFFFFA000);
  // static const Color green = Color(0xFF2E7D32);

  static const Color lightBlue = Color(0xFFEAF3FF);
  static const Color background = Color(0xFFF4F7FB);
  static const Color textDark = Color(0xFF172B4D);
  static const Color textGrey = Color(0xFF64748B);

  // ============================================================
  // STATE
  // ============================================================

  bool physicalCondition = false;
  bool markingsChecked = false;
  bool documentsChecked = false;

  final remarksController = TextEditingController();

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

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
                    color: primaryBlue.withOpacity(0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.checklist_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),

            const SizedBox(width: 12),

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inspection',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'FIELD VERIFICATION',
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.9,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          18,
          10,
          18,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ==================================================
            // PAGE HEADER
            // ==================================================

            _buildPageHeader(),

            const SizedBox(height: 20),

            // ==================================================
            // ASSIGNMENT CARD
            // ==================================================

            _buildAssignmentCard(),

            const SizedBox(height: 28),

            // ==================================================
            // INSPECTION CHECKS HEADER
            // ==================================================

            _buildSectionHeader(
              title: 'Inspection Checks',
              subtitle: 'Verify the condition and required details',
            ),

            const SizedBox(height: 14),

            // ==================================================
            // CHECK CARDS
            // ==================================================

            _checkCard(
              icon: Icons.build_rounded,
              title: 'Physical Condition',
              subtitle:
                  'Instrument is physically in acceptable condition.',
              value: physicalCondition,
              color: primaryBlue,
              onChanged: (value) {
                setState(() {
                  physicalCondition = value;
                });
              },
            ),

            _checkCard(
              icon: Icons.label_rounded,
              title: 'Markings Checked',
              subtitle:
                  'Required markings and verification labels checked.',
              value: markingsChecked,
              color: teal,
              onChanged: (value) {
                setState(() {
                  markingsChecked = value;
                });
              },
            ),

            _checkCard(
              icon: Icons.description_rounded,
              title: 'Documents Checked',
              subtitle:
                  'Required documents and certificates checked.',
              value: documentsChecked,
              color: cyan,
              onChanged: (value) {
                setState(() {
                  documentsChecked = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // ==================================================
            // REMARKS
            // ==================================================

            _buildSectionHeader(
              title: 'Inspection Remarks',
              subtitle: 'Add any observations from the inspection',
            ),

            const SizedBox(height: 14),

            _buildRemarksCard(),

            const SizedBox(height: 28),

            // ==================================================
            // SAVE & CONTINUE
            // ==================================================

            _buildContinueButton(),

            const SizedBox(height: 14),

            // ==================================================
            // STEP INDICATOR
            // ==================================================

            _buildStepIndicator(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PAGE HEADER
  // ============================================================

  Widget _buildPageHeader() {
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
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withOpacity(0.22),
              ),
            ),
            child: const Icon(
              Icons.fact_check_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inspection Checklist',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Check the instrument and verify required details.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11.5,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
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
  // ASSIGNMENT CARD
  // ============================================================

  Widget _buildAssignmentCard() {
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
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.assignment_rounded,
              color: primaryBlue,
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ASSIGNMENT ID',
                  style: TextStyle(
                    fontSize: 9.5,
                    color: textGrey,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Current Assignment',
                  style: TextStyle(
                    fontSize: 13,
                    color: textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                widget.assignmentId,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: primaryBlue,
                  fontWeight: FontWeight.w800,
                ),
              ),
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
  // CHECK CARD
  // ============================================================

  Widget _checkCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color color,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: value
              ? color.withOpacity(0.35)
              : const Color(0xFFE5EAF1),
          width: value ? 1.2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ----------------------------------------------------
          // ICON
          // ----------------------------------------------------

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: value
                  ? color.withOpacity(0.10)
                  : const Color(0xFFF3F6FA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: value
                  ? color
                  : Colors.blueGrey.shade500,
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          // ----------------------------------------------------
          // TEXT
          // ----------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    fontSize: 11,
                    height: 1.35,
                    color: Colors.blueGrey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ----------------------------------------------------
          // CHECKBOX
          // ----------------------------------------------------

          Transform.scale(
            scale: 1.05,
            child: Checkbox(
              value: value,
              activeColor: color,
              checkColor: Colors.white,
              side: BorderSide(
                color: Colors.blueGrey.shade300,
                width: 1.4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              onChanged: (newValue) {
                onChanged(newValue ?? false);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REMARKS CARD
  // ============================================================

  Widget _buildRemarksCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.notes_rounded,
                  color: primaryBlue,
                  size: 20,
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  'Observation Notes',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'OPTIONAL',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: textGrey,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: const Color(0xFFE8EDF3),
              ),
            ),
            child: TextField(
              controller: remarksController,
              maxLines: 5,
              style: const TextStyle(
                fontSize: 12.5,
                color: textDark,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Enter inspection remarks...',
                hintStyle: TextStyle(
                  color: Colors.blueGrey.shade400,
                  fontSize: 12,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTINUE BUTTON
  // ============================================================

  Widget _buildContinueButton() {
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
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => TestingScreen(
                assignmentId: widget.assignmentId,
              ),
            ),
          );
        },
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
            Text(
              'SAVE & CONTINUE',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
                letterSpacing: 0.4,
              ),
            ),

            SizedBox(width: 8),

            Icon(
              Icons.arrow_forward_rounded,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STEP INDICATOR
  // ============================================================

  Widget _buildStepIndicator() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _stepDot(
                active: true,
              ),

              _stepLine(),

              _stepDot(
                active: false,
              ),

              _stepLine(),

              _stepDot(
                active: false,
              ),

              _stepLine(),

              _stepDot(
                active: false,
              ),

              _stepLine(),

              _stepDot(
                active: false,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Inspection • Step 1 of Verification',
            style: TextStyle(
              fontSize: 10.5,
              color: Colors.blueGrey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STEP DOT
  // ============================================================

  Widget _stepDot({
    required bool active,
  }) {
    return Container(
      width: active ? 9 : 7,
      height: active ? 9 : 7,
      decoration: BoxDecoration(
        color: active
            ? primaryBlue
            : const Color(0xFFD7E0EA),
        shape: BoxShape.circle,
      ),
    );
  }

  // ============================================================
  // STEP LINE
  // ============================================================

  Widget _stepLine() {
    return Container(
      width: 22,
      height: 1.5,
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      color: const Color(0xFFD7E0EA),
    );
  }
}