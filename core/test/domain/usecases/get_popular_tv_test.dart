import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/core_helper.mocks.dart';

void main() {
  late GetPopularTv usecase;
  late MockTvRepository mockTvRepositorysitory;

  setUp(() {
    mockTvRepositorysitory = MockTvRepository();
    usecase = GetPopularTv(mockTvRepositorysitory);
  });

  final tPopularTv = <Tv>[];

  group('GetPopularMovies Tests', () {
    group('execute', () {
      test(
          'should get list of movies from the repository when execute function is called',
          () async {
        // arrange
        when(mockTvRepositorysitory.getPopularTv())
            .thenAnswer((_) async => Right(tPopularTv));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(tPopularTv));
      });
    });
  });
}
