import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/search_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/core_helper.mocks.dart';

void main() {
  late SearchTv usecase;
  late MockTvRepository mockTvRepositorysitory;

  setUp(() {
    mockTvRepositorysitory = MockTvRepository();
    usecase = SearchTv(mockTvRepositorysitory);
  });

  final tTvSearch = <Tv>[];
  final tQuery = 'Spiderman';

  test('should get list of movies from the repository', () async {
    // arrange
    when(mockTvRepositorysitory.searchTv(tQuery))
        .thenAnswer((_) async => Right(tTvSearch));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTvSearch));
  });
}
