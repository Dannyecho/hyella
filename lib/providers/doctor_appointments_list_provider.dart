import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hyella/models/appoitments_model.dart';
import 'package:hyella/services/doctor_appointments_provider.dart';

class DoctorAppointmentProvider extends ChangeNotifier {
  DoctorAppointmentService scheduleServices = DoctorAppointmentService();

  ValueNotifier<List<AppointmentModel>> upcomingSchedule = ValueNotifier([]);
  ValueNotifier<List<AppointmentModel>> completedSchedule = ValueNotifier([]);
  ValueNotifier<List<AppointmentModel>> canceledSchedule = ValueNotifier([]);

  bool loadingUpcomingSch = false;
  bool errorLoadingUpcomingSch = false;
  bool loadingCompletedSch = false;
  bool errorLoadingCompletedSch = false;
  bool loadingCanceledSch = false;
  bool errorLoadingCanceledSch = false;

  void getSchedules() async {
    try {
      getUpcomingApp();
      // get the completed schedules
      getCompletedApp();
      // get the cancelled schedules
      getCanceledApp();
    } catch (e) {
    }
  }

  Future<String?> cancelApp(String appointmentRef) async {
    return scheduleServices.cancelAppointment(appointmentRef).then(
          (value) => value.fold(
            (l) {
              return "Unable to cancel Appointment at the moment, please try again later";
            },
            (r) {
              getUpcomingApp();
              getCanceledApp();
              return null;
            },
          ),
        );
  }

  void getCanceledApp() async {
    try {
      loadingCanceledSch = true;
      notifyListeners();
      await scheduleServices.getCancelledSchedules().then(
            (value) => value.fold((l) {
              errorLoadingCanceledSch = true;
              loadingCanceledSch = false;
              notifyListeners();
            }, (r) {
              canceledSchedule.value = [...r];
              errorLoadingCanceledSch = false;
              loadingCanceledSch = false;

              canceledSchedule.notifyListeners();
              notifyListeners();
            }),
          );
    } catch (e) {
      errorLoadingCanceledSch = true;
      loadingCanceledSch = false;
      notifyListeners();
    }
  }

  void getCompletedApp() async {
    try {
      loadingCompletedSch = true;
      notifyListeners();
      await scheduleServices.getCompletedSchedules().then(
            (value) => value.fold((l) {
              errorLoadingCompletedSch = true;
              loadingCompletedSch = false;
              notifyListeners();
            }, (r) {
              completedSchedule.value = [...r];
              errorLoadingCompletedSch = false;
              loadingCompletedSch = false;

              completedSchedule.notifyListeners();
              notifyListeners();
            }),
          );
    } on Exception {
      errorLoadingCompletedSch = true;
      loadingCompletedSch = false;
      notifyListeners();
    }
  }

  void getUpcomingApp() async {
    // get the upcoming schedules
    loadingUpcomingSch = true;
    notifyListeners();
    try {
      await scheduleServices.getUpcomingAppointments().then(
            (value) => value.fold((l) {
              errorLoadingUpcomingSch = true;
              loadingUpcomingSch = false;
              notifyListeners();
            }, (r) {
              upcomingSchedule.value = [...r];
              loadingUpcomingSch = false;
              errorLoadingUpcomingSch = false;

              upcomingSchedule.notifyListeners();
              notifyListeners();
            }),
          );
    } on Exception {
      errorLoadingUpcomingSch = true;
      loadingUpcomingSch = false;
      notifyListeners();
    }
  }
}
