import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/tv_bloc.dart';
import 'package:tv/presentation/page/tv_detail_page.dart';

import '../../dummy_data/dummy_data.dart';
import '../../test_helper_tv_bloc_.dart';

void main() {
  late TvSeriesDetailBlocHelper TvDetailailBlocHelper;
  late TvSeriesRecommendationBlocHelper recommendationsTvBlocHelper;
  late WatchlistTvSeriesBlocHelper watchlistTvBlocHelper;

  setUpAll(() {
    TvDetailailBlocHelper = TvSeriesDetailBlocHelper();
    registerFallbackValue(TvSeriesDetailEventHelper());
    registerFallbackValue(TvSeriesDetailStateHelper());

    recommendationsTvBlocHelper = TvSeriesRecommendationBlocHelper();
    registerFallbackValue(TvSeriesRecommendationEventBlocHelper());
    registerFallbackValue(TvSeriesRecommendationStateHelper());

    watchlistTvBlocHelper = WatchlistTvSeriesBlocHelper();
    registerFallbackValue(WatchlistTvSeriesEventBlocHelper());
    registerFallbackValue(WatchlistTvSeriesStateHelper());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvSeriesDetailBloc>(create: (_) => TvDetailailBlocHelper),
        BlocProvider<WatchlistTvSeriesBloc>(
          create: (_) => watchlistTvBlocHelper,
        ),
        BlocProvider<TvSeriesRecommendationBloc>(
          create: (_) => recommendationsTvBlocHelper,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => TvDetailailBlocHelper.state).thenReturn(TvSeriesLoading());
    when(() => watchlistTvBlocHelper.state).thenReturn(TvSeriesLoading());
    when(() => recommendationsTvBlocHelper.state).thenReturn(TvSeriesLoading());

    final circularProgress = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(TvDetailailPage(
      id: 1,
    )));
    await tester.pump();

    expect(circularProgress, findsOneWidget);
  });
  testWidgets(
      'Watchlist button should display + icon when movie not added to watch list',
      (WidgetTester tester) async {
    when(() => TvDetailailBlocHelper.state)
        .thenReturn(TvSeriesDetailState(testTvDetail));
    when(() => recommendationsTvBlocHelper.state)
        .thenReturn(TvSeriesHasData(testTvList));
    when(() => watchlistTvBlocHelper.state)
        .thenReturn(WatchlistTvSeriesStatusState(false));

    final watchListButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailailPage(id: 97080)));
    await tester.pump();
    expect(watchListButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie added to watch list',
      (WidgetTester tester) async {
    when(() => TvDetailailBlocHelper.state)
        .thenReturn(TvSeriesDetailState(testTvDetail));

    when(() => recommendationsTvBlocHelper.state)
        .thenReturn(TvSeriesHasData(testTvList));
    when(() => watchlistTvBlocHelper.state)
        .thenReturn(WatchlistTvSeriesStatusState(true));

    final watchListButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailailPage(id: 97080)));
    expect(watchListButtonIcon, findsOneWidget);
  });
}
