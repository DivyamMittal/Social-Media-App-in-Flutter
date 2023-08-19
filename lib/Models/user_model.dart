class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.bio,
    required this.image,
    required this.createdAt,
    required this.lastActive,
    required this.isOnline,
    required this.numPosts,
    required this.followers,
    required this.following,
  });
  late String id;
  late String name;
  late String username;
  late String email;
  late String bio;
  late String image;
  late String createdAt;
  late String lastActive;
  late bool isOnline;
  late String numPosts;
  late String followers;
  late String following;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    username = json['username'] ?? '';
    email = json['email'] ?? '';
    bio = json['bio'] ?? '';
    image = json['image'] ?? '';
    createdAt = json['created_at'] ?? '';
    lastActive = json['last_active'] ?? '';
    isOnline = json['is_online'] ?? '';
    numPosts = json['numPosts'] ?? '';
    followers = json['followers'] ?? '';
    following = json['following'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['bio'] = bio;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['lastActive'] = lastActive;
    data['numPosts'] = numPosts;
    data['followers'] = followers;
    data['is_online'] = isOnline;
    data['following'] = following;
    return data;
  }
}
