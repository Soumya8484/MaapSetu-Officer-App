import 'package:flutter/material.dart';

class EmergencyHelpScreen extends StatelessWidget {
  const EmergencyHelpScreen({super.key});

  static const Color primaryColor = Color(0xFF123B6D);
  static const Color backgroundColor = Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        foregroundColor: primaryColor,
        title: const Text(
          'Emergency Help',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emergency_rounded,
                      color: Colors.red.shade700,
                      size: 38,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Emergency Assistance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF172B4D),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Use the options below to get immediate '
                    'assistance during an official inspection.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Emergency Contacts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 14),

            // Emergency Services
            _buildEmergencyCard(
              icon: Icons.local_police_outlined,
              title: 'Police',
              subtitle: 'For immediate police assistance',
              number: '112',
              iconColor: Colors.blue.shade700,
              onTap: () {
                _showCallConfirmation(
                  context,
                  'Police',
                  '112',
                );
              },
            ),

            const SizedBox(height: 12),

            // Emergency Helpline
            _buildEmergencyCard(
              icon: Icons.phone_in_talk_outlined,
              title: 'Emergency Helpline',
              subtitle: 'National emergency response',
              number: '112',
              iconColor: Colors.red.shade700,
              onTap: () {
                _showCallConfirmation(
                  context,
                  'Emergency Helpline',
                  '112',
                );
              },
            ),

            const SizedBox(height: 12),

            // Supervisor
            _buildEmergencyCard(
              icon: Icons.supervisor_account_outlined,
              title: 'Contact Supervisor',
              subtitle: 'Report an inspection emergency',
              number: 'Supervisor',
              iconColor: primaryColor,
              onTap: () {
                _showSupervisorDialog(context);
              },
            ),

            const SizedBox(height: 28),

            // Safety Notice
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFFED7AA),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.orange.shade700,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'If you are in immediate danger, move to a '
                      'safe location and contact emergency services.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: Colors.orange.shade900,
                      ),
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

  Widget _buildEmergencyCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String number,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 25,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF172B4D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            if (number == '112')
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  number,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
              )
            else
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFF94A3B8),
              ),
          ],
        ),
      ),
    );
  }

  void _showCallConfirmation(
    BuildContext context,
    String service,
    String number,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Contact $service?'),
          content: Text(
            'You are about to contact $service at $number.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Phone call functionality will be connected later.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('CONTINUE'),
            ),
          ],
        );
      },
    );
  }

  void _showSupervisorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Contact Supervisor'),
          content: const Text(
            'Supervisor contact details will be connected '
            'to the officer profile/backend.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }
}