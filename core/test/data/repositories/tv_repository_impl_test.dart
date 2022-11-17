import 'dart:io';

import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:core/data/models/season_model.dart';
import 'package:core/data/models/tv_detail_model.dart';
import 'package:core/data/models/tv_genre_model.dart';
import 'package:core/data/models/tv_model.dart';
import 'package:core/data/repositories/tv_repo_impl.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_data.dart';
import '../../helpers/core_helper.mocks.dart';

void main() {
  late TvRepositorysitoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    repository = TvRepositorysitoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvTable = TvTable(
      backdropPath: '/jeP3It0ZPY3SKW3632qwLkkIZv3.jpg',
      genreIds: [80, 18],
      id: 32568,
      originalName: 'Till Death Us Do Part',
      overview:
          "Following the chronicles of the East End working-class Garnett family, headed by patriarch Alf Garnett, a reactionary working-class man who holds racist and anti-socialist views.",
      popularity: 5.455,
      posterPath: '/reEMJA1uzscCbkpeRJeTT2bjqUp.jpg',
      firstAirDate: '2017-05-02',
      name: 'Johnny Speight',
      voteAverage: 8.3,
      voteCount: 14669);

  final tTv = Tv(
      backdropPath: '/jeP3It0ZPY3SKW3632qwLkkIZv3.jpg',
      genreIds: [80, 18],
      id: 32568,
      originalName: 'Till Death Us Do Part',
      overview:
          "Following the chronicles of the East End working-class Garnett family, headed by patriarch Alf Garnett, a reactionary working-class man who holds racist and anti-socialist views.",
      popularity: 5.455,
      posterPath: '/reEMJA1uzscCbkpeRJeTT2bjqUp.jpg',
      firstAirDate: '2017-05-02',
      name: 'Johnny Speight',
      voteAverage: 8.3,
      voteCount: 14669);

  final tTvTableList = <TvTable>[tTvTable];
  final tTvList = <Tv>[tTv];

  group('Now Playing TV Series', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getOnAiringTv())
          .thenAnswer((_) async => tTvTableList);
      // act
      final result = await repository.getOnAirTv();
      // assert
      verify(mockRemoteDataSource.getOnAiringTv());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getOnAiringTv()).thenThrow(ServerException());
      // act
      final result = await repository.getOnAirTv();
      // assert
      verify(mockRemoteDataSource.getOnAiringTv());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getOnAiringTv())
          .thenThrow(SocketException('Gagal terhubung ke jaringan'));
      // act
      final result = await repository.getOnAirTv();
      // assert
      verify(mockRemoteDataSource.getOnAiringTv());
      expect(result,
          equals(Left(ConnectionFailure('Gagal terhubung ke jaringan'))));
    });
  });

  group('Popular TV Series', () {
    test('should return TV Serieslist when call to data source is success',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTv())
          .thenAnswer((_) async => tTvTableList);
      // act
      final result = await repository.getPopularTv();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTv()).thenThrow(ServerException());
      // act
      final result = await repository.getPopularTv();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTv())
          .thenThrow(SocketException('Gagal terhubung ke jaringan'));
      // act
      final result = await repository.getPopularTv();
      // assert
      expect(result, Left(ConnectionFailure('Gagal terhubung ke jaringan')));
    });
  });

  group('Top Rated TV Series', () {
    test('should return TV Serieslist when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTv())
          .thenAnswer((_) async => tTvTableList);
      // act
      final result = await repository.getTopRatedTv();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTv()).thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTv();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTv())
          .thenThrow(SocketException('Gagal terhubung ke jaringan'));
      // act
      final result = await repository.getTopRatedTv();
      // assert
      expect(result, Left(ConnectionFailure('Gagal terhubung ke jaringan')));
    });
  });

  group('Get TV Series Detail', () {
    final tId = 1;
    final tTvResponse = TvDetailailResponse(
      backdropPath: 'backdropPath',
      genres: [TvGenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      originalLanguage: 'en',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      status: 'Status',
      tagline: 'Tagline',
      name: 'name',
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      voteAverage: 1,
      voteCount: 1,
      seasons: [
        SeasonModel(
          id: 1,
          name: 'Season 1',
          episodeCount: 1,
          posterPath: 'posterPath',
        )
      ],
    );

    test(
        'should return TV Series data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetailail(tId))
          .thenAnswer((_) async => tTvResponse);
      // act
      final result = await repository.getTvDetailail(tId);
      // assert
      verify(mockRemoteDataSource.getTvDetailail(tId));
      expect(result, equals(Right(testTvDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetailail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvDetailail(tId);
      // assert
      verify(mockRemoteDataSource.getTvDetailail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetailail(tId))
          .thenThrow(SocketException('Gagal terhubung ke jaringan'));
      // act
      final result = await repository.getTvDetailail(tId);
      // assert
      verify(mockRemoteDataSource.getTvDetailail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Gagal terhubung ke jaringan'))));
    });
  });

  group('Get TV Series Recommendations', () {
    final tTvList = <TvTable>[];
    final tId = 1;

    test('should return data (TV Serieslist) when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenAnswer((_) async => tTvList);
      // act
      final result = await repository.getTvRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvRecommendations(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenThrow(SocketException('Gagal terhubung ke jaringan'));
      // act
      final result = await repository.getTvRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Gagal terhubung ke jaringan'))));
    });
  });

  group('Seach TV Series', () {
    final tQuery = 'spiderman';

    test('should return TV Serieslist when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTv(tQuery))
          .thenAnswer((_) async => tTvTableList);
      // act
      final result = await repository.searchTv(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTv(tQuery)).thenThrow(ServerException());
      // act
      final result = await repository.searchTv(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTv(tQuery))
          .thenThrow(SocketException('Gagal terhubung ke jaringan'));
      // act
      final result = await repository.searchTv(tQuery);
      // assert
      expect(result, Left(ConnectionFailure('Gagal terhubung ke jaringan')));
    });
  });

  // group('save watchlist', () {
  //   test('should return success message when saving successful', () async {
  //     // arrange
  //     when(mockLocalDataSource.insertWatchlist(testTvTable))
  //         .thenAnswer((_) async => 'Added to Watchlist');
  //     // act
  //     final result = await repository.saveWatchlist(testTvDetailail);
  //     // assert
  //     expect(result, Right('Added to Watchlist'));
  //   });

  //   test('should return DatabaseFailure when saving unsuccessful', () async {
  //     // arrange
  //     when(mockLocalDataSource.insertWatchlist(testTvTable))
  //         .thenThrow(DatabaseException('Failed to add watchlist'));
  //     // act
  //     final result = await repository.saveWatchlist(testTvDetailail);
  //     // assert
  //     expect(result, Left(DatabaseFailure('Failed to add watchlist')));
  //   });
  // });

  // group('remove watchlist', () {
  //   test('should return success message when remove successful', () async {
  //     // arrange
  //     when(mockLocalDataSource.removeWatchlist(testTvTable))
  //         .thenAnswer((_) async => 'Removed from watchlist');
  //     // act
  //     final result = await repository.removeWatchlist(testTvDetailail);
  //     // assert
  //     expect(result, Right('Removed from watchlist'));
  //   });

  //   test('should return DatabaseFailure when remove unsuccessful', () async {
  //     // arrange
  //     when(mockLocalDataSource.removeWatchlist(testTvTable))
  //         .thenThrow(DatabaseException('Failed to remove watchlist'));
  //     // act
  //     final result = await repository.removeWatchlist(testTvDetailail);
  //     // assert
  //     expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
  //   });
  // });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist TV Series', () {
    test('should return list of TV Series', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTvTable]);
      // act
      final result = await repository.getWatchlistTv();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });
}
