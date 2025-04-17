import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenweather/model/rewardModel.dart';

class AddEditRewardPage extends StatefulWidget {
  final Reward? reward;

  const AddEditRewardPage({super.key, this.reward});

  @override
  State<AddEditRewardPage> createState() => _AddEditRewardPageState();
}

class _AddEditRewardPageState extends State<AddEditRewardPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _selectedType = 'DIGITAL';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.reward != null) {
      _nameController.text = widget.reward?.name ?? "No name provided";
      _descriptionController.text =
          widget.reward?.description ?? "No description provided";
      _costController.text =
          widget.reward?.cost.toString() ?? "No cost provided";
      _imageUrlController.text = widget.reward?.imageUrl ?? "";
      _selectedType = widget.reward?.type ?? "DIGITAL";
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _costController.dispose();

    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveReward() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      //model
      final Reward rewardData = Reward(
        id: widget.reward?.id ?? 999,
        name: _nameController.text,
        description: _descriptionController.text,
        cost: int.parse(_costController.text),
        type: _selectedType,
        imageUrl: _imageUrlController.text,
      );

      //service

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.reward == null
                ? 'เพิ่มรางวัลสำเร็จ (mock)'
                : 'แก้ไขรางวัลสำเร็จ (mock)'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, rewardData);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.green.shade300 : Colors.green.shade600;
    final backgroundColor =
        isDark ? Theme.of(context).colorScheme.surface : Colors.grey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.reward == null ? 'เพิ่มรางวัลใหม่' : 'แก้ไขรางวัล',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Preview image from URL
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: _imageUrlController.text.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildImagePlaceholder(primaryColor);
                                  },
                                ),
                              )
                            : _buildImagePlaceholder(primaryColor),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: InputDecoration(
                          labelText: 'URL รูปภาพ',
                          hintText: 'https://example.com/image.jpg',
                          prefixIcon: const Icon(Icons.link),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.url,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'ชื่อรางวัล',
                          prefixIcon: const Icon(Icons.card_giftcard),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'กรุณาใส่ชื่อรางวัล'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'รายละเอียด',
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 3,
                        validator: (value) => value == null || value.isEmpty
                            ? 'กรุณาใส่รายละเอียด'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: InputDecoration(
                          labelText: 'ประเภท',
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'FOOD', child: Text('FOOD')),
                          DropdownMenuItem(
                              value: 'DIGITAL', child: Text('DIGITAL')),
                          DropdownMenuItem(
                              value: 'VOUCHERS', child: Text('VOUCHERS')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedType = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _costController,
                        decoration: InputDecoration(
                          labelText: 'ราคา (แต้ม)',
                          prefixIcon: const Icon(Icons.stars_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          final number = int.tryParse(value ?? '');
                          if (value == null || value.isEmpty)
                            return 'กรุณาใส่ราคา';
                          if (number == null || number <= 0)
                            return 'ราคาต้องมากกว่า 0';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: _saveReward,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          widget.reward == null
                              ? 'เพิ่มรางวัล (mock)'
                              : 'บันทึกการแก้ไข (mock)',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildImagePlaceholder(Color primaryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined,
              size: 48, color: primaryColor),
          const SizedBox(height: 8),
          Text('ใส่ URL รูปภาพด้านบน', style: TextStyle(color: primaryColor)),
        ],
      ),
    );
  }
}
