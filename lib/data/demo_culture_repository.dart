import 'package:nyetam/domain/culture_article.dart';

abstract interface class CultureRepository {
  Future<List<CultureArticle>> getArticles();
}

class DemoCultureRepository implements CultureRepository {
  @override
  Future<List<CultureArticle>> getArticles() async => _articles;

  static const _articles = <CultureArticle>[
    CultureArticle(
      id: 'ndole-table',
      name: 'Ndolé and the shared table',
      subtitle: 'Understanding Cameroon’s celebrated bitterleaf dish',
      region: 'Littoral',
      topic: CultureTopic.food,
      introduction:
          'Ndolé brings together bitter leaves, groundnuts, spices and often beef, fish or prawns. It is closely associated with the Sawa people and is served across Cameroon for family meals and celebrations.',
      sections: [
        CultureSection(
          title: 'What to expect',
          content:
              'The bitterness is carefully balanced by a rich groundnut sauce. It is commonly served with plantain, miondo or bobolo.',
        ),
        CultureSection(
          title: 'At the table',
          content:
              'Accepting a shared plate is a gesture of welcome. Ask before photographing a private meal or its preparation.',
        ),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=1400&q=85',
      readMinutes: 4,
    ),
    CultureArticle(
      id: 'greetings',
      name: 'Greetings before business',
      subtitle: 'A respectful start to conversations across Cameroon',
      region: 'All regions',
      topic: CultureTopic.customs,
      introduction:
          'A greeting is more than a formality. Taking time to acknowledge people before asking a question or beginning business communicates respect.',
      sections: [
        CultureSection(
          title: 'French and English',
          content:
              'Bonjour and good morning are widely understood. In smaller communities, learning a local greeting is warmly appreciated.',
        ),
        CultureSection(
          title: 'Respect for elders',
          content:
              'Use formal address until invited to do otherwise and allow elders to be greeted first in group settings.',
        ),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=1400&q=85',
      readMinutes: 3,
    ),
    CultureArticle(
      id: 'bamoun-kingdom',
      name: 'The Bamoun Kingdom',
      subtitle: 'Palace history, script and artistic heritage in Foumban',
      region: 'West',
      topic: CultureTopic.history,
      introduction:
          'Foumban is the historic center of the Bamoun Kingdom. Its palace, museum and artisan quarter preserve a distinctive political and artistic legacy.',
      sections: [
        CultureSection(
          title: 'Sultan Njoya',
          content:
              'Sultan Ibrahim Njoya developed the Shümom script and supported innovation in administration, architecture and historical record keeping.',
        ),
        CultureSection(
          title: 'Visiting respectfully',
          content:
              'Follow palace photography rules and use recognized local guides when exploring royal history and sacred objects.',
        ),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1564399579883-451a5d44ec08?auto=format&fit=crop&w=1400&q=85',
      readMinutes: 6,
    ),
    CultureArticle(
      id: 'cameroon-languages',
      name: 'A country of many languages',
      subtitle: 'French, English, Cameroonian Pidgin and local languages',
      region: 'All regions',
      topic: CultureTopic.language,
      introduction:
          'Cameroon has two official languages and hundreds of local languages. The language used around you changes by region, city and social setting.',
      sections: [
        CultureSection(
          title: 'Useful approach',
          content:
              'Begin with the official language commonly used in the area, speak clearly and ask politely which language your host prefers.',
        ),
        CultureSection(
          title: 'Pidgin English',
          content:
              'Cameroonian Pidgin English is widely used in the North-West, South-West and many urban communities.',
        ),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1521295121783-8a321d551ad2?auto=format&fit=crop&w=1400&q=85',
      readMinutes: 5,
    ),
    CultureArticle(
      id: 'grassfields-craft',
      name: 'Craft of the Grassfields',
      subtitle: 'Beadwork, carving and symbols of the western highlands',
      region: 'North-West',
      topic: CultureTopic.arts,
      introduction:
          'Royal beadwork, carved stools, masks and textiles carry social and spiritual meaning throughout the Cameroon Grassfields.',
      sections: [
        CultureSection(
          title: 'More than decoration',
          content:
              'Patterns and materials can indicate rank, lineage or ceremonial purpose. Ask an artisan about meaning before treating an object as a souvenir.',
        ),
        CultureSection(
          title: 'Buying responsibly',
          content:
              'Choose contemporary work directly from recognized artisans and avoid objects described as sacred or removed from community use.',
        ),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1561214115-f2f134cc4912?auto=format&fit=crop&w=1400&q=85',
      readMinutes: 5,
    ),
  ];
}
