import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager_flutter/models/category/category_model.dart';
import 'package:money_manager_flutter/models/transaction/transaction_model.dart';

const TRANSACATION_DB_NAME = 'trasaction-db';

abstract class TrasactionDbFunctions {
  Future<void> addTrasaction(TranscationModel obj);
  Future<List<TranscationModel>> getAllTransactions();
  Future<void> delelteTransaction(String id);
}

class TransactionDB implements TrasactionDbFunctions {
  TransactionDB.internal();

  static TransactionDB instance = TransactionDB.internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TranscationModel>> transactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTrasaction(TranscationModel obj) async {
    final _db = await Hive.openBox<TranscationModel>(TRANSACATION_DB_NAME);
    _db.put(obj.id, obj);
  }

  Future<void> refresh() async {
    final _list = await getAllTransactions();
    _list.sort((first, second) => second.date.compareTo(first.date));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<List<TranscationModel>> getAllTransactions() async {
    final _db = await Hive.openBox<TranscationModel>(TRANSACATION_DB_NAME);

    return _db.values.toList();
  }

  @override
  Future<void> delelteTransaction(String id) async {
    final _db = await Hive.openBox<TranscationModel>(TRANSACATION_DB_NAME);
    await _db.delete(id);
    refresh();
  }
}
