import 'package:nyetam/domain/place.dart';
import 'package:nyetam/domain/tourism_event.dart';

abstract interface class EventRepository {
  Future<List<TourismEvent>> getUpcomingEvents();
}

class DemoEventRepository implements EventRepository {
  @override
  Future<List<TourismEvent>> getUpcomingEvents() async => _events;

  static const _events = <TourismEvent>[
    TourismEvent(
      id: 'ngondo-festival',
      name: 'Ngondo Festival',
      description:
          'A major Sawa cultural gathering on the Wouri River featuring canoe races, traditional rites, music and coastal cuisine.',
      city: 'Douala',
      region: 'Littoral',
      dateLabel: '06 DEC',
      startTime: '08:00',
      venue: 'Wouri riverfront',
      organizer: 'Ngondo General Assembly',
      ticketLabel: 'Public access',
      imageUrl:
          'https://images.unsplash.com/photo-1504609813442-a8924e83f76e?auto=format&fit=crop&w=1400&q=85',
      coordinates: GeoPoint(4.0721, 9.7085),
      category: 'Culture',
    ),
    TourismEvent(
      id: 'mount-cameroon-race',
      name: 'Race of Hope',
      description:
          'Athletes from Cameroon and beyond race from Buea toward the summit of Mount Cameroon and back.',
      city: 'Buea',
      region: 'South-West',
      dateLabel: '21 FEB',
      startTime: '06:30',
      venue: 'Molyko Stadium',
      organizer: 'Cameroon Athletics Federation',
      ticketLabel: 'Spectator access free',
      imageUrl:
          'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?auto=format&fit=crop&w=1400&q=85',
      coordinates: GeoPoint(4.1591, 9.2789),
      category: 'Sport',
    ),
    TourismEvent(
      id: 'ecrans-noirs',
      name: 'Ecrans Noirs',
      description:
          'Central Africa’s film festival brings screenings, workshops and conversations with filmmakers to Yaoundé.',
      city: 'Yaoundé',
      region: 'Centre',
      dateLabel: '18 OCT',
      startTime: '17:00',
      venue: 'Palais des Congrès',
      organizer: 'Ecrans Noirs Association',
      ticketLabel: 'From 2,000 FCFA',
      imageUrl:
          'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=1400&q=85',
      coordinates: GeoPoint(3.8885, 11.5002),
      category: 'Film',
    ),
  ];
}
