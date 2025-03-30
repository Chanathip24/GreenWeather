import 'package:flutter/material.dart';

class AirQualityForm extends StatefulWidget {
  const AirQualityForm({Key? key}) : super(key: key);

  @override
  State<AirQualityForm> createState() => _AirQualityFormState();
}

class _AirQualityFormState extends State<AirQualityForm> {
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _aqiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _symptomsController.dispose();
    _aqiController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process data here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ส่งข้อมูลสำเร็จ'),
          backgroundColor: Colors.green,
        ),
      );
      _symptomsController.clear();
      _aqiController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('แบบฟอร์มดัชนีคุณภาพอากาศ'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  color: Colors.grey.shade200,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'แบบฟอร์มดัชนีคุณภาพ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Symptoms field
                const Text(
                  'ลักษณะอาการ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _symptomsController,
                  decoration: const InputDecoration(
                    hintText: 'ระบุลักษณะอาการ',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาระบุลักษณะอาการ';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // AQI Value field
                const Text(
                  'AQI Value',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _aqiController,
                  decoration: const InputDecoration(
                    hintText: 'ระบุค่า AQI',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาระบุค่า AQI';
                    }
                    if (int.tryParse(value) == null) {
                      return 'กรุณาระบุตัวเลขเท่านั้น';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ส่งข้อมูล',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
