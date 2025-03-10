import 'dart:convert';
import 'package:ecep/constants/api_endpoints.dart';
import 'package:ecep/models/parent.dart';
import 'package:ecep/models/user.dart';
import 'package:ecep/models/student.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ParentRegistrationScreen extends StatefulWidget {
  const ParentRegistrationScreen({super.key});

  @override
  State<ParentRegistrationScreen> createState() =>
      _ParentRegistrationScreenState();
}

class _ParentRegistrationScreenState extends State<ParentRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  // Contrôleurs

  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _studentController = TextEditingController();
  final _relationshipController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Création de l'utilisateur
      final user = User(
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        address: _addressController.text, username: '', password: '', gender: '', isLecturer: false,
        isStudent: false,
      );

      // 2. Enregistrement via l'API
      final userResponse = await http.post(
        Uri.parse(ApiEndpoints.userRegister),
        body: jsonEncode(user.toRegistrationJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (userResponse.statusCode != 201) {
        throw Exception(jsonDecode(userResponse.body)['detail']);
      }

      // 3. Création du profil parent
      final createdUser = User.fromJson(jsonDecode(userResponse.body));
      final student = Student(

        user: User(username: '', email: '', firstName: '', lastName: '', password: '', gender: '', phone: '', address: '', isLecturer: false,isStudent: false), // Remplacez par les données réelles de l'étudiant
        programId: 0, // Remplacez par les données réelles de l'étudiant

      );

      final parent = Parent(
        user: createdUser,
        student: student,
        relationship: _relationshipController.text,
      );

      final parentResponse = await http.post(
        Uri.parse(ApiEndpoints.parentRegister),
        body: jsonEncode(parent.toRegistrationJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (parentResponse.statusCode != 201) {
        throw Exception('Erreur de création du profil parent');
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      _showError('Erreur: ${e.toString()}');
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
        title: const Text('Inscription Parent'),
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
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildNameFields(),
                const SizedBox(height: 16),
                _buildPhoneField(),
                const SizedBox(height: 16),
                _buildAddressField(),
                const SizedBox(height: 16),
                _buildStudentField(),
                const SizedBox(height: 16),
                _buildRelationshipField(),
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
          Icons.family_restroom, // Icône représentant une famille
          size: 100, // Taille de l'icône
          color: Colors.blue.shade800, // Couleur de l'icône
        ),
        const SizedBox(height: 16),
        Text(
          'Inscription Parent',
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
              labelText: 'Prénom(s) *',
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

  Widget _buildStudentField() {
    return TextFormField(
      controller: _studentController,
      decoration: InputDecoration(
        labelText: 'ID de l\'étudiant *',
        prefixIcon: const Icon(Icons.school_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.number,
      validator: (value) =>
      value == null || value.isEmpty ? 'Ce champ est obligatoire' : null,
    );
  }

  Widget _buildRelationshipField() {
    List<String> relationships = [
      'Père',
      'Mère',
      'Frère',
      'Sœur',
      'Grand-père',
      'Grand-mère',
      'Autre'
    ];

    return DropdownButtonFormField<String>(
      value: _relationshipController.text.isNotEmpty ? _relationshipController.text : null,
      decoration: InputDecoration(
        labelText: 'Relation avec l\'étudiant *',
        prefixIcon: const Icon(Icons.group_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: relationships.map((String relationship) {
        return DropdownMenuItem<String>(
          value: relationship,
          child: Text(relationship),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          _relationshipController.text = newValue;
        }
      },
      validator: (value) => value == null || value.isEmpty ? 'Ce champ est obligatoire' : null,
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