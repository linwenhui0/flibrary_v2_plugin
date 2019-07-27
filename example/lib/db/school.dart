import 'package:flibrary_plugin/annotation/database/annotation.dart';
import 'package:flibrary_plugin/utils/Print.dart';

class School {
  int id;
  String name;
  int level;

  School({this.id, this.name, this.level});

  @override
  String toString() {
    return '{"id":$id,"name":$name,"level":$level}';
  }
}

class SchoolDatabaseTable extends DatabaseTable<School> {
  SchoolDatabaseTable()
      : super("tb_school", [
          DatabaseField("id",
              dataType: DataType.int, id: true, generatedId: true),
          DatabaseField("name"),
          DatabaseField("level", dataType: DataType.int)
        ]);

  @override
  createBean(Map<String, dynamic> map) {
    School school =
        School(id: map["id"], name: map["name"], level: map["level"]);
    Print().printNative("createBean school($school)");
    return school;
  }

  @override
  getValue(School object, String key) {
    switch (key) {
      case "id":
        return object.id;
      case "name":
        return object.name;
      case "level":
        return object.level;
    }
    return null;
  }
}
