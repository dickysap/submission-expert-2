import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_data.dart';
import '../../helpers/core_helper.mocks.dart';

void main() {
  late GetTvDetailail usecase;
  late MockTvRepository mockTvRepositorysitory;

  setUp(() {
    mockTvRepositorysitory = MockTvRepository();
    usecase = GetTvDetailail(mockTvRepositorysitory);
  });

  final tId = 1;

  test('should get movie detail from the repository', () async {
    // arrange
    when(mockTvRepositorysitory.getTvDetailail(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(testTvDetail));
  });
}
