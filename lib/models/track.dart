class Track {
  final String circuitName;
  final String location;
  final String country;
  final String length;
  final String raceDistance;
  final int laps;
  final String lapRecord;
  final String lapRecordHolder;
  final String lapRecordYear;
  final String coordinates;
  final String trackImagePath;

  // Nouveaux champs modernes
  final int corners;
  final int drsZones;
  final String circuitType; // Street / Permanent / Hybrid
  final int topSpeed; // km/h

  // Données techniques (1 à 5)
  final int traction;
  final int braking;
  final int lateral;
  final int tyreStress;
  final int downforce;

  Track({
    required this.circuitName,
    required this.location,
    required this.country,
    required this.length,
    required this.raceDistance,
    required this.laps,
    required this.lapRecord,
    required this.lapRecordHolder,
    required this.lapRecordYear,
    required this.coordinates,
    required this.trackImagePath,
    required this.corners,
    required this.drsZones,
    required this.circuitType,
    required this.topSpeed,
    required this.traction,
    required this.braking,
    required this.lateral,
    required this.tyreStress,
    required this.downforce,
  });
}