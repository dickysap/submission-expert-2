import 'package:core/domain/usecases/get_tv_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/core_helper.mocks.dart';

void main() {
  late GetTvWatchListStatus usecase;
  late MockTvRepository mockTvRepositorysitory;

  setUp(() {
    mockTvRepositorysitory = MockTvRepository();
    usecase = GetTvWatchListStatus(mockTvRepositorysitory);
  });

  test('should get watchlist status from repository', () async {
    // arrange
    when(mockTvRepositorysitory.isAddedToWatchlist(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}
