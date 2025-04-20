import 'package:flutter/material.dart';

import 'package:greenweather/providers/province_provider.dart';

import 'package:provider/provider.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provinceProvider = Provider.of<ProvinceProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.green[400], size: 20),
              const SizedBox(width: 4),
              DropdownButton<String>(
                value: provinceProvider.selectProvince,
                items: provinceProvider.provinces.keys
                    .map<DropdownMenuItem<String>>((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(
                        provinceProvider.provinces[key]?["th"] ?? "ม่ายลุ"),
                  );
                }).toList(),
                onChanged: (String? value) async {
                  if (value != null) {
                    provinceProvider.setProvince(value);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
