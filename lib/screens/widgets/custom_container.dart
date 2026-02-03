import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String texto;
  final IconData icon;
  final Color color;
  final double width;
  final double height;
  const CustomContainer({
    super.key,
    required this.texto,
    required this.icon,
    required this.color,
    this.width = 150,
    this.height = 150,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: Colors.white),
          SizedBox(height: 12),
          Text(
            texto,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
