import 'package:flutter/material.dart';
import 'package:officer_app/data/india_locations.dart';
import '../features/auth/auth_service.dart';
import 'login_screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers for reading user input
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final employeeIdController = TextEditingController();
  final passwordController = TextEditingController();

  // Stores the state selected from the dropdown
  String? selectedState;

  // Stores the district selected from the dropdown
  String? selectedDistrict;

  // AuthService handles Firebase Authentication and Firestore
  final AuthService _authService = AuthService();

  // Used to show a loading indicator
  bool loading = false;

  // Handles the signup process
  Future<void> signup() async {
    // Check text fields
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        employeeIdController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
      return;
    }

    // Check state and district selection
    if (selectedState == null || selectedDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select state and district'),
        ),
      );
      return;
    }

    // Start loading
    setState(() {
      loading = true;
    });

    try {
      // Create Firebase Authentication account
      final user = await _authService.signup(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Check whether account was created
      if (user == null) {
        throw Exception('Account creation failed');
      }

      // Save additional user information in Firestore
      await _authService.createUserProfile(
        uid: user.uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        employeeId: employeeIdController.text.trim(),

        // Set the role automatically
        role: 'LMO',

        // Use selected dropdown values
        district: selectedDistrict!,
        state: selectedState!,
      );

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully'),
        ),
      );

      // Go to LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signup failed: $e'),
        ),
      );
    } finally {
      // Stop loading
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the page is removed
    nameController.dispose();
    emailController.dispose();
    employeeIdController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF5F7FA),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Back button
                IconButton(
                  onPressed: loading
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF172B4D),
                  ),
                ),

                const SizedBox(height: 8),

                // Header icon
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.person_add_outlined,
                      size: 38,
                      color: Color(0xFF174EA6),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Center(
                  child: Text(
                    'CREATE ACCOUNT',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: Color(0xFF172B4D),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Register as a Legal Metrology Officer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF667085),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ---------------------------------------------------------
                // Registration Card
                // ---------------------------------------------------------

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFE4E7EC),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Officer Details',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF172B4D),
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Enter your official details to create your account.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF667085),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ---------------------------------------------------
                      // Full Name
                      // ---------------------------------------------------

                      const Text(
                        'Full Name',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF344054),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: nameController,
                        textCapitalization:
                            TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Enter your full name',
                          hintStyle: const TextStyle(
                            color: Color(0xFF98A2B3),
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: Color(0xFF667085),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF174EA6),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ---------------------------------------------------
                      // Email
                      // ---------------------------------------------------

                      const Text(
                        'Official Email',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF344054),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: emailController,
                        keyboardType:
                            TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter your official email',
                          hintStyle: const TextStyle(
                            color: Color(0xFF98A2B3),
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color(0xFF667085),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF174EA6),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ---------------------------------------------------
                      // Employee ID
                      // ---------------------------------------------------

                      const Text(
                        'Employee ID',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF344054),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: employeeIdController,
                        decoration: InputDecoration(
                          hintText: 'Enter your employee ID',
                          hintStyle: const TextStyle(
                            color: Color(0xFF98A2B3),
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.badge_outlined,
                            color: Color(0xFF667085),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF174EA6),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ---------------------------------------------------
                      // Password
                      // ---------------------------------------------------

                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF344054),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Create a password',
                          hintStyle: const TextStyle(
                            color: Color(0xFF98A2B3),
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF667085),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF174EA6),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ---------------------------------------------------
                      // State
                      // ---------------------------------------------------

                      const Text(
                        'State',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF344054),
                        ),
                      ),

                      const SizedBox(height: 8),

                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: selectedState,
                        decoration: InputDecoration(
                          hintText: 'Select your state',
                          hintStyle: const TextStyle(
                            color: Color(0xFF98A2B3),
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.map_outlined,
                            color: Color(0xFF667085),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF174EA6),
                              width: 1.5,
                            ),
                          ),
                        ),
                        items: indiaLocations.keys.map((state) {
                          return DropdownMenuItem<String>(
                            value: state,
                            child: Text(
                              state,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF344054),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedState = value;
                            selectedDistrict = null;
                          });
                        },
                      ),

                      const SizedBox(height: 18),

                      // ---------------------------------------------------
                      // District
                      // ---------------------------------------------------

                      const Text(
                        'District',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF344054),
                        ),
                      ),

                      const SizedBox(height: 8),

                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: selectedDistrict,
                        decoration: InputDecoration(
                          hintText: selectedState == null
                              ? 'Select state first'
                              : 'Select your district',
                          hintStyle: const TextStyle(
                            color: Color(0xFF98A2B3),
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.location_city_outlined,
                            color: Color(0xFF667085),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD0D5DD),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF174EA6),
                              width: 1.5,
                            ),
                          ),
                        ),
                        items: selectedState == null
                            ? []
                            : indiaLocations[selectedState]!
                                .map((district) {
                                return DropdownMenuItem<String>(
                                  value: district,
                                  child: Text(
                                    district,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF344054),
                                    ),
                                  ),
                                );
                              }).toList(),
                        onChanged: selectedState == null
                            ? null
                            : (value) {
                                setState(() {
                                  selectedDistrict = value;
                                });
                              },
                      ),

                      const SizedBox(height: 26),

                      // ---------------------------------------------------
                      // Create Account Button
                      // ---------------------------------------------------

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: loading ? null : signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF174EA6),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                const Color(0xFF98A2B3),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                          ),
                          child: loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor:
                                        AlwaysStoppedAnimation<
                                            Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'CREATE ACCOUNT',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ---------------------------------------------------
                      // Login
                      // ---------------------------------------------------

                      Center(
                        child: TextButton(
                          onPressed: loading
                              ? null
                              : () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const LoginScreen(),
                                    ),
                                  );
                                },
                          style: TextButton.styleFrom(
                            foregroundColor:
                                const Color(0xFF174EA6),
                          ),
                          child: const Text(
                            'Already have an account? Sign In',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Footer
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'Authorized Officer Registration',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475467),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Legal Metrology Verification System',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF98A2B3),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}