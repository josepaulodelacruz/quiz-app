enum ErrorCode { MISSING_COLLECTION, MISSING_RESULT }

class GenericError extends Error {
  final String code;
  final String message;
  GenericError({this.code = "", this.message = ""});
}

class ApiResponseError extends GenericError {
  ApiResponseError({code, message}) : super(code: code, message: message);
}