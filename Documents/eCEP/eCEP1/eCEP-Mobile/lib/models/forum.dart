// Dans le fichier lib/models/forum.dart

class Room {
  final int? id;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final int? createdBy;
  final List<Message>? messages;

  Room({
    this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.createdBy,
    this.messages,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      createdBy: json['created_by'],
      messages: json['messages'] != null
          ? List<Message>.from(json['messages'].map((x) => Message.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'created_by': createdBy,
    };
  }
}

class Message {
  final int? id;
  final int? roomId;
  final int? userId;
  final String content;
  final DateTime createdAt;
  final String? userAvatar;
  final String? userName;
  final bool isFromCurrentUser;

  Message({
    this.id,
    this.roomId,
    this.userId,
    required this.content,
    required this.createdAt,
    this.userAvatar,
    this.userName,
    this.isFromCurrentUser = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      roomId: json['room_id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      userAvatar: json['user_avatar'],
      userName: json['user_name'],
      isFromCurrentUser: json['is_from_current_user'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'user_avatar': userAvatar,
      'user_name': userName,
    };
  }

  String getFormattedTime() {
    return '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
  }
}