import 'package:flutter/material.dart';
import '../features/auth/auth_service.dart';
import 'signup_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // ============================================================
  // SERVICES
  // ============================================================

  final AuthService _authService = AuthService();

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  // ============================================================
  // STATE
  // ============================================================

  bool isLoading = false;
  bool obscurePassword = true;

  String? emailError;
  String? passwordError;

  // ============================================================
  // ANIMATION
  // ============================================================

  AnimationController? _animationController;

  Animation<double>? _fadeAnimation;

  Animation<Offset>? _slideAnimation;

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF174EA6);
  // static const Color deepBlue = Color(0xFF0D47A1);
  static const Color teal = Color(0xFF00897B);
  // static const Color lightBlue = Color(0xFFEAF3FF);
  static const Color saffron = Color(0xFFFFA000);
  static const Color successGreen = Color(0xFF2E7D32);

  // ============================================================
  // INIT STATE
  // ============================================================

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController!.forward();

    emailController.addListener(_clearEmailError);
    passwordController.addListener(_clearPasswordError);
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    emailController.removeListener(_clearEmailError);
    passwordController.removeListener(_clearPasswordError);

    emailController.dispose();
    passwordController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    _animationController?.dispose();

    super.dispose();
  }

  // ============================================================
  // ERROR HANDLING
  // ============================================================

  void _clearEmailError() {
    if (emailError != null && emailController.text.isNotEmpty) {
      setState(() {
        emailError = null;
      });
    }
  }

  void _clearPasswordError() {
    if (passwordError != null &&
        passwordController.text.isNotEmpty) {
      setState(() {
        passwordError = null;
      });
    }
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool _validateFields() {
    bool valid = true;

    emailError = null;
    passwordError = null;

    final String email = emailController.text.trim();
    final String password = passwordController.text;

    if (email.isEmpty) {
      emailError = 'Email address is required';
      valid = false;
    } else if (!email.contains('@') || !email.contains('.')) {
      emailError = 'Enter a valid email address';
      valid = false;
    }

    if (password.isEmpty) {
      passwordError = 'Password is required';
      valid = false;
    } else if (password.length < 6) {
      passwordError =
          'Password must contain at least 6 characters';
      valid = false;
    }

    setState(() {});

    return valid;
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_validateFields()) {
      return;
    }

    final String email = emailController.text.trim();
    final String password = passwordController.text;

    setState(() {
      isLoading = true;
    });

    try {
      /*
       * IMPORTANT:
       *
       * This is your existing Node.js / Express backend
       * authentication flow.
       *
       * Do NOT replace this with Firebase authentication.
       */

      final String? token =
          await _authService.backendLogin(
        email,
        password,
      );

      if (!mounted) return;

      if (token == null || token.isEmpty) {
        setState(() {
          isLoading = false;
        });

        _showMessage(
          'Invalid email or password.',
          isError: true,
        );

        return;
      }

      /*
       * Existing user identification flow.
       */
      final String currentUserId = email;

      await Future.delayed(
        const Duration(milliseconds: 300),
      );

      if (!mounted) return;

      /*
       * Existing dashboard navigation.
       */
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(
            currentUserId: currentUserId,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(
        _getErrorMessage(e),
        isError: true,
      );
    }
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String _getErrorMessage(Object error) {
    String message = error.toString();

    if (message.startsWith('Exception: ')) {
      message = message.substring(11);
    }

    if (message.trim().isEmpty) {
      return 'Something went wrong. Please try again.';
    }

    return message;
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(
        18,
        0,
        18,
        18,
      ),
      elevation: 8,
      backgroundColor:
          isError ? const Color(0xFFB3261E) : successGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Row(
        children: [
          Icon(
            isError
                ? Icons.error_outline_rounded
                : Icons.check_circle_outline_rounded,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: errorText,

      prefixIcon: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 8,
        ),
        child: Icon(
          icon,
          color: primaryBlue,
          size: 21,
        ),
      ),

      suffixIcon: suffixIcon,

      filled: true,
      fillColor: const Color(0xFFF8FAFD),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),

      labelStyle: const TextStyle(
        color: Color(0xFF68758A),
        fontWeight: FontWeight.w500,
      ),

      hintStyle: const TextStyle(
        color: Color(0xFFA0A9B8),
        fontSize: 14,
      ),

      floatingLabelStyle: const TextStyle(
        color: primaryBlue,
        fontWeight: FontWeight.w700,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFE1E7EF),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFE1E7EF),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: primaryBlue,
          width: 1.8,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFD32F2F),
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFD32F2F),
          width: 1.8,
        ),
      ),
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _buildLogo() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryBlue,
            teal,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.25),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.balance_rounded,
        color: Colors.white,
        size: 39,
      ),
    );
  }

  // ============================================================
  // BRAND HEADER
  // ============================================================

  Widget _buildBrandHeader() {
    return Row(
      children: [
        _buildLogo(),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'MaapSetu',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                  color: Color(0xFF172033),
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Legal Metrology Digital Platform',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SECURE BADGE
  // ============================================================

  Widget _buildSecureBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7F4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFC8E9E2),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_user_rounded,
            size: 15,
            color: teal,
          ),
          SizedBox(width: 6),
          Text(
            'Secure Officer Portal',
            style: TextStyle(
              color: teal,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TITLE SECTION
  // ============================================================

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome back, Officer',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.15,
            letterSpacing: -0.8,
            color: Color(0xFF152238),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'Sign in to continue to your verification workspace.',
          style: TextStyle(
            fontSize: 14.5,
            height: 1.5,
            color: Colors.blueGrey.shade600,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 18),

        _buildSecureBadge(),
      ],
    );
  }

  // ============================================================
  // EMAIL FIELD
  // ============================================================

  Widget _buildEmailField() {
    return TextField(
      controller: emailController,
      focusNode: emailFocusNode,

      keyboardType: TextInputType.emailAddress,

      textInputAction: TextInputAction.next,

      autofillHints: const [
        AutofillHints.email,
      ],

      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(
          passwordFocusNode,
        );
      },

      decoration: _inputDecoration(
        label: 'Official Email',
        hint: 'Enter your registered email',
        icon: Icons.email_outlined,
        errorText: emailError,
      ),
    );
  }

  // ============================================================
  // PASSWORD FIELD
  // ============================================================

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      focusNode: passwordFocusNode,

      obscureText: obscurePassword,

      textInputAction: TextInputAction.done,

      autofillHints: const [
        AutofillHints.password,
      ],

      onSubmitted: (_) {
        if (!isLoading) {
          _login();
        }
      },

      decoration: _inputDecoration(
        label: 'Password',
        hint: 'Enter your password',
        icon: Icons.lock_outline_rounded,
        errorText: passwordError,

        suffixIcon: IconButton(
          tooltip: obscurePassword
              ? 'Show password'
              : 'Hide password',

          onPressed: () {
            setState(() {
              obscurePassword =
                  !obscurePassword;
            });
          },

          icon: Icon(
            obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.blueGrey.shade500,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOGIN BUTTON
  // ============================================================

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : _login,

        style: ElevatedButton.styleFrom(
          elevation: 0,

          backgroundColor: primaryBlue,

          disabledBackgroundColor:
              primaryBlue.withOpacity(0.65),

          foregroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(17),
          ),
        ),

        child: AnimatedSwitcher(
          duration:
              const Duration(milliseconds: 250),

          child: isLoading
              ? const SizedBox(
                  key: ValueKey('loading'),

                  width: 23,
                  height: 23,

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
              : const Row(
                  key: ValueKey('login'),

                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight:
                            FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),

                    SizedBox(width: 10),

                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 21,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ============================================================
  // SIGNUP SECTION
  // ============================================================

  Widget _buildSignupSection() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [
        Text(
          'New officer?',
          style: TextStyle(
            fontSize: 13.5,
            color: Colors.blueGrey.shade600,
          ),
        ),

        TextButton(
          onPressed: isLoading
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const SignupPage(),
                    ),
                  );
                },

          style: TextButton.styleFrom(
            foregroundColor: primaryBlue,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 4,
            ),
          ),

          child: const Text(
            'Create account',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SECURITY FOOTER
  // ============================================================

  Widget _buildSecurityFooter() {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FD),

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color: const Color(0xFFE4EAF2),
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            width: 34,
            height: 34,

            decoration: BoxDecoration(
              color: const Color(0xFFFFF4DE),
              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: const Icon(
              Icons.shield_outlined,
              size: 19,
              color: saffron,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Authorized Access Only',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight:
                        FontWeight.w800,
                    color: Color(0xFF253247),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'This portal is intended for authorized '
                  'Legal Metrology officers and personnel.',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.4,
                    color:
                        Colors.blueGrey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COLOR STRIP
  // ============================================================

  Widget _buildColorStrip() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 4,

            decoration:
                const BoxDecoration(
              color: primaryBlue,

              borderRadius:
                  BorderRadius.only(
                topLeft:
                    Radius.circular(4),
                bottomLeft:
                    Radius.circular(4),
              ),
            ),
          ),
        ),

        Expanded(
          child: Container(
            height: 4,
            color: teal,
          ),
        ),

        Expanded(
          child: Container(
            height: 4,

            decoration:
                const BoxDecoration(
              color: saffron,

              borderRadius:
                  BorderRadius.only(
                topRight:
                    Radius.circular(4),
                bottomRight:
                    Radius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media =
        MediaQuery.of(context);

    final double screenHeight =
        media.size.height;

    final bool isSmallScreen =
        screenHeight < 700;

    /*
     * Safe fallback animations.
     *
     * This prevents the:
     *
     * "LateInitializationError:
     * Field '_fadeAnimation' has not been initialized"
     *
     * problem.
     */

    final Animation<double> fadeAnimation =
        _fadeAnimation ??
            const AlwaysStoppedAnimation<double>(
              1.0,
            );

    final Animation<Offset> slideAnimation =
        _slideAnimation ??
            const AlwaysStoppedAnimation<Offset>(
              Offset.zero,
            );

    return Scaffold(
      backgroundColor:
          const Color(0xFFF3F7FC),

      body: Stack(
        children: [
          // ====================================================
          // BACKGROUND DECORATION
          // ====================================================

          Positioned(
            top: -100,
            right: -80,

            child: Container(
              width: 250,
              height: 250,

              decoration:
                  BoxDecoration(
                shape: BoxShape.circle,

                color:
                    primaryBlue.withOpacity(
                  0.055,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -120,
            left: -100,

            child: Container(
              width: 280,
              height: 280,

              decoration:
                  BoxDecoration(
                shape: BoxShape.circle,

                color:
                    teal.withOpacity(
                  0.05,
                ),
              ),
            ),
          ),

          // ====================================================
          // MAIN CONTENT
          // ====================================================

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),

                padding:
                    EdgeInsets.symmetric(
                  horizontal:
                      media.size.width > 600
                          ? 32
                          : 20,

                  vertical:
                      isSmallScreen
                          ? 18
                          : 30,
                ),

                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 480,
                  ),

                  child: FadeTransition(
                    opacity: fadeAnimation,

                    child: SlideTransition(
                      position: slideAnimation,

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          // ==================================================
                          // BRAND
                          // ==================================================

                          _buildBrandHeader(),

                          SizedBox(
                            height:
                                isSmallScreen
                                    ? 30
                                    : 42,
                          ),

                          // ==================================================
                          // TITLE
                          // ==================================================

                          _buildTitleSection(),

                          SizedBox(
                            height:
                                isSmallScreen
                                    ? 22
                                    : 30,
                          ),

                          // ==================================================
                          // LOGIN CARD
                          // ==================================================

                          Container(
                            width: double.infinity,

                            decoration:
                                BoxDecoration(
                              color: Colors.white,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                28,
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors
                                      .black
                                      .withOpacity(
                                    0.055,
                                  ),

                                  blurRadius: 35,

                                  offset:
                                      const Offset(
                                    0,
                                    15,
                                  ),
                                ),
                              ],

                              border:
                                  Border.all(
                                color:
                                    const Color(
                                  0xFFE8EDF4,
                                ),
                              ),
                            ),

                            child: Column(
                              children: [
                                // ==========================================
                                // TOP COLOR STRIP
                                // ==========================================

                                _buildColorStrip(),

                                Padding(
                                  padding:
                                      EdgeInsets.all(
                                    isSmallScreen
                                        ? 20
                                        : 26,
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [
                                      // ====================================
                                      // CARD TITLE
                                      // ====================================

                                      const Text(
                                        'Officer Sign In',
                                        style:
                                            TextStyle(
                                          fontSize:
                                              19,
                                          fontWeight:
                                              FontWeight
                                                  .w800,
                                          color:
                                              Color(
                                            0xFF1C293B,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 5,
                                      ),

                                      Text(
                                        'Use your registered credentials '
                                        'to access MaapSetu.',
                                        style:
                                            TextStyle(
                                          fontSize:
                                              12.5,
                                          color: Colors
                                              .blueGrey
                                              .shade500,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 22,
                                      ),

                                      // ====================================
                                      // EMAIL
                                      // ====================================

                                      _buildEmailField(),

                                      const SizedBox(
                                        height: 17,
                                      ),

                                      // ====================================
                                      // PASSWORD
                                      // ====================================

                                      _buildPasswordField(),

                                      const SizedBox(
                                        height: 23,
                                      ),

                                      // ====================================
                                      // LOGIN BUTTON
                                      // ====================================

                                      _buildLoginButton(),

                                      const SizedBox(
                                        height: 10,
                                      ),

                                      // ====================================
                                      // SIGNUP
                                      // ====================================

                                      _buildSignupSection(),

                                      const SizedBox(
                                        height: 8,
                                      ),

                                      // ====================================
                                      // SECURITY
                                      // ====================================

                                      _buildSecurityFooter(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 24,
                          ),

                          // ==================================================
                          // FOOTER
                          // ==================================================

                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'MaapSetu • Legal Metrology',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight:
                                        FontWeight.w700,
                                    color: Colors
                                        .blueGrey
                                        .shade500,
                                  ),
                                ),

                                const SizedBox(
                                  height: 5,
                                ),

                                Text(
                                  'Digital Verification & '
                                  'Certification System',
                                  textAlign:
                                      TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: Colors
                                        .blueGrey
                                        .shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}