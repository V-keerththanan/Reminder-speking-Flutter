import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  final String message;
  @HiveField(1)
   DateTime time;

  TodoModel(this.message, this.time);
  Map<dynamic, dynamic> toMap() {
    return {
      time:message
    };
  }
}
