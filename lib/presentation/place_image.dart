import 'package:flutter/material.dart';
import 'package:nyetam/domain/place.dart';

class PlaceImage extends StatelessWidget {
  const PlaceImage({
    super.key,
    required this.place,
    required this.height,
    this.width = double.infinity,
  });

  final Place place;
  final double width;
  final double height;

  static const _assets = <String, String>{
    'ebogo': 'images/Ebogo ecoutourism.webp',
    'sawa-table': 'images/La table Sawa.webp',
    'national-museum': 'images/National Museum.webp',
    'central-hospital': 'images/Yaounde Central Hospital.webp',
    'adamawa-tello-falls': 'images/Tello Falls.webp',
    'adamawa-vina-falls': 'images/vina falls.webp',
    'adamawa-lamidat-ngaoundere': 'images/Lamidat of ngoundere.webp',
    'adamawa-lake-mbalang': 'images/Lake Mbalang.webp',
    'east-lobeke': 'images/lobeke national park.webp',
    'east-boumba-bek': 'images/boumba National park.webp',
    'east-nki': 'images/niki National park.webp',
    'far-north-waza': 'images/waza National PArk.webp',
    'far-north-rhumsiki': 'images/rhumsiki and the Mandara Mountain.webp',
    'far-north-mora-massif': 'images/Mora Massif.webp',
    'far-north-maroua-craft': 'images/maroua artisan centre.webp',
    'north-west-bafut-palace': 'images/bafut palace.webp',
    'north-west-lake-awing': 'images/lake Awing.webp',
    'north-west-menchum-falls': 'images/Mechum Falls.webp',
    'west-foumban-palace': 'images/foumball Royal Place.webp',
    'west-museum-civilizations': 'images/museum of civilisation.webp',
    'west-lake-baleng': 'images/Lake baleng.webp',
    'west-mami-wata-falls': 'images/mami wata Falls.webp',
    'yaounde-bois-sainte-anastasie': 'images/Bois Sainte Anastasie.webp',
    'yaounde-municipal-lake': 'images/Yaounde Municipal Lake.webp',
    'yaounde-mount-febe': 'images/Mount Febe Viewpoint.webp',
    'yaounde-mount-eloundem': 'images/mont-eloundem.webp',
    'yaounde-ecopark-ahala': 'images/ECOPARK.webp',
    'yaounde-mvog-betsi-zoo': 'images/Mvog Betsi Zoo.webp',
  };

  @override
  Widget build(BuildContext context) {
    final asset = _assets[place.id];
    Widget imageErrorBuilder(
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
    ) => Container(
      width: width,
      height: height,
      color: Colors.black12,
      child: Icon(place.category.icon),
    );

    if (asset != null) {
      return Image.asset(
        asset,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: imageErrorBuilder,
      );
    }

    return Image.network(
      place.imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: imageErrorBuilder,
    );
  }
}
