import 'package:flutter/material.dart';
import 'package:money_manager_flutter/models/category/category_db.dart';
import 'package:money_manager_flutter/models/category/category_model.dart';

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
                decoration: const InputDecoration(
                  hintText: 'Purpose',
                ),
              ),
              TextFormField(
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
                        groupValue: CategoryType.income,
                        onChanged: (newValue) {},
                      ),
                      Text('Income'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expense,
                        groupValue: CategoryType.income,
                        onChanged: (newValue) {},
                      ),
                      Text('Income'),
                    ],
                  ),
                ],
              ),
              DropdownButton(
                hint: const Text('Selelct Category'),
                items: CategoryDB.instance.expenseCategoryListListener.value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                  );
                }).toList(),
                onChanged: (selectedValue) {
                  print(selectedValue);
                },
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
