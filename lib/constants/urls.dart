import 'package:flutter_dotenv/flutter_dotenv.dart';

final BACKEND_URL = '${DotEnv().env['HOST']}';