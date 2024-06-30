class Photo {
  final String fullName;
  final String walletNumber;
  final String dhName;

  Photo.fromJsonMap(Map<String, dynamic> map)
      : fullName = map['fullName'],
        walletNumber = map['walletNumber'],
        dhName = map['dhName'];
}
