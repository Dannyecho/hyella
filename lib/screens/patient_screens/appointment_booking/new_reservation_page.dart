import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hyella/helper/constants.dart';
import 'package:hyella/helper/general_loader.dart';
import 'package:hyella/helper/scaffold_messg.dart';
import 'package:hyella/models/avail_timeslot_response.dart';
import 'package:hyella/models/doctors_list_response_model.dart';
import 'package:hyella/models/pre_payment_model.dart';
import 'package:hyella/models/schedule_model.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/providers/appointment_provider.dart';
import 'package:hyella/providers/doctors_provider.dart';
import 'package:hyella/providers/schedule_provider.dart';
import 'package:hyella/screens/patient_screens/appointment_booking/webview.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/appt_venues_resp_model.dart';

class NewReservation extends StatefulWidget {
  final String? specialtyId;
  final List<SpecialtyModel> specialties;
  final ScheduleModel? oldSchedule;
  NewReservation(
      {Key? key, this.specialtyId, required this.specialties, this.oldSchedule})
      : super(key: key);

  @override
  _NewReservationState createState() => _NewReservationState();
}

class _NewReservationState extends State<NewReservation> {
  DateTime? selectedDate;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  final String currency = 'NGN';

  TextEditingController doctorNameController = TextEditingController(text: "");
  TextEditingController remarkController = TextEditingController(text: "");

  String doctorId = '';

  int _currentStep = 0;

  String doctorListTitle = "Select Doctor";
  List<DoctorModel> doctors = [];
  bool loadingDoctorsList = true;
  bool errorLoadingDoctorList = false;
  String doctorListErrorMessage = "";

  String venueSectionTitle = "";
  List<VenueModel> venues = [];
  bool loadingVenues = true;
  bool errorLoadingVenues = false;
  String venueSectionErrorMessage = "";

  bool loadingTimeSlots = true;
  bool errorLoadingTimeSlots = false;
  String instruction = "";
  List<TimeSlotModel> timeSlots = [];
  bool showTImeSlots = false;
  String timeSlotsErrorMessage = "";

  bool loadingPrePaymentData = true;
  bool errorLoadingPrePay = false;
  String disclaimer = "";
  String appointmentRef = "";
  String paymentInfoFieldLabel = "";
  List<TableData> tableData = [];
  VenueModel? selectedVenue;
  TimeSlotModel? selectedTimeSlot;
  String prepaymentErrorMessage = "";

  File? selectedTransferReceipt;
  bool saving = false;

  String totalAmount = "";

  void getDoctors() {
    setState(() {
      loadingDoctorsList = true;
    });
    print(selectedSpecialty!.key);
    //get the doctors from the backend
    Provider.of<DoctorProvider>(context, listen: false)
        .getDoctorsForApp(selectedSpecialty!.key!)
        .then(
          (value) => value.fold(
            (l) {
              loadingDoctorsList = false;
              errorLoadingDoctorList = true;
              doctorListErrorMessage = l;
              setState(() {});
            },
            (r) {
              r.data!.doctors!.forEach(
                (key, value) {
                  doctors.add(
                    DoctorModel(doctorName: value, id: key),
                  );
                },
              );

              // doctorListTitle = r.data!.fieldLabel!;
              loadingDoctorsList = false;
              errorLoadingDoctorList = false;
              // populate the doctor's name text field incase the user is rescheduling
              if (widget.oldSchedule != null) {
                if (doctors
                    .where(
                        (element) => element.id == widget.oldSchedule!.doctorId)
                    .isNotEmpty) {
                  DoctorModel previouslySelectedDoctor = doctors.firstWhere(
                      (element) => element.id == widget.oldSchedule!.doctorId);

                  doctorId = previouslySelectedDoctor.id;
                  doctorNameController.text =
                      previouslySelectedDoctor.doctorName;
                }
              }

              setState(() {});
            },
          ),
        );
  }

  void getAppointmentVenues() {
    setState(() {
      loadingVenues = true;
    });

    //get the doctors from the backend
    Provider.of<AppointmentProvider>(context, listen: false)
        .getVenueAndLocation(doctorId, "", selectedSpecialty!.key!)
        .then(
          (value) => value.fold(
            (l) {
              setState(() {
                loadingVenues = false;
                errorLoadingVenues = true;
                venueSectionErrorMessage = l;
              });
            },
            (r) {
              venues.clear();
              loadingVenues = false;
              errorLoadingVenues = false;
              venueSectionTitle = r.data!.fieldLabel!;
              r.data!.listOption!.forEach((key, value) {
                venues.add(VenueModel(venue: value, id: key));
              });

              if (widget.oldSchedule != null &&
                  venues
                      .where((element) =>
                          element.id == widget.oldSchedule!.locationId)
                      .isNotEmpty) {
                venues
                    .firstWhere((element) =>
                        element.id == widget.oldSchedule!.locationId)
                    .selected = true;

                selectedVenue = venues.firstWhere(
                    (element) => element.id == widget.oldSchedule!.locationId);
              } else {
                venues.first.selected = true;
                selectedVenue = venues.first;
              }

              setState(() {});
            },
          ),
        );
  }

