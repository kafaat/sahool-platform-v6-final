import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

typedef Result<T> = Either<Failure, T>;
typedef FutureResult<T> = Future<Result<T>>;
typedef VoidResult = Result<Unit>;
typedef FutureVoidResult = FutureResult<Unit>;

extension ResultX<T> on Result<T> {
  T? get valueOrNull => fold((l) => null, (r) => r);
  Failure? get failureOrNull => fold((l) => l, (r) => null);
  bool get isSuccess => isRight();
  bool get isFailure => isLeft();

  R when<R>({
    required R Function(Failure failure) failure,
    required R Function(T value) success,
  }) => fold(failure, success);

  T getOrElse(T defaultValue) => fold((_) => defaultValue, (r) => r);
}

Result<T> success<T>(T value) => Right(value);
Result<T> failure<T>(Failure f) => Left(f);
VoidResult successVoid() => Right(unit);
