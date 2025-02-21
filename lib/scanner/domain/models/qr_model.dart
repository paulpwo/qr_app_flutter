class QrModel {
  final String id;
  final String result;
  final DateTime scannedAt;

  QrModel({
    required this.id,
    required this.result,
    required this.scannedAt,
  });

  String get resultTruncated {
    if (result.length <= 30) return result;
    return '${result.substring(0, 30)}...';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(scannedAt);

    if (difference.inSeconds < 60) {
      return 'Hace ${difference.inSeconds}s';
    }
    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes}m';
    }
    if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    }
    if (difference.inDays < 30) {
      return 'Hace ${difference.inDays}d';
    }
    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Hace $months ${months == 1 ? 'mes' : 'meses'}';
    }
    final years = (difference.inDays / 365).floor();
    return 'Hace $years ${years == 1 ? 'año' : 'años'}';
  }

  factory QrModel.create(String result) {
    return QrModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      result: result,
      scannedAt: DateTime.now(),
    );
  }
}
