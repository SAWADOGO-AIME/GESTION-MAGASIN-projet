import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          _buildMainContent(context),
        ],
      ),
    );
  }

  SliverPersistentHeader _buildAppBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 150,
        maxHeight: 250,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF003366), Color(0xFF006699)],
              stops: [0.1, 0.9],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, size: 50, color: Colors.white),
                  const SizedBox(height: 15),
                  Text(
                    'Bienvenue sur eCEP',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Votre plateforme éducative complète',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverList _buildMainContent(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 20),
        _buildCarouselSection(
          context: context,
          title: 'Découvrez notre communauté',
          images: const [
            'https://source.unsplash.com/800x600/?university',
            'https://source.unsplash.com/800x600/?students',
            'https://source.unsplash.com/800x600/?education',
          ],
        ),
        _buildSectionTitle('Fonctionnalités clés'),
        _buildFeatureGrid(),
        _buildSectionTitle('Actualités récentes'),
        _buildNewsCarousel(),
        _buildSectionTitle('Témoignages'),
        _buildTestimonials(),
        _buildFooter(),
      ]),
    );
  }

  Widget _buildCarouselSection({
    required BuildContext context,
    required String title,
    required List<String> images,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF003366),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 300,
            child: PageView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) => _buildCarouselItem(images[index]),
            ),
          ),
          const SizedBox(height: 30),
          _buildActionButton(
            text: 'Commencer maintenant',
            icon: Icons.arrow_forward,
            onPressed: () => Navigator.pushNamed(context, '/accounts/login'),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildShimmerEffect();
              },
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.error_outline, size: 50, color: Colors.grey),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black54,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.1,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            children: const [
              _FeatureTile(
                icon: Icons.school,
                title: 'Cours',
                color: Color(0xFF003366),
              ),
              _FeatureTile(
                icon: Icons.quiz,
                title: 'Évaluations',
                color: Color(0xFF006699),
              ),
              _FeatureTile(
                icon: Icons.library_books,
                title: 'Ressources',
                color: Color(0xFF0099CC),
              ),
              _FeatureTile(
                icon: Icons.forum,
                title: 'Communauté',
                color: Color(0xFF00CCFF),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNewsCarousel() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 3,
        itemBuilder: (context, index) => _NewsCard(
          imageUrl: 'https://source.unsplash.com/400x300/?education$index',
          title: 'Nouveautés de la semaine ${index + 1}',
        ),
      ),
    );
  }

  Widget _buildTestimonials() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          _TestimonialCard(
            author: 'Marie Dupont',
            role: 'Étudiante en Master',
            text:
            'Une plateforme intuitive qui a révolutionné ma manière d\'apprendre. Les ressources sont complètes et toujours à jour.',
          ),
          const SizedBox(height: 20),
          _TestimonialCard(
            author: 'Pierre Martin',
            role: 'Enseignant',
            text:
            'Outil indispensable pour suivre le progrès des étudiants. Interface claire et fonctionnalités complètes.',
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(30),
      color: const Color(0xFF003366),
      child: Column(
        children: [
          const Text(
            'Restez connecté',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(Icons.facebook),
              _buildSocialIcon(Icons.snapchat),
              _buildSocialIcon(Icons.linked_camera),
              _buildSocialIcon(Icons.youtube_searched_for),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            '© 2024 eCEP Tous droits réservés',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required String text, required IconData icon, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24),
      label: Text(text),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
        shadowColor: Colors.blueAccent.withOpacity(0.3),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF003366),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return IconButton(
      icon: Icon(icon, size: 30, color: Colors.white),
      onPressed: () {},
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const _NewsCard({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 15),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Text('En savoir plus'),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String author;
  final String role;
  final String text;

  const _TestimonialCard({
    required this.author,
    required this.role,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage('https://source.unsplash.com/100x100/?portrait'),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      role,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              text,
              style: TextStyle(
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}