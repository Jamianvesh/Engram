import 'package:flutter/material.dart';

import 'units_page.dart';

class RepositoryPage extends StatelessWidget {
  const RepositoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 12,
      itemBuilder: (context, index) {
        int classNumber = index + 1;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: ListTile(
            title: Text(
              "Class $classNumber",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UnitsPage(classNumber: classNumber),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
