import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nyetam/app.dart';
import 'package:nyetam/domain/cameroon_region.dart';
import 'package:nyetam/domain/place.dart';
import 'package:nyetam/presentation/culture_controller.dart';
import 'package:nyetam/presentation/culture_page.dart';
import 'package:nyetam/presentation/cameroon_map.dart';
import 'package:nyetam/presentation/events_controller.dart';
import 'package:nyetam/presentation/events_page.dart';
import 'package:nyetam/presentation/explore_controller.dart';
import 'package:nyetam/presentation/google_map_canvas.dart';
import 'package:nyetam/presentation/region_explorer_page.dart';
import 'package:nyetam/presentation/place_image.dart';
import 'package:nyetam/presentation/reviews_controller.dart';
import 'package:nyetam/presentation/reviews_scope.dart';
import 'package:nyetam/presentation/reviews_section.dart';
import 'package:nyetam/presentation/real_map_canvas.dart';
import 'package:nyetam/services/directions_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as tile_map;

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.controller,
    required this.cultureController,
    required this.eventsController,
  });

  final ExploreController controller;
  final CultureController cultureController;
  final EventsController eventsController;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.load();
    widget.cultureController.load();
    widget.eventsController.load();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DiscoverView(
        controller: widget.controller,
        cultureController: widget.cultureController,
        eventsController: widget.eventsController,
      ),
      MapView(controller: widget.controller),
      TripView(
        controller: widget.controller,
        eventsController: widget.eventsController,
      ),
      SavedView(controller: widget.controller),
    ];
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _index, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.moss.withValues(alpha: .55),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: 'My trip',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}

