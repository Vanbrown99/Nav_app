import 'package:nyetam/domain/place.dart';

class CameroonRegion {
  const CameroonRegion({
    required this.id,
    required this.name,
    required this.capital,
    required this.tagline,
    required this.center,
  });

  final String id;
  final String name;
  final String capital;
  final String tagline;
  final GeoPoint center;
}

const cameroonRegions = <CameroonRegion>[
  CameroonRegion(
    id: 'adamawa',
    name: 'Adamawa',
    capital: 'Ngaoundéré',
    tagline: 'High plateaus and waterfalls',
    center: GeoPoint(7.3167, 13.5833),
  ),
  CameroonRegion(
    id: 'centre',
    name: 'Centre',
    capital: 'Yaoundé',
    tagline: 'Capital culture and rainforest',
    center: GeoPoint(3.8667, 11.5167),
  ),
  CameroonRegion(
    id: 'east',
    name: 'East',
    capital: 'Bertoua',
    tagline: 'Deep forest and wildlife',
    center: GeoPoint(4.5833, 13.6833),
  ),
  CameroonRegion(
    id: 'far-north',
    name: 'Far North',
    capital: 'Maroua',
    tagline: 'Sahel landscapes and heritage',
    center: GeoPoint(10.5910, 14.3159),
  ),
  CameroonRegion(
    id: 'littoral',
    name: 'Littoral',
    capital: 'Douala',
    tagline: 'River, coast and city energy',
    center: GeoPoint(4.0511, 9.7679),
  ),
  CameroonRegion(
    id: 'north',
    name: 'North',
    capital: 'Garoua',
    tagline: 'Savannah and national parks',
    center: GeoPoint(9.3014, 13.3977),
  ),
  CameroonRegion(
    id: 'north-west',
    name: 'North-West',
    capital: 'Bamenda',
    tagline: 'Grassfields and royal traditions',
    center: GeoPoint(5.9631, 10.1591),
  ),
  CameroonRegion(
    id: 'west',
    name: 'West',
    capital: 'Bafoussam',
    tagline: 'Kingdoms, lakes and craft',
    center: GeoPoint(5.4781, 10.4170),
  ),
  CameroonRegion(
    id: 'south',
    name: 'South',
    capital: 'Ebolowa',
    tagline: 'Atlantic beaches and forest',
    center: GeoPoint(2.9167, 11.1500),
  ),
  CameroonRegion(
    id: 'south-west',
    name: 'South-West',
    capital: 'Buea',
    tagline: 'Volcano, coast and rainforest',
    center: GeoPoint(4.1667, 9.2333),
  ),
];
