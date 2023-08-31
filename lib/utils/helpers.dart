bool isValidEmail(String email) {
  if (email.isEmpty) {
    return false;
  }

  final String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final RegExp regex = RegExp(emailRegex);

  return regex.hasMatch(email);
}