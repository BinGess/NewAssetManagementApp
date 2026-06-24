import 'backend_api_client.dart';

class BackendAssetApi {
  final BackendApiClient _client;

  BackendAssetApi(this._client);

  Future<List<BackendPerson>> listPersons(String accessToken) async {
    final json = await _client.getJson('/persons', accessToken: accessToken);
    return _list(json).map(BackendPerson.fromJson).toList();
  }

  Future<BackendPerson> createPerson(
    String accessToken,
    BackendPersonCreate input,
  ) async {
    final json = await _client.postJson(
      '/persons',
      accessToken: accessToken,
      body: input.toJson(),
    );
    return BackendPerson.fromJson(_map(json));
  }

  Future<BackendPerson> updatePerson(
    String accessToken, {
    required String personId,
    required BackendPersonUpdate input,
  }) async {
    final json = await _client.patchJson(
      '/persons/$personId',
      accessToken: accessToken,
      body: input.toJson(),
    );
    return BackendPerson.fromJson(_map(json));
  }

  Future<void> deletePerson(String accessToken, String personId) {
    return _client.delete('/persons/$personId', accessToken: accessToken);
  }

  Future<List<BackendType>> listAssetTypes(String accessToken) async {
    final json =
        await _client.getJson('/assets/types', accessToken: accessToken);
    return _list(json).map(BackendType.fromJson).toList();
  }

  Future<List<BackendType>> listLiabilityTypes(String accessToken) async {
    final json = await _client.getJson(
      '/liabilities/types',
      accessToken: accessToken,
    );
    return _list(json).map(BackendType.fromJson).toList();
  }

  Future<List<BackendAsset>> listAssets(String accessToken) async {
    final json = await _client.getJson('/assets', accessToken: accessToken);
    return _list(json).map(BackendAsset.fromJson).toList();
  }

  Future<BackendAsset> createAsset(
    String accessToken,
    BackendAssetCreate input,
  ) async {
    final json = await _client.postJson(
      '/assets',
      accessToken: accessToken,
      body: input.toJson(),
    );
    return BackendAsset.fromJson(_map(json));
  }

  Future<BackendAsset> updateAsset(
    String accessToken, {
    required String assetId,
    required BackendAssetUpdate input,
  }) async {
    final json = await _client.patchJson(
      '/assets/$assetId',
      accessToken: accessToken,
      body: input.toJson(),
    );
    return BackendAsset.fromJson(_map(json));
  }

  Future<void> deleteAsset(String accessToken, String assetId) {
    return _client.delete('/assets/$assetId', accessToken: accessToken);
  }

  Future<List<BackendLiability>> listLiabilities(String accessToken) async {
    final json =
        await _client.getJson('/liabilities', accessToken: accessToken);
    return _list(json).map(BackendLiability.fromJson).toList();
  }

  Future<BackendLiability> createLiability(
    String accessToken,
    BackendLiabilityCreate input,
  ) async {
    final json = await _client.postJson(
      '/liabilities',
      accessToken: accessToken,
      body: input.toJson(),
    );
    return BackendLiability.fromJson(_map(json));
  }

  Future<BackendLiability> updateLiability(
    String accessToken, {
    required String liabilityId,
    required BackendLiabilityUpdate input,
  }) async {
    final json = await _client.patchJson(
      '/liabilities/$liabilityId',
      accessToken: accessToken,
      body: input.toJson(),
    );
    return BackendLiability.fromJson(_map(json));
  }

  Future<void> deleteLiability(String accessToken, String liabilityId) {
    return _client.delete('/liabilities/$liabilityId',
        accessToken: accessToken);
  }

  Future<List<BackendExpense>> listExpenses(String accessToken) async {
    final json = await _client.getJson('/expenses', accessToken: accessToken);
    return _list(json).map(BackendExpense.fromJson).toList();
  }

  Future<BackendExpense> createExpense(
    String accessToken,
    BackendExpenseCreate input,
  ) async {
    final json = await _client.postJson(
      '/expenses',
      accessToken: accessToken,
      body: input.toJson(),
    );
    return BackendExpense.fromJson(_map(json));
  }

