class Doctor {
  String name;
  String specialty;
  String id;
  double? rating;
  String? description;
  String hospital;
  String location;
  String cPrice;

  Doctor(
      {required this.name,
      required this.specialty,
      required this.id,
      required this.rating,
      required this.description,
      required this.hospital,
      required this.cPrice,
      required this.location});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'id': id,
      "rating": rating,
      "cPrice": cPrice,
      "description": description,
      "hospital": hospital,
      "location": location
    };
  }

  factory Doctor.fromMap(Map map) {
    return Doctor(
      name: map['name'],
      specialty: map['specialty'],
      id: map['Id'],
      cPrice: map["cPrice"],
      rating: map['rating'],
      hospital: map['hospital'],
      location: map['location'],
      description: map['description'],
    );
  }
}
