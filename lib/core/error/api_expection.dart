
class APIException{
  final String message;
  final int code;

  APIException({required this.message, required this.code});
}

class NOInternetException extends APIException{
  NOInternetException({required super.message, required super.code});

}