  Future<BackendExpense> updateExpense(
    String accessToken, {
    required String expenseId,
    required BackendExpenseUpdate input,
  }) async {
    final json = await _client.patchJson(
      '/expenses/$expenseId',
      accessToken: accessToken,
      body: input.toJson(),
    );
    return BackendExpense.fromJson(_map(json));
  }

  Future<void> deleteExpense(String accessToken, String expenseId) {
    return _client.delete('/expenses/$expenseId', accessToken: accessToken);
  }

  Future<List<BackendHolding>> listHoldings(
    String accessToken, {
    required String assetId,
  }) async {
    final json = await _client.getJson(
      '/assets/$assetId/holdings',
      accessToken: accessToken,
    );
    return _list(json).map(BackendHolding.fromJson).toList();
  }

  Future<BackendHolding> createHolding(
    String accessToken, {
    required String assetId,
    required BackendHoldingCreate input,
  }) async {
    final json = await _client.postJson(
      '/assets/$assetId/holdings',
      accessToken: accessToken,
      body: input.toJson(),
    );
    return BackendHolding.fromJson(_map(json));
  }

  Future<BackendHolding> updateHolding(
    String accessToken, {
    required String assetId,
    required String holdingId,
    required BackendHoldingUpdate input,
  }) async {
    final json = await _client.patchJson(
      '/assets/$assetId/holdings/$holdingId',
      accessToken: accessToken,
      body: input.toJson(),
    );
    return BackendHolding.fromJson(_map(json));
  }

  Future<void> deleteHolding(
    String accessToken, {
    required String assetId,
    required String holdingId,
  }) {
    return _client.delete(
      '/assets/$assetId/holdings/$holdingId',
      accessToken: accessToken,
    );
  }
}

class BackendPerson {
  final String id;
  final String name;
  final bool enabled;
  final int version;

  const BackendPerson({
    required this.id,
    required this.name,
    required this.enabled,
    required this.version,
  });

  factory BackendPerson.fromJson(Map<String, Object?> json) {
    return BackendPerson(
      id: json['id']! as String,
      name: json['name']! as String,
      enabled: json['enabled']! as bool,
      version: json['version']! as int,
    );
  }
}

class BackendPersonCreate {
  final String name;
  final bool? enabled;

  const BackendPersonCreate({
    required this.name,
    this.enabled,
  });

  Map<String, Object?> toJson() => {
        'name': name,
        if (enabled != null) 'enabled': enabled,
      };
}

class BackendPersonUpdate {
  final int version;
  final String? name;
  final bool? enabled;

  const BackendPersonUpdate({
    required this.version,
    this.name,
    this.enabled,
  });

  Map<String, Object?> toJson() => {
        'version': version,
        if (name != null) 'name': name,
        if (enabled != null) 'enabled': enabled,
      };
}

class BackendType {
  final String id;
  final String code;
  final String label;
  final bool enabled;
  final int sortOrder;
  final int version;

  const BackendType({
    required this.id,
    required this.code,
    required this.label,
    required this.enabled,
    required this.sortOrder,
    required this.version,
  });

  factory BackendType.fromJson(Map<String, Object?> json) {
    return BackendType(
      id: json['id']! as String,
      code: json['code']! as String,
      label: json['label']! as String,
      enabled: json['enabled']! as bool,
      sortOrder: json['sortOrder']! as int,
      version: json['version']! as int,
    );
  }
}

class BackendAsset {
  final String id;
  final String name;
  final String typeId;
  final String amount;
  final String currency;
  final DateTime valuationDate;
  final String? annualRate;
  final DateTime? startDate;
  final String? notes;
  final String? personId;
  final int version;

  const BackendAsset({
    required this.id,
    required this.name,
    required this.typeId,
    required this.amount,
    required this.currency,
    required this.valuationDate,
    this.annualRate,
    this.startDate,
    this.notes,
    this.personId,
    required this.version,
  });

  factory BackendAsset.fromJson(Map<String, Object?> json) {
    return BackendAsset(
      id: json['id']! as String,
      name: json['name']! as String,
      typeId: json['typeId']! as String,
      amount: json['amount'].toString(),
      currency: json['currency']! as String,
      valuationDate: DateTime.parse(json['valuationDate']! as String),
      annualRate: json['annualRate']?.toString(),
      startDate: _optionalDate(json['startDate']),
      notes: json['notes'] as String?,
      personId: json['personId'] as String?,
      version: json['version']! as int,
    );
  }
}

