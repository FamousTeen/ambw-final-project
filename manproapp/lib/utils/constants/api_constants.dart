// //List of API
// class APIContants {
//   // static const
// }

import 'package:flutter/foundation.dart' show kIsWeb;

// Use localhost when running on the web (browser). Use 10.0.2.2 for Android
// emulator (which maps to host machine). This avoids importing dart:io
// so the file remains web-safe and we don't create new files.
String url = kIsWeb ? 'http://localhost:8000/api/' : 'http://10.0.2.2:8000/api/';
