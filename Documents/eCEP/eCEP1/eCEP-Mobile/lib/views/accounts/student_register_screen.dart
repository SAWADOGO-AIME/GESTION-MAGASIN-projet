import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecep/constants/api_endpoints.dart';
import 'package:ecep/models/student.dart';
import 'package:ecep/models/user.dart';

class StudentRegistrationScreen extends StatefulWidget {
  const StudentRegistrationScreen({super.key});

  @override
  State<StudentRegistrationScreen> createState() =>
      _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState extends State<StudentRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  // Contrôleurs pour les champs du formulaire
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedGender;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final student = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'gender': _selectedGender ?? 'M',
        'phone': _phoneController.text,
        'address': _addressController.text,
        'is_student': true,
        'program': 1, // Program ID est toujours 1
      };

      final response = await http.post(
        Uri.parse(ApiEndpoints.studentRegister),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(student),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inscription réussie !'),
              duration: Duration(seconds: 5),
            ),
          );
          await Future.delayed(const Duration(seconds: 5));
          Navigator.pushReplacementNamed(context, '/accounts/login');
        }
      } else {
        throw Exception('Échec de la création: ${response.body}');
      }
    } on http.ClientException catch (e) {
      _showError('Erreur de connexion : ${e.message}');
    } on FormatException catch (e) {
      _showError('Erreur de format : ${e.message}');
    } catch (e) {
      _showError('Erreur inattendue : ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    setState(() => _errorMessage = message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription Étudiant'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildNameFields(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildGenderDropdown(),
                const SizedBox(height: 16),
                _buildPhoneField(),
                const SizedBox(height: 16),
                _buildAddressField(),
                if (_errorMessage != null) _buildErrorDisplay(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.school,
          size: 200,
          color: Colors.blue.shade800,
        ),
        const SizedBox(height: 16),
        Text(
          'Inscription Étudiant',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Remplissez le formulaire pour créer votre compte',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Adresse mail *',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Ce champ est obligatoire';
        if (!RegExp(r'^.+@.+\..+$').hasMatch(value)) return 'Email invalide';
        return null;
      },
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: 'Prénom *',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Ce champ est obligatoire' : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(
              labelText: 'Nom *',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Ce champ est obligatoire' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Numéro de téléphone *',
        prefixIcon: const Icon(Icons.phone_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Ce champ est obligatoire';
        if (!RegExp(r'^\+?[0-9]{8,}$').hasMatch(value)) return 'Numéro invalide';
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: InputDecoration(
        labelText: 'Adresse *',
        prefixIcon: const Icon(Icons.location_on_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) =>
      value == null || value.isEmpty ? 'Ce champ est obligatoire' : null,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      items: const [
        DropdownMenuItem(value: 'M', child: Text('Masculin')),
        DropdownMenuItem(value: 'F', child: Text('Féminin')),
      ],
      decoration: InputDecoration(
        labelText: 'Genre *',
        prefixIcon: const Icon(Icons.transgender),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) => setState(() => _selectedGender = value),
      validator: (value) => value == null ? 'Ce champ est obligatoire' : null,
    );
  }

  Widget _buildErrorDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800,
          padding: const EdgeInsets.symmetric(vertical: 16),
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
          'Créer mon compte',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}