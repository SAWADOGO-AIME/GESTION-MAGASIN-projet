import 'package:ecep/services/api_service.dart';
import 'package:ecep/views/NavBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _isDrawerOpen = false;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      _isDrawerOpen ? _controller.forward() : _controller.reverse();
    });
  }

  void _toggleSearch() {
    setState(() => _isSearchVisible = !_isSearchVisible);
  }

  void _handleNavigation(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/profile');
          break;
        case 1:
          Navigator.pushNamed(context, '/info');
          break;
        case 2:
        // Reste sur l'accueil
          break;
        case 3:
          _toggleSearch();
          break;
        case 4:
          _toggleDrawer();
          break;
      }
    });
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Déconnexion'),
            content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
            actions: <Widget>[
            TextButton(
            onPressed: () => Navigator.pop(context, false),
        child: const Text('Annuler'),
    ),
    TextButton(
    onPressed: () => Navigator.pop(context, true),
    child: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
    ),
    ],
    ),
    );

    if (confirmed ?? false) {
    await ApiService();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Widget _buildProfileHeader() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final user = snapshot.data!;
        return Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user['profile_picture'] ?? ''),
            ),
            const SizedBox(height: 16),
            Text(
              '${user['first_name']} ${user['last_name']}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user['is_student'] ? 'ÉTUDIANT' : 'ENSEIGNANT',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLogoutButton(),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'first_name': prefs.getString('first_name') ?? '',
      'last_name': prefs.getString('last_name') ?? '',
      'profile_picture': prefs.getString('profile_picture'),
      'is_student': prefs.getBool('is_student') ?? false,
    };
  }

  Widget _buildLogoutButton() {
    return TextButton.icon(
      icon: const Icon(Icons.logout, color: Colors.white70, size: 20),
      label: const Text('Se Déconnecter', style: TextStyle(color: Colors.white)),
      onPressed: _logout,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              if (_isSearchVisible) _buildSearchBar(),
              const Expanded(
                child: Center(
                  child: Text('Contenu Principal'),
                ),
              ),
            ],
          ),

          if (_isDrawerOpen)
            GestureDetector(
                onTap: _toggleDrawer,
                child: Container(color: Colors.black54)),

          NavBar(
            controller: _controller,
            onClose: _toggleDrawer,
            offsetAnimation: _offsetAnimation,
            profileHeader: _buildProfileHeader(), firstName: '', lastName: '', isStudent: true,
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildSearchBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: VoiceSearchBar(controller: _searchController),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _toggleSearch,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _handleNavigation,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Compte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info),
            label: 'Infos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Rechercher',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_outlined),
            activeIcon: Icon(Icons.more_horiz),
            label: 'Plus',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

class VoiceSearchBar extends StatefulWidget {
  final TextEditingController controller;

  const VoiceSearchBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<VoiceSearchBar> createState() => _VoiceSearchBarState();
}

class _VoiceSearchBarState extends State<VoiceSearchBar> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  Future<void> _initializeSpeech() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) await Permission.microphone.request();

    bool available = await _speech.initialize(
      onStatus: (status) => setState(() => _isListening = status == 'listening'),
      onError: (error) => setState(() => _isListening = false),
    );

    if (available) _startListening();
  }

  void _startListening() async {
    if (!_isListening) {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) => widget.controller.text = result.recognizedWords,
        localeId: 'fr_FR',
      );
    }
  }

  void _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.search, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: widget.controller,
            decoration: const InputDecoration(
              hintText: 'Rechercher #Cours #Quiz #Infos...',
              border: InputBorder.none,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            color: _isListening ? Colors.red : Colors.grey,
          ),
          onPressed: () => _isListening ? _stopListening() : _initializeSpeech(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }
}