import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../technical/Injection/injection.dart';
import '../../../technical/Theme/app_motion.dart';
import '../../../technical/Theme/app_palette.dart';
import 'cubit/constellation_cubit.dart';
import 'cubit/constellation_state.dart';
import 'widgets/constellation_body.dart';
import 'widgets/night_sky_background.dart';

class ConstellationPage extends StatelessWidget {
  const ConstellationPage({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(context).push(
    PageRouteBuilder<void>(
      transitionDuration: AppMotion.resolve(context, AppMotion.standard),
      reverseTransitionDuration: AppMotion.resolve(context, AppMotion.standard),
      pageBuilder: (_, _, _) => const ConstellationPage(),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ConstellationCubit>()..load(),
      child: const ConstellationScaffold(),
    );
  }
}

class ConstellationScaffold extends StatelessWidget {
  const ConstellationScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ConstellationCubit>();

    return Scaffold(
      backgroundColor: AppPalette.of(context).nebula,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const NightSkyBackground(),
          BlocBuilder<ConstellationCubit, ConstellationState>(
            builder: (context, state) => ConstellationBody(
              state: state,
              cubit: cubit,
              onBack: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}
