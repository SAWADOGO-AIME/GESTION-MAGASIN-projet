// lib/screens/edit_profile_screen.dart
import 'package:ecep/services/api_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:ecep/models/profile.dart';
import 'package:ecep/services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();

    // Initialiser les contrôleurs avec les valeurs existantes
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.numeroDeTelephone ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    try {
      // Créer un map avec les données mises à jour
      final updatedData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'numeroDeTelephone': _phoneController.text,
      };

      // Récupérer l'ID de l'utilisateur
      final userId = await AuthService.getCurrentUserId();
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Appeler le service API pour mettre à jour
      await ApiService.updateUserProfile(userId, updatedData);

      // Afficher un feedback et retourner
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour avec succès')),
        );
        Navigator.pop(context); // Retour à l'écran précédent
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de mise à jour: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}