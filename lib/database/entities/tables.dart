import 'package:floor/floor.dart';

/*
@Entity(
  tableName: 'UserTable',
  primaryKeys: ['data'],
)
*/

@Entity(primaryKeys: ['id', 'data'])
class UserTable {
  final String? id;
  final String? data;
  final double? steps;
  final double? calories;
  UserTable(this.id, this.data, this.steps, this.calories);
}

@Entity(
  tableName: 'avatar',
  foreignKeys: [
    ForeignKey(
      childColumns: ['avatar_id'],
      parentColumns: ['id'],
      entity: UserTable,
    )
  ],
)
@entity
class AvatarTable {
  @PrimaryKey(autoGenerate: true)
  final int exp;

  @ColumnInfo(name: 'avatar_id')
  final String avatarId;

  AvatarTable(this.exp, this.avatarId);
}