class DiscoverView extends StatelessWidget {
  const DiscoverView({
    super.key,
    required this.controller,
    required this.cultureController,
    required this.eventsController,
  });
  final ExploreController controller;
  final CultureController cultureController;
  final EventsController eventsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _DiscoverHeader(controller: controller)),
          SliverToBoxAdapter(child: _CategoryRail(controller: controller)),
          SliverToBoxAdapter(
            child: _SectionHeading(
              title: controller.query.isNotEmpty
                  ? 'Results for “${controller.query}”'
                  : controller.region != null
                  ? controller.category == null
                        ? '${controller.region} destinations'
                        : '${controller.region} · ${controller.category!.label}'
                  : controller.category?.label ?? 'Near you',
              action: '${controller.visiblePlaces.length} places',
            ),
          ),
          if (controller.isLoading)
            const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (controller.visiblePlaces.isEmpty)
            const SliverToBoxAdapter(
              child: _EmptyState(
                icon: Icons.search_off,
                title: 'No matches here',
                message: 'Try another city, category or search term.',
              ),
            )
          else
            SliverToBoxAdapter(
              child: SizedBox(
                height: 292,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.visiblePlaces.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => PlaceCard(
                    place: controller.visiblePlaces[index],
                    controller: controller,
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: UpcomingEventsRail(controller: eventsController),
          ),
          SliverToBoxAdapter(child: _RegionRail(controller: controller)),
          SliverToBoxAdapter(
            child: _CultureFeature(controller: cultureController),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _DiscoverHeader extends StatelessWidget {
  const _DiscoverHeader({required this.controller});
  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.forest,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'images/mboa_nav_logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MBOA NAV',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.6,
                      ),
                    ),
                    Text(
                      'Explore Cameroon',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Notifications',
                onPressed: () {},
                icon: const Icon(Icons.notifications_none),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Where will Cameroon\ntake you today?',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 18),
          TextField(
            onChanged: controller.search,
            decoration: const InputDecoration(
              hintText: 'Try “beaches near Limbe”',
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.tune),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.my_location, size: 16, color: AppColors.forest),
              const SizedBox(width: 6),
              Text(
                controller.currentLocation == null
                    ? 'Browsing Cameroon'
                    : _formatCoordinates(controller.currentLocation),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 6),
              Text(
                controller.currentLocation == null
                    ? 'Location off'
                    : 'Location active',
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryRail extends StatelessWidget {
  const _CategoryRail({required this.controller});
  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _CategoryButton(
            label: 'All',
            icon: Icons.grid_view_rounded,
            selected: controller.category == null,
            onTap: () => controller.selectCategory(null),
          ),
          ...PlaceCategory.values.map(
            (category) => _CategoryButton(
              label: category.label,
              icon: category.icon,
              selected: controller.category == category,
              onTap: () => controller.selectCategory(category),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: 76,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: selected ? AppColors.forest : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selected
                        ? AppColors.forest
                        : const Color(0xFFE1E5DF),
                  ),
                ),
                child: Icon(
                  icon,
                  color: selected ? Colors.white : AppColors.forest,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  const PlaceCard({super.key, required this.place, required this.controller});
  final Place place;
  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 238,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _openPlace(context, place, controller),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: place.id,
                    child: PlaceImage(place: place, height: 152),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton.filled(
                      tooltip: controller.isFavorite(place)
                          ? 'Remove from saved'
                          : 'Save place',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () => controller.toggleFavorite(place),
                      icon: Icon(
                        controller.isFavorite(place)
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        color: AppColors.forest,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${place.city} · ${place.region}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 17,
                          color: AppColors.gold,
                        ),
                        Expanded(
                          child: Text(
                            ' ${place.rating} (${place.reviewCount})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${controller.distanceTo(place)} km',
                          style: const TextStyle(
                            color: AppColors.forest,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.action});
  final String title;
  final String action;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        Text(
          action,
          style: const TextStyle(
            color: AppColors.forest,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

class _RegionRail extends StatelessWidget {
  const _RegionRail({required this.controller});

  final ExploreController controller;

  void _openRegions(BuildContext context, [String? region]) {
    controller.selectRegion(region);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegionExplorerPage(
          controller: controller,
          onPlaceSelected: (place) => _openPlace(context, place, controller),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Choose a region',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            TextButton(
              onPressed: () => _openRegions(context),
              child: const Text('View all 10'),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 88,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: cameroonRegions.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final region = cameroonRegions[index];
            return Material(
              color: index.isEven ? AppColors.forest : AppColors.clay,
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _openRegions(context, region.name),
                child: SizedBox(
                  width: 148,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          region.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${region.capital} · ${region.tagline}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

class _CultureFeature extends StatelessWidget {
  const _CultureFeature({required this.controller});

  final CultureController controller;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
    child: Material(
      color: const Color(0xFFFFF4D6),
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CultureGuidePage(controller: controller),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: AppColors.gold, width: 5)),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.auto_stories_outlined,
                color: AppColors.clay,
                size: 34,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Know before you go',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Greetings, customs and food traditions across Cameroon.',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: AppColors.clay),
            ],
          ),
        ),
      ),
    ),
  );
}

enum _TravelMode { drive, walk }

class MapView extends StatefulWidget {
  const MapView({super.key, required this.controller});
  final ExploreController controller;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  GoogleMapController? _googleMapController;
  Place? selectedPlace;
  Place? _directionDestination;
  _TravelMode _travelMode = _TravelMode.drive;

  @override
  void dispose() {
    super.dispose();
  }

  int _estimatedMinutes(Place place) {
    final distance = widget.controller.distanceTo(place);
    final speed = _travelMode == _TravelMode.drive ? 35.0 : 4.5;
    final estimate = (distance / speed * 60).round();
    return estimate < 1 ? 1 : estimate;
  }

  Future<void> _launchDirections(Place place) async {
    setState(() => _directionDestination = place);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Showing directions to ${place.name}...')),
    );

    try {
      if (googleMapsConfigured && googleMapsSupportedPlatform) {
        await _googleMapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(place.coordinates.latitude, place.coordinates.longitude),
            14,
          ),
        );
      } else {
        _mapController.move(
          tile_map.LatLng(
            place.coordinates.latitude,
            place.coordinates.longitude,
          ),
          13,
        );
      }
    } catch (_) {
      // Continue to external directions if the map controller is not ready.
    }

    try {
      final launched = await launchGoogleMapsDirections(
        place,
        origin: widget.controller.currentLocation,
        walking: _travelMode == _TravelMode.walk,
      );
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Route preview shown. Could not open Google Maps.'),
          ),
        );
      } else if (launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening directions in Google Maps.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Route preview shown. Could not open Google Maps.'),
          ),
        );
      }
    }
  }

  void _showLegend() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Map legend', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 14),
              const _LegendItem(
                color: AppColors.forest,
                label: 'Destination or useful service',
              ),
              const _LegendItem(
                color: AppColors.clay,
                label: 'Numbered stop in your itinerary',
              ),
              const _LegendItem(
                color: AppColors.gold,
                label: 'Route between itinerary stops',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned.fill(
              child: googleMapsConfigured && googleMapsSupportedPlatform
                  ? GoogleTourismMap(
                      places: widget.controller.visiblePlaces,
                      selectedPlace: selectedPlace,
                      currentLocation: widget.controller.currentLocation,
                      itinerary: widget.controller.tripPlaces,
                      routePoints: widget.controller.routePoints,
                      directionDestination: _directionDestination,
                      onControllerReady: (controller) =>
                          _googleMapController = controller,
                      onPlaceSelected: (place) => setState(() {
                        selectedPlace = place;
                        _directionDestination = null;
                      }),
                    )
                  : RealMapCanvas(
                      mapController: _mapController,
                      places: widget.controller.visiblePlaces,
                      selectedPlace: selectedPlace,
                      currentLocation: widget.controller.currentLocation,
                      itinerary: widget.controller.tripPlaces,
                      routePoints: widget.controller.routePoints,
                      directionDestination: _directionDestination,
                      onPlaceSelected: (place) => setState(() {
                        selectedPlace = place;
                        _directionDestination = null;
                      }),
                    ),
            ),
            Positioned(
              top: 14,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: widget.controller.search,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: widget.controller.region == null
                                ? 'Search the map'
                                : 'Search ${widget.controller.region}',
                            prefixIcon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        tooltip: 'Map layers',
                        onPressed: _showLegend,
                        icon: const Icon(Icons.layers_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: PlaceCategory.values
                          .map(
                            (category) => Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: FilterChip(
                                backgroundColor: Colors.white,
                                selectedColor: AppColors.moss,
                                selected:
                                    widget.controller.category == category,
                                avatar: Icon(category.icon, size: 16),
                                label: Text(category.label),
                                onSelected: (_) =>
                                    widget.controller.selectCategory(
                                      widget.controller.category == category
                                          ? null
                                          : category,
                                    ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .92),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${widget.controller.region ?? 'Cameroon'} · '
                        '${widget.controller.visiblePlaces.length} places',
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: selectedPlace == null ? 24 : 178,
              child: FloatingActionButton.small(
                heroTag: 'location',
                tooltip: 'Center on my location',
                onPressed: () async {
                  final location = widget.controller.currentLocation;
                  if (googleMapsConfigured &&
                      googleMapsSupportedPlatform &&
                      location != null) {
                    await _googleMapController?.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        LatLng(location.latitude, location.longitude),
                        13,
                      ),
                    );
                  } else if (location != null) {
                    _mapController.move(
                      tile_map.LatLng(location.latitude, location.longitude),
                      13,
                    );
                  } else {
                    _mapController.move(const tile_map.LatLng(5.2, 11.7), 5.4);
                  }
                  setState(() => selectedPlace = null);
                },
                child: const Icon(Icons.my_location),
              ),
            ),
            if (selectedPlace != null)
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: _MapPlacePreview(
                  place: selectedPlace!,
                  distanceKm: widget.controller.distanceTo(selectedPlace!),
                  travelMinutes: _estimatedMinutes(selectedPlace!),
                  travelMode: _travelMode,
                  onTravelModeChanged: (mode) =>
                      setState(() => _travelMode = mode),
                  onDirections: () => _launchDirections(selectedPlace!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
      ],
    ),
  );
}

