// import 'package:flutter/material.dart';
// import 'package:officer_app/features/auth/auth_service.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class DocumentsScreen extends StatefulWidget {
//   final String applicationId;

//   const DocumentsScreen({
//     super.key,
//     required this.applicationId,
//   });

//   @override
//   State<DocumentsScreen> createState() => _DocumentsScreenState();
// }

// class _DocumentsScreenState extends State<DocumentsScreen> {
//   final Color primaryColor = const Color(0xFF123B6D);

//   final AuthService authService = AuthService();

//   Map<String, dynamic>? certificate;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadCertificate();
//   }

//   Future<void> _loadCertificate() async {
//     try {
//       final data = await authService.getLocalCertificate(
//         widget.applicationId,
//       );

//       if (!mounted) return;

//       setState(() {
//         certificate = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(
//           color: Color(0xFF123B6D),
//         ),
//         title: const Text(
//           'Documents',
//           style: TextStyle(
//             color: Color(0xFF172B4D),
//             fontSize: 19,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body: isLoading
//           ? Center(
//               child: CircularProgressIndicator(
//                 color: primaryColor,
//               ),
//             )
//           : certificate == null
//               ? _noDocument()
//               : _certificateCard(),
//     );
//   }

//   Widget _noDocument() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.folder_open_outlined,
//               size: 60,
//               color: Colors.grey.shade400,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'No documents available',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF172B4D),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'A certificate will appear here after a successful verification.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _certificateCard() {
//     final cert = certificate!;

