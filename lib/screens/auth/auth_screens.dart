// lib/screens/auth/auth_screens.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _signInEmail() async {
    if (!_emailFormKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.signInWithEmail(_emailCtrl.text, _passwordCtrl.text);
    if (success && mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  Future<void> _sendOTP() async {
    if (!_phoneFormKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.sendOTP(_phoneCtrl.text);
    if (success && mounted) {
      Navigator.of(context).pushNamed(AppRoutes.otpVerification, arguments: {'phone': _phoneCtrl.text});
    }
  }

  Future<void> _googleSignIn() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.signInWithGoogle();
    if (success && mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgOffWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Header
                _buildHeader(),
                const SizedBox(height: 32),
                // Tab Bar
                _buildTabBar(),
                const SizedBox(height: 28),
                // Tab Content
                SizedBox(
                  height: 340,
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildEmailTab(), _buildPhoneTab()],
                  ),
                ),
                // Social Sign In
                _buildSocialSection(),
                const SizedBox(height: 24),
                // Register Link
                _buildRegisterLink(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: AppColors.matteBlack,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('M', style: TextStyle(fontFamily: 'Montserrat', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.softGold)),
              ),
            ),
            const SizedBox(width: 12),
            const Text('MOSPL', style: TextStyle(fontFamily: 'Montserrat', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textCharcoal, letterSpacing: 4)),
          ],
        ),
        const SizedBox(height: 28),
        Text(AppStrings.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(AppStrings.loginSubtitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgLightCream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.matteBlack,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: AppColors.textWhite,
        unselectedLabelColor: AppColors.textDarkGray,
        labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
        tabs: const [Tab(text: 'Email'), Tab(text: 'Phone')],
      ),
    );
  }

  Widget _buildEmailTab() {
    return Form(
      key: _emailFormKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailCtrl,
            label: 'Email Address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passwordCtrl,
            label: 'Password',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.textLight),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (v) => v == null || v.length < 6 ? 'Password must be 6+ characters' : null,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20, height: 20,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (v) => setState(() => _rememberMe = v ?? false),
                      activeColor: AppColors.softBrown,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Remember me', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textDarkGray)),
                ],
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.forgotPassword),
                child: const Text('Forgot Password?', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.softBrown, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Consumer<AuthProvider>(
            builder: (context, auth, _) => LoadingButton(
              onPressed: _signInEmail,
              isLoading: auth.isLoading,
              label: 'Sign In',
              errorMessage: auth.errorMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneTab() {
    return Form(
      key: _phoneFormKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _phoneCtrl,
            label: 'Mobile Number',
            prefixIcon: Icons.phone_outlined,
            prefixText: '+91 ',
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: (v) => v == null || v.length != 10 ? 'Enter valid 10-digit number' : null,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.softBrown.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.softBrown.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.softBrown, size: 16),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('We\'ll send a 6-digit OTP to verify your number', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.softBrown)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Consumer<AuthProvider>(
            builder: (context, auth, _) => LoadingButton(
              onPressed: _sendOTP,
              isLoading: auth.isLoading,
              label: 'Send OTP',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialSection() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('or continue with', style: Theme.of(context).textTheme.bodySmall),
            ),
            const Expanded(child: Divider(color: AppColors.border)),
          ],
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: _googleSignIn,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: const BorderSide(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 22, height: 22,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(child: Text('G', style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFDB4437)))),
              ),
              const SizedBox(width: 12),
              const Text('Continue with Google', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textCharcoal)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.biometricSetup),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: const BorderSide(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fingerprint, color: AppColors.softBrown, size: 22),
              const SizedBox(width: 12),
              const Text('Biometric Login', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textCharcoal)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Don\'t have an account? ', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textDarkGray)),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.register),
            child: const Text('Create Account', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.softBrown)),
          ),
        ],
      ),
    );
  }
}

