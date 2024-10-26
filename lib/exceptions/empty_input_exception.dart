import 'dart:core';

class EmptyInputError extends ArgumentError {
  String cause;

  EmptyInputError(this.cause);
}


