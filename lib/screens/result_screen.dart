import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final String assignmentId;

  const ResultScreen({
    super.key,
    required this.assignmentId,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color primaryBlue = Color(0xFF174EA6);
  // static const Color deepBlue = Color(0xFF0D47A1);
  static const Color teal = Color(0xFF00897B);
  // static const Color cyan = Color(0xFF00ACC1);
  static const Color saffron = Color(0xFFFFA000);
  static const Color green = Color(0xFF2E7D32);
  static const Color red = Color(0xFFC62828);
  static const Color lightBlue = Color(0xFFEAF3FF);
  static const Color background = Color(0xFFF4F7FB);
  static const Color textDark = Color(0xFF172B4D);
  static const Color textGrey = Color(0xFF64748B);

  // ==========================================================
  // STATE
  // ==========================================================

  String selectedResult = 'PENDING';

  final TextEditingController remarksController =
      TextEditingController();

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  // ==========================================================
  // SUBMIT RESULT
  // ==========================================================

  void submitResult() {
    final remarks = remarksController.text.trim();

    Navigator.pop(
      context,
      {
        'result': selectedResult,
        'remarks': remarks,
      },
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
        foregroundColor: textDark,
        centerTitle: false,
        titleSpacing: 4,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: textDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

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
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.fact_check_outlined,
                color: Colors.white,
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verification Result',
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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            18,
            18,
            18,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.16),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.fact_check_outlined,
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
                            'Review Verification',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Select the final result of this verification.',
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

              const SizedBox(height: 24),

              // ==================================================
              // RESULT SECTION TITLE
              // ==================================================

              const Text(
                'Verification Result',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Select the appropriate outcome based on your verification.',
                style: TextStyle(
                  fontSize: 12,
                  color: textGrey,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 14),

              // ==================================================
              // PASS
              // ==================================================

              _resultOption(
                value: 'PASS',
                title: 'PASS',
                description:
                    'The instrument/product meets the required standards.',
                icon: Icons.check_circle_outline,
                color: green,
                backgroundColor:
                    const Color(0xFFE8F5E9),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // FAIL
              // ==================================================

              _resultOption(
                value: 'FAIL',
                title: 'FAIL',
                description:
                    'The instrument/product does not meet the required standards.',
                icon: Icons.cancel_outlined,
                color: red,
                backgroundColor:
                    const Color(0xFFFFEBEE),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // PENDING
              // ==================================================

              _resultOption(
                value: 'PENDING',
                title: 'PENDING',
                description:
                    'The verification result requires further review.',
                icon: Icons.pending_outlined,
                color: saffron,
                backgroundColor:
                    const Color(0xFFFFF8E1),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // REMARKS SECTION
              // ==================================================

              const Text(
                'Remarks',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Add any additional observations or comments.',
                style: TextStyle(
                  fontSize: 12,
                  color: textGrey,
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // REMARKS CARD
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: remarksController,
                  maxLines: 5,
                  style: const TextStyle(
                    fontSize: 13,
                    color: textDark,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        'Enter verification remarks...',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: textGrey,
                    ),
                    filled: true,
                    fillColor: background,
                    contentPadding:
                        const EdgeInsets.all(14),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 8,
                        top: 12,
                      ),
                      child: Icon(
                        Icons.notes_outlined,
                        color: primaryBlue,
                        size: 20,
                      ),
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(
                      minWidth: 45,
                      minHeight: 45,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(13),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(13),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(13),
                      borderSide: const BorderSide(
                        color: primaryBlue,
                        width: 1.3,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // CONTINUE BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: submitResult,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                  ),
                  label: const Text(
                    'CONTINUE TO FINAL SUBMISSION',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.25,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // STEP INDICATOR
              // ==================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  _stepDot(false),
                  _stepLine(),
                  _stepDot(false),
                  _stepLine(),
                  _stepDot(false),
                  _stepLine(),
                  _stepDot(true),
                ],
              ),

              const SizedBox(height: 10),

              const Center(
                child: Text(
                  'Result • Step 5 of Verification',
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 5),
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
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  widget.assignmentId,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'STEP 5',
              style: TextStyle(
                color: primaryBlue,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // RESULT OPTION
  // ==========================================================

  Widget _resultOption({
    required String value,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
  }) {
    final bool selected = selectedResult == value;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        setState(() {
          selectedResult = value;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? backgroundColor
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? color
                : const Color(0xFFE2E8F0),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                selected ? 0.035 : 0.02,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white
                    : backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 26,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? color
                              : textDark,
                        ),
                      ),

                      if (selected) ...[
                        const SizedBox(width: 7),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'SELECTED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Radio<String>(
              value: value,
              groupValue: selectedResult,
              activeColor: color,
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedResult = value;
                });
              },
            ),
          ],
        ),
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
      width: 25,
      height: 1,
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      color: const Color(0xFFCBD5E1),
    );
  }
}