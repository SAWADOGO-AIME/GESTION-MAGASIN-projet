import 'package:ecep/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:ecep/models/forum.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;

  const RoomCard({super.key, required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.forum, color: AppColors.accent),
        title: Text(
          room.name,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
        onTap: onTap,
      ),
    );
  }
}