class BackendAssetCreate {
  final String name;
  final String typeId;
  final String amount;
  final String currency;
  final DateTime valuationDate;
  final String? annualRate;
  final DateTime? startDate;
  final String? notes;
  final String? personId;

  const BackendAssetCreate({
    required this.name,
    required this.typeId,
    required this.amount,
    required this.currency,
    required this.valuationDate,
    this.annualRate,
    this.startDate,
    this.notes,
    this.personId,
  });

  Map<String, Object?> toJson() => {
        'name': name,
        'typeId': typeId,
        'amount': amount,
        'currency': currency,
        'valuationDate': _dateOnly(valuationDate),
        if (annualRate != null) 'annualRate': annualRate,
        if (startDate != null) 'startDate': _dateOnly(startDate!),
        if (notes != null) 'notes': notes,
        if (personId != null) 'personId': personId,
      };
}

class BackendAssetUpdate {
  final int version;
  final String? name;
  final String? typeId;
  final String? amount;
  final String? currency;
  final DateTime? valuationDate;
  final String? annualRate;
  final DateTime? startDate;
  final String? notes;
  final String? personId;

  const BackendAssetUpdate({
    required this.version,
    this.name,
    this.typeId,
    this.amount,
    this.currency,
    this.valuationDate,
    this.annualRate,
    this.startDate,
    this.notes,
    this.personId,
  });

  Map<String, Object?> toJson() => {
        'version': version,
        if (name != null) 'name': name,
        if (typeId != null) 'typeId': typeId,
        if (amount != null) 'amount': amount,
        if (currency != null) 'currency': currency,
        if (valuationDate != null) 'valuationDate': _dateOnly(valuationDate!),
        if (annualRate != null) 'annualRate': annualRate,
        if (startDate != null) 'startDate': _dateOnly(startDate!),
        if (notes != null) 'notes': notes,
        if (personId != null) 'personId': personId,
      };
}

class BackendLiability {
  final String id;
  final String name;
  final String typeId;
  final String amount;
  final String currency;
  final String? interestRate;
  final DateTime? dueDate;
  final String? notes;
  final String? personId;
  final int version;

  const BackendLiability({
    required this.id,
    required this.name,
    required this.typeId,
    required this.amount,
    required this.currency,
    this.interestRate,
    this.dueDate,
    this.notes,
    this.personId,
    required this.version,
  });

  factory BackendLiability.fromJson(Map<String, Object?> json) {
    return BackendLiability(
      id: json['id']! as String,
      name: json['name']! as String,
      typeId: json['typeId']! as String,
      amount: json['amount'].toString(),
      currency: json['currency']! as String,
      interestRate: json['interestRate']?.toString(),
      dueDate: _optionalDate(json['dueDate']),
      notes: json['notes'] as String?,
      personId: json['personId'] as String?,
      version: json['version']! as int,
    );
  }
}

class BackendLiabilityCreate {
  final String name;
  final String typeId;
  final String amount;
  final String currency;
  final String? interestRate;
  final DateTime? dueDate;
  final String? notes;
  final String? personId;

  const BackendLiabilityCreate({
    required this.name,
    required this.typeId,
    required this.amount,
    required this.currency,
    this.interestRate,
    this.dueDate,
    this.notes,
    this.personId,
  });

  Map<String, Object?> toJson() => {
        'name': name,
        'typeId': typeId,
        'amount': amount,
        'currency': currency,
        if (interestRate != null) 'interestRate': interestRate,
        if (dueDate != null) 'dueDate': _dateOnly(dueDate!),
        if (notes != null) 'notes': notes,
        if (personId != null) 'personId': personId,
      };
}

class BackendLiabilityUpdate {
  final int version;
  final String? name;
  final String? typeId;
  final String? amount;
  final String? currency;
  final String? interestRate;
  final DateTime? dueDate;
  final String? notes;
  final String? personId;

  const BackendLiabilityUpdate({
    required this.version,
    this.name,
    this.typeId,
    this.amount,
    this.currency,
    this.interestRate,
    this.dueDate,
    this.notes,
    this.personId,
  });

