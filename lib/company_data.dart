class CompanyData {
  static const String defaultPassword = '12345678';
  static const String defaultRole = 'employee';
  
  static const Map<String, dynamic> mainOffice = {
    "name": "Main Office",
    "latitude": 19.1176638,
    "longitude": 72.9942542,
  };
  
  static const List<Map<String, dynamic>> offsiteLocations = [
    {
      "name": "Manish Office",
      "latitude": 19.1176638,
      "longitude": 72.9942542,
    },
    {
      "name": "Aman Office",
      "latitude": 19.076048,
      "longitude": 72.991755,
    },
    // Add more offsite locations as needed
  ];

  static List<Map<String, dynamic>> get allLocations => [mainOffice, ...offsiteLocations];

  static Map<String, dynamic>? findLocationByName(String name) {
    return allLocations.firstWhere(
      (location) => location["name"] == name,
      orElse: () => {},
    );
  }

  static bool isValidLocation(double latitude, double longitude) {
    return allLocations.any(
      (location) => location["latitude"] == latitude && location["longitude"] == longitude
    );
  }
}