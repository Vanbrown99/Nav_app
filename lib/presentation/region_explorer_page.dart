import 'package:flutter/material.dart';
import 'package:nyetam/app.dart';
import 'package:nyetam/domain/cameroon_region.dart';
import 'package:nyetam/domain/place.dart';
import 'package:nyetam/presentation/explore_controller.dart';

class RegionExplorerPage extends StatelessWidget {
  const RegionExplorerPage({
    super.key,
    required this.controller,
    required this.onPlaceSelected,
  });

  final ExploreController controller;
  final ValueChanged<Place> onPlaceSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Explore by region')),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cameroon’s 10 regions',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Choose a region to discover its landscapes, heritage, food and useful services.',
                      style: TextStyle(color: AppColors.muted, height: 1.45),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 82,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: cameroonRegions.length,
                itemBuilder: (context, index) {
                  final region = cameroonRegions[index];
                  final selected = controller.region == region.name;
                  final count = controller.places
                      .where((place) => place.region == region.name)
                      .length;
                  return Material(
                    color: selected ? AppColors.forest : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => controller.selectRegion(region.name),
                      child: Padding(
                        padding: const EdgeInsets.all(11),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    region.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : AppColors.ink,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$count',
                                  style: TextStyle(
                                    color: selected
                                        ? AppColors.gold
                                        : AppColors.forest,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              region.capital,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white70
                                    : AppColors.muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 58,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: const Text('All categories'),
                        selected: controller.category == null,
                        onSelected: (_) => controller.selectCategory(null),
                      ),
                    ),
                    ...PlaceCategory.values.map(
                      (category) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          avatar: Icon(category.icon, size: 16),
                          label: Text(category.label),
                          selected: controller.category == category,
                          onSelected: (_) => controller.selectCategory(
                            controller.category == category ? null : category,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.region ?? 'Select a region',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Text(
                      '${controller.region == null ? 0 : controller.visiblePlaces.length} destinations',
                      style: const TextStyle(
                        color: AppColors.forest,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.region == null)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 6, 20, 30),
                  child: Text(
                    'Select one of the regions above to view its destinations.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
              )
            else if (controller.visiblePlaces.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 6, 20, 30),
                  child: Text('No destinations match this category yet.'),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                sliver: SliverList.separated(
                  itemCount: controller.visiblePlaces.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final place = controller.visiblePlaces[index];
                    return _RegionalPlaceTile(
                      place: place,
                      distanceKm: controller.distanceTo(place),
                      onTap: () => onPlaceSelected(place),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RegionalPlaceTile extends StatelessWidget {
  const _RegionalPlaceTile({
    required this.place,
    required this.distanceKm,
    required this.onTap,
  });

  final Place place;
  final double distanceKm;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 108,
          child: Row(
            children: [
              Image.network(
                place.imageUrl,
                width: 108,
                height: 108,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 108,
                  color: AppColors.moss,
                  child: Icon(place.category.icon, color: AppColors.forest),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.category.label.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.clay,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        place.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 15,
                            color: AppColors.gold,
                          ),
                          Text(' ${place.rating}'),
                          const Spacer(),
                          Text(
                            '$distanceKm km',
                            style: const TextStyle(
                              color: AppColors.forest,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
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
      ),
    );
  }
}
