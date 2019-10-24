import 'package:flibrary_plugin/annotation/database/annotation.dart';

class Student {
  int id;
  String name;
  bool sex;
  int age;

  Student({this.name, this.id, this.sex, this.age});
}

class StudentDatabaseTable extends DatabaseTable<Student> {
  StudentDatabaseTable()
      : super("tb_student", [
          DatabaseField("id",
              dataType: DataType.int, id: true, generatedId: true),
          DatabaseField("name"),
          DatabaseField("sex", dataType: DataType.int),
          DatabaseField("age", dataType: DataType.int)
        ]);

  @override
  createBean(Map<String, dynamic> map) {
    return Student(
        name: map["name"], id: map["id"], sex: map["sex"], age: map["age"]);
  }

  @override
  getValue(Student object, String key) {
    switch(key){
      case "name":
        return object.name;
      case "id":
        return object.id;
      case "sex":
        return object.sex;
      case "age":
        return object.age;
    }
    return null;
  }
}