  void getAvailableTimeSlots() {
    setState(() {
      showTImeSlots = true;
      loadingTimeSlots = true;
    });

    //get the available time slots from the backend
    Provider.of<AppointmentProvider>(context, listen: false)
        .getTimeSlots(
            selectedVenue!.id, dateFormat.format(selectedDate!), doctorId, "")
        .then(
          (value) => value.fold(
            (l) {
              setState(() {
                loadingTimeSlots = false;
                errorLoadingTimeSlots = true;
                timeSlotsErrorMessage = l;
              });
            },
            (r) {
              timeSlots.clear();
              loadingTimeSlots = false;
              errorLoadingTimeSlots = false;
              instruction = r.data!.instruction!;
              r.data!.listOption!.forEach((key, value) {
                timeSlots.add(TimeSlotModel(time: value, id: key));
              });

              if (widget.oldSchedule != null &&
                  timeSlots
                      .where(
                          (element) => element.id == widget.oldSchedule!.time)
                      .isNotEmpty) {
                timeSlots
                    .firstWhere(
                        (element) => element.id == widget.oldSchedule!.time)
                    .selected = true;
                selectedTimeSlot = timeSlots.firstWhere(
                    (element) => element.id == widget.oldSchedule!.time);
              } else {
                selectedTimeSlot = timeSlots.first;
                timeSlots.first.selected = true;
              }

              setState(() {});
            },
          ),
        );
  }

