import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../logging/app_logger.dart';
import 'sync_operation.dart';
import 'sync_queue.dart';

/// مركز المزامنة - يدير العمليات المعلقة والمزامنة التلقائية
class SyncEngine {
  static final SyncEngine _instance = SyncEngine._internal();
  factory SyncEngine() => _instance;
  SyncEngine._internal();

  final SyncQueue _queue = SyncQueue();
  final Connectivity _connectivity = Connectivity();
  
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _periodicSync;
  bool _isSyncing = false;

  Future<void> start() async {
    AppLogger.i('بدء خدمة المزامنة', tag: 'Sync');
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    _periodicSync = Timer.periodic(const Duration(minutes: 5), (_) => syncAll());
    await syncAll();
  }

  void stop() {
    _connectivitySubscription?.cancel();
    _periodicSync?.cancel();
  }

  Future<void> addOperation(SyncOperation operation) async {
    await _queue.add(operation);
    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      await syncAll();
    }
  }

  Future<SyncResult> syncAll() async {
    if (_isSyncing) return SyncResult(synced: 0, failed: 0, pending: await _queue.count());
    
    _isSyncing = true;
    int synced = 0;
    int failed = 0;

    try {
      final operations = await _queue.getPending();
      for (final op in operations) {
        try {
          await _executeOperation(op);
          await _queue.markCompleted(op.id);
          synced++;
        } catch (e) {
          await _queue.markFailed(op.id, e.toString());
          failed++;
        }
      }
    } finally {
      _isSyncing = false;
    }

    return SyncResult(synced: synced, failed: failed, pending: await _queue.count());
  }

  Future<void> _executeOperation(SyncOperation op) async {
    // Implementation based on operation type
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    if (result != ConnectivityResult.none) syncAll();
  }

  Future<SyncStatus> getStatus() async {
    return SyncStatus(
      isSyncing: _isSyncing,
      pendingCount: await _queue.count(),
      lastSyncTime: DateTime.now(),
    );
  }
}

class SyncResult {
  final int synced;
  final int failed;
  final int pending;
  SyncResult({required this.synced, required this.failed, required this.pending});
}

class SyncStatus {
  final bool isSyncing;
  final int pendingCount;
  final DateTime lastSyncTime;
  SyncStatus({required this.isSyncing, required this.pendingCount, required this.lastSyncTime});
  bool get hasPending => pendingCount > 0;
}
