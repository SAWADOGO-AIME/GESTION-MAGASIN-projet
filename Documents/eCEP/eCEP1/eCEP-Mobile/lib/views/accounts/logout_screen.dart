import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecep/services/api_service.dart'; // Importez votre ApiService

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  bool _isLoading = false; // État de chargement

  Future<void> _logout() async {
    setState(() => _isLoading = true); // Activer l'indicateur de chargement

    try {
      final token = await SharedPreferences.getInstance().then((prefs) => prefs.getString('auth_token'));
      if (token != null) {
        final success = await ApiService.logoutUser(token);
        if (success) {
          // Supprimer le token des SharedPreferences
          await SharedPreferences.getInstance().then((prefs) => prefs.remove('auth_token'));

          // Afficher un message de succès
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Déconnexion réussie !')),
            );
          }

          // Rediriger vers l'écran de connexion
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/accounts/login');
        } else {
          throw Exception('Échec de la déconnexion');
        }
      } else {
        throw Exception('Token non trouvé');
      }
    } catch (e) {
      // Afficher une boîte de dialogue d'erreur
      _showErrorDialog('Erreur de déconnexion: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false); // Désactiver l'indicateur de chargement
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erreur de déconnexion'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Déconnexion'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Afficher un indicateur de chargement
            : ElevatedButton(
          onPressed: _logout, // Déclencher la déconnexion
          child: const Text('Se déconnecter'),
        ),
      ),
    );
  }
}