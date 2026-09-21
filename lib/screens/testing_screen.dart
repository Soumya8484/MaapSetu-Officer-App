import 'package:flutter/material.dart';
import 'package:officer_app/screens/evidence_screen.dart';
import '../models/test_observation.dart';

class TestingScreen extends StatefulWidget {
  final String assignmentId;

  const TestingScreen({
    super.key,
    required this.assignmentId,
  });

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color primaryBlue = Color(0xFF174EA6);
  // static const Color deepBlue = Color(0xFF0D47A1);
  static const Color teal = Color(0xFF00897B);
  static const Color cyan = Color(0xFF00ACC1);
  static const Color saffron = Color(0xFFFFA000);
  static const Color green = Color(0xFF2E7D32);
  static const Color lightBlue = Color(0xFFEAF3FF);
  static const Color background = Color(0xFFF4F7FB);
  static const Color textDark = Color(0xFF172B4D);
  static const Color textGrey = Color(0xFF64748B);

  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  final parameterController = TextEditingController();
  final observedValueController = TextEditingController();
  final requiredValueController = TextEditingController();
  final remarksController = TextEditingController();

  // ==========================================================
  // OBSERVATIONS
  // ==========================================================

  final List<TestObservation> observations = [];

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    parameterController.dispose();
    observedValueController.dispose();
    requiredValueController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  // ==========================================================
  // ADD OBSERVATION
  // ==========================================================

