import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/technical/Theme/app_motion.dart';
import 'package:monapp/layers/technical/Theme/widgets/staggered_appear.dart';

import '../../../support/pump_app.dart';

class DurationProbe extends StatelessWidget {
  const DurationProbe({required this.onResolved, super.key});

  final ValueChanged<Duration> onResolved;

  @override
  Widget build(BuildContext context) {
    onResolved(AppMotion.resolve(context, AppMotion.standard));

    return const SizedBox.shrink();
  }
}

void main() {
  testWidgets('resolve renvoie la durée donnée par défaut', (tester) async {
    late Duration resolved;

    await pumpApp(
      tester,
      DurationProbe(onResolved: (value) => resolved = value),
    );

    expect(resolved, AppMotion.standard);
  });

  testWidgets('resolve renvoie zéro si les animations sont réduites',
      (tester) async {
    late Duration resolved;

    await pumpApp(
      tester,
      DurationProbe(onResolved: (value) => resolved = value),
      disableAnimations: true,
    );

    expect(resolved, Duration.zero);
  });

  testWidgets('apparition échelonnée rend l élément visible', (tester) async {
    await pumpApp(
      tester,
      const StaggeredAppear(index: 3, child: Text('contenu')),
    );

    expect(find.text('contenu'), findsOneWidget);
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
  });

  testWidgets('apparition échelonnée commence transparente', (tester) async {
    await pumpApp(
      tester,
      const StaggeredAppear(index: 0, child: Text('contenu')),
      settle: false,
    );

    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, lessThan(1));

    await tester.pumpAndSettle();
  });

  testWidgets('sans animation, l élément apparaît sans transition',
      (tester) async {
    await pumpApp(
      tester,
      const StaggeredAppear(index: 0, child: Text('contenu')),
      disableAnimations: true,
      settle: false,
    );

    expect(find.text('contenu'), findsOneWidget);
    expect(find.byType(Opacity), findsNothing);
  });
}
