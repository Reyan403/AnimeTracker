import 'dart:convert';

import '../../domain/entities/watch_status.dart';
import '../../domain/entities/watchlist_entry.dart';

abstract final class WatchlistEntryDto {
  static String encode(List<WatchlistEntry> entries) => jsonEncode([
        for (final entry in entries)
          {
            'id': entry.id,
            'title': entry.title,
            'status': entry.status.name,
            'episodesWatched': entry.episodesWatched,
          },
      ]);

  static List<WatchlistEntry>? decode(String? source) {
    if (source == null) {
      return null;
    }

    try {
      return [
        for (final node in jsonDecode(source) as List<dynamic>)
          ?_entryOf(node as Map<String, dynamic>),
      ];
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  static WatchlistEntry? _entryOf(Map<String, dynamic> json) {
    final status = WatchStatus.values.asNameMap()[json['status']];

    if (status == null) {
      return null;
    }

    return WatchlistEntry(
      id: json['id'] as int,
      title: json['title'] as String,
      status: status,
      episodesWatched: json['episodesWatched'] as int? ?? 0,
    );
  }
}
