import 'dart:io';
import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:core/data/datasources/tv_local_data_source.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/data/models/tv_tabel.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/repositories/tv_repo.dart';
import 'package:dartz/dartz.dart';

class TvRepositorysitoryImpl implements TvRepository {
  final TvRemoteDataSource remoteDataSource;
  final TvLocalDataSource localDataSource;

  TvRepositorysitoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Tv>>> getPopularTv() async {
    try {
      final result = await remoteDataSource.getPopularTv();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Gagal terhubung ke jaringan'));
    } on TlsException {
      return left(SSLFailure('Certificate gagal terverifikasi'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTv() async {
    try {
      final result = await remoteDataSource.getTopRatedTv();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Gagal terhubung ke jaringan'));
    } on TlsException {
      return left(SSLFailure('Certificate gagal terverifikasi'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getOnAirTv() async {
    try {
      final result = await remoteDataSource.getOnAiringTv();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Gagal terhubung ke jaringan'));
    } on TlsException {
      return left(SSLFailure('Certificate gagal terverifikasi'));
    }
  }

  @override
  Future<Either<Failure, TvDetail>> getTvDetailail(int id) async {
    try {
      final result = await remoteDataSource.getTvDetailail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Gagal terhubung ke jaringan'));
    } on TlsException {
      return left(SSLFailure('Certificate gagal terverifikasi'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendations(id) async {
    try {
      final result = await remoteDataSource.getTvRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Gagal terhubung ke jaringan'));
    } on TlsException {
      return left(SSLFailure('Certificate gagal terverifikasi'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTv(String query) async {
    try {
      final result = await remoteDataSource.searchTv(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Gagal terhubung ke jaringan'));
    } on TlsException {
      return left(SSLFailure('Certificate gagal terverifikasi'));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv) async {
    try {
      final result =
          await localDataSource.insertWatchlist(TvTable.fromEntity(tv));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail movie) async {
    try {
      final result =
          await localDataSource.removeWatchlist(TvTable.fromEntity(movie));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getTvById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<Tv>>> getWatchlistTv() async {
    final result = await localDataSource.getWatchlistTv();
    return Right(result.map((data) => data.toEntity()).toList());
  }
}
