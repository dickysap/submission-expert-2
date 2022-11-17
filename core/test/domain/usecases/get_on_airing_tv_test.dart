import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_tv_on_airing.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/core_helper.mocks.dart';

void main() {
  late GetOnAiringTv usecase;
  late MockTvRepository mockTvRepositorysitory;

  setUp(() {
    mockTvRepositorysitory = MockTvRepository();
    usecase = GetOnAiringTv(mockTvRepositorysitory);
  });

  final tTv = <Tv>[];

  test('should get list of movies from the repository', () async {
    // arrange
    when(mockTvRepositorysitory.getOnAirTv())
        .thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTv));
  });
}
