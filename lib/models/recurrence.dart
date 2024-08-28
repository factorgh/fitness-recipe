class Recurrence {
  final String type; // Type of recurrence (e.g., 'Daily', 'Weekly', 'Custom')
  final int? customDays; // For 'Custom' recurrence, the number of days
  final List<int>?
      daysOfWeek; // For 'Weekly', days of the week (0=Monday, 1=Tuesday, etc.)
  final List<int>? daysOfMonth; // For 'Monthly', specific dates of the month
  final List<String>? specificDays; // For 'Specific Days in Multiple Weeks'
  final int? occurrences; // For 'Advanced Options', number of occurrences

  Recurrence({
    required this.type,
    this.customDays,
    this.daysOfWeek,
    this.daysOfMonth,
    this.specificDays,
    this.occurrences,
  });

  // Convert to JSON for sending to backend
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'customDays': customDays,
      'daysOfWeek': daysOfWeek,
      'daysOfMonth': daysOfMonth,
      'specificDays': specificDays,
      'occurrences': occurrences,
    };
  }

  // Create a Recurrence object from JSON
  factory Recurrence.fromJson(Map<String, dynamic> json) {
    return Recurrence(
      type: json['type'],
      customDays: json['customDays'],
      daysOfWeek: List<int>.from(json['daysOfWeek'] ?? []),
      daysOfMonth: List<int>.from(json['daysOfMonth'] ?? []),
      specificDays: List<String>.from(json['specificDays'] ?? []),
      occurrences: json['occurrences'],
    );
  }
}
