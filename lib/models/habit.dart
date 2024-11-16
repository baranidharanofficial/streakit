import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final int? id;
  final String name;
  final String notes;
  final int icon;
  final int color;
  List<DateTime> completedDays;
  final int orderIndex; // New field

  Habit({
    this.id,
    required this.name,
    required this.notes,
    required this.icon,
    required this.color,
    required this.completedDays,
    this.orderIndex = 0, // Default value
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'notes': notes,
      'icon': icon,
      'color': color,
      'completed_days': completedDays
          .map((date) => date.toIso8601String())
          .toList()
          .join(','), // Change this as needed
      'order_index': orderIndex, // Include in map
    };
  }

  static Habit fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      notes: map['notes'],
      icon: map['icon'],
      color: map['color'],
      completedDays: map['completed_days'].toString().isEmpty
          ? []
          : (map['completed_days'] as String)
              .split(',')
              .map((dateString) => DateTime.parse(dateString))
              .toList(),
      orderIndex: map['order_index'], // Include in fromMap
    );
  }

  Habit copyWith(
      {int? id,
      String? name,
      String? notes,
      int? icon,
      int? color,
      List<DateTime>? completedDays,
      int? orderIndex}) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      completedDays: completedDays ?? this.completedDays,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}

class NotificationMessage {
  final String message;
  final DateTime createdAt;

  NotificationMessage({
    required this.message,
    required this.createdAt,
  });

  factory NotificationMessage.fromMap(Map<String, dynamic> data) {
    return NotificationMessage(
      message: data['message'] as String,
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }
}

class DailyMessage {
  final String quote;
  final DateTime createdAt;

  DailyMessage({
    required this.quote,
    required this.createdAt,
  });

  factory DailyMessage.fromMap(Map<String, dynamic> data) {
    return DailyMessage(
      quote: data['quote'] as String,
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }
}
