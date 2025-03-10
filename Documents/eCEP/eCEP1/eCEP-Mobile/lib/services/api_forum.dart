import 'package:dio/dio.dart';
import 'package:ecep/models/forum.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.11.109:8000/api/forum/',
    connectTimeout: Duration(milliseconds: 5000),
    receiveTimeout: Duration(milliseconds: 3000),
  ));

  // Récupérer toutes les rooms
  Future<List<Room>> getRooms() async {
    try {
      final response = await _dio.get('rooms/');
      return (response.data as List).map((json) => Room.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erreur de chargement des rooms');
    }
  }

  // Créer une nouvelle room
  Future<Room> createRoom(String name) async {
    try {
      final response = await _dio.post('rooms/', data: {'name': name});
      return Room.fromJson(response.data);
    } catch (e) {
      throw Exception('Erreur de création de room');
    }
  }

  // Récupérer les messages d'une room
  Future<List<Message>> getMessages(int roomId) async {
    try {
      final response = await _dio.get('rooms/$roomId/messages/');
      return (response.data as List).map((json) => Message.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erreur de chargement des messages');
    }
  }

  // Envoyer un message
  Future<Message> sendMessage(int roomId, String message) async {
    try {
      final response = await _dio.post(
        'rooms/$roomId/messages/',
        data: {'value': message, 'user': 'utilisateur_test'}, // À remplacer par l'utilisateur réel
      );
      return Message.fromJson(response.data);
    } catch (e) {
      throw Exception('Erreur d\'envoi du message');
    }
  }
}