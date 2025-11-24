class YPKValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email belum terisi';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Email salah';
    }

    return null;
  }

  static String? validatepassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password belum terisi';
    }

    if (value.length < 6) {
      return 'Password perlu mengandung 6 character';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telpon belum terisi';
    }

    final phoneRegExp = RegExp(r'^\d(10)$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Nomor Telpon salah';
    }
    return null;
  }
}