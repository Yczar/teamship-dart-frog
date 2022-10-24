// ignore_for_file: public_member_api_docs

import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';

const dbName = 'mongo-dart-example';
const dbAddress = '127.0.0.1';
DbConnection connection = DbConnection(dbAddress, '27017', dbName);

class DbConnection {
  DbConnection(this.host, this.port, this.dbName);
  final String host;
  final String port;
  final String dbName;

  String get connectionString =>
      'mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+1.6.0';

  int retryAttempts = 5;

  static bool started = false;

  Db? _db;
  Future<Db> get db async => getConnection();

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
    }
  }

  Future<Db> getConnection() async {
    if (_db == null || !_db!.isConnected) {
      await close();
      var retry = 0;
      while (true) {
        try {
          retry++;
          final db = Db(connectionString);
          await db.open();
          _db = db;
          log('OK after "$retry" attempts');
          break;
        } catch (e) {
          if (retryAttempts < retry) {
            log('Exiting after "$retry" attempts');
            rethrow;
          }
          // each time waits a little bit more before re-trying
          await Future.delayed(Duration(milliseconds: 100 * retry));
        }
      }
    }
    return _db!;
  }
}
