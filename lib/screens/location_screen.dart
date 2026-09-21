import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:officer_app/features/auth/auth_service.dart';
import 'package:officer_app/models/test_observation.dart';
import 'package:officer_app/screens/review_verfication_screen.dart';
import 'result_screen.dart';

class LocationScreen extends StatefulWidget {
  final String assignmentId;
  final List<TestObservation> observations;
  final List<XFile> photos;

  const LocationScreen({
    super.key,
    required this.assignmentId,
    required this.observations,
    required this.photos,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color primaryBlue = Color(0xFF174EA6);
  // static const Color deepBlue = Color(0xFF0D47A1);
  static const Color teal = Color(0xFF00897B);
  // static const Color cyan = Color(0xFF00ACC1);
  // static const Color saffron = Color(0xFFFFA000);
  static const Color green = Color(0xFF2E7D32);
  static const Color lightBlue = Color(0xFFEAF3FF);
  static const Color background = Color(0xFFF4F7FB);
  static const Color textDark = Color(0xFF172B4D);
  static const Color textGrey = Color(0xFF64748B);

  // ==========================================================
  // LOCATION DATA
  // ==========================================================

  double? latitude;
  double? longitude;

  bool isLoading = false;

  // ==========================================================
  // CAPTURE LOCATION
  // ==========================================================

  Future<void> captureLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      // --------------------------------------------------------
      // CHECK LOCATION SERVICE
      // --------------------------------------------------------

      final bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please turn on location/GPS.',
            ),
          ),
        );

        return;
      }

      // --------------------------------------------------------
      // CHECK PERMISSION
      // --------------------------------------------------------

      LocationPermission permission =
          await Geolocator.checkPermission();

      // --------------------------------------------------------
      // REQUEST PERMISSION
      // --------------------------------------------------------

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          if (!mounted) return;

          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location permission denied.',
              ),
            ),
          );

          return;
        }
      }

      // --------------------------------------------------------
      // PERMANENTLY DENIED
      // --------------------------------------------------------

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission is permanently denied. '
              'Please enable it from Settings.',
            ),
          ),
        );

        return;
      }

      // --------------------------------------------------------
      // GET CURRENT LOCATION
      // --------------------------------------------------------

      final Position position =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location captured successfully.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error getting location: $e',
          ),
        ),
      );
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final bool locationCaptured =
        latitude != null && longitude != null;

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
                Icons.location_on_outlined,
                color: Colors.white,
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
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
                        Icons.location_on_outlined,
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
                            'Verification Location',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Capture the GPS location where the verification is being performed.',
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

              const SizedBox(height: 16),

              // ==================================================
              // LOCATION STATUS CARD
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
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
                child: Column(
                  children: [
                    // ------------------------------------------------
                    // GPS ICON
                    // ------------------------------------------------

                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        color: locationCaptured
                            ? const Color(0xFFE8F5E9)
                            : lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: locationCaptured
                              ? const Color(0xFFDFF2E2)
                              : const Color(0xFFDCEBFF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          locationCaptured
                              ? Icons.location_on
                              : Icons.location_searching,
                          size: 36,
                          color: locationCaptured
                              ? green
                              : primaryBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 17),

                    // ------------------------------------------------
                    // STATUS
                    // ------------------------------------------------

                    Text(
                      locationCaptured
                          ? 'Location Captured'
                          : 'Location Not Captured',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      locationCaptured
                          ? 'GPS coordinates have been successfully captured.'
                          : 'Capture your current location before continuing.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: textGrey,
                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ------------------------------------------------
                    // STATUS CHIP
                    // ------------------------------------------------

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: locationCaptured
                            ? const Color(0xFFE8F5E9)
                            : lightBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            locationCaptured
                                ? Icons.check_circle
                                : Icons.gps_fixed,
                            size: 15,
                            color: locationCaptured
                                ? green
                                : primaryBlue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            locationCaptured
                                ? 'GPS VERIFIED'
                                : 'GPS REQUIRED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: locationCaptured
                                  ? green
                                  : primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // COORDINATES CARD
              // ==================================================

              if (locationCaptured) ...[
                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
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
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // ------------------------------------------------
                      // TITLE
                      // ------------------------------------------------

                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: lightBlue,
                              borderRadius:
                                  BorderRadius.circular(11),
                            ),
                            child: const Icon(
                              Icons.my_location,
                              size: 19,
                              color: primaryBlue,
                            ),
                          ),

                          const SizedBox(width: 11),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Captured Coordinates',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w700,
                                    color: textDark,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Current verification location',
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
                              horizontal: 9,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFE8F5E9),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.verified,
                              color: green,
                              size: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const Divider(
                        height: 1,
                        color: Color(0xFFE2E8F0),
                      ),

                      const SizedBox(height: 15),

                      // ------------------------------------------------
                      // LATITUDE
                      // ------------------------------------------------

                      _coordinateRow(
                        icon: Icons.north,
                        label: 'Latitude',
                        value: latitude!.toStringAsFixed(6),
                      ),

                      const SizedBox(height: 14),

                      // ------------------------------------------------
                      // LONGITUDE
                      // ------------------------------------------------

                      _coordinateRow(
                        icon: Icons.east,
                        label: 'Longitude',
                        value: longitude!.toStringAsFixed(6),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // ==================================================
              // CAPTURE LOCATION BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed:
                      isLoading ? null : captureLocation,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          locationCaptured
                              ? Icons.refresh_rounded
                              : Icons.location_on_outlined,
                        ),
                  label: Text(
                    isLoading
                        ? 'Getting Location...'
                        : locationCaptured
                            ? 'RECAPTURE LOCATION'
                            : 'CAPTURE LOCATION',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
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
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // SAVE VERIFICATION BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: locationCaptured
                      ? _saveVerification
                      : null,
                  icon: const Icon(
                    Icons.verified_outlined,
                    size: 20,
                  ),
                  label: const Text(
                    'SAVE VERIFICATION',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        const Color(0xFFDDE3EA),
                    disabledForegroundColor: textGrey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // STEP INDICATOR
              // ==================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  'Location • Step 4 of Verification',
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
              'STEP 4',
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
  // COORDINATE ROW
  // ==========================================================

  Widget _coordinateRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: lightBlue,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            size: 17,
            color: primaryBlue,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
            ],
          ),
        ),

        const Icon(
          Icons.check_circle,
          size: 17,
          color: green,
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

  // ==========================================================
  // SAVE VERIFICATION
  // ==========================================================

  Future<void> _saveVerification() async {
    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please capture your location first.',
          ),
        ),
      );

      return;
    }

    if (widget.observations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please add at least one test observation.',
          ),
        ),
      );

      return;
    }

    try {
      // --------------------------------------------------------
      // GET APPLICATION DETAILS
      // --------------------------------------------------------

      final authService = AuthService();

      final application =
          await authService.getInspectorApplicationDetails(
        widget.assignmentId,
      );

      if (!mounted) return;

      // --------------------------------------------------------
      // GET INSTRUMENT ID
      // --------------------------------------------------------

      final instrumentId =
          application['instrumentId']?.toString() ?? '';

      if (instrumentId.isEmpty) {
        throw Exception(
          'Instrument ID not found for this assignment.',
        );
      }

      // --------------------------------------------------------
      // GET BUSINESS NAME
      // --------------------------------------------------------

      final businessName =
          application['applicant']?.toString() ??
              application['businessName']?.toString() ??
              'Business';

      // --------------------------------------------------------
      // GO TO RESULT SCREEN
      // --------------------------------------------------------

      final resultData =
          await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            assignmentId: widget.assignmentId,
          ),
        ),
      );

      if (!mounted) return;

      // --------------------------------------------------------
      // USER PRESSED BACK WITHOUT SUBMITTING RESULT
      // --------------------------------------------------------

      if (resultData == null) {
        return;
      }

      final selectedResult =
          resultData['result']?.toString() ?? 'PENDING';

      final resultRemarks =
          resultData['remarks']?.toString() ?? '';

      // --------------------------------------------------------
      // GO TO REVIEW SCREEN
      // --------------------------------------------------------

      final reviewResult =
          await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => ReviewVerificationScreen(
            assignmentId: widget.assignmentId,
            instrumentId: instrumentId,
            businessName: businessName,
            observations: widget.observations,
            photos: widget.photos,
            latitude: latitude!,
            longitude: longitude!,
            result: selectedResult,
            resultRemarks: resultRemarks,
          ),
        ),
      );

      if (!mounted) return;

      // --------------------------------------------------------
      // REVIEW COMPLETED
      // --------------------------------------------------------

      if (reviewResult == true) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to continue verification: $e',
          ),
        ),
      );
    }
  }
}