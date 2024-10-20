class InputValidator{

  static void validListName(String listName){
    if (listName.isEmpty) throw ArgumentError("The name of the list cannot be empty");
    if (listName.trim().isEmpty) throw ArgumentError("The name cannot consist of only white-space");
  }







}