class _MapPlacePreview extends StatelessWidget {
  const _MapPlacePreview({
    required this.place,
    required this.distanceKm,
    required this.travelMinutes,
    required this.travelMode,
    required this.onTravelModeChanged,
    required this.onDirections,
  });
  final Place place;
  final double distanceKm;
  final int travelMinutes;
  final _TravelMode travelMode;
  final ValueChanged<_TravelMode> onTravelModeChanged;
  final VoidCallback onDirections;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 68,
                  height: 68,
                  child: PlaceImage(place: place, height: 68),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '$distanceKm km · about $travelMinutes min',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: AppColors.gold),
                        Text(' ${place.rating}'),
                      ],
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: onDirections,
                icon: const Icon(Icons.directions, size: 18),
                label: const Text('Go'),
              ),
            ],
          ),
          const SizedBox(height: 7),
          SegmentedButton<_TravelMode>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: _TravelMode.drive,
                icon: Icon(Icons.directions_car_outlined, size: 17),
                label: Text('Drive'),
              ),
              ButtonSegment(
                value: _TravelMode.walk,
                icon: Icon(Icons.directions_walk, size: 17),
                label: Text('Walk'),
              ),
            ],
            selected: {travelMode},
            onSelectionChanged: (selection) =>
                onTravelModeChanged(selection.first),
          ),
        ],
      ),
    ),
  );
}

