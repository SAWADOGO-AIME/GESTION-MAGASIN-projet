import 'package:ecep/views/chatbot/chat_screen.dart';
import 'package:ecep/views/forum_space/forum/create_room_dialog.dart';
import 'package:ecep/views/forum_space/room_card.dart';
import 'package:flutter/material.dart';
import 'package:ecep/constants/colors.dart';
import 'package:ecep/models/forum.dart';
import 'package:ecep/services/api_forum.dart';


class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final ApiService _api = ApiService();
  late Future<List<Room>> _roomsFuture;

  @override
  void initState() {
    super.initState();
    _refreshRooms();
  }

  Future<void> _refreshRooms() async {
    setState(() => _roomsFuture = _api.getRooms());
  }

  void _navigateToChat(Room room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(room: room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forums de discussion'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshRooms,
            tooltip: 'Actualiser la liste',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshRooms,
        color: AppColors.accent,
        child: FutureBuilder<List<Room>>(
          future: _roomsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              );
            }

            if (snapshot.hasError) {
              return _buildErrorWidget();
            }

            final rooms = snapshot.data!;
            return rooms.isEmpty ? _buildEmptyState() : _buildRoomList(rooms);
          },
        ),
      ),
      floatingActionButton: _buildCreateButton(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Erreur de chargement...',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _refreshRooms,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'Aucune discussion disponible\nCommencez par créer une room!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.textPrimary.withOpacity(0.6),
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildRoomList(List<Room> rooms) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      itemCount: rooms.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => RoomCard(
        room: rooms[index],
        onTap: () => _navigateToChat(rooms[index]),
      ),
    );
  }

  Widget _buildCreateButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      tooltip: 'Créer une nouvelle room',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.add),
      onPressed: () => _showCreateRoomDialog(),
    );
  }

  void _showCreateRoomDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const CreateRoomDialog(),
    );

    if (result == true) _refreshRooms();
  }
}