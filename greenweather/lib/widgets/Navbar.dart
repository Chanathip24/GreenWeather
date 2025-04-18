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
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onItemTapped(index),
        borderRadius: BorderRadius.circular(15),
        splashColor: Colors.green.withOpacity(0.1),
        highlightColor: Colors.green.withOpacity(0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          constraints: BoxConstraints(minWidth: 60),
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
                size: 24, 
              ),
              const SizedBox(height: 4),
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
        ),
      ),
    );
  }
}
