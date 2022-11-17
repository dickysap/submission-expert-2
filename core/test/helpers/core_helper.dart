import 'package:http/io_client.dart';
import 'package:core/common/connection.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/db/tv_db.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_local_data_source.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_repo.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  TvRepository,
  MovieRemoteDataSource,
  TvRemoteDataSource,
  MovieLocalDataSource,
  TvLocalDataSource,
  DatabaseHelper,
  TvDb,
  Connection,
], customMocks: [
  MockSpec<IOClient>(as: #MockHttpClient)
])
void main() {}