  void addObservation() {
    final parameter = parameterController.text.trim();

    final observedText =
        observedValueController.text.trim();

    final requiredText =
        requiredValueController.text.trim();

    final remarks =
        remarksController.text.trim();

    // --------------------------------------------------------
    // VALIDATE PARAMETER
    // --------------------------------------------------------

    if (parameter.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a parameter',
          ),
        ),
      );

      return;
    }

    // --------------------------------------------------------
    // PARSE VALUES
    // --------------------------------------------------------

    final observedValue =
        double.tryParse(observedText);

    final requiredValue =
        double.tryParse(requiredText);

    // --------------------------------------------------------
    // CREATE OBSERVATION
    // --------------------------------------------------------

    final observation = TestObservation(
      parameter: parameter,
      observedValue: observedValue,
      requiredValue: requiredValue,
      remarks: remarks,
    );

    // --------------------------------------------------------
    // ADD TO LIST
    // --------------------------------------------------------

    setState(() {
      observations.add(observation);

      parameterController.clear();
      observedValueController.clear();
      requiredValueController.clear();
      remarksController.clear();
    });

    // --------------------------------------------------------
    // CONFIRMATION
    // --------------------------------------------------------

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Observation added successfully',
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // ==========================================================
  // CONTINUE TO EVIDENCE
  // ==========================================================

  void continueToEvidence() {
    if (observations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please add at least one observation',
          ),
        ),
      );

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EvidenceScreen(
          assignmentId: widget.assignmentId,
          observations: observations,
        ),
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: true,
        titleSpacing: 4,

        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    primaryBlue,
                    teal,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.science_outlined,
                color: Colors.white,
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            const Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Testing',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'FIELD VERIFICATION',
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
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
        padding: const EdgeInsets.fromLTRB(
          18,
          18,
          18,
          30,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            // ==================================================
            // PAGE HEADER
            // ==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    primaryBlue,
                    teal,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color:
                        primaryBlue.withOpacity(0.16),
                    blurRadius: 18,
                    offset:
                        const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.16),
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.analytics_outlined,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Observations',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Record measurements and compare them with permitted values.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // ASSIGNMENT CARD
            // ==================================================

            _assignmentCard(),

            const SizedBox(height: 26),

            // ==================================================
            // SECTION TITLE
            // ==================================================

            _sectionTitle(
              icon: Icons.edit_note_outlined,
              title: 'Enter Observation',
              subtitle:
                  'Add measurement details for this verification.',
            ),

            const SizedBox(height: 14),

            // ==================================================
            // PARAMETER
            // ==================================================

            _inputCard(
              icon: Icons.tune_outlined,
              iconColor: primaryBlue,
              title: 'Parameter',
              subtitle:
                  'Measurement parameter being tested',
              child: TextField(
                controller: parameterController,
                textInputAction:
                    TextInputAction.next,
                decoration: _inputDecoration(
                  'e.g. Accuracy',
                ),
              ),
            ),

            // ==================================================
            // OBSERVED VALUE
            // ==================================================

            _inputCard(
              icon: Icons.analytics_outlined,
              iconColor: teal,
              title: 'Observed Value',
              subtitle:
                  'Value measured during testing',
              child: TextField(
                controller:
                    observedValueController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction:
                    TextInputAction.next,
                decoration: _inputDecoration(
                  'Enter observed value',
                ),
              ),
            ),

            // ==================================================
            // REQUIRED VALUE
            // ==================================================

            _inputCard(
              icon: Icons.rule_outlined,
              iconColor: saffron,
              title: 'Required / Permitted Value',
              subtitle:
                  'Applicable permitted or standard value',
              child: TextField(
                controller:
                    requiredValueController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction:
                    TextInputAction.next,
                decoration: _inputDecoration(
                  'Enter required value',
                ),
              ),
            ),

            // ==================================================
            // REMARKS
            // ==================================================

            _inputCard(
              icon: Icons.notes_outlined,
              iconColor: cyan,
              title: 'Remarks',
              subtitle:
                  'Additional observation notes',
              child: TextField(
                controller: remarksController,
                maxLines: 3,
                textInputAction:
                    TextInputAction.newline,
                decoration: _inputDecoration(
                  'Enter remarks',
                ),
              ),
            ),

            const SizedBox(height: 4),

            // ==================================================
            // ADD OBSERVATION BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: addObservation,
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 20,
                ),
                label: const Text(
                  'ADD OBSERVATION',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      primaryBlue,
                  backgroundColor:
                      Colors.white,
                  side: const BorderSide(
                    color: primaryBlue,
                    width: 1.3,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),

            // ==================================================
            // ADDED OBSERVATIONS
            // ==================================================

            if (observations.isNotEmpty) ...[
              const SizedBox(height: 28),

              _sectionTitle(
                icon:
                    Icons.fact_check_outlined,
                title: 'Added Observations',
                subtitle:
                    'Review the measurements recorded so far.',
              ),

              const SizedBox(height: 14),

              ...observations
                  .asMap()
                  .entries
                  .map(
                (entry) {
                  final index =
                      entry.key;
                  final observation =
                      entry.value;

                  return _observationCard(
                    index + 1,
                    observation,
                  );
                },
              ),
            ],

            const SizedBox(height: 18),

            // ==================================================
            // SAVE & CONTINUE
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed:
                    observations.isEmpty
                        ? null
                        : continueToEvidence,
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                ),
                label: const Text(
                  'SAVE & CONTINUE',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      primaryBlue,
                  foregroundColor:
                      Colors.white,
                  disabledBackgroundColor:
                      const Color(0xFFDDE3EA),
                  disabledForegroundColor:
                      textGrey,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ==================================================
            // STEP INDICATOR
            // ==================================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                _stepDot(false),
                _stepLine(),
                _stepDot(true),
                _stepLine(),
                _stepDot(false),
              ],
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                'Testing • Step 2 of Verification',
                style: TextStyle(
                  fontSize: 11,
                  color: textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // ASSIGNMENT CARD
  // ==========================================================

  Widget _assignmentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset:
                const Offset(0, 5),
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
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.assignment_outlined,
              color: primaryBlue,
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'ASSIGNMENT ID',
                  style: TextStyle(
                    fontSize: 10,
                    color: textGrey,
                    fontWeight:
                        FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  widget.assignmentId,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color:
                  const Color(0xFFE8F5E9),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: 7,
                  color: green,
                ),
                SizedBox(width: 5),
                Text(
                  'TESTING',
                  style: TextStyle(
                    color: green,
                    fontSize: 9,
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

  // ==========================================================
  // SECTION TITLE
  // ==========================================================

  Widget _sectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: lightBlue,
            borderRadius:
                BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: primaryBlue,
            size: 20,
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
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w700,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: textGrey,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // INPUT CARD
  // ==========================================================

  Widget _inputCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin:
          const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset:
                const Offset(0, 4),
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
                      iconColor.withOpacity(0.09),
                  borderRadius:
                      BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
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
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w700,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      subtitle,
                      style:
                          const TextStyle(
                        fontSize: 11,
                        color: textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          child,
        ],
      ),
    );
  }

  // ==========================================================
  // INPUT DECORATION
  // ==========================================================

  InputDecoration _inputDecoration(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(
        color: Color(0xFF94A3B8),
        fontSize: 13,
      ),

      filled: true,

      fillColor:
          const Color(0xFFF8FAFC),

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: primaryBlue,
          width: 1.5,
        ),
      ),
    );
  }

  // ==========================================================
  // OBSERVATION CARD
  // ==========================================================

  Widget _observationCard(
    int number,
    TestObservation observation,
  ) {
    return Container(
      width: double.infinity,
      margin:
          const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset:
                const Offset(0, 4),
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
                width: 38,
                height: 38,
                alignment:
                    Alignment.center,
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      primaryBlue,
                      teal,
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(11),
                ),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Text(
                  observation.parameter,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                    color: textDark,
                  ),
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFE8F5E9),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: const Text(
                  'RECORDED',
                  style: TextStyle(
                    color: green,
                    fontSize: 8,
                    fontWeight:
                        FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            height: 1,
            color:
                const Color(0xFFEFF2F5),
          ),

          const SizedBox(height: 13),

          _observationRow(
            Icons.analytics_outlined,
            'Observed Value',
            observation.observedValue
                    ?.toString() ??
                '-',
            teal,
          ),

          _observationRow(
            Icons.rule_outlined,
            'Required Value',
            observation.requiredValue
                    ?.toString() ??
                '-',
            saffron,
          ),

          _observationRow(
            Icons.notes_outlined,
            'Remarks',
            observation.remarks.isEmpty
                ? '-'
                : observation.remarks,
            cyan,
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // OBSERVATION ROW
  // ==========================================================

  Widget _observationRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color:
                  iconColor.withOpacity(0.08),
              borderRadius:
                  BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 15,
            ),
          ),

          const SizedBox(width: 9),

          SizedBox(
            width: 100,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 5),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: textGrey,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 5),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w600,
                  color: textDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // STEP DOT
  // ==========================================================

  Widget _stepDot(bool active) {
    return Container(
      width: active ? 10 : 8,
      height: active ? 10 : 8,
      decoration: BoxDecoration(
        color: active
            ? primaryBlue
            : const Color(0xFFCBD5E1),
        shape: BoxShape.circle,
      ),
    );
  }

  // ==========================================================
  // STEP LINE
  // ==========================================================

  Widget _stepLine() {
    return Container(
      width: 35,
      height: 1,
      margin:
          const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      color:
          const Color(0xFFCBD5E1),
    );
  }
}