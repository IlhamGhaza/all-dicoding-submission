import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import '../../../l10n/app_localizations.dart';
import '../../../core/utils/permission.dart';

class SelectLocationScreenOSM extends StatefulWidget {
  const SelectLocationScreenOSM({super.key});

  @override
  State<SelectLocationScreenOSM> createState() => _SelectLocationScreenOSMState();
}

class _SelectLocationScreenOSMState extends State<SelectLocationScreenOSM> {
  final MapController _mapController = MapController();
  latlng.LatLng? _selectedLocation;
  String _selectedAddress = '';
  final List<Marker> _markers = [];

  static const latlng.LatLng _kInitialCenter = latlng.LatLng(-6.200000, 106.816666);
  static const double _kInitialZoom = 12.0;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    final l10n = AppLocalizations.of(context)!;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addressNotAvailable)),
      );
      return;
    }

    try {
      bool permissionGranted = await checkLocationPermission();
      if (!permissionGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.addressNotAvailable)),
          );
        }
        return;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error granting location permission: $e')),
        );
      }
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      final current = latlng.LatLng(position.latitude, position.longitude);
      _mapController.move(current, 15.0);
      _onMapTap(current);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting current location: $e')),
      );
    }
  }

  Future<void> _onMapTap(latlng.LatLng position) async {
    setState(() {
      _selectedLocation = position;
      _markers
        ..clear()
        ..add(
          Marker(
            width: 40,
            height: 40,
            point: position,
            child: const Icon(Icons.location_on, size: 40, color: Colors.red),
          ),
        );
    });

    try {
      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() {
          _selectedAddress = '${p.street ?? ''}, ${p.subLocality ?? ''}, ${p.locality ?? ''}, ${p.postalCode ?? ''}, ${p.country ?? ''}'
              .replaceAll(RegExp(r'^, |, $'), '')
              .replaceAll(RegExp(r', ,'), ',');
        });
      }
    } catch (_) {
      setState(() {
        _selectedAddress = AppLocalizations.of(context)!.addressNotAvailable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectLocation),
        actions: [
          if (_selectedLocation != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                final sel = _selectedLocation!;
                // Return google_maps_flutter.LatLng to keep existing callers unchanged
                context.pop(gmaps.LatLng(sel.latitude, sel.longitude));
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _kInitialCenter,
              initialZoom: _kInitialZoom,
              onTap: (tapPosition, point) => _onMapTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'flutter_story',
              ),
              MarkerLayer(markers: _markers),
            ],
          ),
          if (_selectedLocation != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.selectedLocation,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, Lon: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                      ),
                      if (_selectedAddress.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          _selectedAddress,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final sel = _selectedLocation!;
                            context.pop(gmaps.LatLng(sel.latitude, sel.longitude));
                          },
                          child: Text(l10n.confirmLocation),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
