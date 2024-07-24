import 'package:flutter/material.dart';
import 'package:hyella/helper/styles.dart';
import 'package:hyella/providers/schedule_provider.dart';
import 'package:provider/provider.dart';

class ErrorGettingAppointment extends StatelessWidget {
  const ErrorGettingAppointment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Styles.regular(
            "Unable to get data at the moment\nplease try again later.",
            align: TextAlign.center),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<ScheduleProvider>(context, listen: false)
                .getSchedules();
          },
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor)),
          child: Text(
            "Retry",
          ),
        )
      ],
    );
  }
}
