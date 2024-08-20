import 'Status.dart';

class ApiResponse<T> {
  Status status;
  T? data;          // Nullable data, which allows null values
  String? message;  // Nullable message

  ApiResponse(this.status, this.message, this.data);

  // Constructor for loading state
  ApiResponse.loading() : status = Status.LOADING;

  // Constructor for completed state
  ApiResponse.completed(T data)
      : status = Status.COMPLETED,
        data = data;

  // Constructor for error state
  ApiResponse.error(String message)
      : status = Status.ERROR,
        message = message;

  @override
  String toString() {
    return "Status : $status \nMessage : $message \nData : $data";
  }
}
