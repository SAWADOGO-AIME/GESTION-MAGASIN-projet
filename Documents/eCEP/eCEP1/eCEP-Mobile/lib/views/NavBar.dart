import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final AnimationController controller;
  final VoidCallback onClose;
  final Animation<Offset> offsetAnimation;
  final Widget? profileHeader;
  final String firstName;
  final String lastName;
  final bool isStudent;

  const NavBar({
    super.key,
    required this.controller,
    required this.onClose,
    required this.offsetAnimation,
    this.profileHeader,
    required this.firstName,
    required this.lastName,
    required this.isStudent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final textTheme = theme.textTheme;

    return SlideTransition(
      position: offsetAnimation,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(5, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            profileHeader ?? _buildDefaultHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                children: [
                  const SizedBox(height: 16),
                  _buildCategoryItems(
                    context,
                    [
                      MenuItemData(Icons.home_rounded, 'Accueil', '/acceuil'),
                      MenuItemData(Icons.book_rounded, 'Mes cours', '/course'),
                    ],
                  ),
                  _buildSectionHeader(context, 'Cours & Évaluations'),
                  _buildCategoryItems(
                    context,
                    [
                      MenuItemData(Icons.trending_up_rounded, 'Progression', '/admin'),
                      MenuItemData(Icons.grade_rounded, 'Résultats de Grade', '/grade'),
                      MenuItemData(Icons.school_rounded, 'Allocations de Cours', '/students'),
                      MenuItemData(Icons.assignment_rounded, 'Examens', '/exams'),
                      MenuItemData(Icons.quiz_rounded, 'Quiz', '/quiz-progress'),
                      MenuItemData(Icons.smart_toy_rounded, 'Assistant', '/chatbot/chat_screen'),
                      MenuItemData(Icons.forum_rounded, 'Forum', '/forum_space/forum/room_list_screen'),
                    ],
                  ),
                  _buildSectionHeader(context, 'Compte'),
                  _buildCategoryItems(
                    context,
                    [
                      MenuItemData(Icons.person_rounded, 'Profil', '/accounts/profile'),
                      MenuItemData(Icons.settings_rounded, 'Paramètres du Compte', '/settings'),
                      MenuItemData(Icons.lock_rounded, 'Changer de Mot de Passe', '/change-password'),
                    ],
                  ),
                  _buildLanguageSelector(context),
                  _buildLogoutButton(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.orange.shade400,
            Colors.orange.shade300,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8),
              ],
            ),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Colors.orange.shade100,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 96,
                  width: 96,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.person,
                    size: 48,
                    color: Colors.orange.shade800,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$firstName $lastName',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4),
              ],
            ),
            child: Text(
              isStudent ? 'Étudiant' : 'Enseignant',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text.toUpperCase(),
            style: TextStyle(
              color: Colors.orange.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.orange.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItems(BuildContext context, List<MenuItemData> items) {
    return Column(
      children: items.map((item) => _buildMenuItem(context, item)).toList(),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItemData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onClose();
            Navigator.pushNamed(context, item.route);
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.orange.withOpacity(0.1),
          highlightColor: Colors.orange.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    color: Colors.orange.shade800,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: 'fr',
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: Colors.orange.shade800),
            items: const [
              DropdownMenuItem(
                value: 'fr',
                child: Row(
                  children: [
                    Icon(Icons.language, color: Colors.orange, size: 20),
                    SizedBox(width: 12),
                    Text('Français (FR)'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'en',
                child: Row(
                  children: [
                    Icon(Icons.language, color: Colors.orange, size: 20),
                    SizedBox(width: 12),
                    Text('English (EN)'),
                  ],
                ),
              ),
            ],
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ElevatedButton(
        onPressed: () {
          onClose();
          Navigator.pushReplacementNamed(context, '/accounts/logout');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded),
            SizedBox(width: 12),
            Text(
              'Se Déconnecter',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, -3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildFooterButton(
                context,
                Icons.star_rounded,
                'Noter eCEP',
                Colors.amber,
                    () {},
              ),
              const SizedBox(width: 8),
              _buildFooterButton(
                context,
                Icons.share_rounded,
                'Partager',
                Colors.blue,
                    () {},
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'eCEP © 2025',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Confidentialité'),
                  ),
                  const Text('|', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Conditions'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButton(
      BuildContext context,
      IconData icon,
      String label,
      Color color,
      VoidCallback onPressed,
      ) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 16),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class MenuItemData {
  final IconData icon;
  final String title;
  final String route;

  const MenuItemData(this.icon, this.title, this.route);
}