import 'package:nyetam/domain/tour_guide.dart';

abstract interface class GuideRepository {
  Future<List<TourGuide>> getVerifiedGuides();
  Future<void> submitInquiry(GuideInquiry inquiry);
}

class DemoGuideRepository implements GuideRepository {
  final List<GuideInquiry> _inquiries = [];

  @override
  Future<List<TourGuide>> getVerifiedGuides() async => _guides;

  @override
  Future<void> submitInquiry(GuideInquiry inquiry) async {
    _inquiries.add(inquiry);
  }

  static const _guides = <TourGuide>[
    TourGuide(
      id: 'guide-estelle',
      name: 'Estelle Manka',
      city: 'Buea',
      region: 'South-West',
      bio:
          'Mountain and nature guide specializing in Mount Cameroon, village walks and responsible wildlife encounters.',
      imageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=900&q=85',
      languages: ['English', 'French', 'Pidgin English'],
      areasCovered: ['Buea', 'Limbe', 'Mount Cameroon'],
      services: ['Mountain treks', 'Nature walks', 'Airport welcome'],
      yearsExperience: 8,
      priceLabel: 'From 35,000 FCFA/day',
      rating: 4.9,
      reviewCount: 86,
      isVerified: true,
    ),
    TourGuide(
      id: 'guide-alain',
      name: 'Alain Mvondo',
      city: 'Yaoundé',
      region: 'Centre',
      bio:
          'Cultural historian offering museum visits, architecture walks and day trips along the Nyong River.',
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=900&q=85',
      languages: ['French', 'English', 'Ewondo'],
      areasCovered: ['Yaoundé', 'Mbalmayo', 'Ebogo'],
      services: ['City tours', 'Museum visits', 'Cultural interpretation'],
      yearsExperience: 11,
      priceLabel: 'From 28,000 FCFA/day',
      rating: 4.8,
      reviewCount: 124,
      isVerified: true,
    ),
    TourGuide(
      id: 'guide-clarisse',
      name: 'Clarisse Ewane',
      city: 'Kribi',
      region: 'South',
      bio:
          'Coastal guide connecting travelers with waterfalls, fishing communities, local cuisine and forest excursions.',
      imageUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=900&q=85',
      languages: ['French', 'English', 'Batanga'],
      areasCovered: ['Kribi', 'Lobé', 'Campo'],
      services: ['Coastal tours', 'Food experiences', 'Community visits'],
      yearsExperience: 7,
      priceLabel: 'From 30,000 FCFA/day',
      rating: 4.9,
      reviewCount: 73,
      isVerified: true,
    ),
    TourGuide(
      id: 'guide-ibrahim',
      name: 'Ibrahim Dairou',
      city: 'Maroua',
      region: 'Far North',
      bio:
          'Northern Cameroon specialist for heritage markets, craft traditions and guided landscapes around the Mandara Mountains.',
      imageUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=900&q=85',
      languages: ['French', 'Fulfulde', 'Arabic'],
      areasCovered: ['Maroua', 'Mora', 'Rhumsiki'],
      services: ['Heritage tours', 'Craft visits', 'Landscape excursions'],
      yearsExperience: 13,
      priceLabel: 'From 32,000 FCFA/day',
      rating: 4.8,
      reviewCount: 98,
      isVerified: true,
    ),
  ];
}
