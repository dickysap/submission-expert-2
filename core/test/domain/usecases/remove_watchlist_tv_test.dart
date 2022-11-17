import 'package:core/domain/usecases/remove_tv_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_data.dart';
import '../../helpers/core_helper.mocks.dart';

void main() {
  late RemoveTvWatchlist usecase;
  late MockTvRepository mockTvRepositorysitory;

  setUp(() {
    mockTvRepositorysitory = MockTvRepository();
    usecase = RemoveTvWatchlist(mockTvRepositorysitory);
  });

  test('should remove watchlist movie from repository', () async {
    // arrange
    when(mockTvRepositorysitory.removeWatchlist(testTvDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    verify(mockTvRepositorysitory.removeWatchlist(testTvDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
