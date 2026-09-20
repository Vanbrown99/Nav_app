import 'package:nyetam/domain/place.dart';

List<Place> createYaoundePlaces() {
  return List.unmodifiable(
    _seeds.indexed.map((entry) {
      final index = entry.$1;
      final seed = entry.$2;
      return Place(
        id: seed.id,
        name: seed.name,
        city: 'Yaoundé',
        region: 'Centre',
        category: seed.category,
        description: seed.description,
        imageUrl: _images[seed.category]!,
        coordinates: GeoPoint(seed.latitude, seed.longitude),
        rating: seed.rating,
        reviewCount: 24 + (index * 17) % 280,
        distanceKm: double.parse((1.4 + (index * .37) % 13).toStringAsFixed(1)),
        travelMinutes: 7 + (index * 3) % 38,
        openingHours: seed.openingHours ?? _hours[seed.category]!,
        priceLabel: seed.priceLabel ?? _prices[seed.category]!,
        tags: seed.tags,
      );
    }),
  );
}

const _images = <PlaceCategory, String>{
  PlaceCategory.attraction:
      'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1400&q=85',
  PlaceCategory.restaurant:
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1400&q=85',
  PlaceCategory.hotel:
      'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1400&q=85',
  PlaceCategory.culture:
      'https://images.unsplash.com/photo-1564399579883-451a5d44ec08?auto=format&fit=crop&w=1400&q=85',
  PlaceCategory.entertainment:
      'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=1400&q=85',
  PlaceCategory.emergency:
      'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=1400&q=85',
};

const _hours = <PlaceCategory, String>{
  PlaceCategory.attraction: 'Open daily, 08:00–18:00',
  PlaceCategory.restaurant: 'Open daily, 11:00–22:30',
  PlaceCategory.hotel: 'Reception open 24 hours',
  PlaceCategory.culture: 'Mon–Sat, 09:00–17:00',
  PlaceCategory.entertainment: 'Open daily, 09:00–22:00',
  PlaceCategory.emergency: 'Open 24 hours',
};

const _prices = <PlaceCategory, String>{
  PlaceCategory.attraction: 'From 1,000 FCFA',
  PlaceCategory.restaurant: 'From 4,000 FCFA',
  PlaceCategory.hotel: 'From 35,000 FCFA/night',
  PlaceCategory.culture: 'Entry varies',
  PlaceCategory.entertainment: 'Prices vary',
  PlaceCategory.emergency: 'Essential service',
};

class _YaoundeSeed {
  const _YaoundeSeed({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.tags,
    this.openingHours,
    this.priceLabel,
  });

  final String id;
  final String name;
  final PlaceCategory category;
  final String description;
  final double latitude;
  final double longitude;
  final double rating;
  final List<String> tags;
  final String? openingHours;
  final String? priceLabel;
}

