import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../contract/contract.dart';
import '../store.dart';
import 'status_chip.dart';

// OpenStreetMap's public tiles, weeks 2–4. Week 5 swaps this one constant for
// the course's own Bucharest tiles.
const tiles = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const bucharest = LatLng(44.4355, 26.1025);

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _selected; // Exercise 4: the first tap selects, the second opens

  @override
  Widget build(BuildContext context) {
    final entrances = StoreScope.of(context).entrances;
    final done =
        entrances.where((e) => e.surveyStatus != SurveyStatus.not_started).length;
    return Stack(
      children: [
        FlutterMap(
          options: const MapOptions(initialCenter: bucharest, initialZoom: 13),
          children: [
            TileLayer(
              urlTemplate: tiles,
              // OSM's policy: a distinct User-Agent. flutter_map builds it
              // from this package name.
              userAgentPackageName: 'ro.rau.field_app',
            ),
            MarkerLayer(
              markers: [
                for (final e in entrances)
                  Marker(
                    point: LatLng(e.correctedLat ?? e.lat, e.correctedLng ?? e.lng),
                    width: 44,
                    height: 44,
                    child: Semantics(
                      button: true,
                      label: '${e.street} ${e.number}, ${e.entranceName}',
                      child: GestureDetector(
                        onTap: () => _selected == e.id
                            ? context.push('/entrances/${e.id}')
                            : setState(() => _selected = e.id),
                        // Exercise 4 — an implicit animation: change the size,
                        // AnimatedContainer tweens to it.
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            width: _selected == e.id ? 34 : 22,
                            height: _selected == e.id ? 34 : 22,
                            decoration: BoxDecoration(
                              color: statusColor[e.surveyStatus],
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SimpleAttributionWidget(source: Text('OpenStreetMap contributors')),
          ],
        ),
        // No app bar on this tab: SafeArea keeps the banner clear of the notch.
        SafeArea(
          // Align, not Center: a Stack's child may be as big as the Stack,
          // and Center would stretch the card over the whole map.
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text('${entrances.length} entrances · $done surveyed',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}