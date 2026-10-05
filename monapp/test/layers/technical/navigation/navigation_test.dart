import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/technical/Navigation/app_destination.dart';
import 'package:monapp/layers/technical/Navigation/app_navigation_bar.dart';
import 'package:monapp/layers/technical/Navigation/app_navigation_rail.dart';

import '../../../support/pump_app.dart';

void main() {
  testWidgets('la barre marque la destination sélectionnée', (tester) async {
    AppDestination? tapped;

    await pumpApp(
      tester,
      Align(
        alignment: Alignment.bottomCenter,
        child: AppNavigationBar(
          selected: AppDestination.watchlist,
          onSelected: (destination) => tapped = destination,
        ),
      ),
    );

    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      AppDestination.watchlist.index,
    );

    await tester.tap(find.text('Catalogue'));

    expect(tapped, AppDestination.catalogue);
  });

  testWidgets('le rail propose les mêmes destinations', (tester) async {
    AppDestination? tapped;

    await pumpApp(
      tester,
      AppNavigationRail(
        selected: AppDestination.catalogue,
        onSelected: (destination) => tapped = destination,
      ),
      size: const Size(1000, 800),
    );

    expect(find.text('Liste'), findsOneWidget);

    await tester.tap(find.text('Liste'));

    expect(tapped, AppDestination.watchlist);
  });
}
