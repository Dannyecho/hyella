import 'package:flutter/material.dart';
import 'package:hyella/models/doctor_model.dart';
import '../helper/colors.dart';

class DoctorItem extends StatelessWidget {
  final Doctor doctor;
  DoctorItem({required this.doctor});

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        elevation: 2,
        shadowColor: Colors.black12,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: _width * .01),
        child: Container(
          width: _width * .45,
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
                backgroundColor: avatarBgColor,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                doctor.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                doctor.specialty,
                style: TextStyle(color: Colors.blueGrey, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                  color: Color(0xffFEF8EA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 18,
                      color: getColor(doctor.rating!.round()),
                    ),
                    Text(doctor.rating.toString())
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color getColor(int? star) {
    switch (star) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.redAccent;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.grey;
      case 5:
        return Colors.orangeAccent;
      default:
        return Colors.orange;
    }
  }
}
