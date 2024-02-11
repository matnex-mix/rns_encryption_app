import 'package:encryption_demo2/models/user.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DB {

  static Isar? isarInstance;

  static Future<Isar> isar() async {
    if( isarInstance == null ) {
      final dir = await getApplicationDocumentsDirectory();
      isarInstance = await Isar.open(
        [UserSchema],
        directory: dir.path,
      );
    }

    return isarInstance!;
  }

}