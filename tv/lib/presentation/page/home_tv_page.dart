import 'package:core/common/constants.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie/presentation/page/home_movie_page.dart';
import 'package:movie/presentation/page/search_page_tv.dart';
import 'package:movie/presentation/page/watchlist_movies_page.dart';
import 'package:tv/presentation/bloc/tv_bloc.dart';
import 'package:tv/presentation/page/popular_tv_page.dart';
import 'package:tv/presentation/page/top_rated_tv_page.dart';
import 'package:tv/presentation/page/tv_detail_page.dart';

import 'about_page.dart';
import 'now_playing_page.dart';
import 'watchlist_tv_page.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-show';
  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OnAiringTvBloc>().add(FetchNowPlayingTvSeries());
      context.read<PopularTvSeriesBloc>().add(FetchPopularTvSeries());
      context.read<TopRatedTvSeriesBloc>().add(FetchTopRatedTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pushNamed(context, HomeMoviePage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('Tv Show'),
              onTap: () {
                Navigator.pushNamed(context, HomeTvPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist Tv'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTvPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPageTv.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildSubHeading(
              title: 'Now Playing',
              onTap: () =>
                  Navigator.pushNamed(context, NowPlayingTvPage.ROUTE_NAME),
            ),
            BlocBuilder<OnAiringTvBloc, TvSeriesStateBloc>(
              builder: (context, state) {
                if (state is TvSeriesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TvSeriesHasData) {
                  return TvList(state.tvSeries);
                } else if (state is TvSeriesError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return Text('Failed');
                }
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME),
            ),
            BlocBuilder<PopularTvSeriesBloc, TvSeriesStateBloc>(
              builder: (context, state) {
                if (state is TvSeriesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TvSeriesHasData) {
                  return TvList(state.tvSeries);
                } else if (state is TvSeriesError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return Text('Failed');
                }
              },
            ),
            _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME)),
            BlocBuilder<TopRatedTvSeriesBloc, TvSeriesStateBloc>(
              builder: (context, state) {
                if (state is TvSeriesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TvSeriesHasData) {
                  return TvList(state.tvSeries);
                } else if (state is TvSeriesError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return Text('Failed');
                }
              },
            ),
          ]),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tvShow;

  TvList(this.tvShow);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvShow[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, TvDetailailPage.ROUTE_NAME,
                    arguments: tv.id);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvShow.length,
      ),
    );
  }
}
