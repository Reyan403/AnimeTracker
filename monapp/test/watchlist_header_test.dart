import 'package:flutter_test/flutter_test.dart';

import 'package:monapp/layers/functional/Anime/presentation/widgets/watchlist_header.dart';

void main() {
  test('the issue date reads as an abbreviated French date', () {
    expect(formatIssueDate(DateTime(2026, 9, 10)), 'JEU. 10 SEPT. 2026');
    expect(formatIssueDate(DateTime(2026, 2, 1)), 'DIM. 1 FÉVR. 2026');
  });
}
