import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/locals/model/home_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HomeDatabase{
  static final HomeDatabase instance = HomeDatabase._init();

  static Database? _database;
  HomeDatabase._init();

  Future<Database> get database async{
    if(_database != null){
      return _database!;
    }
    _database = await _initDB('home.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: homeCreate);
  }



  //Create table
  Future homeCreate(Database db, int version) async{
    await db.execute('''
    CREATE TABLE $tableNameHome(
    ${HomeFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${HomeFields.product_id} INTEGER NOT NULL,
    ${HomeFields.product_name} TEXT,
    ${HomeFields.unit_tag} TEXT,
    ${HomeFields.image} TEXT,
    ${HomeFields.purchase_price} DOUBLE,
    ${HomeFields.sale_price} DOUBLE,
    ${HomeFields.description} TEXT,
    ${HomeFields.view_quantity} TEXT,
    ${HomeFields.vat_amount} DOUBLE,
    ${HomeFields.discount_amount} DOUBLE,
    ${HomeFields.maximum_quantity} DOUBLE,
    ${HomeFields.current_stock} DOUBLE,
    ${HomeFields.weight} DOUBLE,
    ${HomeFields.sku} TEXT,
    ${HomeFields.category_id} TEXT,
    ${HomeFields.measurement_sku} TEXT,
    ${HomeFields.measurement_title} TEXT,
    ${HomeFields.measurement_value} TEXT,
    ${HomeFields.measurement} LIST
    )
    ''');
  }

  //customer Create
  Future createHome(BuildContext context, Home home, {pass}) async{
    final db = await instance.database;

    var count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableNameHome where ${HomeFields.product_id}=${home.product_id}'));

    if(count!>0){
      // MyComponents().mySnackBar(context, 'This Product Already In Your Cart');
      return db.update(tableNameHome, home.toJson(),
        where: '${home.id} = ?',
        whereArgs: [home.id],
      );
    }

    else{
      final id = await db.insert(tableNameHome, home.toJson());
      // pass == 'true' ? Navigator.push(context, MaterialPageRoute(builder: (_)=>CartScreen())) : null;
      return home.copy(id: id);
    }
  }

  //View Home Products
  Future<List<Home>> viewHome() async{
    final db = await instance.database;
    final result = await db.query(tableNameHome);
    return result.map((json) => Home.fromJson(json)).toList();
  }

  //Delete Customers
  Future<int> deleteHome(int id) async{
    final db = await instance.database;
    return db.delete(tableNameHome, where: '${HomeFields.product_id} = ?', whereArgs: [id]);
  }

  Future<Home?> readNote(int id) async{
    final db = await instance.database;

    final maps = await db.query(
      tableNameHome,
      columns: HomeFields.values,
      where: '${HomeFields.id} = ?',
      whereArgs: [id],
    );

    if(maps.isNotEmpty){
      return Home.fromJson(maps.first);
    }
    else {
      throw Exception('Id $id Not Found');
    }
  }

  Future close() async{
    final db = await instance.database;
    _database = null;
    db.close();
  }
}