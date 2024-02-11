import 'package:flutter/material.dart';

class ComparationResult extends StatefulWidget {
  final List<Map<String, Map<String, dynamic>>> result;

  const ComparationResult({Key? key, required this.result}) : super(key: key);

  @override
  State<ComparationResult> createState() => _ComparationResultState();
}

class _ComparationResultState extends State<ComparationResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Key Size: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(width: 10),
                    Text('${widget.result[0]['details']?['keySize'] * 8}bits', style: TextStyle(fontSize: 18)),

                    const SizedBox(width: 30),
                    Text(' Message Size: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(width: 10),
                    Text('${widget.result[0]['details']?['messageSize'] * 8}bits', style: TextStyle(fontSize: 18)),
                  ]
                ),
                const SizedBox(height: 15),
                DataTable(
                  columns: widget.result[1].entries.map((e) {
                    return DataColumn(label: Text(
                        e.key.toUpperCase(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                    ));
                  }).toList()..insert(0, DataColumn(label: Text(
                      'Cryptography',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ))),
                  rows: List.generate((widget.result.length - 1) * 2, (i) {
                    final isDecryption = (i % 2) != 0;
                    i = (i/2).floor() + 1;

                    if( isDecryption ) {
                      return DataRow(cells: widget.result[i].entries.map((e) {
                        return DataCell(Text(e.value['decryption'] ?? '-'));
                      }).toList()..insert(0, DataCell(Text('Decryption ($i)'))));
                    }

                    return DataRow(cells: widget.result[i].entries.map((e) {
                      return DataCell(Text(e.value['encryption'] ?? '-'));
                    }).toList()
                      ..insert(0, DataCell(Text('Encryption ($i)'))));
                  })
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
