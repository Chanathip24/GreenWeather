import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenweather/model/Redemptionmodel.dart';
import 'package:greenweather/model/Rewardmodel.dart';
import 'package:greenweather/providers/reward_provider.dart';
import 'package:provider/provider.dart';

class AddRewardItemPage extends StatefulWidget {
  final List<RewardItem>? data;
  final int? rewardId;

  const AddRewardItemPage(
      {super.key, required this.data, required this.rewardId});

  @override
  State<AddRewardItemPage> createState() => _AddRewardItemPageState();
}

class _AddRewardItemPageState extends State<AddRewardItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _singleValueController = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingItems = false;

  List<RewardItem>? _currentItems = [];
  bool _showCurrentItems = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentItems();
  }

  Future<void> _loadCurrentItems() async {
    setState(() {
      _isLoadingItems = true;
    });

    try {
      final mockItems = widget.data;

      if (mounted) {
        setState(() {
          _currentItems = mockItems;
          _isLoadingItems = false;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $error'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoadingItems = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _singleValueController.dispose();
    super.dispose();
  }

  Future<void> _addSingleItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    //provider
    final rewardProvider = Provider.of<RewardProvider>(context, listen: false);
    try {
      final RewardItem item = RewardItem(
        rewardId: widget.rewardId!,
        value: _singleValueController.text,
        isUsed: false,
      );

      await Future.delayed(const Duration(milliseconds: 500));
      await Provider.of<RewardProvider>(context, listen: false)
          .createRewardItem(item);

      if (rewardProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error ${rewardProvider.error}")));
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Add Item successfully")));
      setState(() {
        _currentItems!.add(RewardItem(
          id: _currentItems!.length + 1,
          rewardId: widget.rewardId!,
          value: _singleValueController.text,
          isUsed: false,
        ));
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เพิ่มไอเทมสำเร็จ'),
            backgroundColor: Colors.green,
          ),
        );
        _singleValueController.clear();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateSingleValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณากรอกค่าไอเทม';
    }
    return null;
  }

  Widget _buildCurrentItemsSection() {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'รายการไอเทมปัจจุบัน (${_currentItems?.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (_isLoadingItems)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Container(
            height: 200,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _isLoadingItems
                ? const Center(child: Text('กำลังโหลดข้อมูล...'))
                : _currentItems!.isEmpty
                    ? const Center(child: Text('ไม่พบรายการไอเทม'))
                    : ListView.builder(
                        itemCount: _currentItems?.length,
                        itemBuilder: (context, index) {
                          final item = _currentItems![index];
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              item.isUsed!
                                  ? Icons.check_circle_outline
                                  : Icons.radio_button_unchecked,
                              color: item.isUsed! ? Colors.green : Colors.grey,
                            ),
                            title: Text(item.value!),
                            subtitle: Text(
                              'ID: ${item.id} • สถานะ: ${item.isUsed! ? "ใช้แล้ว" : "ยังไม่ได้ใช้"}',
                              style: TextStyle(
                                fontSize: 12,
                                color: item.isUsed!
                                    ? Colors.green.shade700
                                    : Colors.grey.shade700,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.copy, size: 18),
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: item.value!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('คัดลอก ${item.value} แล้ว'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              tooltip: 'คัดลอก',
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleModeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'เพิ่มไอเทมทีละรายการ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _singleValueController,
          decoration: const InputDecoration(
            labelText: 'ค่าไอเทม',
            border: OutlineInputBorder(),
            hintText: 'เช่น รหัสส่วนลด, โค้ด, ซีเรียลนัมเบอร์',
            prefixIcon: Icon(Icons.qr_code),
          ),
          validator: _validateSingleValue,
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _addSingleItem,
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.add),
          label: Text(_isLoading ? 'กำลังเพิ่ม...' : 'เพิ่มไอเทม'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มไอเทมแล้ว'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
                _showCurrentItems ? Icons.visibility_off : Icons.visibility),
            tooltip: _showCurrentItems ? 'ซ่อนรายการ' : 'แสดงรายการ',
            onPressed: () {
              setState(() {
                _showCurrentItems = !_showCurrentItems;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'รีเฟรช',
            onPressed: _isLoadingItems ? null : _loadCurrentItems,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_showCurrentItems) _buildCurrentItemsSection(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildSingleModeContent(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