  Map<String, Object?> toJson() => {
        'version': version,
        if (name != null) 'name': name,
        if (typeId != null) 'typeId': typeId,
        if (amount != null) 'amount': amount,
        if (currency != null) 'currency': currency,
        if (interestRate != null) 'interestRate': interestRate,
        if (dueDate != null) 'dueDate': _dateOnly(dueDate!),
        if (notes != null) 'notes': notes,
        if (personId != null) 'personId': personId,
      };
}

class BackendExpense {
  final String id;
  final String name;
  final String amount;
  final String cycle;
  final String personId;
  final DateTime date;
  final String? notes;
  final int version;

  const BackendExpense({
    required this.id,
    required this.name,
    required this.amount,
    required this.cycle,
    required this.personId,
    required this.date,
    this.notes,
    required this.version,
  });

  factory BackendExpense.fromJson(Map<String, Object?> json) {
    return BackendExpense(
      id: json['id']! as String,
      name: json['name']! as String,
      amount: json['amount'].toString(),
      cycle: json['cycle']! as String,
      personId: json['personId']! as String,
      date: DateTime.parse(json['date']! as String),
      notes: json['notes'] as String?,
      version: json['version']! as int,
    );
  }
}

class BackendExpenseCreate {
  final String name;
  final String amount;
  final String cycle;
  final String personId;
  final DateTime date;
  final String? notes;

  const BackendExpenseCreate({
    required this.name,
    required this.amount,
    required this.cycle,
    required this.personId,
    required this.date,
    this.notes,
  });

  Map<String, Object?> toJson() => {
        'name': name,
        'amount': amount,
        'cycle': cycle,
        'personId': personId,
        'date': _dateOnly(date),
        if (notes != null) 'notes': notes,
      };
}

class BackendExpenseUpdate {
  final int version;
  final String? name;
  final String? amount;
  final String? cycle;
  final String? personId;
  final DateTime? date;
  final String? notes;

  const BackendExpenseUpdate({
    required this.version,
    this.name,
    this.amount,
    this.cycle,
    this.personId,
    this.date,
    this.notes,
  });

  Map<String, Object?> toJson() => {
        'version': version,
        if (name != null) 'name': name,
        if (amount != null) 'amount': amount,
        if (cycle != null) 'cycle': cycle,
        if (personId != null) 'personId': personId,
        if (date != null) 'date': _dateOnly(date!),
        if (notes != null) 'notes': notes,
      };
}

class BackendHolding {
  final String id;
  final String assetId;
  final String name;
  final String price;
  final String quantity;
  final String? notes;
  final int version;

  const BackendHolding({
    required this.id,
    required this.assetId,
    required this.name,
    required this.price,
    required this.quantity,
    this.notes,
    required this.version,
  });

  factory BackendHolding.fromJson(Map<String, Object?> json) {
    return BackendHolding(
      id: json['id']! as String,
      assetId: json['assetId']! as String,
      name: json['name']! as String,
      price: json['price'].toString(),
      quantity: json['quantity'].toString(),
      notes: json['notes'] as String?,
      version: json['version']! as int,
    );
  }
}

class BackendHoldingCreate {
  final String name;
  final String price;
  final String quantity;
  final String? notes;

  const BackendHoldingCreate({
    required this.name,
    required this.price,
    required this.quantity,
    this.notes,
  });

  Map<String, Object?> toJson() => {
        'name': name,
        'price': price,
        'quantity': quantity,
        if (notes != null) 'notes': notes,
      };
}

class BackendHoldingUpdate {
  final int version;
  final String? name;
  final String? price;
  final String? quantity;
  final String? notes;

  const BackendHoldingUpdate({
    required this.version,
    this.name,
    this.price,
    this.quantity,
    this.notes,
  });

  Map<String, Object?> toJson() => {
        'version': version,
        if (name != null) 'name': name,
        if (price != null) 'price': price,
        if (quantity != null) 'quantity': quantity,
        if (notes != null) 'notes': notes,
      };
}

List<Map<String, Object?>> _list(Object? json) {
  return (json! as List<Object?>).cast<Map<String, Object?>>();
}

Map<String, Object?> _map(Object? json) => json! as Map<String, Object?>;

String _dateOnly(DateTime value) {
  return value.toIso8601String().substring(0, 10);
}

DateTime? _optionalDate(Object? value) {
  return value == null ? null : DateTime.parse(value as String);
}
