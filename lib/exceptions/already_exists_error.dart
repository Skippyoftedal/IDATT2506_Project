class AlreadyExistsError extends ArgumentError {
  String objectName;

  AlreadyExistsError(this.objectName);
  
  @override
  String toString() {
    return objectName;
  }
}