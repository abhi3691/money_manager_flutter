import 'package:flutter/material.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(10),
        itemBuilder: (ctx, index) {
          return const Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 50,
                child: Text(
                  '12\ndec',
                  textAlign: TextAlign.center,
                ),
              ),
              title: Text('RS 100000'),
              subtitle: Text('Travel'),
            ),
          );
        },
        separatorBuilder: (ctx, index) {
          return const SizedBox(height: 10);
        },
        itemCount: 10);
  }
}
