bool isValidEmail(String email) {
  if (email.isEmpty) {
    return false;
  }

  const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final RegExp regex = RegExp(emailRegex);

  return regex.hasMatch(email);
}

String getDuration(DateTime start, DateTime end) {
  if (end.difference(start).inDays < 8) {
    return 'Week';
  }

  if (end.difference(start).inDays < 31) {
    return 'Month';
  }

  if (end.difference(start).inDays < 366) {
    return 'Year';
  }

  return 'Infinite';
}
