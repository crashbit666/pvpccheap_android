class Device {
  final int id;
  final String name;
  final String protocol;
  final String webhook;
  final int maxHours;
  final String status;
  final List<SleepHours> sleepHours;
  final List<SleepHours> sleepHoursWeekend;

  Device({
    required this.id,
    required this.name,
    required this.protocol,
    required this.webhook,
    required this.maxHours,
    required this.status,
    required this.sleepHours,
    required this.sleepHoursWeekend,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      protocol: json['protocol'],
      webhook: json['webhook'] ?? '',
      maxHours: json['max_hours'],
      status: json['status'],
      sleepHours: (json['sleep_hours'] as List)
          .map((item) => SleepHours.fromJson(item))
          .toList(),
      sleepHoursWeekend: (json['sleep_hours_weekend'] as List)
          .map((item) => SleepHours.fromJson(item))
          .toList(),
    );
  }
}

class SleepHours {
  final int id;
  final int hour;
  final bool isActive;
  final bool isWeekend;

  SleepHours({
    required this.id,
    required this.hour,
    required this.isActive,
    required this.isWeekend,
  });

  factory SleepHours.fromJson(Map<String, dynamic> json) {
    return SleepHours(
      id: json['id'],
      hour: json['hour'],
      isActive: json['is_active'],
      isWeekend: json['is_weekend'],
    );
  }
}
