import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/domain/place.dart';
import 'package:nyetam/presentation/cameroon_map.dart';

void main() {
  test('projects northern and eastern coordinates correctly', () {
    const size = Size(400, 700);
    final north = CameroonMapProjection.project(
      const GeoPoint(11.3, 14.6),
      size,
    );
    final south = CameroonMapProjection.project(const GeoPoint(2.8, 9.9), size);

    expect(north.dy, lessThan(south.dy));
    expect(north.dx, greaterThan(south.dx));
    expect(north.dx, inInclusiveRange(0, size.width));
    expect(south.dy, inInclusiveRange(0, size.height));
  });
}
