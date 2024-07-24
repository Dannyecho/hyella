class PatientsModel {
  String number;
  String name;
  String doctor;
  String? phone;
  String? address;
  String? docSpec;

  PatientsModel(
      {required this.doctor,
      required this.name,
      required this.number,
      this.address,
      this.phone, this.docSpec});
}
