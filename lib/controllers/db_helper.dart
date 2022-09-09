import 'package:hive/hive.dart';
class DbHelper {
  
  late Box box;
  DbHelper(){
    openBox();
  }

  openBox(){
    box= Hive.box('money');
  }

  Future addData(int amount, DateTime date,String note, bool type) async{
    var value = {
      'amount':amount,
      'DateTime':date,
      'type':type,
      'note':note,   
    };
    box.add(value);
  }

  Future<Map> fetch(){
    if(box.values.isEmpty){
      return Future.value({});
    }else{
      return Future.value(box.toMap());
    }
  }
}