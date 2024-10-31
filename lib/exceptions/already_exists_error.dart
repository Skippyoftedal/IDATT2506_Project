///Error thrown when an object already exists, and a duplicate is not allowed
///in the given collection.
class AlreadyExistsError extends ArgumentError {
  String objectName;

  AlreadyExistsError(this.objectName);
  
  @override
  String toString() {
    return objectName;
  }
}