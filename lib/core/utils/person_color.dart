import 'package:flutter/material.dart';

/// Assigns a consistent accent color to a person based on their ID.
/// Colors are drawn from a palette designed for the dark glassmorphism theme.
class PersonColors {
  PersonColors._();

  static const List<Color> _palette = [
    Color(0xFF3B82F6), // blue   (primary)
    Color(0xFF10B981), // emerald
    Color(0xFFF59E0B), // amber
    Color(0xFFEC4899), // pink
    Color(0xFF8B5CF6), // violet
    Color(0xFF06B6D4), // cyan
    Color(0xFFF97316), // orange
    Color(0xFF84CC16), // lime
  ];

  /// Returns the accent color for a given person [id].
  /// Falls back gracefully when [id] is null.
  static Color forId(int? id) {
    if (id == null) return const Color(0xFF64748B); // slate (no person)
    return _palette[id % _palette.length];
  }

  /// A lighter variant (12 % opacity) used for background fills.
  static Color bgForId(int? id) => forId(id).withValues(alpha: 0.12);

  /// A border variant (40 % opacity) used for card border glow.
  static Color borderForId(int? id) => forId(id).withValues(alpha: 0.4);
}
