import 'package:floor/floor.dart';

@entity 
class AvatarTable {
  @PrimaryKey (autoGenerate:true)

  final String? id;

  final String? data;

  final int step;

  final int calories; 

  AvatarTable(this.id,this.data,this.step,this.calories);

}