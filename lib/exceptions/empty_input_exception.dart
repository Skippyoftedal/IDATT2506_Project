///Error thrown when a required input is empty
class EmptyInputError extends ArgumentError {
  String cause;

  EmptyInputError(this.cause);
}