// ==================== REGISTER SCREEN ====================
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _passwordCtrl.dispose(); _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to Terms & Conditions')),
      );
      return;
    }
    final auth = context.read<AuthProvider>();
    final success = await auth.signUpWithEmail(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      phone: _phoneCtrl.text.trim(),
    );
    if (success && mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgOffWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.registerTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text(AppStrings.registerSubtitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 28),
              // Welcome bonus badge
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.softGold.withOpacity(0.15), AppColors.warmBeige]),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.softGold.withOpacity(0.3)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.star_rounded, color: AppColors.softGold, size: 20),
                    SizedBox(width: 10),
                    Text('Get 100 reward points on signup!', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.softBrown)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _nameCtrl,
                label: 'Full Name',
                prefixIcon: Icons.person_outline,
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailCtrl,
                label: 'Email Address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneCtrl,
                label: 'Mobile Number',
                prefixIcon: Icons.phone_outlined,
                prefixText: '+91 ',
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (v) => v == null || v.length != 10 ? 'Enter valid 10-digit number' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordCtrl,
                label: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.textLight),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (v) => v == null || v.length < 6 ? 'Password must be 6+ characters' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirmPasswordCtrl,
                label: 'Confirm Password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureConfirm,
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.textLight),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                validator: (v) => v != _passwordCtrl.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22, height: 22,
                    child: Checkbox(
                      value: _agreeTerms,
                      onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                      activeColor: AppColors.softBrown,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textDarkGray),
                        children: [
                          const TextSpan(text: 'I agree to MOSPL\'s '),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, AppRoutes.terms),
                              child: const Text('Terms & Conditions', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.softBrown)),
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, AppRoutes.privacy),
                              child: const Text('Privacy Policy', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.softBrown)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Consumer<AuthProvider>(
                builder: (context, auth, _) => LoadingButton(
                  onPressed: _register,
                  isLoading: auth.isLoading,
                  label: 'Create Account',
                  errorMessage: auth.errorMessage,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textDarkGray)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('Sign In', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.softBrown)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== OTP SCREEN ====================
class OtpVerificationScreen extends StatefulWidget {
  final String phone;
  const OtpVerificationScreen({super.key, required this.phone});
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _resendTimer = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_resendTimer > 0) _resendTimer--;
        else _canResend = true;
      });
      return _resendTimer > 0;
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter complete 6-digit OTP')));
      return;
    }
    final auth = context.read<AuthProvider>();
    final success = await auth.verifyOTP(_otp, phone: widget.phone);
    if (success && mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgOffWhite,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(AppStrings.otpTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textDarkGray, height: 1.5),
                children: [
                  const TextSpan(text: 'OTP sent to '),
                  TextSpan(text: '+91 ${widget.phone}', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // OTP Input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 48,
                  height: 56,
                  child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(fontFamily: 'Montserrat', fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textCharcoal),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: AppColors.bgLightCream,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.softBrown, width: 2)),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) _focusNodes[index + 1].requestFocus();
                      if (value.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
                      setState(() {});
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            // Resend
            Center(
              child: _canResend
                  ? TextButton(
                onPressed: () {
                  setState(() { _resendTimer = 60; _canResend = false; });
                  context.read<AuthProvider>().sendOTP(widget.phone);
                  _startTimer();
                },
                child: const Text('Resend OTP', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: AppColors.softBrown)),
              )
                  : Text('Resend OTP in ${_resendTimer}s', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textLight)),
            ),
            const SizedBox(height: 32),
            Consumer<AuthProvider>(
              builder: (context, auth, _) => LoadingButton(
                onPressed: _verify,
                isLoading: auth.isLoading,
                label: 'Verify OTP',
                errorMessage: auth.errorMessage,
                enabled: _otp.length == 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== FORGOT PASSWORD SCREEN ====================
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _emailSent = false;

  @override
  void dispose() { _emailCtrl.dispose(); super.dispose(); }

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.sendPasswordResetEmail(_emailCtrl.text);
    if (success && mounted) setState(() => _emailSent = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgOffWhite,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _emailSent ? _buildSuccessState() : _buildFormState(),
      ),
    );
  }

  Widget _buildFormState() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Icon(Icons.lock_reset, size: 52, color: AppColors.softBrown),
          const SizedBox(height: 20),
          Text(AppStrings.forgotPasswordTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(AppStrings.forgotPasswordSubtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 36),
          CustomTextField(
            controller: _emailCtrl,
            label: 'Email Address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
          ),
          const SizedBox(height: 28),
          Consumer<AuthProvider>(
            builder: (context, auth, _) => LoadingButton(
              onPressed: _sendReset,
              isLoading: auth.isLoading,
              label: 'Send Reset Link',
              errorMessage: auth.errorMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 90, height: 90,
          decoration: BoxDecoration(color: AppColors.accentSuccess.withOpacity(0.1), shape: BoxShape.circle),
          child: const Icon(Icons.check_circle_outline, size: 50, color: AppColors.accentSuccess),
        ),
        const SizedBox(height: 24),
        const Text('Email Sent!', style: TextStyle(fontFamily: 'Montserrat', fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
        const SizedBox(height: 12),
        Text(
          'We\'ve sent a password reset link to\n${_emailCtrl.text}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, color: AppColors.textDarkGray, height: 1.6),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.login),
          child: const Text('Back to Login'),
        ),
      ],
    );
  }
}