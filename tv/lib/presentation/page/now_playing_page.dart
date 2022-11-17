import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/tv_bloc.dart';
import 'package:tv/presentation/widget/tv_card_list.dart';

class NowPlayingTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/nowplaying-tv';

  @override
  State<NowPlayingTvPage> createState() => _NowPlayingTvPageTvPageState();
}

class _NowPlayingTvPageTvPageState extends State<NowPlayingTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<OnAiringTvBloc>().add(FetchNowPlayingTvSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Tv'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<OnAiringTvBloc, TvSeriesStateBloc>(
            builder: (context, state) {
              if (state is TvSeriesLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is TvSeriesHasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final onAiringTv = state.tvSeries[index];
                    return TvCard(onAiringTv);
                  },
                  itemCount: state.tvSeries.length,
                );
              } else if (state is TvSeriesError) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return Text('No Movies :(');
              }
            },
          )),
    );
  }
}
