import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../booster/booster_page.dart';
import '../cubit/dex_cubit.dart';

abstract final class BoosterLauncher {
  static Future<void> open(BuildContext context) async {
    final cubit = context.read<DexCubit>();

    await BoosterPage.open(context);
    cubit.load();
  }
}
