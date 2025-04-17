import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenweather/model/Redemptionmodel.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class AddRewardItemPage extends StatefulWidget {
  final int rewardId;
  final String rewardName;

  const AddRewardItemPage({
    super.key,
    required this.rewardId,
    required this.rewardName,
  });

  @override
  State<AddRewardItemPage> createState() => _AddRewardItemPageState();
}

class _AddRewardItemPageState extends State<AddRewardItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _singleValueController = TextEditingController();
  final _bulkValueController = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingItems = false;
  bool _isBulkMode = false;
  List<String> _bulkValues = [];
  int _validItemsCount = 0;
  List<Redemption> _currentItems = [];
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
      // TODO: Replace with actual service call
      // For example:
      // final rewardService = Provider.of<RewardService>(context, listen: false);
      // final items = await rewardService.getRewardItems(widget.rewardId);

      // Mock data for demonstration
      await Future.delayed(const Duration(seconds: 1));
      final mockItems = [
        Redemption(
            id: 1,
            rewardId: widget.rewardId,
            rewardValue: "CODE123",
            isUsed: false),
        Redemption(
            id: 2,
            rewardId: widget.rewardId,
            rewardValue: "CODE456",
            isUsed: true),
        Redemption(
            id: 3,
            rewardId: widget.rewardId,
            rewardValue: "CODE789",
            isUsed: false),
      ];

      if (mounted) {
        setState(() {
          _currentItems = mockItems; // Replace with actual items from service
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
    _bulkValueController.dispose();
    super.dispose();
  }

  Future<void> _addSingleItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final Redemption item = Redemption(
        id: 0,
        rewardId: widget.rewardId,
        rewardValue: _singleValueController.text,
        value: _singleValueController.text,
        isUsed: false,
      );

      // TODO: Add service call to add reward item
      // For example:
      // final rewardService = Provider.of<RewardService>(context, listen: false);
      // await rewardService.addRewardItem(item);

      // Mock successful addition
      await Future.delayed(const Duration(milliseconds: 500));

      // Update the local list with the new item
      setState(() {
        _currentItems.add(Redemption(
          id: _currentItems.isEmpty ? 1 : _currentItems.last.id + 1,
          rewardId: widget.rewardId,
          rewardValue: _singleValueController.text,
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

  Future<void> _addBulkItems() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_bulkValues.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ไม่พบรายการไอเทมที่ถูกต้อง'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Add bulk items service call
      // For example:
      // final rewardService = Provider.of<RewardService>(context, listen: false);
      // await rewardService.addBulkRewardItems(widget.rewardId, _bulkValues);

      // Mock successful addition
      await Future.delayed(const Duration(seconds: 1));

      // Update the local list with new items
      final int lastId = _currentItems.isEmpty ? 0 : _currentItems.last.id;
      final newItems = _bulkValues.asMap().entries.map((entry) {
        return Redemption(
          id: lastId + entry.key + 1,
          rewardId: widget.rewardId,
          rewardValue: entry.value,
          value: entry.value,
          isUsed: false,
        );
      }).toList();

      setState(() {
        _currentItems.addAll(newItems);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เพิ่ม ${_bulkValues.length} ไอเทมสำเร็จ'),
            backgroundColor: Colors.green,
          ),
        );
        _bulkValueController.clear();
        setState(() {
          _bulkValues = [];
          _validItemsCount = 0;
        });
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

  void _processBulkText() {
    final text = _bulkValueController.text;

    // Try parsing as JSON array first
    try {
      final jsonData = jsonDecode(text);
      if (jsonData is List) {
        final List<String> values =
            jsonData.map((item) => item.toString()).toList();
        setState(() {
          _bulkValues = values.where((v) => v.isNotEmpty).toList();
          _validItemsCount = _bulkValues.length;
        });
        return;
      }
    } catch (_) {
      // If JSON parsing fails, treat as line-separated values
      final List<String> values = text.split('\n');
      setState(() {
        _bulkValues = values.where((v) => v.trim().isNotEmpty).toList();
        _validItemsCount = _bulkValues.length;
      });
    }
  }

  void _pasteFromClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData != null && clipboardData.text != null) {
        _bulkValueController.text = clipboardData.text!;
        _processBulkText();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการวางข้อความ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String? _validateSingleValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณากรอกข้อมูล';
    }
    return null;
  }

  String? _validateBulkValues(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณากรอกข้อมูล';
    }

    // Process the text to count valid items
    _processBulkText();

    if (_bulkValues.isEmpty) {
      return 'ไม่พบรายการไอเทมที่ถูกต้อง';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มไอเทมสำหรับ ${widget.rewardName}'),
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
            onPressed: _isLoadingItems ? null : () => _loadCurrentItems(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Current Items Section (Collapsible)
            if (_showCurrentItems) _buildCurrentItemsSection(),

            // Form Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isBulkMode = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: !_isBulkMode
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.shade300,
                                    foregroundColor: !_isBulkMode
                                        ? Colors.white
                                        : Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                  child: const Text('เพิ่มทีละรายการ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isBulkMode = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isBulkMode
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.shade300,
                                    foregroundColor: _isBulkMode
                                        ? Colors.white
                                        : Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                  child: const Text('เพิ่มหลายรายการ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _isBulkMode
                                ? _buildBulkModeContent()
                                : _buildSingleModeContent(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                  'รายการไอเทมปัจจุบัน (${_currentItems.length})',
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
                : _currentItems.isEmpty
                    ? const Center(child: Text('ไม่พบรายการไอเทม'))
                    : ListView.builder(
                        itemCount: _currentItems.length,
                        itemBuilder: (context, index) {
                          final item = _currentItems[index];
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              item.isUsed!
                                  ? Icons.check_circle_outline
                                  : Icons.radio_button_unchecked,
                              color: item.isUsed! ? Colors.green : Colors.grey,
                            ),
                            title: Text(item.rewardValue!),
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
                                    ClipboardData(text: item.rewardValue!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('คัดลอก ${item.rewardValue} แล้ว'),
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
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'หมายเหตุ: แต่ละไอเทมจะถูกสร้างแยกกัน คุณสามารถเพิ่มทีละรายการได้',
            style: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildBulkModeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'เพิ่มไอเทมหลายรายการ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: _pasteFromClipboard,
              icon: const Icon(Icons.paste),
              tooltip: 'วางจากคลิปบอร์ด',
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'แต่ละบรรทัดจะถูกนับเป็น 1 ไอเทม หรือวาง JSON array',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: TextFormField(
            controller: _bulkValueController,
            decoration: const InputDecoration(
              labelText: 'รายการไอเทม',
              border: OutlineInputBorder(),
              hintText: 'code1\ncode2\ncode3\nหรือ ["code1","code2","code3"]',
              alignLabelWithHint: true,
            ),
            validator: _validateBulkValues,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            onChanged: (value) {
              _processBulkText();
            },
          ),
        ),
        const SizedBox(height: 12),
        if (_validItemsCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  'พบ $_validItemsCount รายการที่ถูกต้อง',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed:
              (_isLoading || _validItemsCount == 0) ? null : _addBulkItems,
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.upload_file),
          label: Text(
              _isLoading ? 'กำลังเพิ่ม...' : 'เพิ่ม $_validItemsCount ไอเทม'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}
