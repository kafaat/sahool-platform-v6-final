import 'package:equatable/equatable.dart';

enum SyncOperationType { create, update, delete }
enum SyncOperationStatus { pending, syncing, completed, failed }

class SyncOperation extends Equatable {
  final String id;
  final SyncOperationType type;
  final String endpoint;
  final String? entityId;
  final Map<String, dynamic> data;
  final SyncOperationStatus status;
  final int retryCount;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime? syncedAt;

  const SyncOperation({
    required this.id,
    required this.type,
    required this.endpoint,
    this.entityId,
    required this.data,
    this.status = SyncOperationStatus.pending,
    this.retryCount = 0,
    this.errorMessage,
    required this.createdAt,
    this.syncedAt,
  });

  SyncOperation copyWith({
    SyncOperationStatus? status,
    int? retryCount,
    String? errorMessage,
    DateTime? syncedAt,
  }) {
    return SyncOperation(
      id: id, type: type, endpoint: endpoint, entityId: entityId, data: data,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'type': type.name, 'endpoint': endpoint, 'entityId': entityId,
    'data': data, 'status': status.name, 'retryCount': retryCount,
    'errorMessage': errorMessage, 'createdAt': createdAt.toIso8601String(),
    'syncedAt': syncedAt?.toIso8601String(),
  };

  factory SyncOperation.fromJson(Map<String, dynamic> json) => SyncOperation(
    id: json['id'], type: SyncOperationType.values.byName(json['type']),
    endpoint: json['endpoint'], entityId: json['entityId'],
    data: Map<String, dynamic>.from(json['data']),
    status: SyncOperationStatus.values.byName(json['status']),
    retryCount: json['retryCount'] ?? 0, errorMessage: json['errorMessage'],
    createdAt: DateTime.parse(json['createdAt']),
    syncedAt: json['syncedAt'] != null ? DateTime.parse(json['syncedAt']) : null,
  );

  @override
  List<Object?> get props => [id];
}
