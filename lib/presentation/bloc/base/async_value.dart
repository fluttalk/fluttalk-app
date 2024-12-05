sealed class AsyncValue<T> {
  const AsyncValue();
}

class AsyncInitial<T> extends AsyncValue<T> {
  const AsyncInitial();
}

class AsyncLoading<T> extends AsyncValue<T> {
  const AsyncLoading();
}

class AsyncData<T> extends AsyncValue<T> {
  final T data;
  const AsyncData(this.data);
}

class AsyncError<T> extends AsyncValue<T> {
  final String message;
  const AsyncError(this.message);
}
