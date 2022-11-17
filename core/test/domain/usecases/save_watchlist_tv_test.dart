import 'package:core/domain/usecases/save_tv_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_data.dart';
import '../../helpers/core_helper.mocks.dart';

void main() {
  late SaveTvWatchlist usecase;
  late MockTvRepository mockTvRepositorysitory;

  setUp(() {
    mockTvRepositorysitory = MockTvRepository();
    usecase = SaveTvWatchlist(mockTvRepositorysitory);
  });

  test('should save movie to the repository', () async {
    // arrange
    when(mockTvRepositorysitory.saveWatchlist(testTvDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    verify(mockTvRepositorysitory.saveWatchlist(testTvDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
