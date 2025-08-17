sealed class ApiState<T> {
  const ApiState();
}

class ApiInitial<T> extends ApiState<T> {
  const ApiInitial();
}

class ApiLoading<T> extends ApiState<T> {
  const ApiLoading();
}

class ApiSuccess<T> extends ApiState<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiError<T> extends ApiState<T> {
  final String message;
  const ApiError(this.message);
}
