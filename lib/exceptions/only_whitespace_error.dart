///Error thrown when a required input consists of only whitespace
class OnlyWhitespaceError extends ArgumentError {
  String cause;

  OnlyWhitespaceError(this.cause);
}