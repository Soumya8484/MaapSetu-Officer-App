import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import '../features/auth/auth_service.dart';
import 'assignment_details_screen.dart';

class MyAssignmentsContent extends StatefulWidget {
  final String currentUserId;

  const MyAssignmentsContent({
    super.key,
    required this.currentUserId,
  });

  @override
  State<MyAssignmentsContent> createState() =>
      _MyAssignmentsContentState();
}

class _MyAssignmentsContentState
    extends State<MyAssignmentsContent> {
  String selectedFilter = 'All';

  final Color primaryColor = const Color(0xFF123B6D);

  List<dynamic> assignments = [];

  bool loadingAssignments = true;

  String? assignmentsError;

  // ============================================================
  // EXISTING BACKEND LOGIC — UNCHANGED
  // ============================================================

  Future<void> loadAssignments() async {
    print('STEP 1: loadAssignments started');

    try {
      setState(() {
        loadingAssignments = true;
        assignmentsError = null;
      });

      print('STEP 2: calling getInspectorApplications');

      final data =
          await AuthService().getInspectorApplications();

      print('STEP 3: applications received');

      print(
        'NUMBER OF APPLICATIONS: ${data.length}',
      );

      if (!mounted) return;

      setState(() {
        assignments = data;
        loadingAssignments = false;
      });

      print('STEP 4: assignments displayed');
    } catch (e) {
      print('ASSIGNMENTS ERROR: $e');

      if (!mounted) return;

      setState(() {
        loadingAssignments = false;
        assignmentsError = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    print('MY ASSIGNMENTS SCREEN OPENED');

    loadAssignments();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F8FC),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // MODERN HEADER
          // ======================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              0,
            ),
            child: Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF123B6D),
                    Color(0xFF174EA6),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(18),

                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF123B6D)
                        .withOpacity(0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),

              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center,

                children: [
                  // ==================================================
                  // ICON
                  // ==================================================

                  Container(
                    width: 52,
                    height: 52,

                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.14),

                      borderRadius:
                          BorderRadius.circular(14),

                      border: Border.all(
                        color: Colors.white
                            .withOpacity(0.18),
                      ),
                    ),

                    child: const Icon(
                      Icons.assignment_rounded,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // ==================================================
                  // TITLE
                  // ==================================================

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'My Assignments',

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'Verification activities assigned to you',

                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.35,
                            color: Colors.white
                                .withOpacity(0.82),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ======================================================
          // FILTER HEADER
          // ======================================================

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: Row(
              children: [
                const Text(
                  'Filter assignments',

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                    color: Color(0xFF172B4D),
                  ),
                ),

                const Spacer(),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(20),

                    border: Border.all(
                      color:
                          const Color(0xFFE2E8F0),
                    ),
                  ),

                  child: Text(
                    '${assignments.length} total',

                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          Colors.blueGrey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ======================================================
          // FILTERS
          // ======================================================

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              physics:
                  const BouncingScrollPhysics(),

              child: Row(
                children: [
                  _filterButton('All'),
                  _filterButton('Today'),
                  _filterButton('Upcoming'),
                  _filterButton('Completed'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ======================================================
          // ASSIGNMENTS
          // ======================================================

          Expanded(
            child: Builder(
              builder: (context) {
                // ==================================================
                // LOADING
                // ==================================================

                if (loadingAssignments) {
                  return Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [
                        Container(
                          width: 54,
                          height: 54,

                          padding:
                              const EdgeInsets.all(14),

                          decoration:
                              BoxDecoration(
                            color: Colors.white,

                            shape:
                                BoxShape.circle,

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(
                                  0.05,
                                ),
                                blurRadius: 12,
                                offset:
                                    const Offset(
                                  0,
                                  4,
                                ),
                              ),
                            ],
                          ),

                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color:
                                primaryColor,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'Loading assignments...',

                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                FontWeight.w600,
                            color:
                                Colors.blueGrey
                                    .shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // ==================================================
                // ERROR
                // ==================================================

                if (assignmentsError != null) {
                  return _emptyState(
                    icon:
                        Icons.cloud_off_rounded,
                    title:
                        'Unable to load assignments',
                    subtitle:
                        assignmentsError!,
                  );
                }

                // ==================================================
                // NO ASSIGNMENTS
                // ==================================================

                if (assignments.isEmpty) {
                  return _emptyState(
                    icon:
                        Icons.assignment_outlined,
                    title:
                        'No assignments found',
                    subtitle:
                        'Assigned verification activities will appear here.',
                  );
                }

                // ==================================================
                // EXISTING FILTER LOGIC — UNCHANGED
                // ==================================================

                final filteredAssignments =
                    assignments.where((data) {
                  final status =
                      data['status'] ?? '';

                  if (selectedFilter ==
                      'Completed') {
                    return status == 'COMPLETED';
                  }

                  if (selectedFilter ==
                      'Upcoming') {
                    return status == 'SCHEDULED' ||
                        status == 'ASSIGNED';
                  }

                  if (selectedFilter ==
                      'Today') {
                    final appointmentDate =
                        data[
                            'appointmentDate'];

                    if (appointmentDate ==
                        null) {
                      return false;
                    }

                    final now =
                        DateTime.now();

                    try {
                      final date =
                          DateTime.parse(
                        appointmentDate
                            .toString(),
                      );

                      return date.year ==
                              now.year &&
                          date.month ==
                              now.month &&
                          date.day ==
                              now.day;
                    } catch (_) {
                      return false;
                    }
                  }

                  return true;
                }).toList();

                // ==================================================
                // NO FILTERED ASSIGNMENTS
                // ==================================================

                if (filteredAssignments
                    .isEmpty) {
                  return _emptyState(
                    icon:
                        Icons.filter_alt_off_rounded,
                    title:
                        'No assignments in this category',
                    subtitle:
                        'Try selecting another filter.',
                  );
                }

                // ==================================================
                // EXISTING LIST
                // ==================================================

                return ListView.builder(
                  physics:
                      const BouncingScrollPhysics(),

                  padding:
                      const EdgeInsets.fromLTRB(
                    20,
                    4,
                    20,
                    20,
                  ),

                  itemCount:
                      filteredAssignments.length,

                  itemBuilder:
                      (context, index) {
                    final data =
                        Map<String, dynamic>.from(
                      filteredAssignments[index],
                    );

                    final assignmentId =
                        data['applicationId']
                                ?.toString() ??
                            '';

                    return _assignmentCard(
                      context,
                      assignmentId,
                      data,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTER BUTTON — UI ONLY
  // ============================================================

  Widget _filterButton(String filter) {
    final isSelected =
        selectedFilter == filter;

    IconData icon;

    switch (filter) {
      case 'Today':
        icon = Icons.today_outlined;
        break;

      case 'Upcoming':
        icon = Icons.upcoming_outlined;
        break;

      case 'Completed':
        icon = Icons.check_circle_outline;
        break;

      default:
        icon = Icons.grid_view_rounded;
    }

    return Padding(
      padding:
          const EdgeInsets.only(right: 8),

      child: ChoiceChip(
        avatar: Icon(
          icon,
          size: 16,
          color: isSelected
              ? primaryColor
              : Colors.blueGrey.shade500,
        ),

        label: Text(
          filter,

          style: TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.w600,

            color: isSelected
                ? primaryColor
                : Colors.blueGrey.shade700,
          ),
        ),

        selected: isSelected,

        showCheckmark: false,

        backgroundColor:
            Colors.white,

        selectedColor:
            const Color(0xFFEAF3FF),

        side: BorderSide(
          color: isSelected
              ? primaryColor
              : const Color(0xFFE2E8F0),
          width: isSelected ? 1.2 : 1,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 7,
        ),

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10),
        ),

        onSelected: (_) {
          // EXISTING FILTER LOGIC — UNCHANGED
          setState(() {
            selectedFilter = filter;
          });
        },
      ),
    );
  }

  // ============================================================
  // ASSIGNMENT CARD — UI ONLY
  // ============================================================

  Widget _assignmentCard(
    BuildContext context,
    String assignmentId,
    Map<String, dynamic> data,
  ) {
    final status =
        data['status'] ?? 'UNKNOWN';

    return Container(
      margin:
          const EdgeInsets.only(bottom: 13),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color: const Color(0xFFE7EDF4),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius:
              BorderRadius.circular(16),

          // ====================================================
          // EXISTING NAVIGATION — UNCHANGED
          // ====================================================

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    AssignmentDetailsScreen(
                  assignmentId:
                      assignmentId,
                ),
              ),
            );
          },

          child: Padding(
            padding:
                const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // ==================================================
                // TOP ROW
                // ==================================================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    // ==============================================
                    // SCALE ICON
                    // ==============================================

                    Container(
                      width: 48,
                      height: 48,

                      decoration:
                          BoxDecoration(
                        gradient:
                            LinearGradient(
                          begin:
                              Alignment.topLeft,
                          end:
                              Alignment.bottomRight,
                          colors: [
                            primaryColor
                                .withOpacity(
                              0.12,
                            ),
                            const Color(
                              0xFFEAF3FF,
                            ),
                          ],
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),

                      child: Icon(
                        Icons.scale_rounded,
                        color:
                            primaryColor,
                        size: 25,
                      ),
                    ),

                    const SizedBox(width: 13),

                    // ==============================================
                    // APPLICATION DETAILS
                    // ==============================================

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            data['applicationId']
                                    ?.toString() ??
                                '',

                            maxLines: 1,

                            overflow:
                                TextOverflow.ellipsis,

                            style:
                                const TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w700,
                              color:
                                  Color(0xFF172B4D),
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            data['applicant']
                                    ?.toString() ??
                                '',

                            maxLines: 2,

                            overflow:
                                TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.35,
                              color: Colors
                                  .blueGrey
                                  .shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // ==============================================
                    // STATUS
                    // ==============================================

                    _statusWidget(
                      status.toString(),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // ==================================================
                // DIVIDER
                // ==================================================

                Container(
                  height: 1,
                  color:
                      const Color(0xFFF0F3F7),
                ),

                const SizedBox(height: 13),

                // ==================================================
                // INSTRUMENT ROW
                // ==================================================

                Row(
                  children: [
                    Container(
                      width: 31,
                      height: 31,

                      decoration:
                          BoxDecoration(
                        color: const Color(
                          0xFFF4F7FA,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          8,
                        ),
                      ),

                      child: Icon(
                        Icons
                            .precision_manufacturing_outlined,
                        size: 17,
                        color:
                            Colors.blueGrey
                                .shade600,
                      ),
                    ),

                    const SizedBox(width: 9),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Instrument',

                            style: TextStyle(
                              fontSize: 10,
                              fontWeight:
                                  FontWeight.w600,
                              color: Colors
                                  .blueGrey
                                  .shade500,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            data['instrumentType']
                                    ?.toString() ??
                                '',

                            maxLines: 1,

                            overflow:
                                TextOverflow.ellipsis,

                            style:
                                const TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ==============================================
                    // ARROW
                    // ==============================================

                    Container(
                      width: 30,
                      height: 30,

                      decoration:
                          BoxDecoration(
                        color: const Color(
                          0xFFF7F9FC,
                        ),

                        shape:
                            BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons
                            .arrow_forward_ios_rounded,
                        size: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STATUS — UI ONLY
  // ============================================================

  Widget _statusWidget(String status) {
    Color background;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'COMPLETED':
        background =
            const Color(0xFFE8F5E9);

        textColor =
            const Color(0xFF2E7D32);

        icon =
            Icons.check_circle_rounded;

        break;

      case 'IN PROGRESS':
      case 'IN_PROGRESS':
        background =
            const Color(0xFFE3F2FD);

        textColor =
            const Color(0xFF1565C0);

        icon =
            Icons.autorenew_rounded;

        break;

      case 'SCHEDULED':
        background =
            const Color(0xFFFFF3E0);

        textColor =
            const Color(0xFFE65100);

        icon =
            Icons.schedule_rounded;

        break;

      case 'ASSIGNED':
        background =
            const Color(0xFFF3E5F5);

        textColor =
            const Color(0xFF6A1B9A);

        icon =
            Icons.assignment_turned_in_outlined;

        break;

      default:
        background =
            Colors.grey.shade100;

        textColor =
            Colors.grey.shade700;

        icon =
            Icons.info_outline_rounded;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: background,

        borderRadius:
            BorderRadius.circular(8),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          Icon(
            icon,
            size: 13,
            color: textColor,
          ),

          const SizedBox(width: 4),

          Text(
            status.replaceAll('_', ' '),

            style: TextStyle(
              fontSize: 9.5,
              fontWeight:
                  FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY STATE — UI ONLY
  // ============================================================

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 35,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            // ==================================================
            // ICON
            // ==================================================

            Container(
              width: 76,
              height: 76,

              decoration: BoxDecoration(
                color:
                    primaryColor.withOpacity(
                  0.07,
                ),

                shape:
                    BoxShape.circle,

                border: Border.all(
                  color:
                      primaryColor.withOpacity(
                    0.08,
                  ),
                ),
              ),

              child: Icon(
                icon,
                size: 34,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 19),

            // ==================================================
            // TITLE
            // ==================================================

            Text(
              title,

              textAlign:
                  TextAlign.center,

              style: const TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.w700,
                color:
                    Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 7),

            // ==================================================
            // SUBTITLE
            // ==================================================

            Text(
              subtitle,

              textAlign:
                  TextAlign.center,

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