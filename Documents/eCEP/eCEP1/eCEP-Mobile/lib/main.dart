import 'package:ecep/models/user.dart';
import 'package:ecep/views/accounts/logout_screen.dart';
import 'package:ecep/views/accounts/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecep/views/accounts/forgotpassword_screen.dart';
import 'package:ecep/views/accounts/lecturer_register_screen.dart';
import 'package:ecep/views/accounts/login_screen.dart';
import 'package:ecep/views/accounts/parent_register_screen.dart';
import 'package:ecep/views/accounts/role_selection_screen.dart';
import 'package:ecep/views/accounts/student_register_screen.dart';
import 'package:ecep/views/chatbot/chat_screen.dart';
import 'package:ecep/views/forum_space/forum/room_list_screen.dart';
import 'package:ecep/views/home_screen.dart';
import 'package:ecep/views/main_screen.dart';
import 'package:ecep/views/search_screen.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eCEP - Éducation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        // Core routes
        '/': (context) => const HomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/mainscreen': (context) => const MainScreen(),
        '/search': (context) => const SearchScreen(),


        // Account routes
        '/accounts/login': (context) => const LoginScreen(),
        '/accounts/logout': (context) => const LogoutScreen(),
        '/accounts/register': (context) => RoleSelectionScreen(),
        '/accounts/forgotpassword': (context) => ForgotPasswordScreen(),


        // Registration routes
        '/accounts/roleselection': (context) => RoleSelectionScreen(),
        '/accounts/register/student': (context) => const StudentRegistrationScreen(),
        '/accounts/register/lecturer': (context) => const LecturerRegistrationScreen(),
        '/accounts/register/parent': (context) => const ParentRegistrationScreen(),

        '/accounts/profile': (context) => ProfileScreen(), //doit etre la place de user connecté

        // Feature routes
        '/chatbot/chat_screen': (context) =>const ChatApp(),
        '/forum_space/forum/room_list_screen': (context) => const RoomListScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}