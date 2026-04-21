class Person {
  final int id;
  final String name;
  final bool enabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Person({
    required this.id,
    required this.name,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
  });

  Person copyWith({
    int? id,
    String? name,
    bool? enabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Person && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
