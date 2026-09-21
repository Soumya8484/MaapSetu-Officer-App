import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryContent extends StatelessWidget {
  final String currentUserId;

  const HistoryContent({
    super.key,
    required this.currentUserId,
  });

  final Color primaryColor =
      const Color(0xFF123B6D);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            22,
            20,
            10,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Verification History',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF172B4D),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'Previously completed verification activities',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('assignments')
                .where(
                  'officerId',
                  isEqualTo: currentUserId,
                )
                .snapshots(),

            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }

              if (snapshot.hasError) {
                return _emptyState(
                  icon: Icons.error_outline,
                  title:
                      'Unable to load history',
                  subtitle:
                      'Please check your connection and try again.',
                );
              }

              final documents =
                  snapshot.data?.docs ?? [];

              final completed =
                  documents.where((doc) {
                final data =
                    doc.data()
                        as Map<String, dynamic>;

                return data['status'] ==
                    'COMPLETED';
              }).toList();

              if (completed.isEmpty) {
                return _emptyState(
                  icon: Icons.history_outlined,
                  title:
                      'No verification history',
                  subtitle:
                      'Completed verification records will appear here.',
                );
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  20,
                ),

                itemCount: completed.length,

                itemBuilder:
                    (context, index) {
                  final data =
                      completed[index].data()
                          as Map<String, dynamic>;

                  return _historyCard(data);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _historyCard(
      Map<String, dynamic> data) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 12),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),

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
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color:
                      const Color(0xFFE8F5E9),
                  borderRadius:
                      BorderRadius.circular(10),
                ),

                child: const Icon(
                  Icons.check_circle_outline,
                  color:
                      Color(0xFF2E7D32),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['applicationId'] ??
                          '',
                      style:
                          const TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            Color(0xFF172B4D),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      data['businessName'] ??
                          '',
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Divider(),

          const SizedBox(height: 10),

          Row(
            children: [
              Icon(
                Icons.scale_outlined,
                size: 17,
                color:
                    Colors.grey.shade600,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  data['instrumentType'] ??
                      '',
                  style:
                      const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 17,
                color:
                    Colors.green.shade700,
              ),

              const SizedBox(width: 8),

              const Text(
                'Completed',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Container(
              width: 70,
              height: 70,

              decoration: BoxDecoration(
                color:
                    primaryColor.withOpacity(
                        0.07),
                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                size: 32,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              title,
              textAlign:
                  TextAlign.center,

              style: const TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              subtitle,
              textAlign:
                  TextAlign.center,

              style: TextStyle(
                fontSize: 13,
                color:
                    Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}