class TripView extends StatelessWidget {
  const TripView({
    super.key,
    required this.controller,
    required this.eventsController,
  });
  final ExploreController controller;
  final EventsController eventsController;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) => ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('My journey', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        const Text(
          'Build each day around places that matter to you.',
          style: TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.forest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${controller.tripPlaces.length} STOPS · CAMEROON',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      controller.tripPlaces.length > 1
                          ? '${controller.tripPlaces.first.city} to ${controller.tripPlaces.last.city}'
                          : 'Your Cameroon journey',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Route overview',
                onPressed: null,
                icon: const Icon(Icons.route),
              ),
            ],
          ),
        ),
        if (controller.tripPlaces.isNotEmpty) ...[
          const SizedBox(height: 14),
          _TripRouteOverview(controller: controller),
          if (controller.isRouteLoading)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: LinearProgressIndicator(minHeight: 2),
            ),
        ],
        const SizedBox(height: 24),
        Text('Route stops', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 14),
        if (controller.tripPlaces.isEmpty)
          const _EmptyState(
            icon: Icons.route_outlined,
            title: 'Your day is open',
            message:
                'Open a place and add it to your trip. Travel times will appear here.',
          )
        else
          ...controller.tripPlaces.asMap().entries.map(
            (entry) => _TripStop(
              index: entry.key,
              place: entry.value,
              previousPlace: entry.key == 0
                  ? null
                  : controller.tripPlaces[entry.key - 1],
              totalStops: controller.tripPlaces.length,
              controller: controller,
            ),
          ),
        EventItinerarySection(controller: eventsController),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Add another day'),
        ),
      ],
    ),
  );
}

