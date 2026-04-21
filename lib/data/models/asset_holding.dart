class AssetHolding {
  final int id;
  final int assetId;
  final String name;
  final double price;
  final double quantity;
  final String? notes;

  const AssetHolding({
    required this.id,
    required this.assetId,
    required this.name,
    required this.price,
    required this.quantity,
    this.notes,
  });

  /// Total market value of this holding
  double get totalValue => price * quantity;

  AssetHolding copyWith({
    int? id,
    int? assetId,
    String? name,
    double? price,
    double? quantity,
    Object? notes = _sentinel,
  }) {
    return AssetHolding(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      notes: notes == _sentinel ? this.notes : notes as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AssetHolding && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

const _sentinel = Object();
