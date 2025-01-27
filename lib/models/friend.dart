import 'dart:convert';

class Friend {
  final String id;
  final String username;
  final String email;
  final String displayName;
  final String profilePicture;

  Friend({
    required this.id,
    required this.username,
    required this.email,
    required this.displayName,
    required this.profilePicture,
  });

  // Convert a Friend object into a Map object
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'displayName': displayName,
      'profilePicture': profilePicture,
    };
  }

  // Convert a Map object into a Friend object
  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['_id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());

  // Convert a JSON string into a Friend object
  factory Friend.fromJson(String source) => Friend.fromMap(json.decode(source));
}

class FriendRequest {
  final String id; 
  final String from; 

  FriendRequest({
    required this.id,
    required this.from,
  });

  // Convert a FriendRequest object into a Map object
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'from': from,
    };
  }

  // Convert a Map object into a FriendRequest object
  factory FriendRequest.fromMap(Map<String, dynamic> map) {
    return FriendRequest(
      id: map['_id'] ?? '',
      from: map['from'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());

  // Convert a JSON string into a FriendRequest object
  factory FriendRequest.fromJson(String source) => FriendRequest.fromMap(json.decode(source));
}