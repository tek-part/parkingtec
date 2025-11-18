const String _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ0123456789';

String generateParkingCode({int length = 6}) {
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < length; i++) {
    final int index = DateTime.now().microsecondsSinceEpoch % _alphabet.length;
    buffer.write(_alphabet[index]);
  }
  return buffer.toString();
}

bool isValidParkingCode(String input) {
  final RegExp regex = RegExp(r'^[A-HJ-NP-Z0-9]{6}$');
  return regex.hasMatch(input);
}