class _TripStop extends StatelessWidget {
  const _TripStop({
    required this.index,
    required this.place,
    required this.previousPlace,
    required this.totalStops,
    required this.controller,
  });
  final int index;
  final Place place;
  final Place? previousPlace;
  final int totalStops;
  final ExploreController controller;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 54,
        child: Text(
          'STOP\n${index + 1}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.forest,
            fontSize: 11,
          ),
        ),
      ),
      Column(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
            ),
          ),
          Container(width: 2, height: 76, color: AppColors.moss),
        ],
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Text(
              place.name,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              previousPlace == null
                  ? '${place.city} · Starting point'
                  : '${place.city} · '
                        '${controller.distanceBetween(previousPlace!, place)} km from previous',
            ),
            trailing: PopupMenuButton<String>(
              tooltip: 'Stop options',
              onSelected: (value) {
                switch (value) {
                  case 'up':
                    controller.moveTripPlace(index, -1);
                  case 'down':
                    controller.moveTripPlace(index, 1);
                  case 'remove':
                    controller.toggleTripPlace(place);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'up',
                  enabled: index > 0,
                  child: const Text('Move earlier'),
                ),
                PopupMenuItem(
                  value: 'down',
                  enabled: index < totalStops - 1,
                  child: const Text('Move later'),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Text('Remove stop'),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

class _TripRouteOverview extends StatelessWidget {
  const _TripRouteOverview({required this.controller});

  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 210,
            child: CameroonMapCanvas(
              places: controller.tripPlaces,
              itinerary: controller.tripPlaces,
              routePoints: controller.routePoints,
              currentLocation: controller.currentLocation,
              compact: true,
              maxMarkers: 30,
              onPlaceSelected: (place) =>
                  _openPlace(context, place, controller),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: _RouteMetric(
                    icon: Icons.route,
                    value: '${controller.tripDistanceKm} km',
                    label: 'total route',
                  ),
                ),
                Container(width: 1, height: 34, color: AppColors.moss),
                Expanded(
                  child: _RouteMetric(
                    icon: Icons.schedule,
                    value: _formatTravelTime(controller.tripEstimatedMinutes),
                    label: 'estimated drive',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteMetric extends StatelessWidget {
  const _RouteMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, size: 19, color: AppColors.forest),
      const SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
          Text(
            label,
            style: const TextStyle(color: AppColors.muted, fontSize: 11),
          ),
        ],
      ),
    ],
  );
}

String _formatTravelTime(int minutes) {
  if (minutes < 60) return '$minutes min';
  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;
  return remainingMinutes == 0
      ? '$hours hr'
      : '$hours hr $remainingMinutes min';
}

class SavedView extends StatelessWidget {
  const SavedView({super.key, required this.controller});
  final ExploreController controller;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) => ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Saved places',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            IconButton.filledTonal(
              onPressed: () {},
              icon: const Icon(Icons.person_outline),
              tooltip: 'Profile',
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (controller.favorites.isEmpty)
          const _EmptyState(
            icon: Icons.bookmark_outline,
            title: 'Keep remarkable places close',
            message: 'Tap the bookmark on any destination to keep it here.',
          )
        else
          ...controller.favorites.map(
            (place) => Card(
              child: ListTile(
                onTap: () => _openPlace(context, place, controller),
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 62,
                    height: 62,
                    child: PlaceImage(place: place, height: 62),
                  ),
                ),
                title: Text(
                  place.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${place.city} · ${controller.distanceTo(place)} km',
                ),
                trailing: IconButton(
                  onPressed: () => controller.toggleFavorite(place),
                  icon: const Icon(Icons.bookmark, color: AppColors.forest),
                ),
              ),
            ),
          ),
        const SizedBox(height: 28),
        Text('Safety nearby', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEDE7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.clay.withValues(alpha: .35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.emergency_outlined, color: AppColors.clay),
                  SizedBox(width: 8),
                  Text(
                    'Your current coordinates',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SelectableText(
                controller.currentLocation == null
                    ? 'Location unavailable'
                    : _formatCoordinates(controller.currentLocation),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                controller.currentLocation == null
                    ? 'Enable location to share precise coordinates.'
                    : 'Device GPS position',
                style: const TextStyle(color: AppColors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: AppColors.clay),
          onPressed: () {},
          icon: const Icon(Icons.share_location_outlined),
          label: const Text('Share my location'),
        ),
      ],
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Icon(icon, size: 38, color: AppColors.forest),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted),
        ),
      ],
    ),
  );
}

void _openPlace(
  BuildContext context,
  Place place,
  ExploreController controller,
) {
  final reviewsController = ReviewsScope.of(context);
  reviewsController.loadForPlace(place.id);
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => PlaceDetailPage(
        place: place,
        controller: controller,
        reviewsController: reviewsController,
      ),
    ),
  );
}

