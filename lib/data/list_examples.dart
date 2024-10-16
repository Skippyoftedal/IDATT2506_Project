import 'package:idatt2506_project/model/todo_item.dart';
import 'package:idatt2506_project/model/todo_list.dart';
import 'package:idatt2506_project/model/user_info.dart';

TodoList getExampleList() {
  return TodoList(
    "Skole-liste",
    [
      TodoItem("gjøre lekser"),
      TodoItem("godkjenn øvinger lekser"),
      TodoItem("kjøpe tomater"),
    ],
  );
}

UserInfo getExampleUserInfo(){
  return UserInfo("Tobias");
}
