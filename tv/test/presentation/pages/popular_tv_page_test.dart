import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/tv_bloc.dart';
import 'package:tv/presentation/page/popular_tv_page.dart';

import '../../dummy_data/dummy_data.dart';
import '../../test_helper_tv_bloc_.dart';

void main() {
  late PopularTvSeriesBlocHelper popularTvBlocHelper;
  setUpAll(() {
    popularTvBlocHelper = PopularTvSeriesBlocHelper();
    registerFallbackValue(PopularTvSeriesStateHelper());
    registerFallbackValue(PopularTvSeriesEventBlocHelper());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesBloc>(
      create: (_) => popularTvBlocHelper,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    popularTvBlocHelper.close();
  });

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => popularTvBlocHelper.state).thenReturn(TvSeriesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => popularTvBlocHelper.state).thenReturn(TvSeriesLoading());
    when(() => popularTvBlocHelper.state)
        .thenReturn(TvSeriesHasData(testTvList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

    expect(listViewFinder, findsOneWidget);
  });
}
