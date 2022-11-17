import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/repositories/tv_repo.dart';
import 'package:dartz/dartz.dart';

class GetTvDetailail {
  final TvRepository repository;

  GetTvDetailail(this.repository);

  Future<Either<Failure, TvDetail>> execute(int id) {
    return repository.getTvDetailail(id);
  }
}
