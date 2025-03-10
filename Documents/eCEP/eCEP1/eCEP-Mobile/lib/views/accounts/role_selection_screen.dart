import 'package:flutter/material.dart';
import 'student_register_screen.dart';
import 'lecturer_register_screen.dart';
import 'parent_register_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir un rôle'),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFF5F5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRoleCard(
                  context,
                  title: 'Étudiant',
                  icon: Icons.school_outlined,
                  color: Colors.blue.shade700,
                  route: '/accounts/register/student',
                ),
                const SizedBox(height: 20),
                _buildRoleCard(
                  context,
                  title: 'Enseignant',
                  icon: Icons.people_outline,
                  color: Colors.green.shade700,
                  route: '/accounts/register/lecturer',
                ),
                const SizedBox(height: 20),
                _buildRoleCard(
                  context,
                  title: 'Parent',
                  icon: Icons.family_restroom_outlined,
                  color: Colors.orange.shade700,
                  route: '/accounts/register/parent',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, {required String title, required IconData icon, required Color color, required String route}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}