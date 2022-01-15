import 'package:flutter/material.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';
import 'package:money_manager_flutter/db/transcation/trasacation_db.dart';
import 'package:money_manager_flutter/models/category/category_model.dart';
import 'package:money_manager_flutter/models/transaction/transaction_model.dart';

class ScreenaddTranSaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenaddTranSaction({Key? key}) : super(key: key);

  @override
  State<ScreenaddTranSaction> createState() => _ScreenaddTranSactionState();
}

class _ScreenaddTranSactionState extends State<ScreenaddTranSaction> {
  DateTime? _selelctedDate;
  CategoryType? _SelectedCategorytype;
  CategoryModel? _selelctedCategoryModel;
  String? _CategoryID;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _SelectedCategorytype = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _purposeTextEditingController,
                decoration: const InputDecoration(
                  hintText: 'Purpose',
                ),
              ),
              TextFormField(
                controller: _amountTextEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Amount',
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (_selectedDateTemp == null) {
                    return;
                  } else {
                    print(_selectedDateTemp.toString());
                    setState(() {
                      _selelctedDate = _selectedDateTemp;
                    });
                  }
                },
                icon: Icon(Icons.calendar_today),
                label: Text(_selelctedDate == null
                    ? 'Selelct Date'
                    : _selelctedDate!.toString()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.income,
                        groupValue: _SelectedCategorytype,
                        onChanged: (newValue) {
                          setState(() {
                            _SelectedCategorytype = CategoryType.income;
                            _CategoryID = null;
                          });
                        },
                      ),
                      Text('Income'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expense,
                        groupValue: _SelectedCategorytype,
                        onChanged: (newValue) {
                          setState(() {
                            _SelectedCategorytype = CategoryType.expense;
                            _CategoryID = null;
                          });
                        },
                      ),
                      Text('Expense'),
                    ],
                  ),
                ],
              ),
              DropdownButton<String>(
                hint: const Text('Selelct Category'),
                value: _CategoryID,
                items: (_SelectedCategorytype == CategoryType.income
                        ? CategoryDB().incomeCategoryListListener
                        : CategoryDB.instance.expenseCategoryListListener)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                    onTap: () {
                      print(e.toString());
                      _selelctedCategoryModel = e;
                    },
                  );
                }).toList(),
                onChanged: (selectedValue) {
                  print(selectedValue);
                  setState(() {
                    _CategoryID = selectedValue;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  addTrasaction();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTrasaction() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;

    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    if (_CategoryID == null) {
      return;
    }
    if (_selelctedDate == null) {
      return;
    }
    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }

    final _model = TranscationModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selelctedDate!,
      type: _SelectedCategorytype!,
      category: _selelctedCategoryModel!,
    );
    await TransactionDB.instance.addTrasaction(_model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }
}
