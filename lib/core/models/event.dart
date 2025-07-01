class Event {
  final String id;
  final String title;
  final String description;
  final String bannerImageUrl;
  final double? lat;
  final double? lng;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.bannerImageUrl,
    this.lat,
    this.lng,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      bannerImageUrl: json['bannerImageUrl'] ?? '',
      lat: json['lat'] != null ? double.tryParse(json['lat'].toString()) : null,
      lng: json['lng'] != null ? double.tryParse(json['lng'].toString()) : null,
    );
  }
}