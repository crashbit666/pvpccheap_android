class Device {
  final int id;
  final String name;
  final String description;

  Device({required this.id, required this.name, required this.description});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? 'No description available',
    );
  }
}