import 'package:nyetam/domain/place.dart';

List<Place> createRegionalPlaces() {
  return List.unmodifiable(
    _regionalSeeds.indexed.map((entry) {
      final index = entry.$1;
      final seed = entry.$2;
      return Place(
        id: seed.id,
        name: seed.name,
        city: seed.city,
        region: seed.region,
        category: seed.category,
        description: seed.description,
        imageUrl: _regionalImages[seed.category]!,
        coordinates: GeoPoint(seed.latitude, seed.longitude),
        rating: seed.rating,
        reviewCount: 38 + (index * 23) % 240,
        distanceKm: 10 + index * 2.7,
        travelMinutes: 20 + index * 5,
        openingHours: seed.openingHours,
        priceLabel: seed.priceLabel,
        tags: seed.tags,
      );
    }),
  );
}

const _regionalImages = <PlaceCategory, String>{
  PlaceCategory.attraction:
      'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1400&q=85',
  PlaceCategory.culture:
      'https://images.unsplash.com/photo-1564399579883-451a5d44ec08?auto=format&fit=crop&w=1400&q=85',
  PlaceCategory.restaurant:
      'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=1400&q=85',
  PlaceCategory.hotel:
      'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1400&q=85',
  PlaceCategory.entertainment:
      'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=1400&q=85',
  PlaceCategory.emergency:
      'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=1400&q=85',
};

class _RegionalSeed {
  const _RegionalSeed({
    required this.id,
    required this.name,
    required this.city,
    required this.region,
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.tags,
    this.openingHours = 'Open daily, 08:00–17:00',
    this.priceLabel = 'Entry varies',
  });

  final String id;
  final String name;
  final String city;
  final String region;
  final PlaceCategory category;
  final String description;
  final double latitude;
  final double longitude;
  final double rating;
  final List<String> tags;
  final String openingHours;
  final String priceLabel;
}

