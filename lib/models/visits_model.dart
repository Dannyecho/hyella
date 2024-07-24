class VisitModel {
  String time;
  String date;
  String? patientImage;
  String? name;
  String phone;
  String docSpec;
  String? address;

  VisitModel({
    required this.date,
    required this.phone,
    required this.docSpec,
    required this.time,
    this.address,
    this.name,
     this.patientImage,

  });
}
