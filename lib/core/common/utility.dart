extension DateTimeExtension on DateTime {
  String get differentTimeDisplayText {
    final now = DateTime.now();
    final difference = now.difference(this);
    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inMinutes == 1) {
      return '1분 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours == 1) {
      return '1시간 전';
    } else if (difference.inHours > 1) {
      return '${difference.inHours}시간 전';
    } else {
      return '${difference.inDays}일 전';
    }
  }
}
