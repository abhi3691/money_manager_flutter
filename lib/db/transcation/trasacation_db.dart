import 'package:hive_flutter/adapters.dart';
import 'package:money_manager_flutter/models/category/category_model.dart';
import 'package:money_manager_flutter/models/transaction/transaction_model.dart';

const TRANSACATION_DB_NAME = 'trasaction-db';

abstract class TrasactionDbFunctions {
  Future<void> addTrasaction(TranscationModel obj);
}

class TransactionDB implements TrasactionDbFunctions {
  TransactionDB.internal();

  static TransactionDB instance = TransactionDB.internal();

  factory TransactionDB() {
    return instance;
  }

  @override
  Future<void> addTrasaction(TranscationModel obj) async {
    final _db = await Hive.openBox<TranscationModel>(TRANSACATION_DB_NAME);
    _db.put(obj.id, obj);
  }
}
