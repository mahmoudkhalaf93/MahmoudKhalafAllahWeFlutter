class OfferModel {
  final String id;
  final String title;
  final String description;
  final double discount;
  final String image;
  final bool isActive;
  final bool isTimeCalendar;
  final String nameline1;
  final String nameline1Ar;
  final String nameline2;
  final String nameline2Ar;
  final String time;
  final String timeAr;

  OfferModel({
    required this.id,
    this.title = '',
    this.description = '',
    this.discount = 0,
    this.image = '',
    this.isActive = true,
    this.isTimeCalendar = false,
    this.nameline1 = '',
    this.nameline1Ar = '',
    this.nameline2 = '',
    this.nameline2Ar = '',
    this.time = '',
    this.timeAr = '',
  });

  factory OfferModel.fromJson(Map<String, dynamic> json, String id) {
    return OfferModel(
      id: id,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      discount: (json['discount'] is num)
          ? (json['discount'] as num).toDouble()
          : double.tryParse(json['discount']?.toString() ?? '0') ?? 0.0,
      image: json['image']?.toString() ?? '',
      isActive: json['isActive'] ?? true,
      isTimeCalendar: json['isTimeCalendar'] ?? false,
      nameline1: json['nameline1']?.toString() ?? '',
      nameline1Ar: json['nameline1Ar']?.toString() ?? '',
      nameline2: json['nameline2']?.toString() ?? '',
      nameline2Ar: json['nameline2Ar']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      timeAr: json['timeAr']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'discount': discount,
      'image': image,
      'isActive': isActive,
      'isTimeCalendar': isTimeCalendar,
      'nameline1': nameline1,
      'nameline1Ar': nameline1Ar,
      'nameline2': nameline2,
      'nameline2Ar': nameline2Ar,
      'time': time,
      'timeAr': timeAr,
    };
  }

  OfferModel copyWith({
    String? id,
    String? title,
    String? description,
    double? discount,
    String? image,
    bool? isActive,
    bool? isTimeCalendar,
    String? nameline1,
    String? nameline1Ar,
    String? nameline2,
    String? nameline2Ar,
    String? time,
    String? timeAr,
  }) {
    return OfferModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      discount: discount ?? this.discount,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      isTimeCalendar: isTimeCalendar ?? this.isTimeCalendar,
      nameline1: nameline1 ?? this.nameline1,
      nameline1Ar: nameline1Ar ?? this.nameline1Ar,
      nameline2: nameline2 ?? this.nameline2,
      nameline2Ar: nameline2Ar ?? this.nameline2Ar,
      time: time ?? this.time,
      timeAr: timeAr ?? this.timeAr,
    );
  }
}
