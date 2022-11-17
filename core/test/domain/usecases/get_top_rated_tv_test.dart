import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/core_helper.mocks.dart';

void main() {
  late GetTopRatedTv usecase;
  late MockTvRepository mockTvRepositorysitory;

  setUp(() {
    mockTvRepositorysitory = MockTvRepository();
    usecase = GetTopRatedTv(mockTvRepositorysitory);
  });

  final tTvTopRated = <Tv>[];

  test('should get list of movies from repository', () async {
    // arrange
    when(mockTvRepositorysitory.getTopRatedTv())
        .thenAnswer((_) async => Right(tTvTopRated));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvTopRated));
  });
}
