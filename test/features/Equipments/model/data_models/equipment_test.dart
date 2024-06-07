import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pfe_gmao/features/Equipments/model/data_models/equipment.dart';

void main() {
  late Equipment equipment;
  late Timestamp now;

  setUp(() {
    //Instance if Timestamp for testing
    now = Timestamp.now();
    //Instance of equipment for testing
    equipment = Equipment(
      id: '1',
      TagName: 'TagName',
      Description: 'Description',
      Status: 'Status',
      Priority: 'Priority',
      Area: 'Area',
      CreatedOn: now,
      UpdatedOn: now,
      Discipline: 'Discipline',
      Workshop: 'Workshop',
      Photo: 'Photo',
      Longitude: 'Longitude',
      Latitude: 'Latitude',
      userManual: 'userManual',
      contract: 'contract',
    );
  });

  //Testing equipment constructor
  test('should create an instance of Equipment', () {
    expect(equipment.id, '1');
    expect(equipment.TagName, 'TagName');
    expect(equipment.Description, 'Description');
    expect(equipment.Status, 'Status');
    expect(equipment.Priority, 'Priority');
    expect(equipment.Area, 'Area');
    expect(equipment.CreatedOn, now);
    expect(equipment.UpdatedOn, now);
    expect(equipment.Discipline, 'Discipline');
    expect(equipment.Workshop, 'Workshop');
    expect(equipment.Photo, 'Photo');
    expect(equipment.Longitude, 'Longitude');
    expect(equipment.Latitude, 'Latitude');
    expect(equipment.userManual, 'userManual');
    expect(equipment.contract, 'contract');
  });

  //Testing equipment from JSON methode
  test('should create an Equipment instance from JSON', () {
    final json = {
      'id': '1',
      'TagName': 'TagName',
      'Description': 'Description',
      'Status': 'Status',
      'Priority': 'Priority',
      'Area': 'Area',
      'CreatedOn': now,
      'UpdatedOn': now,
      'Discipline': 'Discipline',
      'Workshop': 'Workshop',
      'Photo': 'Photo',
      'Longitude': 'Longitude',
      'Latitude': 'Latitude',
      'userManual': 'userManual',
      'contract': 'contract',
    };

    final equipmentFromJson = Equipment.fromJSON(json);

    expect(equipmentFromJson.id, '1');
    expect(equipmentFromJson.TagName, 'TagName');
    expect(equipmentFromJson.Description, 'Description');
    expect(equipmentFromJson.Status, 'Status');
    expect(equipmentFromJson.Priority, 'Priority');
    expect(equipmentFromJson.Area, 'Area');
    expect(equipmentFromJson.CreatedOn, now);
    expect(equipmentFromJson.UpdatedOn, now);
    expect(equipmentFromJson.Discipline, 'Discipline');
    expect(equipmentFromJson.Workshop, 'Workshop');
    expect(equipmentFromJson.Photo, 'Photo');
    expect(equipmentFromJson.Longitude, 'Longitude');
    expect(equipmentFromJson.Latitude, 'Latitude');
    expect(equipmentFromJson.userManual, 'userManual');
    expect(equipmentFromJson.contract, 'contract');
  });

  test('should convert an Equipment instance to JSON', () {
    final json = equipment.toJson();

    expect(json['id'], '1');
    expect(json['TagName'], 'TagName');
    expect(json['Description'], 'Description');
    expect(json['Status'], 'Status');
    expect(json['Priority'], 'Priority');
    expect(json['Area'], 'Area');
    expect(json['CreatedOn'], now);
    expect(json['UpdatedOn'], now);
    expect(json['Discipline'], 'Discipline');
    expect(json['WorkShop'], 'Workshop');
    expect(json['Photo'], 'Photo');
    expect(json['Longitude'], 'Longitude');
    expect(json['Latitude'], 'Latitude');
    expect(json['userManual'], 'userManual');
    expect(json['contract'], 'contract');
  });
}
