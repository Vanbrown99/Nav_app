import 'package:nyetam/domain/place.dart';
import 'package:nyetam/data/regional_places.dart';
import 'package:nyetam/data/yaounde_places.dart';

abstract interface class PlaceRepository {
  Future<List<Place>> getPlaces();
}

class DemoPlaceRepository implements PlaceRepository {
  @override
  Future<List<Place>> getPlaces() async => [
    ..._places,
    ...createRegionalPlaces(),
    ...createYaoundePlaces(),
  ];

  static const _places = <Place>[
    Place(
      id: 'mount-cameroon',
      name: 'Mount Cameroon',
      city: 'Buea',
      region: 'South-West',
      category: PlaceCategory.attraction,
      description:
          'Climb West Africa’s highest peak through rainforest, savannah and volcanic ridges with certified local guides.',
      imageUrl:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1400&q=85',
      coordinates: GeoPoint(4.2038, 9.1706),
      rating: 4.8,
      reviewCount: 428,
      distanceKm: 12.4,
      travelMinutes: 26,
      openingHours: 'Guided departures 06:00–08:00',
      priceLabel: 'From 25,000 FCFA',
      tags: ['Hiking', 'Volcano', 'Guide required'],
    ),
    Place(
      id: 'lobe-falls',
      name: 'Lobé Falls',
      city: 'Kribi',
      region: 'South',
      category: PlaceCategory.attraction,
      description:
          'A rare coastal waterfall where the Lobé River drops directly into the Atlantic beside fishing villages.',
      imageUrl:
          'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?auto=format&fit=crop&w=1400&q=85',
      coordinates: GeoPoint(2.8865, 9.8969),
      rating: 4.7,
      reviewCount: 316,
      distanceKm: 4.8,
      travelMinutes: 12,
      openingHours: 'Open daily, 07:00–18:00',
      priceLabel: '2,000 FCFA',
      tags: ['Waterfall', 'Canoe', 'Beach'],
    ),
    Place(
      id: 'ebogo',
      name: 'Ebogo Ecotourism Site',
      city: 'Mbalmayo',
      region: 'Centre',
      category: PlaceCategory.culture,
      description:
          'Glide along the Nyong River beneath ancient forest canopy and learn about local conservation traditions.',
      imageUrl:
          'https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?auto=format&fit=crop&w=1400&q=85',
      coordinates: GeoPoint(3.4013, 11.4702),
      rating: 4.6,
      reviewCount: 184,
      distanceKm: 38.2,
      travelMinutes: 58,
      openingHours: 'Open daily, 08:00–17:00',
      priceLabel: 'From 5,000 FCFA',
      tags: ['Forest', 'Canoe', 'Community'],
    ),
    Place(
      id: 'sawa-table',
      name: 'La Table Sawa',
      city: 'Douala',
      region: 'Littoral',
      category: PlaceCategory.restaurant,
      description:
          'Contemporary Cameroonian cooking with ndolé, grilled fish and seasonal ingredients from the coast.',
      imageUrl:
          'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=1400&q=85',
      coordinates: GeoPoint(4.0383, 9.6891),
      rating: 4.5,
      reviewCount: 267,
      distanceKm: 1.7,
      travelMinutes: 7,
      openingHours: 'Open today, 11:30–23:00',
      priceLabel: '8,000–20,000 FCFA',
      tags: ['Cameroonian', 'Seafood', 'Family'],
    ),
    Place(
      id: 'kribi-bay',
      name: 'Kribi Bay Lodge',
      city: 'Kribi',
      region: 'South',
      category: PlaceCategory.hotel,
      description:
          'A quiet coastal lodge with ocean-facing rooms, local breakfast and direct access to the beach.',
      imageUrl:
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1400&q=85',
      coordinates: GeoPoint(2.9406, 9.9102),
      rating: 4.6,
      reviewCount: 195,
      distanceKm: 2.3,
      travelMinutes: 9,
      openingHours: 'Reception open 24 hours',
      priceLabel: 'From 48,000 FCFA/night',
      tags: ['Beachfront', 'Breakfast', 'Airport transfer'],
    ),
    Place(
      id: 'national-museum',
      name: 'National Museum',
      city: 'Yaoundé',
      region: 'Centre',
      category: PlaceCategory.culture,
      description:
          'Discover the artistic heritage, royal traditions and diverse histories of Cameroon’s ten regions.',
      imageUrl:
          'https://images.unsplash.com/photo-1564399579883-451a5d44ec08?auto=format&fit=crop&w=1400&q=85',
      coordinates: GeoPoint(3.8617, 11.5147),
      rating: 4.4,
      reviewCount: 352,
      distanceKm: 3.1,
      travelMinutes: 14,
      openingHours: 'Tue–Sun, 10:00–17:00',
      priceLabel: '5,000 FCFA',
      tags: ['Museum', 'History', 'Accessible'],
    ),
    Place(
      id: 'limbe-wildlife',
      name: 'Limbe Wildlife Centre',
      city: 'Limbe',
      region: 'South-West',
      category: PlaceCategory.attraction,
      description:
          'A conservation centre caring for rescued primates in lush botanical surroundings near the coast.',
      imageUrl:
          'https://images.unsplash.com/photo-1540573133985-87b6da6d54a9?auto=format&fit=crop&w=1400&q=85',
      coordinates: GeoPoint(4.0186, 9.2069),
      rating: 4.6,
      reviewCount: 509,
      distanceKm: 5.6,
      travelMinutes: 18,
      openingHours: 'Open daily, 08:00–17:00',
      priceLabel: '3,000 FCFA',
      tags: ['Wildlife', 'Conservation', 'Family'],
    ),
    Place(
      id: 'central-hospital',
      name: 'Yaoundé Central Hospital',
      city: 'Yaoundé',
      region: 'Centre',
      category: PlaceCategory.emergency,
      description:
          'Major public hospital with continuous emergency and specialist services.',
      imageUrl:
          'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=1400&q=85',
      coordinates: GeoPoint(3.8736, 11.5094),
      rating: 4.0,
      reviewCount: 83,
      distanceKm: 1.2,
      travelMinutes: 5,
      openingHours: 'Emergency service open 24 hours',
      priceLabel: 'Public service',
      tags: ['Hospital', 'Emergency', '24 hours'],
    ),
  ];
}
