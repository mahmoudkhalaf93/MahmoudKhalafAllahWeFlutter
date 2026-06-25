class OfferModel {
  final String? nameline1;
  final String? nameline1Ar;
  final String? nameline2;
  final String? nameline2Ar;
  final String? image;
  final String? time;
  final String? timeAr;
  final bool? isTimeCalendar;
  final String? firebaseId;

  OfferModel({
    this.nameline1,
    this.nameline1Ar,
    this.nameline2,
    this.nameline2Ar,
    this.image,
    this.time,
    this.timeAr,
    this.isTimeCalendar,
    this.firebaseId,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json, String id) {
    return OfferModel(
      nameline1: json['nameline1'],
      nameline1Ar: json['nameline1Ar'],
      nameline2: json['nameline2'],
      nameline2Ar: json['nameline2Ar'],
      image: json['image'],
      time: json['time'],
      timeAr: json['timeAr'],
      isTimeCalendar: json['isTimeCalendar'] ?? false,
      firebaseId: id,
    );
  }
}
