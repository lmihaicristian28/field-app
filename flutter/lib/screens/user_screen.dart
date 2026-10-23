import 'package:flutter/material.dart';

import '../contract/contract.dart';
import '../store.dart';

// Exercise 1 — a param route: /users/:id
class UserScreen extends StatelessWidget {
  const UserScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final user = StoreScope.of(context).fixtures.users.where((u) => u.id == id).firstOrNull;
    return Scaffold(
      appBar: AppBar(title: Text(user?.name ?? 'Unknown')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user?.name ?? 'No such person.',
                style: Theme.of(context).textTheme.headlineSmall),
            Text('${user?.role == Role.admin ? 'Office (admin)' : 'Field worker'} · ${user?.email}'),
          ],
        ),
      ),
    );
  }
}