import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:golf_live_scoring/core/services/data/data_service.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.dart';
import 'package:golf_live_scoring/ui/screens/main/main_state.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class MainCubit extends Cubit<MainState> {
  MainCubit(
    this._router,
    this._dataService,
  ) : super(MainState());

  final GolfRouter _router;
  final DataService _dataService;

  late int counter;

  Future<void> init() async {}

  @override
  Future<void> close() {
    return super.close();
  }
}