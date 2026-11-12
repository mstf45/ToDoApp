sealed class ProductResult<T> {
  const ProductResult();

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String message) onError,
  });
}

final class ProductSuccess<T> extends ProductResult<T> {
  const ProductSuccess(this.data);

  final T data;

  @override
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String message) onError,
  }) {
    return onSuccess(data);
  }
}

final class ProductFailure<T> extends ProductResult<T> {
  const ProductFailure(this.message);

  final String message;

  @override
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String message) onError,
  }) {
    return onError(message);
  }
}
