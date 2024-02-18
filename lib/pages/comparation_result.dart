import 'dart:io';

import 'package:encryption_demo2/widgets.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ComparationResult extends StatefulWidget {
  List<Map<String, Map<String, dynamic>>> result;

  ComparationResult({Key? key, required this.result}) : super(key: key);

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
                const SizedBox(height: 50),
                TextButton(
                  child: Text('Export to Excel'),
                  onPressed: ()  async {
                    Widgets.load(dismissible: true);

                    var alphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

                    var excel = Excel.createExcel();

                    Sheet encryptionSheet = excel['Encryption'];
                    Sheet decryptionSheet = excel['Decryption'];

                    widget.result[0] = {
                      'Key Size:': {},
                      ' ${widget.result[0]['details']?['keySize'] ?? 0} Bytes.': {},
                      '': {},
                      'Message Size:': {},
                      '${widget.result[0]['details']?['messageSize'] ?? 0} Bytes.': {},
                    };

                    widget.result.insert(1, widget.result[1]);

                    for(int i = 0; i < widget.result.length; i++){
                      var rowLabel = i + 1;
                      var columnLabel = 0;
                      for(var x in widget.result[i].entries){
                        CellStyle cellStyle = CellStyle(bold: i <= 1 && !x.key.endsWith('.'), fontFamily :getFontFamily(FontFamily.Calibri));

                        encryptionSheet.cell(CellIndex.indexByString('${alphabets[columnLabel]}$rowLabel'))
                          ..value = TextCellValue(i <= 1 ? x.key.toUpperCase() : x.value['encryption'].toString().replaceAll("s", ""))
                          ..cellStyle = cellStyle;

                        decryptionSheet.cell(CellIndex.indexByString('${alphabets[columnLabel]}$rowLabel'))
                          ..value = TextCellValue(i <= 1 ? x.key.toUpperCase() : x.value['decryption'].toString().replaceAll("s", ""))
                          ..cellStyle = cellStyle;

                        columnLabel += 1;
                      }
                    }

                    var fileBytes = excel.save();
                    var directory = await getExternalStorageDirectory();

                    if( fileBytes != null && directory != null ) {
                      File("${directory.path}/export_comparison.xlsx")
                        ..createSync(recursive: true)
                        ..writeAsBytesSync(fileBytes);
                    }

                    Get.back();
                    Get.snackbar("Success", "Export completed successfully");
                  },
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}