const _regionalSeeds = <_RegionalSeed>[
  _RegionalSeed(
    id: 'adamawa-tello-falls',
    name: 'Tello Falls',
    city: 'Ngaoundéré',
    region: 'Adamawa',
    category: PlaceCategory.attraction,
    description:
        'A dramatic waterfall where the river drops over a broad rock shelf into a sheltered basin.',
    latitude: 7.2472,
    longitude: 13.5611,
    rating: 4.6,
    tags: ['Waterfall', 'Nature', 'Hiking'],
  ),
  _RegionalSeed(
    id: 'adamawa-vina-falls',
    name: 'Vina Falls',
    city: 'Ngaoundéré',
    region: 'Adamawa',
    category: PlaceCategory.attraction,
    description:
        'Rocky cascades on the Vina River surrounded by the open landscapes of the Adamawa Plateau.',
    latitude: 7.2906,
    longitude: 13.5865,
    rating: 4.4,
    tags: ['Waterfall', 'River', 'Photography'],
  ),
  _RegionalSeed(
    id: 'adamawa-lamidat-ngaoundere',
    name: 'Lamidat of Ngaoundéré',
    city: 'Ngaoundéré',
    region: 'Adamawa',
    category: PlaceCategory.culture,
    description:
        'The historic seat of the local lamido, reflecting Fulani architecture, ceremony and regional history.',
    latitude: 7.3220,
    longitude: 13.5800,
    rating: 4.5,
    tags: ['Palace', 'Fulani culture', 'History', 'Guide'],
  ),
  _RegionalSeed(
    id: 'adamawa-lake-mbalang',
    name: 'Lake Mbalang',
    city: 'Ngaoundéré',
    region: 'Adamawa',
    category: PlaceCategory.attraction,
    description:
        'A tranquil crater lake near Ngaoundéré with green surroundings and quiet viewpoints.',
    latitude: 7.3308,
    longitude: 13.5047,
    rating: 4.3,
    tags: ['Lake', 'Nature', 'Picnic'],
  ),
  _RegionalSeed(
    id: 'east-lobeke',
    name: 'Lobéké National Park',
    city: 'Moloundou',
    region: 'East',
    category: PlaceCategory.attraction,
    description:
        'A Congo Basin rainforest park known for forest clearings, elephants, gorillas and exceptional biodiversity.',
    latitude: 2.2500,
    longitude: 15.7500,
    rating: 4.8,
    tags: ['National park', 'Wildlife', 'Rainforest', 'Guide required'],
    openingHours: 'Access with authorized guide',
    priceLabel: 'Permit and guide fees apply',
  ),
  _RegionalSeed(
    id: 'east-boumba-bek',
    name: 'Boumba Bek National Park',
    city: 'Yokadouma',
    region: 'East',
    category: PlaceCategory.attraction,
    description:
        'A remote protected rainforest landscape with rich wildlife and community-based conservation activity.',
    latitude: 2.9000,
    longitude: 15.3500,
    rating: 4.7,
    tags: ['National park', 'Rainforest', 'Wildlife', 'Expedition'],
    openingHours: 'Access with authorized guide',
    priceLabel: 'Permit and guide fees apply',
  ),
  _RegionalSeed(
    id: 'east-nki',
    name: 'Nki National Park',
    city: 'Yokadouma',
    region: 'East',
    category: PlaceCategory.attraction,
    description:
        'One of Cameroon’s least disturbed forest areas, suited to carefully planned conservation travel.',
    latitude: 2.4500,
    longitude: 14.5000,
    rating: 4.7,
    tags: ['National park', 'Forest', 'Wildlife', 'Expedition'],
    openingHours: 'Advance authorization required',
    priceLabel: 'Permit and guide fees apply',
  ),
  _RegionalSeed(
    id: 'east-kadey-river',
    name: 'Kadey River Viewpoint',
    city: 'Batouri',
    region: 'East',
    category: PlaceCategory.attraction,
    description:
        'A riverside landscape near Batouri offering a glimpse of the forest region’s waterways and daily life.',
    latitude: 4.4380,
    longitude: 14.3610,
    rating: 4.1,
    tags: ['River', 'Landscape', 'Local life'],
  ),
  _RegionalSeed(
    id: 'far-north-waza',
    name: 'Waza National Park',
    city: 'Waza',
    region: 'Far North',
    category: PlaceCategory.attraction,
    description:
        'Cameroon’s celebrated savannah reserve, known for birdlife and seasonal wildlife viewing.',
    latitude: 11.3333,
    longitude: 14.6667,
    rating: 4.7,
    tags: ['National park', 'Safari', 'Birding', 'Wildlife'],
    openingHours: 'Seasonal access with park guide',
    priceLabel: 'Park and guide fees apply',
  ),
  _RegionalSeed(
    id: 'far-north-rhumsiki',
    name: 'Rhumsiki and the Mandara Mountains',
    city: 'Rhumsiki',
    region: 'Far North',
    category: PlaceCategory.attraction,
    description:
        'A striking volcanic landscape of rocky peaks, traditional compounds and highland footpaths.',
    latitude: 10.5000,
    longitude: 13.6000,
    rating: 4.8,
    tags: ['Mountains', 'Village', 'Hiking', 'Culture'],
  ),
  _RegionalSeed(
    id: 'far-north-mora-massif',
    name: 'Mora Massif',
    city: 'Mora',
    region: 'Far North',
    category: PlaceCategory.attraction,
    description:
        'A rugged mountain area with panoramic Sahel views and routes best explored with local guidance.',
    latitude: 11.0461,
    longitude: 14.1401,
    rating: 4.5,
    tags: ['Mountain', 'Hiking', 'Viewpoint', 'Guide'],
  ),
  _RegionalSeed(
    id: 'far-north-maroua-craft',
    name: 'Maroua Artisan Centre',
    city: 'Maroua',
    region: 'Far North',
    category: PlaceCategory.culture,
    description:
        'A craft market for leatherwork, woven goods, metalwork and objects made by northern artisans.',
    latitude: 10.5950,
    longitude: 14.3220,
    rating: 4.4,
    tags: ['Craft', 'Market', 'Leather', 'Shopping'],
    openingHours: 'Mon–Sat, 08:00–18:00',
  ),
  _RegionalSeed(
    id: 'north-benoue',
    name: 'Bénoué National Park',
    city: 'Garoua',
    region: 'North',
    category: PlaceCategory.attraction,
    description:
        'A broad savannah reserve along the Bénoué River with antelope, hippos, primates and diverse birdlife.',
    latitude: 8.3333,
    longitude: 13.8333,
    rating: 4.6,
    tags: ['National park', 'Safari', 'River', 'Wildlife'],
    openingHours: 'Seasonal access with park guide',
    priceLabel: 'Park and guide fees apply',
  ),
  _RegionalSeed(
    id: 'north-faro',
    name: 'Faro National Park',
    city: 'Poli',
    region: 'North',
    category: PlaceCategory.attraction,
    description:
        'A remote protected landscape of savannah, rivers and wildlife near Cameroon’s western border.',
    latitude: 8.0000,
    longitude: 12.5000,
    rating: 4.5,
    tags: ['National park', 'Savannah', 'Wildlife', 'Expedition'],
    openingHours: 'Advance planning required',
    priceLabel: 'Permit and guide fees apply',
  ),
  _RegionalSeed(
    id: 'north-lagdo-lake',
    name: 'Lake Lagdo',
    city: 'Lagdo',
    region: 'North',
    category: PlaceCategory.attraction,
    description:
        'A vast reservoir with fishing communities, broad water views and sunset landscapes.',
    latitude: 9.0500,
    longitude: 13.6667,
    rating: 4.4,
    tags: ['Lake', 'Fishing', 'Sunset', 'Landscape'],
  ),
  _RegionalSeed(
    id: 'north-rey-bouba',
    name: 'Lamidat of Rey Bouba',
    city: 'Rey Bouba',
    region: 'North',
    category: PlaceCategory.culture,
    description:
        'A historic fortified palace complex and enduring center of northern traditional authority.',
    latitude: 8.6725,
    longitude: 14.1786,
    rating: 4.6,
    tags: ['Palace', 'History', 'Architecture', 'Tradition'],
  ),
  _RegionalSeed(
    id: 'north-west-bafut-palace',
    name: 'Bafut Palace',
    city: 'Bafut',
    region: 'North-West',
    category: PlaceCategory.culture,
    description:
        'A major Grassfields royal compound preserving palace architecture, ritual spaces and historical collections.',
    latitude: 6.0833,
    longitude: 10.1167,
    rating: 4.7,
    tags: ['Palace', 'Grassfields', 'Museum', 'Tradition'],
  ),
  _RegionalSeed(
    id: 'north-west-lake-awing',
    name: 'Lake Awing',
    city: 'Awing',
    region: 'North-West',
    category: PlaceCategory.attraction,
    description:
        'A highland crater lake valued for its scenery and cultural significance to surrounding communities.',
    latitude: 5.8700,
    longitude: 10.1800,
    rating: 4.6,
    tags: ['Crater lake', 'Highlands', 'Culture', 'Hiking'],
  ),
  _RegionalSeed(
    id: 'north-west-menchum-falls',
    name: 'Menchum Falls',
    city: 'Wum',
    region: 'North-West',
    category: PlaceCategory.attraction,
    description:
        'A powerful roadside waterfall dropping through forested highland terrain in the Menchum Valley.',
    latitude: 6.4000,
    longitude: 10.1000,
    rating: 4.6,
    tags: ['Waterfall', 'Highlands', 'Photography'],
  ),
  _RegionalSeed(
    id: 'north-west-bamenda-highlands',
    name: 'Bamenda Highlands',
    city: 'Bamenda',
    region: 'North-West',
    category: PlaceCategory.attraction,
    description:
        'Rolling green highlands, escarpment views and scenic roads surrounding the regional capital.',
    latitude: 5.9631,
    longitude: 10.1591,
    rating: 4.5,
    tags: ['Highlands', 'Viewpoint', 'Road trip', 'Hiking'],
  ),
  _RegionalSeed(
    id: 'west-foumban-palace',
    name: 'Foumban Royal Palace',
    city: 'Foumban',
    region: 'West',
    category: PlaceCategory.culture,
    description:
        'The historic palace of the Bamoun sultans and a central landmark for the kingdom’s political and artistic heritage.',
    latitude: 5.7260,
    longitude: 10.8990,
    rating: 4.8,
    tags: ['Palace', 'Bamoun', 'History', 'Museum'],
  ),
  _RegionalSeed(
    id: 'west-museum-civilizations',
    name: 'Museum of Civilizations',
    city: 'Dschang',
    region: 'West',
    category: PlaceCategory.culture,
    description:
        'A major museum presenting the peoples, histories and cultural landscapes of Cameroon.',
    latitude: 5.4470,
    longitude: 10.0530,
    rating: 4.7,
    tags: ['Museum', 'Culture', 'History', 'Architecture'],
  ),
  _RegionalSeed(
    id: 'west-lake-baleng',
    name: 'Lake Baleng',
    city: 'Bafoussam',
    region: 'West',
    category: PlaceCategory.attraction,
    description:
        'A crater lake in the Bamileke highlands surrounded by farms, slopes and volcanic scenery.',
    latitude: 5.5200,
    longitude: 10.4100,
    rating: 4.5,
    tags: ['Crater lake', 'Highlands', 'Nature'],
  ),
  _RegionalSeed(
    id: 'west-mami-wata-falls',
    name: 'Mami Wata Falls',
    city: 'Dschang',
    region: 'West',
    category: PlaceCategory.attraction,
    description:
        'A scenic waterfall reached through the green highland countryside around Dschang.',
    latitude: 5.4550,
    longitude: 10.0170,
    rating: 4.5,
    tags: ['Waterfall', 'Hiking', 'Nature', 'Dschang'],
  ),
];
