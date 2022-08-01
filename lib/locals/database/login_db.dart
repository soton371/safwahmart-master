import 'package:flutter/material.dart';
import 'package:grocery/locals/model/login_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LoginDatabase{
  static final LoginDatabase instance = LoginDatabase._init();

  static Database? _database;
  LoginDatabase._init();

  Future<Database> get database async{
    if(_database != null){
      return _database!;
    }
    _database = await _initDB('login.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: loginCreate);
  }



  //Create table
  Future loginCreate(Database db, int version) async{
    await db.execute('''
    CREATE TABLE $tableNameLogin(
    ${LoginFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${LoginFields.token} TEXT NOT NULL,
    ${LoginFields.name} TEXT,
    ${LoginFields.email} TEXT,
    ${LoginFields.phone} TEXT,
    ${LoginFields.user_id} INTEGER,
    ${LoginFields.customer_id} INTEGER,
    ${LoginFields.district_id} INTEGER,
    ${LoginFields.district} TEXT,
    ${LoginFields.area_id} INTEGER,
    ${LoginFields.area} TEXT,
    ${LoginFields.address} TEXT,
    ${LoginFields.zip_code} TEXT
        )
    ''');
  }

  //customer Create
  Future createLogin(BuildContext context, Login login) async{
    final db = await instance.database;

    var count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableNameLogin where ${LoginFields.id}=${login.id}'));

    if(count!>0){
      return db.update(tableNameLogin, login.toJson(),
        where: '${login.phone} = ?',
        whereArgs: [login.phone],
      );
    }

    else{
      final id = await db.insert(tableNameLogin, login.toJson());
      return login.copy(id: id);
    }
  }

  //View Customers
  Future<List<Login>> viewLogin() async{
    final db = await instance.database;

    final result = await db.query(tableNameLogin);
    return result.map((json) => Login.fromJson(json)).toList();
  }

  //Delete Customers
  Future<int> deleteLogin(String phone) async{
    final db = await instance.database;
    print('Delete');
    return db.delete(tableNameLogin, where: '${LoginFields.phone} = ?', whereArgs: [phone]);
  }

  // Future<int> updateLogin(Login login) async{
  //   final db = await instance.database;
  //
  //   return await db.update(tableNameLogin, login.toJson(),);
  // }


  Future close() async{
    final db = await instance.database;
    _database = null;
    db.close();
  }
}