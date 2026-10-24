import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../core/campus_places.dart';
import '../theme/app_theme.dart';

/// Penanda peta yang dipakai bersama.
class MapMarkers {
  MapMarkers._();

  static Marker pickup(LatLng point) => Marker(
        point: point,
        width: 44,
        height: 44,
        child: const Icon(
          Icons.trip_origin_rounded,
          color: AppTheme.primaryLightColor,
          size: 30,
        ),
      );

  static Marker destination(LatLng point) => Marker(
        point: point,
        width: 44,
        height: 44,
        alignment: Alignment.topCenter,
        child: const Icon(
          Icons.location_on_rounded,
          color: AppTheme.errorColor,
          size: 40,
        ),
      );

  static Marker driver(LatLng point) => Marker(
        point: point,
        width: 46,
        height: 46,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.textColor, width: 2),
          ),
          child: const Icon(
            Icons.two_wheeler_rounded,
            color: AppTheme.textColor,
            size: 24,
          ),
        ),
      );
}

/// Peta OpenStreetMap.
///
/// Catatan: server tile resmi OSM ditujukan untuk pemakaian ringan. Untuk
/// rilis publik, pakai penyedia tile berbayar/sendiri.
/// Lihat https://operations.osmfoundation.org/policies/tiles/
class MojekMap extends StatefulWidget {
  const MojekMap({
    super.key,
    this.center,
    this.zoom = 15,
    this.fitPoints = const [],
    this.markers = const [],
    this.polylines = const [],
    this.interactive = true,
    this.controller,
    this.onPositionChanged,
  });

  final LatLng? center;
  final double zoom;

  /// Bila berisi 2+ titik, kamera awal menyesuaikan agar semuanya terlihat.
  final List<LatLng> fitPoints;
  final List<Marker> markers;
  final List<Polyline> polylines;
  final bool interactive;
  final MapController? controller;
  final void Function(MapCamera camera, bool hasGesture)? onPositionChanged;

  @override
  State<MojekMap> createState() => _MojekMapState();
}

class _MojekMapState extends State<MojekMap> {
  MapController? _ownController;

  MapController get _controller =>
      widget.controller ?? (_ownController ??= MapController());

  @override
  void dispose() {
    _ownController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fit = widget.fitPoints.length >= 2;

    return FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: widget.center ??
            (widget.fitPoints.isNotEmpty
                ? widget.fitPoints.first
                : CampusPlaces.center),
        initialZoom: widget.zoom,
        initialCameraFit: fit
            ? CameraFit.coordinates(
                coordinates: widget.fitPoints,
                padding: const EdgeInsets.all(56),
                maxZoom: 17,
              )
            : null,
        interactionOptions: InteractionOptions(
          flags: widget.interactive
              ? InteractiveFlag.all & ~InteractiveFlag.rotate
              : InteractiveFlag.none,
        ),
        onPositionChanged: widget.onPositionChanged == null
            ? null
            : (camera, hasGesture) =>
                widget.onPositionChanged!(camera, hasGesture),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.mojek.app',
        ),
        if (widget.polylines.isNotEmpty)
          PolylineLayer(polylines: widget.polylines),
        MarkerLayer(markers: widget.markers),
        const RichAttributionWidget(
          alignment: AttributionAlignment.bottomLeft,
          attributions: [
            TextSourceAttribution('OpenStreetMap contributors'),
          ],
        ),
      ],
    );
  }
}

Polyline routeLine(List<LatLng> points) => Polyline(
      points: points,
      strokeWidth: 5,
      color: AppTheme.primaryLightColor,
    );
