abstract final class BoosterDay {
  static String keyOf(DateTime moment) {
    final local = moment.toLocal();

    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }

  static DateTime midnightAfter(DateTime moment) {
    final local = moment.toLocal();

    return DateTime(local.year, local.month, local.day + 1);
  }
}
