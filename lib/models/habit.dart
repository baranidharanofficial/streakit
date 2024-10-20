class Habit {
  int? id;
  String name;
  String notes;
  int icon;
  int color;
  List<DateTime> completedDays;

  Habit({
    this.id,
    required this.name,
    required this.notes,
    required this.icon,
    required this.color,
    required this.completedDays,
  });

  // Convert a Habit into a Map for sqflite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'notes': notes,
      'icon': icon,
      'color': color,
      'completed_days':
          completedDays.join(','), // Store as comma-separated string
    };
  }

  // Convert a Map back into a Habit
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      notes: map['notes'],
      icon: map['icon'],
      color: map['color'],
      completedDays: (map['completed_days'] as String).isNotEmpty
          ? (map['completed_days'] as String)
              .split(',')
              .map((dateStr) => DateTime.parse(dateStr))
              .toList()
          : [],
    );
  }

  // Define copyWith to allow partial updates
  Habit copyWith({
    int? id,
    String? name,
    String? notes,
    int? icon,
    int? color,
    List<DateTime>? completedDays,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      completedDays: completedDays ?? this.completedDays,
    );
  }
}
