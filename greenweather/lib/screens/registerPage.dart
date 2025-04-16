import 'package:flutter/material.dart';
import 'package:greenweather/model/userModel.dart';
import 'package:greenweather/providers/authentication_provider.dart';
import 'package:greenweather/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  AuthenticationProvider authProvider;
  RegisterPage({required this.authProvider, Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'สร้างบัญชีใหม่',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App logo
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.wb_sunny,
                        color: Colors.green,
                        size: 54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Welcome text
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Green Weather',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'สร้างบัญชีเพื่อติดตามสภาพอากาศ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildInputField(
                  label: 'Firstname',
                  hintText: 'ชื่อจริง',
                  controller: _fnameController,
                  icon: Icons.person_outline,
                ),
                // Full Name field
                const SizedBox(height: 16),

                _buildInputField(
                  label: 'Lastname',
                  hintText: 'ชื่อเล่น',
                  controller: _lnameController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),

                // Email field
                _buildInputField(
                  label: 'Email',
                  hintText: 'อีเมล',
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password field
                _buildInputField(
                  label: 'Password',
                  hintText: 'รหัสผ่าน',
                  controller: _passwordController,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password field
                _buildInputField(
                  label: 'Confirm Password',
                  hintText: 'ยืนยันรหัสผ่าน',
                  controller: _confirmPasswordController,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Terms and conditions checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? true;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                    Expanded(
                      child: Text(
                        'ฉันยอมรับข้อกำหนดและเงื่อนไขการใช้งาน',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Register button
                ElevatedButton(
                  onPressed: () async {
                    if (_fnameController.text.isEmpty ||
                        _lnameController.text.isEmpty ||
                        _emailController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    String? error = AuthService.validatePassword(
                        _passwordController.text,
                        _confirmPasswordController.text,
                        _acceptTerms);
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    await widget.authProvider.register(
                      Usermodel(
                        fname: _fnameController.text,
                        lname: _lnameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      ),
                    );
                    if (widget.authProvider.isAuthenticate) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('สมัครสมาชิกสำเร็จ'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(widget.authProvider.error!),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: widget.authProvider.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'สมัครสมาชิก',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 24),

                // Already have an account
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'มีบัญชีอยู่แล้ว?',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // // Or divider
                // Row(
                //   children: [
                //     Expanded(
                //       child: Divider(color: Colors.grey[300], thickness: 1),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 16),
                //       child: Text(
                //         'หรือ',
                //         style: TextStyle(
                //           color: Colors.grey[600],
                //           fontSize: 14,
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: Divider(color: Colors.grey[300], thickness: 1),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 16),

                // // Social login
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _socialLoginButton(
                //       icon: Icons.facebook,
                //       color: Colors.blue,
                //       onPressed: () {},
                //     ),
                //     const SizedBox(width: 16),
                //     _socialLoginButton(
                //       icon: Icons.g_mobiledata_rounded,
                //       color: Colors.red,
                //       onPressed: () {},
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    bool? obscureText,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword ? (obscureText ?? true) : false,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.grey),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText! ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: EdgeInsets.symmetric(vertical: 16),
          ),
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget _socialLoginButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
