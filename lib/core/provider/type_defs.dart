import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/provider/failure.dart';

typedef FutureEith<T> = Future<Either<Faiture, T>>;
typedef FutureVoid = FutureEith<void>;
