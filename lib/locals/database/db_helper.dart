import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/locals/model/local_cart_model.dart';
import 'package:grocery/views/cart/CartScreen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CartDatabase{
  static final CartDatabase instance = CartDatabase._init();

  static Database? _database;
  CartDatabase._init();

  Future<Database> get database async{
    if(_database != null){
      return _database!;
    }
    _database = await _initDB('cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: cartCreate);
  }



  //Create table
  Future cartCreate(Database db, int version) async{
    await db.execute('''
    CREATE TABLE $tableName(
    ${CartFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${CartFields.product_id} INTEGER NOT NULL,
    ${CartFields.product_name} TEXT,
    ${CartFields.unit_tag} TEXT,
    ${CartFields.image} TEXT,
    ${CartFields.purchase_price} DOUBLE,
    ${CartFields.sale_price} DOUBLE,
    ${CartFields.quantity} INTEGER NOT NULL,
    ${CartFields.view_quantity} TEXT,
    ${CartFields.vat_amount} DOUBLE,
    ${CartFields.discount_amount} DOUBLE,
    ${CartFields.maximum_quantity} DOUBLE,
    ${CartFields.current_stock} DOUBLE,
    ${CartFields.weight} DOUBLE,
    ${CartFields.measurement_sku} TEXT,
    ${CartFields.measurement_title} TEXT,
    ${CartFields.measurement_value} TEXT
    )
    ''');
  }

  //customer Create
  Future createCart(BuildContext context, AddtoCart carts, {pass}) async{
    final db = await instance.database;

    var count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName where ${CartFields.product_id}=${carts.product_id}'));

    if(count!>0){
      MyComponents().mySnackBar(context, 'This Product Already In Your Cart');
      return db.update(tableName, carts.toJson(),
        where: '${carts.id} = ?',
        whereArgs: [carts.id],
      );
    }

    else{

      final id = await db.insert(tableName, carts.toJson());
      //pass == 'true' ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>CartScreen())) : null;
      return carts.copy(id: id);
    }
  }

  //View Customers
  Future<List<AddtoCart>> viewCart() async{
    final db = await instance.database;

    final result = await db.query(tableName);
    return result.map((json) => AddtoCart.fromJson(json)).toList();
  }

  //Delete Customers
  Future<int> deleteCart(int id) async{
    final db = await instance.database;
    return db.delete(tableName, where: '${CartFields.id} = ?', whereArgs: [id]);
  }

  Future<AddtoCart?> readNote(int id) async{
    final db = await instance.database;

    final maps = await db.query(
      tableName,
      columns: CartFields.values,
      where: '${CartFields.id} = ?',
      whereArgs: [id],
    );

    if(maps.isNotEmpty){
      return AddtoCart.fromJson(maps.first);
    }
    else {
      throw Exception('Id $id Not Found');
    }
  }

  Future<int> updateCart(int id, int quantity) async{
    final db = await instance.database;

    return await db.rawUpdate('UPDATE $tableName SET ${CartFields.quantity} = $quantity WHERE ${CartFields.id} = ${id}');
  }


  Future close() async{
    final db = await instance.database;
    _database = null;
    db.close();
  }
}