import 'package:mysql1/mysql1.dart';

Future<MySqlConnection> getConnection() async {
  var settings = ConnectionSettings(
      host: 'localhost',
      port: 3307,
      user: 'root',
      password: 'root',
      db: 'ibge');
  return await MySqlConnection.connect(settings);
}

