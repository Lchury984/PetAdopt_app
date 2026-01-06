/// Clase para encapsular resultados de la API
class ApiResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  ApiResult({
    this.data,
    this.error,
    required this.isSuccess,
  });

  factory ApiResult.success(T data) {
    return ApiResult(
      data: data,
      error: null,
      isSuccess: true,
    );
  }

  factory ApiResult.failure(String error) {
    return ApiResult(
      data: null,
      error: error,
      isSuccess: false,
    );
  }
}
