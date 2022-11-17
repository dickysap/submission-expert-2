import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/repositories/tv_repo.dart';
import 'package:dartz/dartz.dart';

class GetOnAiringTv {
  final TvRepository repository;

  GetOnAiringTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getOnAirTv();
  }
}
