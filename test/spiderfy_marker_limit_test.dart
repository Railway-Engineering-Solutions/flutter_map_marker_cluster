import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  for (final zoomToBounds in [false, true]) {
    for (final limit in [0, 2, 3]) {
      testWidgets('three markers, limit $limit, zoomToBounds $zoomToBounds',
          (tester) async {
        const center = LatLng(0, 0);
        await tester.pumpWidget(MaterialApp(
          home: FlutterMap(
            options: const MapOptions(
              initialCenter: center,
              initialZoom: 18,
              maxZoom: 18,
            ),
            children: [
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  markers: [
                    for (var i = 0; i < 3; i++)
                      Marker(
                        point: center,
                        child: SizedBox(key: ValueKey('marker-$i')),
                      ),
                  ],
                  maxZoom: 18,
                  zoomToBoundsOnClick: zoomToBounds,
                  disableSpiderfyAboveMarkerCount: limit,
                  animationsOptions: const AnimationsOptions(
                    spiderfy: Duration.zero,
                    fitBound: Duration.zero,
                  ),
                  builder: (_, markers) => Text(
                    '${markers.length}',
                    key: const ValueKey('cluster'),
                  ),
                ),
              ),
            ],
          ),
        ));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('marker-0')), findsNothing);
        await tester.tap(find.byKey(const ValueKey('cluster')));
        await tester.pumpAndSettle();
        for (var i = 0; i < 3; i++) {
          expect(find.byKey(ValueKey('marker-$i')),
              limit == 2 ? findsNothing : findsOneWidget);
        }
      });
    }
  }
}
