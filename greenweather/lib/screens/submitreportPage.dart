import 'package:flutter/material.dart';
import 'package:greenweather/providers/authentication_provider.dart';
import 'package:greenweather/screens/loginPage.dart';
import 'package:provider/provider.dart';

class AirQualityForm extends StatefulWidget {
  const AirQualityForm({super.key});

  @override
  State<AirQualityForm> createState() => _AirQualityFormState();
}

class _AirQualityFormState extends State<AirQualityForm> {
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _aqiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _symptomsController.dispose();
    _aqiController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('ส่งข้อมูลสำเร็จ'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(12),
        ),
      );

      // Clear form
      _symptomsController.clear();
      _aqiController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    if (!authProvider.isAuthenticate) {
      return LoginPage();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('แบบฟอร์มคุณภาพอากาศ',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
        centerTitle: true,
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showAqiInfoDialog(context);
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const Text(
                      'รายงานคุณภาพอากาศ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'กรุณากรอกข้อมูลเพื่อรายงานคุณภาพอากาศในพื้นที่ของคุณ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Symptoms field
                    const Text(
                      'ลักษณะอาการ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _symptomsController,
                      decoration: InputDecoration(
                        hintText: 'เช่น แสบตา ไอ หายใจลำบาก',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.green.shade400),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาระบุลักษณะอาการ';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // AQI Value field
                    Row(
                      children: [
                        const Text(
                          'ค่าดัชนีคุณภาพอากาศ (AQI)',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: 'ค่า AQI ระหว่าง 0-500',
                          child: Icon(Icons.help_outline,
                              color: Colors.grey.shade500, size: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _aqiController,
                      decoration: InputDecoration(
                        hintText: 'ระบุค่า AQI เช่น 125',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.green.shade400),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาระบุค่า AQI';
                        }
                        if (int.tryParse(value) == null) {
                          return 'กรุณาระบุตัวเลขเท่านั้น';
                        }
                        final aqi = int.parse(value);
                        if (aqi < 0 || aqi > 500) {
                          return 'ค่า AQI ควรอยู่ระหว่าง 0-500';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),
                    _buildAqiIndicator(),

                    const SizedBox(height: 40),

                    // Submit Button
                    SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade500,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.green.shade200,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'ส่งข้อมูล',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAqiIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _aqiLevelIndicator('ดี', Colors.green),
              _aqiLevelIndicator('ปานกลาง', Colors.yellow.shade700),
              _aqiLevelIndicator('เริ่มมีผลต่อสุขภาพ', Colors.orange),
              _aqiLevelIndicator('มีผลต่อสุขภาพ', Colors.red.shade400),
              _aqiLevelIndicator('อันตราย', Colors.purple.shade400),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              Text('100',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              Text('200',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              Text('300',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              Text('500',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _aqiLevelIndicator(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  void _showAqiInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ระดับค่า AQI',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _aqiInfoRow('0-50', 'ดี', Colors.green),
            _aqiInfoRow('51-100', 'ปานกลาง', Colors.yellow.shade700),
            _aqiInfoRow(
                '101-150', 'ไม่ดีต่อสุขภาพต่อกลุ่มเสี่ยง', Colors.orange),
            _aqiInfoRow('151-200', 'ไม่ดีต่อสุขภาพ', Colors.red.shade400),
            _aqiInfoRow('201-300', 'อันตราย', Colors.purple.shade400),
            _aqiInfoRow('>300', 'อันตรายร้ายแรง', Colors.purple.shade900),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ปิด', style: TextStyle(color: Colors.green.shade600)),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _aqiInfoRow(String range, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(range, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(description, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
