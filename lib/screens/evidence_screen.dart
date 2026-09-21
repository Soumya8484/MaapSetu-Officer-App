import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:officer_app/models/test_observation.dart';
import 'package:officer_app/screens/location_screen.dart';

class EvidenceScreen extends StatefulWidget {
  final String assignmentId;
  final List<TestObservation> observations;

  const EvidenceScreen({
    super.key,
    required this.assignmentId,
    required this.observations,
  });

  @override
  State<EvidenceScreen> createState() =>
      _EvidenceScreenState();
}

class _EvidenceScreenState extends State<EvidenceScreen> {
  // ==========================================================
  // IMAGE PICKER
  // ==========================================================

  final ImagePicker picker = ImagePicker();
  final List<XFile> photos = [];

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
  // CAPTURE PHOTO
  // ==========================================================

  Future<void> capturePhoto() async {
    try {
      final photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          photos.add(photo);
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to capture photo: $e',
          ),
        ),
      );
    }
  }

  // ==========================================================
  // REMOVE PHOTO
  // ==========================================================

  void removePhoto(int index) {
    setState(() {
      photos.removeAt(index);
    });
  }

  // ==========================================================
  // CONTINUE TO LOCATION
  // ==========================================================

  void continueToLocation() {
    if (photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please capture at least one photo',
          ),
        ),
      );

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LocationScreen(
          assignmentId: widget.assignmentId,
          observations: widget.observations,
          photos: photos,
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
        foregroundColor: textDark,
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
                Icons.camera_alt_outlined,
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
                  'Evidence',
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
                      color:
                          Colors.white.withOpacity(0.16),
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.photo_camera_outlined,
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
                          'Evidence & Documents',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          'Capture clear photographic evidence for this verification.',
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
            // INSTRUCTION CARD
            // ==================================================

            _instructionCard(),

            const SizedBox(height: 18),

            // ==================================================
            // CAMERA BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: capturePhoto,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      primaryBlue,
                  foregroundColor:
                      Colors.white,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  size: 21,
                ),
                label: const Text(
                  'CAPTURE PHOTO',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // PHOTO SECTION HEADER
            // ==================================================

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
                    Icons.collections_outlined,
                    color: primaryBlue,
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
                        'Captured Evidence',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Photos captured during field verification',
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
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${photos.length} '
                    '${photos.length == 1 ? 'Photo' : 'Photos'}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight:
                          FontWeight.w700,
                      color: primaryBlue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ==================================================
            // PHOTO GRID / EMPTY STATE
            // ==================================================

            if (photos.isEmpty)
              _emptyPhotoState(),

            if (photos.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: photos.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder:
                    (context, index) {
                  return _photoCard(index);
                },
              ),

            const SizedBox(height: 28),

            // ==================================================
            // SAVE & CONTINUE
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed:
                    photos.isEmpty
                        ? null
                        : continueToLocation,
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
                child: const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      'SAVE & CONTINUE',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 0.3,
                      ),
                    ),

                    SizedBox(width: 9),

                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                    ),
                  ],
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
                _stepDot(true),
                _stepLine(),
                _stepDot(false),
              ],
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                'Evidence • Step 3 of Verification',
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
                  'EVIDENCE',
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
  // INSTRUCTION CARD
  // ==========================================================

  Widget _instructionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            lightBlue,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
            BorderRadius.circular(17),
        border: Border.all(
          color:
              primaryBlue.withOpacity(0.10),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.info_outline,
              color: primaryBlue,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Evidence Required',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                    color: textDark,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Capture clear photographs of the instrument, serial number, markings and test setup.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: textGrey,
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
  // EMPTY PHOTO STATE
  // ==========================================================

  Widget _emptyPhotoState() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 38,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: lightBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.photo_camera_outlined,
              size: 32,
              color: primaryBlue,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'No evidence captured',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w700,
              color: textDark,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Use the camera button above to capture evidence.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: textGrey,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PHOTO CARD
  // ==========================================================

  Widget _photoCard(int index) {
    final photo = photos[index];

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [

          // ----------------------------------------------------
          // PHOTO
          // ----------------------------------------------------

          Image.file(
            File(photo.path),
            fit: BoxFit.cover,
          ),

          // ----------------------------------------------------
          // DARK GRADIENT
          // ----------------------------------------------------

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 65,
            child: Container(
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  begin:
                      Alignment.topCenter,
                  end:
                      Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black
                        .withOpacity(0.70),
                  ],
                ),
              ),
            ),
          ),

          // ----------------------------------------------------
          // PHOTO NUMBER
          // ----------------------------------------------------

          Positioned(
            left: 11,
            bottom: 10,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.black
                    .withOpacity(0.35),
                borderRadius:
                    BorderRadius.circular(8),
              ),
              child: Text(
                'Photo ${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ),

          // ----------------------------------------------------
          // DELETE BUTTON
          // ----------------------------------------------------

          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.black
                  .withOpacity(0.55),
              shape:
                  const CircleBorder(),
              child: InkWell(
                customBorder:
                    const CircleBorder(),
                onTap: () {
                  removePhoto(index);
                },
                child: const Padding(
                  padding:
                      EdgeInsets.all(8),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 19,
                  ),
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
      width: 25,
      height: 1,
      margin:
          const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      color:
          const Color(0xFFCBD5E1),
    );
  }
}