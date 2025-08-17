import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:latlong2/latlong.dart' as latlng;
import 'dart:async';

import '../../../../data/models/story_model.dart';
import '../../../../core/config/app_config.dart';
import '../../../../l10n/app_localizations.dart';

class StoryDetailPage extends StatelessWidget {
  final Story story;

  const StoryDetailPage({
    super.key,
    required this.story,
  });

  Future<String> _getAddressFromLatLng(
      double lat, double lon, BuildContext context) async {
    try {
      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';
      }

      if (!context.mounted) {
        return "Address information unavailable";
      }

      final l10n = AppLocalizations.of(context)!;
      return l10n.addressNotAvailable;
    } catch (e) {
      if (!context.mounted) {
        return "Error fetching address";
      }

      final l10n = AppLocalizations.of(context)!;
      return l10n.addressNotAvailable;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Set<Marker> markers = {};
    LatLng? storyLocation;

    if (story.lat != null && story.lon != null) {
      storyLocation = LatLng(story.lat!, story.lon!);
      markers.add(
        Marker(
          markerId: MarkerId(story.id),
          position: storyLocation,
          infoWindow:
              InfoWindow(title: story.name, snippet: l10n.storyLocation),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'story-${story.id}',
                child: CachedNetworkImage(
                  imageUrl: story.photoUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.error,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          story.name.isNotEmpty
                              ? story.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              DateFormat('MMMM dd, yyyy • HH:mm')
                                  .format(story.createdAt),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    story.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                  ),
                  //maps
                  if (storyLocation != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: FutureBuilder<String>(
                                    future: _getAddressFromLatLng(
                                        storyLocation.latitude,
                                        storyLocation.longitude,
                                        context),
                                    builder: (context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text(l10n.loadingLocation,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium);
                                      }
                                      return Text(
                                        snapshot.data ??
                                            l10n.addressNotAvailable,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: AppConfig.hasGoogleMapsApiKey
                                ? GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                        target: storyLocation, zoom: 15),
                                    markers: markers,
                                    scrollGesturesEnabled: false,
                                    zoomGesturesEnabled: false,
                                  )
                                : IgnorePointer(
                                    ignoring: true,
                                    child: fmap.FlutterMap(
                                      options: fmap.MapOptions(
                                        initialCenter: latlng.LatLng(
                                          storyLocation.latitude,
                                          storyLocation.longitude,
                                        ),
                                        initialZoom: 15,
                                      ),
                                      children: [
                                        fmap.TileLayer(
                                          urlTemplate:
                                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                          subdomains: const ['a', 'b', 'c'],
                                          userAgentPackageName: 'flutter_story',
                                        ),
                                        fmap.MarkerLayer(
                                          markers: [
                                            fmap.Marker(
                                              width: 36,
                                              height: 36,
                                              point: latlng.LatLng(
                                                storyLocation.latitude,
                                                storyLocation.longitude,
                                              ),
                                              child: const Icon(
                                                Icons.location_on,
                                                size: 36,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
