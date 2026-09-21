import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:officer_app/features/auth/auth_service.dart';
import 'package:officer_app/models/test_observation.dart';

class ReviewVerificationScreen extends StatefulWidget {
  final String assignmentId;
  final String instrumentId;
  final String businessName;
  final List<TestObservation> observations;
  final List<XFile> photos;
  final double latitude;
  final double longitude;
  final String result;
  final String resultRemarks;

  const ReviewVerificationScreen({
    super.key,
    required this.assignmentId,
    required this.instrumentId,
    required this.businessName,
    required this.observations,
    required this.photos,
    required this.latitude,
    required this.longitude,
    required this.result,
    required this.resultRemarks,
  });

  @override
  State<ReviewVerificationScreen> createState() =>
      _ReviewVerificationScreenState();
}

class _ReviewVerificationScreenState
    extends State<ReviewVerificationScreen> {
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

  bool isSubmitting = false;

  // ==========================================================
  // SUBMIT VERIFICATION
  // ==========================================================

  Future<void> _submitVerification() async {
    if (isSubmitting) return;

    // ----------------------------------------------------------
    // VALIDATE OBSERVATIONS
    // ----------------------------------------------------------

    if (widget.observations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please complete at least one test observation.',
          ),
        ),
      );

      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final authService = AuthService();

      // --------------------------------------------------------
      // BACKEND CURRENTLY ACCEPTS ONE OBSERVATION
      // --------------------------------------------------------

      final observation = widget.observations.first;

      print('==============================================');
      print('SUBMITTING VERIFICATION');
      print('Application ID: ${widget.assignmentId}');
      print('Instrument ID: ${widget.instrumentId}');
      print('Result: ${widget.result}');
      print('Latitude: ${widget.latitude}');
      print('Longitude: ${widget.longitude}');
      print('==============================================');

      // --------------------------------------------------------
      // STEP 1: SAVE VERIFICATION
      // --------------------------------------------------------

      final verificationResponse =
          await authService.saveVerification(
        applicationId: widget.assignmentId,
        instrumentId: widget.instrumentId,
        latitude: widget.latitude,
        longitude: widget.longitude,
        testName: observation.parameter,
        standardValue: observation.requiredValue ?? 0.0,
        observedValue: observation.observedValue ?? 0.0,
        observationRemarks: observation.remarks,
        result: widget.result,
        remarks: widget.resultRemarks.isNotEmpty
            ? widget.resultRemarks
            : 'Verification submitted from officer app.',
        location:
            '${widget.latitude.toStringAsFixed(6)}, '
            '${widget.longitude.toStringAsFixed(6)}',
      );

      print('==============================================');
      print('VERIFICATION RESPONSE');
      print(verificationResponse);
      print('==============================================');

      if (verificationResponse['success'] != true) {
        throw Exception(
          verificationResponse['message'] ??
              'Failed to save verification.',
        );
      }

      // --------------------------------------------------------
      // STEP 2: GET VERIFICATION NUMBER
      // --------------------------------------------------------

      final verificationData =
          verificationResponse['verification'];

      if (verificationData == null) {
        throw Exception(
          'Verification was saved but verification data '
          'was not returned by the server.',
        );
      }

      final verificationNumber =
          verificationData['verificationId']?.toString();

      if (verificationNumber == null ||
          verificationNumber.isEmpty) {
        throw Exception(
          'Verification number was not returned by the server.',
        );
      }

      print('==============================================');
      print(
        'VERIFICATION NUMBER: $verificationNumber',
      );
      print('==============================================');

      // --------------------------------------------------------
      // STEP 3: GENERATE CERTIFICATE ONLY FOR PASS
      // --------------------------------------------------------

      Map<String, dynamic>? certificateResponse;

      if (widget.result.toUpperCase() == 'PASS') {
        print('==============================================');
        print('RESULT IS PASS');
        print('GENERATING CERTIFICATE...');
        print('==============================================');

        certificateResponse =
            await authService.createCertificate(
          verificationId: verificationNumber,
          applicationId: widget.assignmentId,
          instrumentId: widget.instrumentId,
          certificateType: 'Verification Certificate',
          status: 'Valid',
        );

        final certificate =
            certificateResponse['certificate'];

        if (certificate != null) {
          await authService.saveCertificateLocally(
            widget.assignmentId,
            Map<String, dynamic>.from(certificate),
          );

          print('CERTIFICATE SAVED LOCALLY');
        }

        print('==============================================');
        print('CERTIFICATE RESPONSE');
        print(certificateResponse);
        print('==============================================');

        if (certificateResponse['success'] != true) {
          throw Exception(
            certificateResponse['message'] ??
                'Verification saved, but certificate generation failed.',
          );
        }
      }

      // --------------------------------------------------------
      // STEP 4: SUCCESS MESSAGE
      // --------------------------------------------------------

      if (!mounted) return;

      final certificate =
          certificateResponse?['certificate'];

      final certificateNumber =
          certificate?['certificateNumber']?.toString();

      if (widget.result.toUpperCase() == 'PASS' &&
          certificateNumber != null &&
          certificateNumber.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Verification submitted successfully.\n'
              'Certificate: $certificateNumber',
            ),
            backgroundColor: green,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Verification submitted successfully!',
            ),
            backgroundColor: green,
            duration: Duration(seconds: 3),
          ),
        );
      }

      // --------------------------------------------------------
      // RETURN SUCCESS TO LOCATION SCREEN
      // --------------------------------------------------------

      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      print('==============================================');
      print('SUBMIT VERIFICATION ERROR');
      print(e);
      print('==============================================');

      if (!mounted) return;

      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to submit verification: $e',
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // ==========================================================
  // EDIT
  // ==========================================================

  void _editVerification() {
    Navigator.pop(context, false);
  }

  // ==========================================================
  // STATUS ROW
  // ==========================================================

  Widget _statusRow({
    required String title,
    required String value,
    required IconData icon,
    bool success = true,
  }) {
    final Color statusColor =
        success ? green : saffron;

    final Color statusBackground = success
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFF8E1);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusBackground,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: statusColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: statusBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final bool observationsComplete =
        widget.observations.isNotEmpty;

    final bool testResultsComplete =
        widget.observations.isNotEmpty;

    final bool locationComplete =
        widget.latitude != 0.0 &&
        widget.longitude != 0.0;

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
          onPressed: isSubmitting
              ? null
              : () => Navigator.pop(
                    context,
                    false,
                  ),
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Review',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'FINAL VERIFICATION',
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
                      offset: const Offset(0, 8),
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
                        color:
                            Colors.white.withOpacity(0.16),
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.verified_outlined,
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
                            'Final Review',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Review all verification information carefully before final submission.',
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
              // VERIFICATION SUMMARY
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
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
                          Colors.black.withOpacity(0.03),
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
                        borderRadius:
                            BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.fact_check_outlined,
                        color: primaryBlue,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 13),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verification Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w700,
                              color: textDark,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Review everything before submission',
                            style: TextStyle(
                              fontSize: 11,
                              color: textGrey,
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
                            Icons.check_circle,
                            size: 14,
                            color: green,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'REVIEW',
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
              ),

              const SizedBox(height: 22),

              // ==================================================
              // VERIFICATION DETAILS
              // ==================================================

              const Text(
                'Verification Details',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Application and instrument information.',
                style: TextStyle(
                  fontSize: 12,
                  color: textGrey,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
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
                          Colors.black.withOpacity(0.025),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _detailRow(
                      'Application',
                      widget.assignmentId,
                      Icons.assignment_outlined,
                    ),

                    const Divider(
                      height: 24,
                      color: Color(0xFFE2E8F0),
                    ),

                    _detailRow(
                      'Instrument',
                      widget.instrumentId,
                      Icons.scale_outlined,
                    ),

                    const Divider(
                      height: 24,
                      color: Color(0xFFE2E8F0),
                    ),

                    _detailRow(
                      'Business',
                      widget.businessName,
                      Icons.storefront_outlined,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // COMPLETION STATUS
              // ==================================================

              const Text(
                'Completion Status',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Verification steps completed in this inspection.',
                style: TextStyle(
                  fontSize: 12,
                  color: textGrey,
                ),
              ),

              const SizedBox(height: 12),

              _statusRow(
                title: 'Photos',
                value: '${widget.photos.length}',
                icon: Icons.photo_camera_outlined,
              ),

              _statusRow(
                title: 'Documents',
                value: '0',
                icon: Icons.description_outlined,
                success: false,
              ),

              _statusRow(
                title: 'Observations',
                value: observationsComplete
                    ? '✓'
                    : '✗',
                icon: Icons.analytics_outlined,
                success: observationsComplete,
              ),

              _statusRow(
                title: 'Test Results',
                value: testResultsComplete
                    ? '✓'
                    : '✗',
                icon: Icons.science_outlined,
                success: testResultsComplete,
              ),

              _statusRow(
                title: 'Location',
                value: locationComplete
                    ? '✓'
                    : '✗',
                icon: Icons.location_on_outlined,
                success: locationComplete,
              ),

              const SizedBox(height: 7),

              // ==================================================
              // LOCATION
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(17),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius:
                            BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.gps_fixed,
                        color: primaryBlue,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Verification GPS Location',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w700,
                              color: textDark,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            '${widget.latitude.toStringAsFixed(6)}, '
                            '${widget.longitude.toStringAsFixed(6)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: textGrey,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.check_circle,
                      color: green,
                      size: 19,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // RESULT
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
                'Final outcome selected for this verification.',
                style: TextStyle(
                  fontSize: 12,
                  color: textGrey,
                ),
              ),

              const SizedBox(height: 12),

              _resultCard(),

              // ==================================================
              // RESULT REMARKS
              // ==================================================

              if (widget.resultRemarks.isNotEmpty) ...[
                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(17),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: lightBlue,
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.notes_outlined,
                              color: primaryBlue,
                              size: 19,
                            ),
                          ),

                          const SizedBox(width: 10),

                          const Text(
                            'Result Remarks',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w700,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.resultRemarks,
                          style: const TextStyle(
                            fontSize: 12,
                            color: textGrey,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 28),

              // ==================================================
              // EDIT BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: isSubmitting
                      ? null
                      : _editVerification,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 19,
                  ),
                  label: const Text(
                    'EDIT VERIFICATION',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryBlue,
                    side: const BorderSide(
                      color: primaryBlue,
                      width: 1.3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // SUBMIT BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: isSubmitting
                      ? null
                      : _submitVerification,
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 21,
                          height: 21,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2.3,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.verified_outlined,
                          size: 21,
                        ),
                  label: Text(
                    isSubmitting
                        ? 'SUBMITTING...'
                        : 'SUBMIT VERIFICATION',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        const Color(0xFFDDE3EA),
                    disabledForegroundColor: textGrey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

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
                  'Review & Submit • Final Step',
                  style: TextStyle(
                    fontSize: 11,
                    color: textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Center(
                child: Text(
                  'Please review the information carefully before submitting.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: textGrey,
                    height: 1.4,
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
  // RESULT CARD
  // ==========================================================

  Widget _resultCard() {
    final String result =
        widget.result.toUpperCase();

    final bool isPass = result == 'PASS';
    final bool isFail = result == 'FAIL';

    final Color resultColor = isPass
        ? green
        : isFail
            ? red
            : saffron;

    final Color resultBackground = isPass
        ? const Color(0xFFE8F5E9)
        : isFail
            ? const Color(0xFFFFEBEE)
            : const Color(0xFFFFF8E1);

    final Color borderColor = isPass
        ? const Color(0xFFB7DFBF)
        : isFail
            ? const Color(0xFFFFB8B8)
            : const Color(0xFFFFD88A);

    final IconData resultIcon = isPass
        ? Icons.check_circle
        : isFail
            ? Icons.cancel
            : Icons.pending;

    final String statusText = isPass
        ? 'Ready to submit'
        : isFail
            ? 'Verification failed'
            : 'Pending review';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: resultBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
          width: 1.2,
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
                  BorderRadius.circular(13),
            ),
            child: Icon(
              resultIcon,
              color: resultColor,
              size: 28,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  result,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: resultColor,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: resultColor,
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
              color: Colors.white.withOpacity(0.75),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Text(
              isPass
                  ? 'APPROVED'
                  : isFail
                      ? 'FAILED'
                      : 'PENDING',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: resultColor,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DETAIL ROW
  // ==========================================================

  Widget _detailRow(
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: lightBlue,
            borderRadius:
                BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: primaryBlue,
            size: 18,
          ),
        ),

        const SizedBox(width: 12),

        SizedBox(
          width: 85,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 9),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 7),
            child: Text(
              value.isEmpty
                  ? 'Not available'
                  : value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textDark,
                height: 1.35,
              ),
            ),
          ),
        ),
      ],
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