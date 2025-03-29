import 'package:flutter/material.dart';

class Appbar extends StatefulWidget {
  const Appbar({super.key});

  @override
  State<Appbar> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return mainAppbar();
  }

  Padding mainAppbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.green[400], size: 20),
              const SizedBox(width: 4),
              const Text(
                'กรุงเทพมหานคร',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
