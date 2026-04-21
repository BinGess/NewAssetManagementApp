import '../database/app_database.dart';
import 'snapshot_repository.dart';

class DashboardService {
  final AppDatabase _db;
  final SnapshotRepository _snapshotRepo;

  DashboardService(this._db, this._snapshotRepo);

  /// Records a snapshot of the current financial state.
  /// Skips recording if the last snapshot was less than 60 minutes ago
  /// AND the amounts haven't changed significantly (within 1 unit).
  Future<void> recordSnapshot({String currency = 'CNY'}) async {
    final totalAssets = await _sumAssets();
    final totalLiabilities = await _sumLiabilities();

    final latest = await _snapshotRepo.getLatest();
    if (latest != null) {
      final minutesSinceLast =
          DateTime.now().difference(latest.createdAt).inMinutes;
      final assetsUnchanged = (latest.totalAssets - totalAssets).abs() < 1.0;
      final liabilitiesUnchanged =
          (latest.totalLiabilities - totalLiabilities).abs() < 1.0;
      if (minutesSinceLast < 60 && assetsUnchanged && liabilitiesUnchanged) {
        return;
      }
    }

    await _snapshotRepo.insert(
      totalAssets: totalAssets,
      totalLiabilities: totalLiabilities,
      currency: currency,
    );
  }

  Future<double> _sumAssets() async {
    final result = await _db.customSelect(
      'SELECT COALESCE(SUM(amount), 0.0) AS total FROM assets',
    ).getSingle();
    return result.read<double>('total');
  }

  Future<double> _sumLiabilities() async {
    final result = await _db.customSelect(
      'SELECT COALESCE(SUM(amount), 0.0) AS total FROM liabilities',
    ).getSingle();
    return result.read<double>('total');
  }
}
