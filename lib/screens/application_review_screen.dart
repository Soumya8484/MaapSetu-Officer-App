import 'package:flutter/material.dart';

class ApplicationReviewScreen extends StatelessWidget {
  final Map<String, dynamic> applicationData;

  const ApplicationReviewScreen({
    super.key,
    required this.applicationData,
  });

  static const Color primaryColor = Color(0xFF123B6D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,

        iconTheme: const IconThemeData(
          color: primaryColor,
        ),

        title: const Text(
          'Application Review',
          style: TextStyle(
            color: Color(0xFF172B4D),
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

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
            // PAGE INTRODUCTION
            // =================================================

            _buildIntroduction(),

            const SizedBox(height: 20),

            // =================================================
            // BUSINESS DETAILS
            // =================================================

            _buildSectionCard(
              title: 'Business Details',
              icon: Icons.business_outlined,

              children: [
                _buildReadOnlyRow(
                  label: 'Business Name',
                  value: _getValue(
                    'businessName',
                    'Not available',
                  ),
                ),

                _buildReadOnlyRow(
                  label: 'Registration No.',
                  value: _getValue(
                    'registrationNo',
                    'Not available',
                  ),
                ),

                _buildReadOnlyRow(
                  label: 'Address',
                  value: _getValue(
                    'address',
                    'Not available',
                  ),

                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // =================================================
            // APPLICANT DETAILS
            // =================================================

            _buildSectionCard(
              title: 'Applicant Details',
              icon: Icons.person_outline,

              children: [
                _buildReadOnlyRow(
                  label: 'Name',
                  value: _getValue(
                    'applicantName',
                    'Not available',
                  ),
                ),

                _buildReadOnlyRow(
                  label: 'Email',
                  value: _getValue(
                    'email',
                    'Not available',
                  ),
                ),

                _buildReadOnlyRow(
                  label: 'Phone',
                  value: _getValue(
                    'phone',
                    'Not available',
                  ),

                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // =================================================
            // DOCUMENTS
            // =================================================

            _buildSectionCard(
              title: 'Documents',
              icon: Icons.folder_outlined,

              children: [
                _buildDocumentRow(
                  title: 'PAN',
                  verified:
                      _getBoolValue('panVerified'),
                ),

                _buildDocumentRow(
                  title: 'GST',
                  verified:
                      _getBoolValue('gstVerified'),
                ),

                _buildDocumentRow(
                  title: 'Registration Certificate',
                  verified:
                      _getBoolValue(
                        'registrationCertificateVerified',
                      ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // =================================================
            // VERIFICATION
            // =================================================

            _buildVerificationCard(),

            const SizedBox(height: 28),

            // =================================================
            // BUTTONS
            // =================================================

            Row(
              children: [
                // EDIT BUTTON

                Expanded(
                  child: SizedBox(
                    height: 52,

                    child: OutlinedButton.icon(
                      onPressed: () {
                        _editApplication(context);
                      },

                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 19,
                      ),

                      label: const Text(
                        'EDIT',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,

                        side: BorderSide(
                          color: primaryColor
                              .withOpacity(0.35),
                        ),

                        backgroundColor:
                            Colors.white,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // SUBMIT BUTTON

                Expanded(
                  child: SizedBox(
                    height: 52,

                    child: ElevatedButton.icon(
                      onPressed: () {
                        _submitApplication(context);
                      },

                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 19,
                      ),

                      label: const Text(
                        'SUBMIT',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            primaryColor,

                        foregroundColor:
                            Colors.white,

                        elevation: 0,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // =================================================
            // WARNING
            // =================================================

            _buildSubmitWarning(),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // INTRODUCTION
  // =========================================================

  Widget _buildIntroduction() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.06),

        borderRadius:
            BorderRadius.circular(12),

        border: Border.all(
          color: primaryColor.withOpacity(0.12),
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            Icons.fact_check_outlined,
            color: primaryColor,
            size: 24,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Review Application',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(0xFF172B4D),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Please review all verified information '
                  'carefully before submitting the application.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color:
                        Colors.grey.shade700,
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
  // SECTION CARD
  // =========================================================

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        16,
        15,
        16,
        5,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(12),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.025),

            blurRadius: 7,

            offset:
                const Offset(0, 2),
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
                width: 34,
                height: 34,

                decoration: BoxDecoration(
                  color:
                      primaryColor
                          .withOpacity(0.08),

                  borderRadius:
                      BorderRadius.circular(8),
                ),

                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 19,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      Color(0xFF172B4D),
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

  // =========================================================
  // READ ONLY ROW
  // =========================================================

  Widget _buildReadOnlyRow({
    required String label,
    required String value,
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
                      Color(0xFFF1F5F9),
                ),
              ),
            )
          : null,

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Expanded(
            flex: 4,

            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color:
                    Colors.grey.shade600,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            flex: 6,

            child: Text(
              value,

              textAlign:
                  TextAlign.right,

              style: const TextStyle(
                fontSize: 13,
                color:
                    Color(0xFF172B4D),
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DOCUMENT ROW
  // =========================================================

  Widget _buildDocumentRow({
    required String title,
    required bool verified,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 12,
      ),

      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF1F5F9),
          ),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 25,
            height: 25,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: verified
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFEBEE),
            ),

            child: Icon(
              verified
                  ? Icons.check
                  : Icons.close,

              size: 16,

              color: verified
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFC62828),
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight:
                    FontWeight.w600,
                color:
                    Color(0xFF172B4D),
              ),
            ),
          ),

          Text(
            verified
                ? 'Verified'
                : 'Not verified',

            style: TextStyle(
              fontSize: 11,
              fontWeight:
                  FontWeight.w700,

              color: verified
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFC62828),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // VERIFICATION CARD
  // =========================================================

  Widget _buildVerificationCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(12),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.025),

            blurRadius: 7,

            offset:
                const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color:
                  const Color(0xFFE8F5E9),

              borderRadius:
                  BorderRadius.circular(9),
            ),

            child: const Icon(
              Icons.verified_outlined,
              color:
                  Color(0xFF2E7D32),
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(0xFF172B4D),
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 17,
                      color:
                          Color(0xFF2E7D32),
                    ),

                    const SizedBox(width: 7),

                    Expanded(
                      child: Text(
                        'All required information verified',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color:
                              Colors.grey.shade700,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SUBMIT WARNING
  // =========================================================

  Widget _buildSubmitWarning() {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Icon(
          Icons.info_outline,
          size: 16,
          color: Colors.grey.shade500,
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Text(
            'After submission, the verified application '
            'may no longer be editable.',
            style: TextStyle(
              fontSize: 11,
              height: 1.4,
              color:
                  Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // GET STRING VALUE
  // =========================================================

  String _getValue(
    String key,
    String fallback,
  ) {
    final value = applicationData[key];

    if (value == null) {
      return fallback;
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return fallback;
    }

    return text;
  }

  // =========================================================
  // GET BOOLEAN VALUE
  // =========================================================

  bool _getBoolValue(
    String key,
  ) {
    final value = applicationData[key];

    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true';
    }

    return false;
  }

  // =========================================================
  // EDIT
  // =========================================================

  void _editApplication(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Edit functionality will be connected next.',
        ),
      ),
    );
  }

  // =========================================================
  // SUBMIT
  // =========================================================

  void _submitApplication(
    BuildContext context,
  ) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Submit Application?',
          ),

          content: const Text(
            'Please make sure all information '
            'has been reviewed correctly. '
            'Once submitted, the application '
            'may no longer be editable.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text(
                'CANCEL',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Submit API will be connected next.',
                    ),
                  ),
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    primaryColor,
                foregroundColor:
                    Colors.white,
              ),

              child: const Text(
                'SUBMIT',
              ),
            ),
          ],
        );
      },
    );
  }
}