  void getPrePaymentData() {
    setState(() {
      loadingPrePaymentData = true;
    });

    //get the doctors from the backend
    Provider.of<AppointmentProvider>(context, listen: false)
        .getPrePaymentData(doctorId, selectedVenue!.id,
            dateFormat.format(selectedDate!), selectedTimeSlot!.id)
        .then(
          (value) => value.fold(
            (l) {
              setState(() {
                loadingPrePaymentData = false;
                errorLoadingPrePay = true;
                prepaymentErrorMessage = l;
              });
            },
            (r) {
              //clear the list
              tableData.clear();

              loadingPrePaymentData = false;
              errorLoadingPrePay = false;
              appointmentRef = r.data!.appointmentRef!;

              disclaimer = r.data!.instruction!;
              r.data!.tableRow!.forEach((key, value) {
                tableData.add(TableData(title: key, value: value));
              });
              totalAmount = r.data!.paymentDue.toString();

              setState(() {});
            },
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    if (widget.specialtyId != null) {
      selectedSpecialty =
          widget.specialties.firstWhere((e) => e.key == widget.specialtyId);
      doctorListTitle = selectedSpecialty!.appointmentLabel!;
    }

    if (widget.oldSchedule != null) {
      selectedSpecialty = widget.specialties
          .firstWhere((e) => e.key == widget.oldSchedule!.specialtyKey!);
    }
  }

  SpecialtyModel? selectedSpecialty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule appointment"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        child: Stepper(
          currentStep: _currentStep,
          onStepCancel: () => stepBack(),
          onStepContinue: () => stepForward(),
          controlsBuilder: (context, details) => Padding(
            padding: EdgeInsets.only(top: _currentStep != 2 ? 20.0 : 0),
            child: Row(
              children: [
                saving
                    ? generalLoader()
                    : ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.secondary),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                        ),
                        onPressed: () => stepForward(),
                        child: Text(
                          _currentStep != 2 ? " Next " : "Save",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                SizedBox(
                  width: 15,
                ),
                TextButton(
                  onPressed: () => stepBack(),
                  child: Text(
                    _currentStep == 0 ? "Cancel" : "Previous",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          steps: [
            Step(
              title: Text(
                "Select Specialty",
                style: TextStyle(fontSize: 20),
              ),
              content: _currentStep != 0
                  ? SizedBox()
                  : Column(
                      children: widget.specialties
                          .where((element) =>
                              element.title !=
                              "List of All Services & Specialities")
                          .map(
                            (e) => ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 0,
                              ),
                              onTap: () {
                                widget.specialties.forEach((element) {
                                  if (element == e) {
                                    selectedSpecialty = element;
                                    doctorListTitle = element.appointmentLabel!;
                                    setState(() {});
                                  }
                                });
                              },
                              tileColor: e == selectedSpecialty
                                  ? Colors.grey[200]
                                  : Colors.white,
                              leading: Container(
                                width: 20,
                                child: Radio<SpecialtyModel>(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: e,
                                  groupValue: selectedSpecialty,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        selectedSpecialty = value!;
                                        doctorListTitle =
                                            value.appointmentLabel!;
                                      },
                                    );
                                  },
                                ),
                              ),
                              title: Text(e.title!),
                            ),
                          )
                          .toList(),
                    ),
            ),
            Step(
              title: Text(
                doctorListTitle,
                style: TextStyle(fontSize: 20),
              ),
              content: loadingDoctorsList
                  ? generalLoader()
                  : errorLoadingDoctorList
                      ? errorGettingData(getDoctors, doctorListErrorMessage)
                      : Column(
                          children: [
                            Container(
                              height: 60,
                              child: TypeAheadField(
                                controller: doctorNameController,
                                decorationBuilder: (context, child) {
                                  return TextField(
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1.5),
                                      ),
                                      contentPadding: EdgeInsets.all(8),
                                      hintText: "Search Doctor Name",
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            doctorNameController.clear();
                                          },
                                          child: Icon(Icons.close)),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                                suggestionsCallback: (pattern) async {
                                  // get the doctor's list if the list is empty
                                  if (doctors.isEmpty) {
                                    await Provider.of<DoctorProvider>(context,
                                            listen: false)
                                        .getDoctorsForApp(
                                            selectedSpecialty!.key!)
                                        .then(
                                          (value) => value.fold((l) {}, (r) {
                                            r.data!.doctors!
                                                .forEach((key, value) {
                                              doctors.add(DoctorModel(
                                                  doctorName: value, id: key));
                                            });
                                          }),
                                        );
                                  }
                                  return doctors
                                      .where(
                                        (element) => element.doctorName
                                            .toLowerCase()
                                            .contains(
                                              pattern.toLowerCase(),
                                            ),
                                      )
                                      .toList();
                                },
                                itemBuilder: (context, DoctorModel suggestion) {
                                  return ListTile(
                                    title: Text(suggestion.doctorName),
                                  );
                                },
                                onSelected: (DoctorModel suggestion) {
                                  doctorNameController.text =
                                      suggestion.doctorName;
                                  doctorId = suggestion.id;
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
            ),
            Step(
              title: const Text(
                "Appointment Details",
                style: TextStyle(fontSize: 20),
              ),
              content: loadingVenues
                  ? generalLoader()
                  : errorLoadingVenues
                      ? errorGettingData(
                          getAppointmentVenues, venueSectionErrorMessage)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              venueSectionTitle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ToggleButtons(
                              isSelected:
                                  venues.map((e) => e.selected).toList(),
                              renderBorder: false,
                              direction: Axis.vertical,
                              selectedColor: Theme.of(context).primaryColor,
                              children: venues
                                  .map(
                                    (e) => Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 20,
                                          child: Radio<VenueModel>(
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                            value: e,
                                            groupValue: selectedVenue,
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  selectedVenue = value!;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          e.venue,
                                          style: const TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  )
                                  .toList(),
                              onPressed: (index) {
                                // unselect all
                                venues.forEach(
                                  (element) {
                                    element.selected = false;
                                  },
                                );

                                venues[index].selected = true;
                                selectedVenue = venues[index];
                                setState(() {});
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 150,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  side: MaterialStateProperty.all(
                                    BorderSide(color: Colors.black, width: 2),
                                  ),
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                ),
                                onPressed: () {
                                  if (venues
                                      .where((element) => element.selected)
                                      .isEmpty) {
                                    showSnackbar(
                                        "Please select a venue for the appointment.",
                                        false);
                                  } else {
                                    _selectDate(context);
                                  }
                                },
                                child: Text(
                                  selectedDate == null
                                      ? "Tap to select date"
                                      : dateFormat.format(selectedDate!),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            !showTImeSlots
                                ? SizedBox()
                                : loadingTimeSlots
                                    ? generalLoader()
                                    : errorLoadingTimeSlots
                                        ? errorGettingData(
                                            getAvailableTimeSlots,
                                            timeSlotsErrorMessage)
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Time slots",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ToggleButtons(
                                                isSelected: timeSlots
                                                    .map((e) => e.selected)
                                                    .toList(),
                                                renderBorder: false,
                                                selectedColor: Theme.of(context)
                                                    .primaryColor,
                                                direction: Axis.vertical,
                                                children: timeSlots
                                                    .map(
                                                      (e) => Container(
                                                        width: deviceWidth(
                                                            context),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              width: 20,
                                                              child: Radio<
                                                                  TimeSlotModel>(
                                                                activeColor: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                value: e,
                                                                groupValue:
                                                                    selectedTimeSlot,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(
                                                                    () {
                                                                      selectedTimeSlot =
                                                                          value!;
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              e.time,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                                onPressed: (index) {
                                                  // unselect all
                                                  timeSlots.forEach((element) {
                                                    element.selected = false;
                                                  });

                                                  timeSlots[index].selected =
                                                      true;

                                                  selectedTimeSlot =
                                                      timeSlots[index];
                                                  setState(() {});
                                                },
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                            HtmlWidget(instruction),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Additional Remark/Notes",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              minLines: 4,
                              maxLines: 5,
                              controller: remarkController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                  hintText: "Optional"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
            ),
            Step(
              title: Text(
                "Confirmation/Payment",
                style: TextStyle(fontSize: 20),
              ),
              content: loadingPrePaymentData
                  ? generalLoader()
                  : errorLoadingPrePay
                      ? errorGettingData(
                          getPrePaymentData, prepaymentErrorMessage)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Disclaimer",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            HtmlWidget(disclaimer),
                            // Text(
                            //   disclaimer,
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.normal,
                            //       fontSize: 13),
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: tableData
                                  .map(
                                    (e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.title! + ":",
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                e.value!,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  bool showSelectFIleButton = false;
  bool isPaid = false;

  Widget errorGettingData(Function() method, String errorMessage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextButton(
          onPressed: method,
          child: Text(
            "Refresh",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.secondary),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        )
      ],
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(days: 1)),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: (DateTime.now().hour > 11)
            ? DateTime.now().add(Duration(days: 1))
            : DateTime.now(),
        lastDate: DateTime(2101));

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      // upon successful date selection, get the available time slots on the selected date
      getAvailableTimeSlots();
    }
  }

  void stepBack() {
    if (_currentStep != 0) {
      setState(() {
        _currentStep = _currentStep - 1;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void stepForward() {
    // check if we are in the first stage
    if (_currentStep == 0) {
      if (selectedSpecialty == null) {
        showSnackbar("Please select a specialty", false);
        return;
      } else {
        getDoctors();
      }
    }
    if (_currentStep == 1) {
      //check if user hasn't selected any doctor yet
      if (doctorNameController.text.trim() == "") {
        //show an error if not
        showSnackbar("Please select a consultant", false);
        return;
      } else {
        // get the available venue
        getAppointmentVenues();
      }
    } else if (_currentStep == 2) {
      if (selectedDate == null) {
        showSnackbar("Please select a date of visit", false);

        return null;
      } else if (selectedVenue == null) {
        showSnackbar("Please select a venue/location", false);

        return null;
      } else if (selectedTimeSlot == null) {
        showSnackbar("Please select a time slot", false);

        return null;
      }

      getPrePaymentData();
    }
    if (_currentStep != 3) {
      setState(() {
        _currentStep = _currentStep + 1;
      });
    } else {
      completeBooking();
    }
  }

  void completeBooking() {
    setState(() {
      saving = true;
    });

    if (widget.oldSchedule != null) {
      ScheduleModel scheduleModel = widget.oldSchedule!;
      Provider.of<ScheduleProvider>(context, listen: false)
          .rescheduleAppointment(
              context: context,
              appRef: scheduleModel.appointmentId!,
              appDate: dateFormat.format(selectedDate!),
              apTime: selectedTimeSlot!.id,
              doctorId: doctorId,
              locationId: selectedVenue!.id,
              specialtyKey: selectedSpecialty!.key!,
              remark: remarkController.text.trim())
          .then(
            (value) => value.fold(
              (l) {
                setState(() {
                  saving = false;
                });
                showSnackbar(l, false);
              },
              (r) {
                setState(() {
                  saving = false;
                });
                Provider.of<ScheduleProvider>(context, listen: false)
                    .getUpcomingApp();
                showSnackbar(r.msg ?? "", true);
                // goto url to make payment
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AppointmentWebview(
                        url: r.data!.url ?? "", title: "Make Payment"),
                  ),
                );
              },
            ),
          );
    } else {
      Provider.of<AppointmentProvider>(context, listen: false)
          .completeAppointment(appointmentRef, doctorId)
          .then(
            (value) => value.fold(
              (l) {
                setState(() {
                  saving = false;
                });
                showSnackbar(l, false);
              },
              (r) {
                setState(() {
                  saving = false;
                });

                if (r.type == 1) {
                  // reload the schedule after creating an appointment
                  Provider.of<ScheduleProvider>(context, listen: false)
                      .getUpcomingApp();

                  // goto url to make payment
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AppointmentWebview(
                        url: r.data!.url ?? "",
                        title: r.data!.urlTitle ?? "Make payment",
                      ),
                    ),
                  );
                }
              },
            ),
          );
    }
  }
}
