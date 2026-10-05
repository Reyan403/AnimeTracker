import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Constellation/domain/entities/constellation.dart';
import 'package:monapp/layers/functional/Constellation/presentation/cubit/constellation_cubit.dart';
import 'package:monapp/layers/functional/Constellation/presentation/cubit/constellation_state.dart';

import 'ui_support.dart';

void main() {
  late StreamController<Constellation> controller;
  late ConstellationCubit cubit;

  setUp(() {
    controller = StreamController<Constellation>();
    cubit = ConstellationCubit(FakeBuildConstellation(() => controller.stream));
  });

  tearDown(() async {
    await cubit.close();
    unawaited(controller.close());
  });

  Future<void> emit(Constellation constellation) async {
    controller.add(constellation);
    await Future<void>.delayed(Duration.zero);
  }

  test('démarre en chargement', () {
    expect(cubit.state.status, ConstellationStatus.loading);
  });

  test('passe en succès quand des étoiles arrivent', () async {
    await cubit.load();
    await emit(sampleConstellation);

    expect(cubit.state.status, ConstellationStatus.success);
    expect(cubit.state.constellation, sampleConstellation);
  });

  test('passe en vide quand la liste ne contient aucune étoile', () async {
    await cubit.load();
    await emit(emptyConstellation);

    expect(cubit.state.status, ConstellationStatus.empty);
  });

  test('passe en échec sur erreur du flux', () async {
    await cubit.load();
    controller.addError(Exception('boom'));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, ConstellationStatus.failure);
  });

  test('select retient l étoile et la retrouve', () async {
    await cubit.load();
    await emit(sampleConstellation);

    cubit.select(2);

    expect(cubit.state.selectedStarId, 2);
    expect(cubit.state.selectedStar?.title, 'Étoile en cours');
    expect(cubit.state.linkCountOf(2), 2);
    expect(cubit.state.linkCountOf(3), 1);

    cubit.select(null);

    expect(cubit.state.selectedStar, isNull);
  });

  test('select est ignoré hors succès', () async {
    cubit.select(1);

    expect(cubit.state.selectedStarId, isNull);
  });

  test('filterByGenre retient le genre et peut le retirer', () async {
    await cubit.load();
    await emit(sampleConstellation);

    cubit.filterByGenre('action');
    expect(cubit.state.genreSlug, 'action');

    cubit.filterByGenre(null);
    expect(cubit.state.genreSlug, isNull);
  });

  test('filterByGenre est ignoré hors succès', () {
    cubit.filterByGenre('action');

    expect(cubit.state.genreSlug, isNull);
  });

  test('garde la sélection quand le flux réémet la même étoile', () async {
    await cubit.load();
    await emit(sampleConstellation);
    cubit.select(1);
    await emit(sampleConstellation);

    expect(cubit.state.selectedStarId, 1);
  });

  test('perd la sélection quand l étoile disparaît', () async {
    await cubit.load();
    await emit(sampleConstellation);
    cubit.select(1);
    await emit(
      Constellation(
        stars: [sampleConstellation.stars[1]],
        links: const [],
        genres: sampleConstellation.genres,
      ),
    );

    expect(cubit.state.selectedStarId, isNull);
  });

  test('load relance le chargement', () async {
    await cubit.load();
    await emit(sampleConstellation);
    controller = StreamController<Constellation>();

    await cubit.load();

    expect(cubit.state.status, ConstellationStatus.loading);
  });
}
