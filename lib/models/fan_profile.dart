class FanProfile {
  final String id;
  final String ownerUid;       // Firebase Auth UID — edit rights
  final String name;
  final String handle;
  final String city;
  final String favouriteTeam;
  final String favouritePlayer;
  final String bio;
  final String photoUrl;       // user-uploaded photo (Storage URL)
  final String aiImageUrl;     // Gemini-generated image (base64 data URI or Storage URL)
  final String watchStyle;     // extra Q: "How do you watch matches?"
  final String matchMood;      // extra Q: "Describe your mood when your team wins"
  final DateTime createdAt;

  const FanProfile({
    required this.id,
    required this.ownerUid,
    required this.name,
    required this.handle,
    required this.city,
    required this.favouriteTeam,
    required this.favouritePlayer,
    required this.bio,
    this.photoUrl = '',
    this.aiImageUrl = '',
    this.watchStyle = '',
    this.matchMood = '',
    required this.createdAt,
  });

  factory FanProfile.fromMap(String id, Map<String, dynamic> m) => FanProfile(
        id: id,
        ownerUid: m['ownerUid'] as String? ?? '',
        name: m['name'] as String? ?? '',
        handle: m['handle'] as String? ?? '',
        city: m['city'] as String? ?? '',
        favouriteTeam: m['favouriteTeam'] as String? ?? '',
        favouritePlayer: m['favouritePlayer'] as String? ?? '',
        bio: m['bio'] as String? ?? '',
        photoUrl: m['photoUrl'] as String? ?? '',
        aiImageUrl: m['aiImageUrl'] as String? ?? '',
        watchStyle: m['watchStyle'] as String? ?? '',
        matchMood: m['matchMood'] as String? ?? '',
        createdAt: m['createdAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(m['createdAt'] as int)
            : DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'ownerUid': ownerUid,
        'name': name,
        'handle': handle,
        'city': city,
        'favouriteTeam': favouriteTeam,
        'favouritePlayer': favouritePlayer,
        'bio': bio,
        'photoUrl': photoUrl,
        'aiImageUrl': aiImageUrl,
        'watchStyle': watchStyle,
        'matchMood': matchMood,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  FanProfile copyWith({
    String? name,
    String? handle,
    String? city,
    String? favouriteTeam,
    String? favouritePlayer,
    String? bio,
    String? photoUrl,
    String? aiImageUrl,
    String? watchStyle,
    String? matchMood,
  }) =>
      FanProfile(
        id: id,
        ownerUid: ownerUid,
        name: name ?? this.name,
        handle: handle ?? this.handle,
        city: city ?? this.city,
        favouriteTeam: favouriteTeam ?? this.favouriteTeam,
        favouritePlayer: favouritePlayer ?? this.favouritePlayer,
        bio: bio ?? this.bio,
        photoUrl: photoUrl ?? this.photoUrl,
        aiImageUrl: aiImageUrl ?? this.aiImageUrl,
        watchStyle: watchStyle ?? this.watchStyle,
        matchMood: matchMood ?? this.matchMood,
        createdAt: createdAt,
      );
}
