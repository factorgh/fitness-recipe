import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:voltican_fitness/utils/sqflite_setup/database_helpers.dart';

class MyTbApp extends StatelessWidget {
  final Future<Database> database;

  const MyTbApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('SQLite Tables and Content')),
        body: TableContentViewer(database: database),
      ),
    );
  }
}

class TableContentViewer extends StatefulWidget {
  final Future<Database> database;

  const TableContentViewer({super.key, required this.database});

  @override
  _TableContentViewerState createState() => _TableContentViewerState();
}

class _TableContentViewerState extends State<TableContentViewer> {
  late Future<List<String>> _tableNames;
  late Future<Map<String, List<Map<String, dynamic>>>> _tableContents;

  @override
  void initState() {
    super.initState();
    _tableNames = DatabaseHelper().getTableNames();
    _tableContents = _loadTableContents();
  }

  Future<Map<String, List<Map<String, dynamic>>>> _loadTableContents() async {
    final tableNames = await _tableNames;
    final contents = <String, List<Map<String, dynamic>>>{};

    for (final tableName in tableNames) {
      contents[tableName] = await DatabaseHelper().getTableContent(tableName);
    }

    return contents;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
      future: _tableContents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        final tableContents = snapshot.data!;

        return ListView(
          children: tableContents.entries.map((entry) {
            final tableName = entry.key;
            final rows = entry.value;

            return ExpansionTile(
              title: Text(tableName),
              children: rows.map((row) {
                return ListTile(
                  title: Text(row.toString()),
                );
              }).toList(),
            );
          }).toList(),
        );
      },
    );
  }
}
