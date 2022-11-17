import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_tv_recomendations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/core_helper.mocks.dart';

void main() {
  late GetTvRecommendations usecase;
  late MockTvRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTvRepository();
    usecase = GetTvRecommendations(mockMovieRepository);
  });

  final tId = 1;
  final tTvRecommendation = <Tv>[];

  test('should get list of movie recommendations from the repository',
      () async {
    // arrange
    when(mockMovieRepository.getTvRecommendations(tId))
        .thenAnswer((_) async => Right(tTvRecommendation));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTvRecommendation));
  });
}
