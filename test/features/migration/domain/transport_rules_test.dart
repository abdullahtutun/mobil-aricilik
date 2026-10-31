import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/migration/domain/transport.dart';
import 'package:mobil_arici/features/migration/domain/transport_rules.dart';

final _at = DateTime.utc(2026, 11, 15, 18);

Hive _hive(String id, String number, {HiveStatus? status}) => Hive(
  id: id,
  orgId: 'org-1',
  number: number,
  type: HiveType.langstroth,
  apiaryId: 'cam',
  status: status ?? HiveStatus.active,
  createdAt: _at,
  updatedAt: _at,
);

TransportItem _item(
  String hiveId, {
  String vehicle = 'Kamyon 1',
  int loadedMinute = 0,
  int? unloadedMinute,
}) => TransportItem(
  id: 'item-$hiveId',
  orgId: 'org-1',
  transportId: 'transport-1',
  hiveId: hiveId,
  vehicle: vehicle,
  loadedAt: _at.add(Duration(minutes: loadedMinute)),
  unloadedAt: unloadedMinute == null
      ? null
      : _at.add(Duration(hours: 6, minutes: unloadedMinute)),
  createdAt: _at,
  updatedAt: _at,
);

void main() {
  final transport = Transport(
    id: 'transport-1',
    orgId: 'org-1',
    sourceApiaryId: 'cam',
    destinationApiaryId: 'kislak',
    vehicles: const ['Kamyon 1', 'Kamyon 2', 'Römork'],
    createdAt: _at,
    updatedAt: _at,
  );

  test('araç başına yüklü kovan; boş araç 0, listede olmayan araç '
      'sonda', () {
    expect(
      loadedPerVehicle(transport, [
        _item('a', vehicle: 'Kamyon 2'),
        _item('b'),
        _item('c', vehicle: 'Kamyon 2'),
        _item('d', vehicle: 'Pikap'),
      ]),
      {'Kamyon 1': 1, 'Kamyon 2': 2, 'Römork': 0, 'Pikap': 1},
    );
  });

  test('okutulmamış kovanlar: aktif ve taşımada olmayanlar, numara '
      'sırasıyla', () {
    final hives = [
      _hive('h10', '10'),
      _hive('h2', '2'),
      _hive('h3', '3'),
      _hive('dead', '1', status: HiveStatus.dead),
    ];
    final items = [_item('h3'), _item('stray')];

    expect(hivesNotLoaded(hives, items).map((h) => h.number), ['2', '10']);
    // 2 yüklü (biri başka yerden) + 2 okutulmamış.
    expect(expectedLoadCount(hives, items), 4);
  });

  test('indirilmemiş kovanlar yüklenme sırasıyla', () {
    final items = [
      _item('b', loadedMinute: 2),
      _item('a', loadedMinute: 1),
      _item('c', loadedMinute: 3, unloadedMinute: 1),
    ];

    expect(itemsNotUnloaded(items).map((i) => i.hiveId), ['a', 'b']);
  });

  test('son okutulan: yüklemede en son yüklenen, indirmede en son '
      'indirilen', () {
    final items = [
      _item('a', loadedMinute: 1, unloadedMinute: 5),
      _item('b', loadedMinute: 3, unloadedMinute: 2),
      _item('c', loadedMinute: 2),
    ];

    expect(lastScanned(items, unloading: false)!.hiveId, 'b');
    expect(lastScanned(items, unloading: true)!.hiveId, 'a');
    expect(lastScanned([_item('c')], unloading: true), isNull);
    expect(lastScanned(const [], unloading: false), isNull);
  });

  test('numarayla kovan: boşluk ve harf büyüklüğü gözetilmez, aktif '
      'öne geçer', () {
    final hives = [
      _hive('old', '140', status: HiveStatus.sold),
      _hive('new', '140'),
      _hive('a', 'A-7'),
    ];

    expect(hiveByNumber(hives, ' 140 ')!.id, 'new');
    expect(hiveByNumber(hives, 'a-7')!.id, 'a');
    expect(hiveByNumber(hives, '999'), isNull);
    expect(hiveByNumber(hives, ' '), isNull);
  });
}