class PlaceDetailPage extends StatelessWidget {
  const PlaceDetailPage({
    super.key,
    required this.place,
    required this.controller,
    required this.reviewsController,
  });
  final Place place;
  final ExploreController controller;
  final ReviewsController reviewsController;

  Future<void> _openDirections(BuildContext context) async {
    try {
      final launched = await launchGoogleMapsDirections(
        place,
        origin: controller.currentLocation,
        walking: false,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            launched
                ? 'Opening directions in Google Maps.'
                : 'Could not open Google Maps.',
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([controller, reviewsController]),
    builder: (context, _) => Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 310,
            pinned: true,
            leading: IconButton.filled(
              tooltip: 'Back',
              style: IconButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
              IconButton.filled(
                tooltip: 'Share',
                style: IconButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {},
                icon: const Icon(Icons.ios_share),
              ),
              const SizedBox(width: 10),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: place.id,
                child: PlaceImage(place: place, height: 310),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.category.label.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.clay,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    place.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.gold,
                        size: 20,
                      ),
                      Text(
                        ' ${reviewsController.averageRating(place)} '
                        '(${reviewsController.totalReviewCount(place)} reviews)',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          '${place.city}, ${place.region}',
                          textAlign: TextAlign.end,
                          style: const TextStyle(color: AppColors.muted),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _Stat(
                          icon: Icons.route,
                          value: '${controller.distanceTo(place)} km',
                          label: 'from you',
                        ),
                      ),
                      Expanded(
                        child: _Stat(
                          icon: Icons.schedule,
                          value: '${place.travelMinutes} min',
                          label: 'by car',
                        ),
                      ),
                      Expanded(
                        child: _Stat(
                          icon: Icons.payments_outlined,
                          value: place.priceLabel,
                          label: 'entry',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Text('Why go', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text(
                    place.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.55,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: place.tags
                        .map((tag) => Chip(label: Text(tag)))
                        .toList(),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Plan your visit',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.schedule_outlined,
                    title: 'Opening hours',
                    value: place.openingHours,
                  ),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    title: 'Coordinates',
                    value:
                        '${place.coordinates.latitude}, ${place.coordinates.longitude}',
                  ),
                  const _InfoRow(
                    icon: Icons.language_outlined,
                    title: 'Guide languages',
                    value: 'French, English and local languages',
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4D6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: AppColors.clay),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Carry cash in FCFA and confirm access conditions before departure.',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  ReviewsSection(place: place, controller: reviewsController),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
          ),
          child: Row(
            children: [
              IconButton.outlined(
                tooltip: 'Save place',
                onPressed: () => controller.toggleFavorite(place),
                icon: Icon(
                  controller.isFavorite(place)
                      ? Icons.bookmark
                      : Icons.bookmark_outline,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => controller.toggleTripPlace(place),
                  icon: Icon(
                    controller.isInTrip(place) ? Icons.check : Icons.add,
                  ),
                  label: Text(
                    controller.isInTrip(place) ? 'In my trip' : 'Add to trip',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _openDirections(context),
                  icon: const Icon(Icons.directions),
                  label: const Text('Directions'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, color: AppColors.forest),
      const SizedBox(height: 6),
      Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
      ),
      Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
    ],
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.forest),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(value, style: const TextStyle(color: AppColors.muted)),
            ],
          ),
        ),
      ],
    ),
  );
}

String _formatCoordinates(GeoPoint? point) {
  if (point == null) return '';
  final latitudeDirection = point.latitude >= 0 ? 'N' : 'S';
  final longitudeDirection = point.longitude >= 0 ? 'E' : 'W';
  return '${point.latitude.abs().toStringAsFixed(4)}° $latitudeDirection, '
      '${point.longitude.abs().toStringAsFixed(4)}° $longitudeDirection';
}
