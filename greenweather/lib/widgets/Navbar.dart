import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });
  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return _buildBottomNavBar();
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomNavItem(
            Icons.home,
            'หน้าหลัก',
            widget.selectedIndex == 0,
            0,
          ),
          _buildBottomNavItem(
            Icons.star_border,
            'รีวิว',
            widget.selectedIndex == 1,
            1,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(13),
            child: _buildBottomNavItem(
              Icons.my_location,
              'รายงาน',
              widget.selectedIndex == 2,
              2,
              isMid: true,
            ),
          ),
          _buildBottomNavItem(
            Icons.emoji_events,
            'อันดับ',
            widget.selectedIndex == 3,
            3,
          ),
          _buildBottomNavItem(
            Icons.person_outline,
            'โปรไฟล์',
            widget.selectedIndex == 4,
            4,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    IconData icon,
    String label,
    bool isActive,
    int index, {
    bool? isMid,
  }) {
    return GestureDetector(
      onTap: () => widget.onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isMid != null
                ? Colors.white
                : isActive
                    ? Colors.green
                    : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isMid != null
                  ? Colors.white
                  : isActive
                      ? Colors.green
                      : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