//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         Container(
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(
//               color: Colors.grey.shade200,
//             ),
//           ),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 48,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFEAF1FB),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Icon(
//                       Icons.verified_outlined,
//                       color: primaryColor,
//                       size: 27,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Verification Certificate',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF172B4D),
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           'Official verification document',
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Color(0xFF7A869A),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 9,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE8F5E9),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: Text(
//                       '${cert['status'] ?? 'Valid'}',
//                       style: const TextStyle(
//                         color: Color(0xFF2E7D32),
//                         fontSize: 9,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 18),
//               const Divider(),

//               _info(
//                 'Certificate Number',
//                 cert['certificateNumber'],
//               ),

//               _info(
//                 'Verification ID',
//                 cert['verificationId'],
//               ),

//               _info(
//                 'Application ID',
//                 cert['applicationId'],
//               ),

//               _info(
//                 'Instrument',
//                 cert['instrumentType'],
//               ),

//               _info(
//                 'Manufacturer',
//                 cert['manufacturer'],
//               ),

//               _info(
//                 'Officer ID',
//                 cert['officerId'],
//               ),

//               _info(
//                 'Issue Date',
//                 _date(cert['issueDate']),
//               ),

//               _info(
//                 'Valid Until',
//                 _date(cert['validUntil']),
//               ),

//               const SizedBox(height: 15),

//               SizedBox(
//                 width: double.infinity,
//                 height: 46,
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => CertificateDetailsScreen(
//                           certificate: cert,
//                         ),
//                       ),
//                     );
//                   },
//                   icon: const Icon(
//                     Icons.visibility_outlined,
//                   ),
//                   label: const Text(
//                     'VIEW CERTIFICATE',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: primaryColor,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(9),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _info(
//     String label,
//     dynamic value,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 8,
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const Spacer(),
//           Flexible(
//             child: Text(
//               value?.toString() ?? 'Not available',
//               textAlign: TextAlign.right,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF172B4D),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _date(dynamic value) {
//     if (value == null) {
//       return 'Not available';
//     }

//     try {
//       final date = DateTime.parse(value.toString());

//       return '${date.day.toString().padLeft(2, '0')}/'
//           '${date.month.toString().padLeft(2, '0')}/'
//           '${date.year}';
//     } catch (_) {
//       return value.toString();
//     }
//   }
// }

// /* =========================================================
//    CERTIFICATE DETAILS
// ========================================================= */

// class CertificateDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic> certificate;

//   const CertificateDetailsScreen({
//     super.key,
//     required this.certificate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     const primaryColor = Color(0xFF123B6D);

//     // Public React website.
//     // The QR code will open the certificate verification page.
//     const publicWebUrl = 'https://maap-setu-two.vercel.app';

//     // Get the certificate ID, for example: CERT-8
//     final certificateId =
//         certificate['certificateId']?.toString() ?? '';

//     // Final QR URL:
//     // https://maap-setu-two.vercel.app/verify/CERT-8

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(
//           color: primaryColor,
//         ),
//         title: const Text(
//           'Certificate',
//           style: TextStyle(
//             color: Color(0xFF172B4D),
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(18),
//         child: Container(
//           padding: const EdgeInsets.all(22),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: primaryColor.withOpacity(.25),
//             ),
//           ),
//           child: Column(
//             children: [
//               const Icon(
//                 Icons.verified,
//                 size: 58,
//                 color: primaryColor,
//               ),

//               const SizedBox(height: 12),

//               const Text(
//                 'LEGAL METROLOGY',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 1.5,
//                   color: Color(0xFF6B7280),
//                 ),
//               ),

//               const SizedBox(height: 6),

//               const Text(
//                 'VERIFICATION CERTIFICATE',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 21,
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xFF172B4D),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               Text(
//                 certificate['certificateNumber'] ??
//                     'Certificate',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: primaryColor,
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // =================================================
//               // PUBLIC VERIFICATION QR CODE
//               // =================================================

//               QrImageView(
//                 data:
//                     '$publicWebUrl/verify/$certificateId',
//                 size: 180,
//                 backgroundColor: Colors.white,
//               ),

//               const SizedBox(height: 20),

//               _row(
//                 'Application',
//                 certificate['applicationId'],
//               ),

//               _row(
//                 'Verification',
//                 certificate['verificationId'],
//               ),

//               _row(
//                 'Instrument',
//                 certificate['instrumentType'],
//               ),

//               _row(
//                 'Manufacturer',
//                 certificate['manufacturer'],
//               ),

//               _row(
//                 'Officer ID',
//                 certificate['officerId'],
//               ),

//               _row(
//                 'Issue Date',
//                 _date(certificate['issueDate']),
//               ),

//               _row(
//                 'Valid Until',
//                 _date(certificate['validUntil']),
//               ),

//               _row(
//                 'Status',
//                 certificate['status'],
//               ),

//               const SizedBox(height: 20),

//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE8F5E9),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Row(
//                   children: [
//                     Icon(
//                       Icons.check_circle,
//                       color: Color(0xFF2E7D32),
//                     ),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Certificate generated after successful verification.',
//                         style: TextStyle(
//                           color: Color(0xFF2E7D32),
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _row(
//     String label,
//     dynamic value,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 10,
//       ),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 11,
//               color: Color(0xFF6B7280),
//             ),
//           ),
//           const Spacer(),
//           Flexible(
//             child: Text(
//               value?.toString() ?? 'Not available',
//               textAlign: TextAlign.right,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF172B4D),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _date(dynamic value) {
//     if (value == null) {
//       return 'Not available';
//     }

//     try {
//       final date = DateTime.parse(value.toString());

//       return '${date.day.toString().padLeft(2, '0')}/'
//           '${date.month.toString().padLeft(2, '0')}/'
//           '${date.year}';
//     } catch (_) {
//       return value.toString();
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:officer_app/features/auth/auth_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DocumentsScreen extends StatefulWidget {
  final String applicationId;

  const DocumentsScreen({
    super.key,
    required this.applicationId,
  });

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  // ============================================================
  // MAAPSETU COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF174EA6);
  static const Color deepBlue = Color(0xFF0D47A1);
  static const Color teal = Color(0xFF00897B);
  // static const Color cyan = Color(0xFF00ACC1);
  static const Color saffron = Color(0xFFFFA000);
  static const Color green = Color(0xFF2E7D32);
  static const Color lightBlue = Color(0xFFEAF3FF);
  static const Color background = Color(0xFFF4F7FB);
  static const Color textDark = Color(0xFF172B4D);
  static const Color textGrey = Color(0xFF64748B);

  final AuthService authService = AuthService();

  Map<String, dynamic>? certificate;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCertificate();
  }

  Future<void> _loadCertificate() async {
    try {
      final data = await authService.getLocalCertificate(
        widget.applicationId,
      );

      if (!mounted) return;

      setState(() {
        certificate = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        toolbarHeight: 68,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    primaryBlue,
                    teal,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
        titleSpacing: 12,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Documents',
              style: TextStyle(
                color: textDark,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'VERIFICATION RECORDS',
              style: TextStyle(
                color: textGrey,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: primaryBlue,
                strokeWidth: 2.5,
              ),
            )
          : certificate == null
              ? _noDocument()
              : _certificateCard(),
    );
  }

  // ============================================================
  // NO DOCUMENT STATE
  // ============================================================

  Widget _noDocument() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.folder_open_outlined,
                size: 46,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'No Documents Available',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              'A certificate will appear here after a successful '
              'verification.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textGrey,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.blueGrey.shade100,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: textGrey,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    'Certificate pending',
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CERTIFICATE CARD
  // ============================================================

  Widget _certificateCard() {
    final cert = certificate!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
      children: [
        // --------------------------------------------------------
        // PAGE HEADER
        // --------------------------------------------------------

        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                primaryBlue,
                deepBlue,
                teal,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.16),
                blurRadius: 18,
                offset: const Offset(0, 8),
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
                    color: Colors.white.withOpacity(0.18),
                  ),
                ),
                child: const Icon(
                  Icons.verified_rounded,
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
                      'Verification Certificate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Official Legal Metrology verification document',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
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

        // --------------------------------------------------------
        // CERTIFICATE SUMMARY
        // --------------------------------------------------------

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.blueGrey.shade100,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_outlined,
                      color: primaryBlue,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Certificate Issued',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Verification completed successfully',
                          style: TextStyle(
                            fontSize: 11,
                            color: textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(
                    cert['status']?.toString() ?? 'Valid',
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.numbers_outlined,
                      color: primaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Certificate Number',
                        style: TextStyle(
                          color: textGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        cert['certificateNumber']?.toString() ??
                            'Not available',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: primaryBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              _info(
                'Verification ID',
                cert['verificationId'],
              ),
              _info(
                'Application ID',
                cert['applicationId'],
              ),
              _info(
                'Instrument',
                cert['instrumentType'],
              ),
              _info(
                'Manufacturer',
                cert['manufacturer'],
              ),
              _info(
                'Officer ID',
                cert['officerId'],
              ),
              _info(
                'Issue Date',
                _date(cert['issueDate']),
              ),
              _info(
                'Valid Until',
                _date(cert['validUntil']),
              ),

              const SizedBox(height: 14),

              // --------------------------------------------------
              // VIEW CERTIFICATE BUTTON
              // --------------------------------------------------

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CertificateDetailsScreen(
                          certificate: cert,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.visibility_outlined,
                    size: 20,
                  ),
                  label: const Text(
                    'VIEW CERTIFICATE',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // --------------------------------------------------------
        // SECURITY INFORMATION
        // --------------------------------------------------------

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.blueGrey.shade100,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.qr_code_2,
                  color: green,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Digitally Verifiable',
                      style: TextStyle(
                        color: textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'The certificate contains a QR code that can '
                      'be used to verify its authenticity.',
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _statusBadge(String status) {
    final bool isValid =
        status.toUpperCase() == 'VALID' ||
        status.toUpperCase() == 'ACTIVE';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: isValid
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isValid
                ? Icons.check_circle_outline
                : Icons.info_outline,
            size: 13,
            color: isValid ? green : saffron,
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: isValid ? green : saffron,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMATION ROW
  // ============================================================

  Widget _info(
    String label,
    dynamic value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.blueGrey.shade50,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 6,
            child: Text(
              value?.toString() ?? 'Not available',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DATE FORMATTER
  // ============================================================

  String _date(dynamic value) {
    if (value == null) {
      return 'Not available';
    }

    try {
      final date = DateTime.parse(value.toString());

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (_) {
      return value.toString();
    }
  }
}

// ================================================================
// CERTIFICATE DETAILS SCREEN
// ================================================================

class CertificateDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> certificate;

  const CertificateDetailsScreen({
    super.key,
    required this.certificate,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF174EA6);
    const deepBlue = Color(0xFF0D47A1);
    const teal = Color(0xFF00897B);
    const green = Color(0xFF2E7D32);
    const lightBlue = Color(0xFFEAF3FF);
    const background = Color(0xFFF4F7FB);
    const textDark = Color(0xFF172B4D);
    const textGrey = Color(0xFF64748B);

    // Public React website.
    // The QR code will open the certificate verification page.
    const publicWebUrl = 'https://maap-setu-two.vercel.app';

    // Get the certificate ID.
    final certificateId =
        certificate['certificateId']?.toString() ?? '';

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        toolbarHeight: 68,
        iconTheme: const IconThemeData(
          color: primaryBlue,
        ),
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Certificate',
              style: TextStyle(
                color: textDark,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'DIGITAL VERIFICATION',
              style: TextStyle(
                color: textGrey,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
        child: Column(
          children: [
            // ----------------------------------------------------
            // CERTIFICATE HEADER
            // ----------------------------------------------------

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                22,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    primaryBlue,
                    deepBlue,
                    teal,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.16),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                      ),
                    ),
                    child: const Icon(
                      Icons.verified_rounded,
                      size: 38,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'LEGAL METROLOGY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    'VERIFICATION CERTIFICATE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 17),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      certificate['certificateNumber']?.toString() ??
                          'Certificate',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ----------------------------------------------------
            // QR VERIFICATION CARD
            // ----------------------------------------------------

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.blueGrey.shade100,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.035),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.qr_code_2,
                        color: primaryBlue,
                        size: 23,
                      ),
                      SizedBox(width: 9),
                      Text(
                        'Public Verification',
                        style: TextStyle(
                          color: textDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Scan this QR code to verify the certificate online.',
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.blueGrey.shade100,
                      ),
                    ),
                    child: QrImageView(
                      data:
                          '$publicWebUrl/verify/$certificateId',
                      size: 190,
                      backgroundColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          color: primaryBlue,
                          size: 16,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            'Digitally verifiable certificate',
                            style: TextStyle(
                              color: primaryBlue,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ----------------------------------------------------
            // CERTIFICATE INFORMATION
            // ----------------------------------------------------

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.blueGrey.shade100,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.fact_check_outlined,
                        color: primaryBlue,
                        size: 22,
                      ),
                      SizedBox(width: 9),
                      Text(
                        'Certificate Details',
                        style: TextStyle(
                          color: textDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  _row(
                    'Application',
                    certificate['applicationId'],
                  ),
                  _row(
                    'Verification',
                    certificate['verificationId'],
                  ),
                  _row(
                    'Instrument',
                    certificate['instrumentType'],
                  ),
                  _row(
                    'Manufacturer',
                    certificate['manufacturer'],
                  ),
                  _row(
                    'Officer ID',
                    certificate['officerId'],
                  ),
                  _row(
                    'Issue Date',
                    _date(certificate['issueDate']),
                  ),
                  _row(
                    'Valid Until',
                    _date(certificate['validUntil']),
                  ),
                  _row(
                    'Status',
                    certificate['status'],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ----------------------------------------------------
            // VERIFICATION STATUS
            // ----------------------------------------------------

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFC8E6C9),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: green,
                    size: 24,
                  ),
                  SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Certificate Verified',
                          style: TextStyle(
                            color: green,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'This certificate was generated after successful '
                          'verification of the measuring instrument.',
                          style: TextStyle(
                            color: green,
                            fontSize: 11,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------
            // FOOTER
            // ----------------------------------------------------

            const Text(
              'MaapSetu • Digital Legal Metrology Services',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textGrey,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Official Officer Verification Portal',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textGrey,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CERTIFICATE DETAIL ROW
  // ============================================================

  Widget _row(
    String label,
    dynamic value,
  ) {
    const textDark = Color(0xFF172B4D);
    const textGrey = Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.blueGrey.shade50,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 6,
            child: Text(
              value?.toString() ?? 'Not available',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DATE FORMATTER
  // ============================================================

  String _date(dynamic value) {
    if (value == null) {
      return 'Not available';
    }

    try {
      final date = DateTime.parse(value.toString());

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (_) {
      return value.toString();
    }
  }
}