const _seeds = <_YaoundeSeed>[
  _YaoundeSeed(
    id: 'yaounde-mvog-betsi-zoo',
    name: 'Mvog-Betsi Zoo',
    category: PlaceCategory.attraction,
    description:
        'A long-established wildlife park and environmental education site focused on native Central African species.',
    latitude: 3.8668,
    longitude: 11.4897,
    rating: 4.1,
    tags: ['Zoo', 'Wildlife', 'Family', 'Nature'],
  ),
  _YaoundeSeed(
    id: 'yaounde-bois-sainte-anastasie',
    name: 'Bois Sainte Anastasie',
    category: PlaceCategory.attraction,
    description:
        'A landscaped urban green space with shaded paths, gardens and quiet areas near central Yaoundé.',
    latitude: 3.8738,
    longitude: 11.5172,
    rating: 4.2,
    tags: ['Park', 'Garden', 'Walk', 'Family'],
  ),
  _YaoundeSeed(
    id: 'yaounde-municipal-lake',
    name: 'Yaoundé Municipal Lake',
    category: PlaceCategory.attraction,
    description:
        'A central city lake and recognizable urban landmark surrounded by government and hospitality districts.',
    latitude: 3.8610,
    longitude: 11.5130,
    rating: 4.0,
    tags: ['Lake', 'City walk', 'Photography'],
  ),
  _YaoundeSeed(
    id: 'yaounde-mount-febe',
    name: 'Mount Fébé Viewpoint',
    category: PlaceCategory.attraction,
    description:
        'A forested hill offering broad views over Yaoundé and access to nearby walking routes.',
    latitude: 3.9153,
    longitude: 11.4906,
    rating: 4.5,
    tags: ['Viewpoint', 'Hiking', 'Nature', 'Sunset'],
  ),
  _YaoundeSeed(
    id: 'yaounde-mount-eloundem',
    name: 'Mount Eloundem',
    category: PlaceCategory.attraction,
    description:
        'A green hill on the southern edge of the capital suited to guided hikes and panoramic city views.',
    latitude: 3.8016,
    longitude: 11.4878,
    rating: 4.4,
    tags: ['Mountain', 'Hiking', 'Viewpoint', 'Guide'],
  ),
  _YaoundeSeed(
    id: 'yaounde-mefou-sanctuary',
    name: 'Mefou Primate Sanctuary',
    category: PlaceCategory.attraction,
    description:
        'A forest sanctuary near the capital caring for rescued gorillas, chimpanzees and other primates.',
    latitude: 3.6478,
    longitude: 11.5482,
    rating: 4.7,
    tags: ['Primates', 'Conservation', 'Forest', 'Guided visit'],
    openingHours: 'Tue–Sun, guided visits by arrangement',
  ),
  _YaoundeSeed(
    id: 'yaounde-ecopark-ahala',
    name: 'Ecopark Ahala',
    category: PlaceCategory.attraction,
    description:
        'A leisure and nature area in southern Yaoundé used for outdoor activities and family outings.',
    latitude: 3.7964,
    longitude: 11.5068,
    rating: 4.1,
    tags: ['Park', 'Outdoor', 'Family', 'Picnic'],
  ),
  _YaoundeSeed(
    id: 'yaounde-golf-club',
    name: 'Yaoundé Golf Club',
    category: PlaceCategory.attraction,
    description:
        'An established green course near Mount Fébé with practice and clubhouse facilities.',
    latitude: 3.9117,
    longitude: 11.4937,
    rating: 4.3,
    tags: ['Golf', 'Sport', 'Nature', 'Club'],
    priceLabel: 'Visitor rates vary',
  ),
  _YaoundeSeed(
    id: 'yaounde-hippodrome',
    name: 'Yaoundé Hippodrome',
    category: PlaceCategory.attraction,
    description:
        'A historic open district known for equestrian events, public gatherings and central-city walks.',
    latitude: 3.8732,
    longitude: 11.5110,
    rating: 4.0,
    tags: ['Landmark', 'Equestrian', 'City walk'],
  ),
  _YaoundeSeed(
    id: 'yaounde-congress-viewpoint',
    name: 'Palais des Congrès Viewpoint',
    category: PlaceCategory.attraction,
    description:
        'Elevated grounds around the conference center with a wide outlook across Yaoundé’s green hills.',
    latitude: 3.8927,
    longitude: 11.5007,
    rating: 4.4,
    tags: ['Viewpoint', 'Architecture', 'Photography'],
  ),
  _YaoundeSeed(
    id: 'yaounde-reunification-monument',
    name: 'Reunification Monument',
    category: PlaceCategory.culture,
    description:
        'A major national monument commemorating the reunification of Cameroon and its modern political history.',
    latitude: 3.8509,
    longitude: 11.5087,
    rating: 4.5,
    tags: ['Monument', 'History', 'Architecture', 'National heritage'],
  ),
  _YaoundeSeed(
    id: 'yaounde-blackitude-museum',
    name: 'Blackitude Museum',
    category: PlaceCategory.culture,
    description:
        'A private museum presenting royal objects, masks, sculpture and cultural heritage from Cameroon.',
    latitude: 3.8654,
    longitude: 11.5161,
    rating: 4.4,
    tags: ['Museum', 'Art', 'Heritage', 'Guided visit'],
  ),
  _YaoundeSeed(
    id: 'yaounde-benedictine-museum',
    name: 'Benedictine Museum of Mont Fébé',
    category: PlaceCategory.culture,
    description:
        'A collection of traditional sculpture, masks, textiles and objects housed near the monastery on Mount Fébé.',
    latitude: 3.9158,
    longitude: 11.4936,
    rating: 4.5,
    tags: ['Museum', 'Traditional art', 'History', 'Mount Fébé'],
  ),
  _YaoundeSeed(
    id: 'yaounde-basilica-mvolye',
    name: 'Mary Queen of the Apostles Basilica',
    category: PlaceCategory.culture,
    description:
        'A prominent basilica in Mvolyé known for its modern architecture, stained glass and pilgrimage history.',
    latitude: 3.8457,
    longitude: 11.5085,
    rating: 4.7,
    tags: ['Basilica', 'Architecture', 'Faith', 'Mvolyé'],
    priceLabel: 'Free entry',
  ),
  _YaoundeSeed(
    id: 'yaounde-cathedral',
    name: 'Notre-Dame des Victoires Cathedral',
    category: PlaceCategory.culture,
    description:
        'The Catholic cathedral of Yaoundé, recognizable by its broad triangular facade in the city center.',
    latitude: 3.8662,
    longitude: 11.5204,
    rating: 4.5,
    tags: ['Cathedral', 'Architecture', 'Faith', 'City center'],
    priceLabel: 'Free entry',
  ),
  _YaoundeSeed(
    id: 'yaounde-national-archives',
    name: 'National Archives of Cameroon',
    category: PlaceCategory.culture,
    description:
        'A national research institution preserving administrative, historical and audiovisual records.',
    latitude: 3.8721,
    longitude: 11.5183,
    rating: 4.1,
    tags: ['Archives', 'Research', 'History'],
    openingHours: 'Mon–Fri, 08:00–15:30',
  ),
  _YaoundeSeed(
    id: 'yaounde-national-gallery',
    name: 'National Gallery of Contemporary Art',
    category: PlaceCategory.culture,
    description:
        'An exhibition space for contemporary Cameroonian visual art, rotating shows and cultural programs.',
    latitude: 3.8701,
    longitude: 11.5148,
    rating: 4.2,
    tags: ['Gallery', 'Contemporary art', 'Exhibition'],
  ),
  _YaoundeSeed(
    id: 'yaounde-institut-francais',
    name: 'Institut Français du Cameroun',
    category: PlaceCategory.culture,
    description:
        'A cultural venue hosting cinema, concerts, exhibitions, performances and a public media library.',
    latitude: 3.8695,
    longitude: 11.5168,
    rating: 4.4,
    tags: ['Cinema', 'Concert', 'Library', 'Exhibition'],
  ),
  _YaoundeSeed(
    id: 'yaounde-goethe-institut',
    name: 'Goethe-Institut Kamerun',
    category: PlaceCategory.culture,
    description:
        'A cultural center presenting exhibitions, talks, film, music and international artistic exchange.',
    latitude: 3.8840,
    longitude: 11.5112,
    rating: 4.5,
    tags: ['Culture center', 'Film', 'Music', 'Language'],
  ),
  _YaoundeSeed(
    id: 'yaounde-charles-atangana',
    name: 'Charles Atangana Monument',
    category: PlaceCategory.culture,
    description:
        'A city monument recalling an influential Ewondo leader and a complex period in Cameroon’s colonial history.',
    latitude: 3.8602,
    longitude: 11.5153,
    rating: 4.0,
    tags: ['Monument', 'Ewondo', 'History'],
  ),
  _YaoundeSeed(
    id: 'yaounde-forest-peoples-museum',
    name: 'Forest Peoples Ethnographic Museum',
    category: PlaceCategory.culture,
    description:
        'A focused cultural collection exploring communities, livelihoods and material traditions of the forest zone.',
    latitude: 3.8794,
    longitude: 11.5260,
    rating: 4.3,
    tags: ['Museum', 'Ethnography', 'Forest peoples'],
  ),
  _YaoundeSeed(
    id: 'yaounde-cultural-centre',
    name: 'Cameroon Cultural Centre',
    category: PlaceCategory.culture,
    description:
        'A venue for performances, rehearsals, exhibitions and programs featuring Cameroonian artists.',
    latitude: 3.8682,
    longitude: 11.5217,
    rating: 4.2,
    tags: ['Performance', 'Art', 'Dance', 'Culture center'],
  ),
  _YaoundeSeed(
    id: 'yaounde-la-salsa',
    name: 'La Salsa',
    category: PlaceCategory.restaurant,
    description:
        'A relaxed Yaoundé restaurant serving grilled dishes, pizzas and international favorites.',
    latitude: 3.8924,
    longitude: 11.5154,
    rating: 4.3,
    tags: ['Grill', 'Pizza', 'Terrace', 'Bastos'],
  ),
  _YaoundeSeed(
    id: 'yaounde-le-biniou',
    name: 'Le Biniou',
    category: PlaceCategory.restaurant,
    description:
        'A long-running restaurant known for French-inspired cooking and a quiet dining room.',
    latitude: 3.8878,
    longitude: 11.5151,
    rating: 4.4,
    tags: ['French', 'Dinner', 'Bastos'],
  ),
  _YaoundeSeed(
    id: 'yaounde-bois-ebene',
    name: 'Bois d’Ébène',
    category: PlaceCategory.restaurant,
    description:
        'A garden restaurant combining Cameroonian dishes, grilled meats and a leafy outdoor setting.',
    latitude: 3.8928,
    longitude: 11.5221,
    rating: 4.4,
    tags: ['Cameroonian', 'Garden', 'Grill', 'Local food'],
  ),
  _YaoundeSeed(
    id: 'yaounde-kajazoma',
    name: 'Kajazoma',
    category: PlaceCategory.restaurant,
    description:
        'A contemporary restaurant and arts-oriented venue with seasonal dishes and regular cultural programming.',
    latitude: 3.8911,
    longitude: 11.5099,
    rating: 4.5,
    tags: ['Contemporary', 'Art', 'Dinner', 'Live events'],
  ),
  _YaoundeSeed(
    id: 'yaounde-yao-ba',
    name: 'Yao Ba Restaurant',
    category: PlaceCategory.restaurant,
    description:
        'An Asian dining option in Yaoundé offering noodles, rice dishes, seafood and shared plates.',
    latitude: 3.8892,
    longitude: 11.5128,
    rating: 4.2,
    tags: ['Asian', 'Noodles', 'Seafood'],
  ),
  _YaoundeSeed(
    id: 'yaounde-istanbul',
    name: 'Istanbul Turkish Restaurant',
    category: PlaceCategory.restaurant,
    description:
        'Turkish grills, mezze and generous shared dishes in the Bastos dining district.',
    latitude: 3.8990,
    longitude: 11.5182,
    rating: 4.4,
    tags: ['Turkish', 'Grill', 'Family', 'Bastos'],
  ),
  _YaoundeSeed(
    id: 'yaounde-chez-wou',
    name: 'Chez Wou',
    category: PlaceCategory.restaurant,
    description:
        'A popular Chinese restaurant serving generous classics suitable for groups and family meals.',
    latitude: 3.8838,
    longitude: 11.5122,
    rating: 4.2,
    tags: ['Chinese', 'Groups', 'Family'],
  ),
  _YaoundeSeed(
    id: 'yaounde-o-vive',
    name: 'Ô Vive',
    category: PlaceCategory.restaurant,
    description:
        'A polished restaurant with international cooking, desserts and a calm setting for lunch or dinner.',
    latitude: 3.8917,
    longitude: 11.5169,
    rating: 4.4,
    tags: ['International', 'Dessert', 'Lunch'],
  ),
  _YaoundeSeed(
    id: 'yaounde-la-terrasse',
    name: 'La Terrasse',
    category: PlaceCategory.restaurant,
    description:
        'An open-air dining address for grilled fish, meat, drinks and relaxed evening meals.',
    latitude: 3.8761,
    longitude: 11.5236,
    rating: 4.1,
    tags: ['Terrace', 'Grilled fish', 'Evening'],
  ),
  _YaoundeSeed(
    id: 'yaounde-le-safoutier',
    name: 'Le Safoutier',
    category: PlaceCategory.restaurant,
    description:
        'A hotel restaurant presenting Cameroonian and international dishes with attentive service.',
    latitude: 3.8625,
    longitude: 11.5180,
    rating: 4.3,
    tags: ['Cameroonian', 'International', 'Hotel dining'],
  ),
  _YaoundeSeed(
    id: 'yaounde-platinium-cafe',
    name: 'Platinium Café',
    category: PlaceCategory.restaurant,
    description:
        'A modern café and casual restaurant for coffee, light meals and evening gatherings.',
    latitude: 3.8867,
    longitude: 11.5208,
    rating: 4.1,
    tags: ['Cafe', 'Coffee', 'Casual', 'Evening'],
  ),
  _YaoundeSeed(
    id: 'yaounde-the-famous',
    name: 'The Famous',
    category: PlaceCategory.restaurant,
    description:
        'A lively restaurant-lounge serving contemporary plates and drinks in an urban setting.',
    latitude: 3.8971,
    longitude: 11.5136,
    rating: 4.2,
    tags: ['Lounge', 'Contemporary', 'Nightlife'],
  ),
  _YaoundeSeed(
    id: 'yaounde-zad-snack',
    name: 'ZAD Snack',
    category: PlaceCategory.restaurant,
    description:
        'A practical local favorite for quick meals, grilled chicken, sandwiches and takeaway.',
    latitude: 3.8743,
    longitude: 11.5251,
    rating: 4.0,
    tags: ['Fast food', 'Takeaway', 'Budget'],
  ),
  _YaoundeSeed(
    id: 'yaounde-maison-cafe',
    name: 'La Maison du Café',
    category: PlaceCategory.restaurant,
    description:
        'A coffee-focused stop for breakfast, pastries, conversation and locally roasted flavors.',
    latitude: 3.8870,
    longitude: 11.5177,
    rating: 4.3,
    tags: ['Coffee', 'Breakfast', 'Pastries'],
  ),
  _YaoundeSeed(
    id: 'yaounde-boukarou',
    name: 'Le Boukarou Lounge',
    category: PlaceCategory.restaurant,
    description:
        'A relaxed dining and lounge venue pairing local dishes, grills and evening music.',
    latitude: 3.9023,
    longitude: 11.5213,
    rating: 4.2,
    tags: ['Local food', 'Grill', 'Lounge', 'Music'],
  ),
  _YaoundeSeed(
    id: 'yaounde-hilton',
    name: 'Hilton Yaoundé',
    category: PlaceCategory.hotel,
    description:
        'A central international hotel with restaurants, meeting facilities, pool and city views.',
    latitude: 3.8665,
    longitude: 11.5146,
    rating: 4.4,
    tags: ['Luxury', 'Pool', 'Business', 'City center'],
    priceLabel: 'Premium rates',
  ),
  _YaoundeSeed(
    id: 'yaounde-djeuga-palace',
    name: 'Djeuga Palace Hotel',
    category: PlaceCategory.hotel,
    description:
        'A full-service central hotel with pool, conference spaces and convenient access to government districts.',
    latitude: 3.8728,
    longitude: 11.5155,
    rating: 4.1,
    tags: ['Pool', 'Conference', 'City center'],
  ),
  _YaoundeSeed(
    id: 'yaounde-star-land',
    name: 'Star Land Hotel Bastos',
    category: PlaceCategory.hotel,
    description:
        'A contemporary hotel in Bastos with modern rooms, dining and business-oriented services.',
    latitude: 3.8985,
    longitude: 11.5150,
    rating: 4.4,
    tags: ['Bastos', 'Business', 'Restaurant', 'Modern'],
  ),
  _YaoundeSeed(
    id: 'yaounde-mont-febe-hotel',
    name: 'Hôtel Mont Fébé',
    category: PlaceCategory.hotel,
    description:
        'A landmark hillside hotel known for elevated city views and proximity to Mount Fébé attractions.',
    latitude: 3.9165,
    longitude: 11.4916,
    rating: 4.0,
    tags: ['View', 'Pool', 'Landmark', 'Mount Fébé'],
  ),
  _YaoundeSeed(
    id: 'yaounde-la-falaise',
    name: 'Hôtel La Falaise Yaoundé',
    category: PlaceCategory.hotel,
    description:
        'A central upscale hotel with wellness facilities, dining and rooms for business and leisure stays.',
    latitude: 3.8690,
    longitude: 11.5191,
    rating: 4.3,
    tags: ['Spa', 'Business', 'Restaurant', 'City center'],
  ),
  _YaoundeSeed(
    id: 'yaounde-merina',
    name: 'Hôtel Mérina',
    category: PlaceCategory.hotel,
    description:
        'A renovated central hotel offering a pool, restaurant and practical access to downtown Yaoundé.',
    latitude: 3.8674,
    longitude: 11.5186,
    rating: 4.2,
    tags: ['Pool', 'Restaurant', 'Central'],
  ),
  _YaoundeSeed(
    id: 'yaounde-united-hotel',
    name: 'United Hotel International',
    category: PlaceCategory.hotel,
    description:
        'A modern hospitality address with conference facilities and access to central administrative areas.',
    latitude: 3.8759,
    longitude: 11.5054,
    rating: 4.3,
    tags: ['Business', 'Conference', 'Modern'],
  ),
  _YaoundeSeed(
    id: 'yaounde-hotel-franco',
    name: 'Hôtel Franco',
    category: PlaceCategory.hotel,
    description:
        'A long-established hotel with pool, restaurant and meeting spaces near central neighborhoods.',
    latitude: 3.8819,
    longitude: 11.5163,
    rating: 4.0,
    tags: ['Pool', 'Restaurant', 'Conference'],
  ),
  _YaoundeSeed(
    id: 'yaounde-safyad',
    name: 'Safyad Hotel',
    category: PlaceCategory.hotel,
    description:
        'A comfortable hotel in the Odza area with airport access, dining and leisure facilities.',
    latitude: 3.8049,
    longitude: 11.5349,
    rating: 4.1,
    tags: ['Odza', 'Airport access', 'Pool'],
  ),
  _YaoundeSeed(
    id: 'yaounde-suita',
    name: 'Suita Hotel',
    category: PlaceCategory.hotel,
    description:
        'A boutique-style stay with contemporary rooms and a quieter residential setting.',
    latitude: 3.8860,
    longitude: 11.5034,
    rating: 4.3,
    tags: ['Boutique', 'Quiet', 'Business'],
  ),
  _YaoundeSeed(
    id: 'yaounde-canal-olympia-1',
    name: 'CanalOlympia Yaoundé 1',
    category: PlaceCategory.entertainment,
    description:
        'A cinema and open-air entertainment venue screening films and hosting concerts and community events.',
    latitude: 3.8790,
    longitude: 11.5387,
    rating: 4.3,
    tags: ['Cinema', 'Concert', 'Family', 'Film'],
  ),
  _YaoundeSeed(
    id: 'yaounde-canal-olympia-2',
    name: 'CanalOlympia Yaoundé 2',
    category: PlaceCategory.entertainment,
    description:
        'A modern cinema venue with regular film programming and occasional live events.',
    latitude: 3.8218,
    longitude: 11.5215,
    rating: 4.2,
    tags: ['Cinema', 'Film', 'Entertainment'],
  ),
  _YaoundeSeed(
    id: 'yaounde-sports-palace',
    name: 'Yaoundé Multipurpose Sports Complex',
    category: PlaceCategory.entertainment,
    description:
        'A major indoor arena in Warda hosting basketball, handball, concerts and national events.',
    latitude: 3.8858,
    longitude: 11.5074,
    rating: 4.4,
    tags: ['Sports', 'Arena', 'Concert', 'Warda'],
  ),
  _YaoundeSeed(
    id: 'yaounde-ahmadou-ahidjo-stadium',
    name: 'Ahmadou Ahidjo Stadium',
    category: PlaceCategory.entertainment,
    description:
        'The capital’s historic football stadium and a central venue for major national and international matches.',
    latitude: 3.8867,
    longitude: 11.5400,
    rating: 4.4,
    tags: ['Football', 'Stadium', 'Sport', 'Omnisports'],
  ),
  _YaoundeSeed(
    id: 'yaounde-mundi',
    name: 'Mundi Leisure Park',
    category: PlaceCategory.entertainment,
    description:
        'A family leisure destination outside central Yaoundé with outdoor recreation and event spaces.',
    latitude: 3.7488,
    longitude: 11.5830,
    rating: 4.2,
    tags: ['Leisure', 'Family', 'Outdoor', 'Events'],
  ),
  _YaoundeSeed(
    id: 'yaounde-club-france',
    name: 'Club France Yaoundé',
    category: PlaceCategory.entertainment,
    description:
        'A recreation club with sports, swimming, dining and social activities for members and guests.',
    latitude: 3.8849,
    longitude: 11.5078,
    rating: 4.2,
    tags: ['Club', 'Swimming', 'Sports', 'Dining'],
  ),
  _YaoundeSeed(
    id: 'yaounde-carrefour-warda',
    name: 'Carrefour Market Warda',
    category: PlaceCategory.entertainment,
    description:
        'A central shopping destination for groceries, travel essentials and everyday services.',
    latitude: 3.8841,
    longitude: 11.5095,
    rating: 4.1,
    tags: ['Shopping', 'Supermarket', 'Travel essentials', 'Warda'],
  ),
  _YaoundeSeed(
    id: 'yaounde-central-market',
    name: 'Yaoundé Central Market',
    category: PlaceCategory.entertainment,
    description:
        'A dense city market for textiles, household goods, produce and the rhythms of daily commerce.',
    latitude: 3.8650,
    longitude: 11.5212,
    rating: 4.0,
    tags: ['Market', 'Shopping', 'Textiles', 'Local life'],
    openingHours: 'Mon–Sat, 07:00–18:00',
  ),
  _YaoundeSeed(
    id: 'yaounde-general-hospital',
    name: 'Yaoundé General Hospital',
    category: PlaceCategory.emergency,
    description:
        'A major referral hospital providing specialist care and continuous emergency support.',
    latitude: 3.9101,
    longitude: 11.5274,
    rating: 4.0,
    tags: ['Hospital', 'Emergency', 'Specialist', '24 hours'],
  ),
  _YaoundeSeed(
    id: 'yaounde-gynaeco-hospital',
    name: 'Gynaeco-Obstetric and Paediatric Hospital',
    category: PlaceCategory.emergency,
    description:
        'A specialist public hospital for maternal, reproductive, neonatal and paediatric care.',
    latitude: 3.9109,
    longitude: 11.5353,
    rating: 4.1,
    tags: ['Hospital', 'Maternity', 'Paediatric', 'Emergency'],
  ),
  _YaoundeSeed(
    id: 'yaounde-jamot-hospital',
    name: 'Jamot Hospital',
    category: PlaceCategory.emergency,
    description:
        'A public hospital serving Yaoundé with specialist departments and urgent medical care.',
    latitude: 3.8806,
    longitude: 11.5228,
    rating: 3.9,
    tags: ['Hospital', 'Emergency', 'Public service'],
  ),
  _YaoundeSeed(
    id: 'yaounde-cnps-essos',
    name: 'CNPS Hospital Essos',
    category: PlaceCategory.emergency,
    description:
        'A well-known hospital in Essos providing consultations, diagnostics and emergency services.',
    latitude: 3.8757,
    longitude: 11.5416,
    rating: 4.0,
    tags: ['Hospital', 'Clinic', 'Emergency', 'Essos'],
  ),
  _YaoundeSeed(
    id: 'yaounde-cite-verte-hospital',
    name: 'Cité Verte District Hospital',
    category: PlaceCategory.emergency,
    description:
        'A district-level public hospital supporting communities in western Yaoundé.',
    latitude: 3.8856,
    longitude: 11.4859,
    rating: 3.8,
    tags: ['Hospital', 'District', 'Emergency'],
  ),
  _YaoundeSeed(
    id: 'yaounde-efoulan-hospital',
    name: 'Efoulan District Hospital',
    category: PlaceCategory.emergency,
    description:
        'A public district hospital serving southern Yaoundé with general and emergency care.',
    latitude: 3.8338,
    longitude: 11.5118,
    rating: 3.8,
    tags: ['Hospital', 'District', 'Emergency', 'Efoulan'],
  ),
  _YaoundeSeed(
    id: 'yaounde-djoungolo-hospital',
    name: 'Djoungolo District Hospital',
    category: PlaceCategory.emergency,
    description:
        'A central district hospital offering general consultations and urgent medical services.',
    latitude: 3.8786,
    longitude: 11.5309,
    rating: 3.9,
    tags: ['Hospital', 'District', 'Emergency'],
  ),
  _YaoundeSeed(
    id: 'yaounde-pharmacy-bastos',
    name: 'Bastos Pharmacy',
    category: PlaceCategory.emergency,
    description:
        'A pharmacy serving the Bastos area with medicines, health essentials and pharmacist advice.',
    latitude: 3.8964,
    longitude: 11.5147,
    rating: 4.2,
    tags: ['Pharmacy', 'Medicine', 'Bastos'],
    openingHours: 'Open daily, extended hours',
  ),
  _YaoundeSeed(
    id: 'yaounde-fire-mimboman',
    name: 'Mimboman Fire and Rescue Station',
    category: PlaceCategory.emergency,
    description:
        'A fire and rescue service point supporting eastern districts of Yaoundé.',
    latitude: 3.8668,
    longitude: 11.5677,
    rating: 4.0,
    tags: ['Fire station', 'Rescue', 'Emergency'],
  ),
  _YaoundeSeed(
    id: 'yaounde-central-police',
    name: 'Yaoundé Central Police Station No. 1',
    category: PlaceCategory.emergency,
    description:
        'A central police service point for assistance, incident reporting and public safety support.',
    latitude: 3.8658,
    longitude: 11.5176,
    rating: 3.8,
    tags: ['Police', 'Safety', 'Emergency', 'City center'],
  ),
];
