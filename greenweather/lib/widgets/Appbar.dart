import 'package:flutter/material.dart';

class Mainappbar extends StatefulWidget {
  const Mainappbar({super.key});

  @override
  State<Mainappbar> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Mainappbar> {
  @override
  Widget build(BuildContext context) {
    return Mainappbar();
  }

  Mainappbar() {
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
