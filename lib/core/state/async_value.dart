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
  final T value;
  const AsyncData(this.value);
}

class AsyncError<T> extends AsyncValue<T> {
  final String message;
  const AsyncError(this.message);
}
