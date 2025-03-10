import 'package:ecep/services/api_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    // Valider le formulaire
    if (!_formKey.currentState!.validate()) return;

    // Activer l'indicateur de chargement
    setState(() => _isLoading = true);

    try {
      // Appeler l'API pour se connecter
      final token = await ApiService.loginUser(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      // Vérifier si un token a été reçu
      if (token != null) {
        // Sauvegarder le token (par exemple, dans SharedPreferences)
        await ApiService.saveToken(token as String);

        // Afficher un message de succès
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connexion réussie !')),
          );
        }

        // Rediriger vers l'écran principal
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/mainscreen');
      } else {
        // Si aucun token n'est reçu, afficher une erreur
        throw Exception('Token non reçu');
      }
    } catch (e) {
      // Afficher une boîte de dialogue d'erreur en cas d'échec
      _showErrorDialog('Erreur de connexion: ${e.toString()}');
    } finally {
      // Désactiver l'indicateur de chargement
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erreur de connexion'),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFF5F5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildLoginCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Column(
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      Text(
        'Bienvenue sur eCEP',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Connectez-vous pour continuer',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey.shade600,
        ),
      ),
    ],
  );

  Widget _buildLoginCard() => Card(
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildUsernameField(),
            const SizedBox(height: 20),
            _buildPasswordField(),
            const SizedBox(height: 16),
            _buildForgotPassword(),
            const SizedBox(height: 24),
            _buildLoginButton(),
            const SizedBox(height: 24),
            _buildSignupLink(),
          ],
        ),
      ),
    ),
  );

  Widget _buildUsernameField() => TextFormField(
    controller: _usernameController,
    decoration: InputDecoration(
      labelText: 'Nom d\'utilisateur',
      prefixIcon: const Icon(Icons.person_outline),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
    ),
    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
  );

  Widget _buildPasswordField() => TextFormField(
    controller: _passwordController,
    obscureText: _obscurePassword,
    decoration: InputDecoration(
      labelText: 'Mot de passe',
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
    ),
    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
  );

  Widget _buildForgotPassword() => Align(
    alignment: Alignment.centerRight,
    child: TextButton(
      onPressed: () => Navigator.pushNamed(context, '/accounts/forgotpassword'),
      child: Text(
        'Mot de passe oublié ?',
        style: TextStyle(
          color: Colors.blue.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );

  Widget _buildLoginButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      child: _isLoading
          ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : const Text(
        'SE CONNECTER',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.1,
        ),
      ),
    ),
  );

  Widget _buildSignupLink() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Pas de compte ? ',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 15,
        ),
      ),
      TextButton(
        onPressed: () => Navigator.pushNamed(context, '/accounts/roleselection'),
        child: Text(
          'Créer un compte',
          style: TextStyle(
            color: Colors.blue.shade700,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ],
  );
}