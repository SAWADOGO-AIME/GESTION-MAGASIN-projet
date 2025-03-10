import 'package:flutter/material.dart';
import 'package:ecep/models/user.dart';
import 'package:ecep/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileScreen extends StatefulWidget {


  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _verifyAuth() async {
    final token = await ApiService.getToken();
    final userId = await ApiService.getUserId();

    if (token == null || userId == null) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }



  Future<void> _loadUserData() async {
    try {
      final token = await ApiService.getToken();
      if (token == null) throw Exception('Non connecté');

      final userId = '1';//await ApiService.getUserId();
      if (userId == null) throw Exception('ID utilisateur manquant');

      final user = await ApiService.getUserData(userId);

      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      // Redirection si nécessaire
      if (e.toString().contains('Session expirée')) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }


  // Dans ApiService
  static Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('is_student');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil User")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileHeader(_user!),
          const SizedBox(height: 20),
          _buildInfoCard('Informations Personnelles', [
            _buildInfoItem('Nom Complet', '${_user!.firstName} ${_user!.lastName}'),
            _buildInfoItem('Email', _user!.email),
            _buildInfoItem('Téléphone', _user!.phone ?? 'Non renseigné'),
            _buildInfoItem('Adresse', _user!.address ?? 'Non renseignée'),
          ]),
          const SizedBox(height: 20),
          _buildInfoCard('Statut', [
            _buildInfoItem('Rôle', _user!.isStudent ? 'Étudiant' : 'Enseignant'),
            _buildInfoItem('Identifiant', _user!.username),
          ]),
        ],
      ),
    );
  }



  Widget _buildProfileHeader(User user) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: user.profilePictureUrl != null
                ? NetworkImage(user.profilePictureUrl!)
                : const AssetImage('assets/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(height: 10),
          Text(
            '${user.firstName} ${user.lastName}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            user.isStudent ? 'Étudiant' : 'Enseignant',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}