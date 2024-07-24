import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hyella/models/book_appt_response_model.dart';
import 'package:hyella/models/schedule_model.dart';
import 'package:hyella/services/schedule_services.dart';

class ScheduleProvider extends ChangeNotifier {
  ScheduleServices scheduleServices = ScheduleServices();

  ValueNotifier<List<ScheduleModel>> upcomingSchedule = ValueNotifier([]);
  ValueNotifier<List<ScheduleModel>> completedSchedule = ValueNotifier([]);
  ValueNotifier<List<ScheduleModel>> canceledSchedule = ValueNotifier([]);

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

  Future<Either<String, String>> acceptApp(String appointmentRef,
      String appDate, String appTime, String remark) async {
    loadingUpcomingSch = true;
    notifyListeners();
    return scheduleServices
        .acceptAppointment(appointmentRef, appDate, appTime, remark)
        .then(
          (value) => value.fold(
            (l) {
              return Left(l);
            },
            (r) {
              getUpcomingApp();
              return Right(r);
            },
          ),
        );
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

  Future<Either<String, BookApptRespModel>> rescheduleAppointment(
      {required BuildContext context,
      required String appRef,
      required String appDate,
      required String apTime,
      required String doctorId,
      required String locationId,
      required String specialtyKey,
      required String remark}) async {
    var res = await scheduleServices.rescheduleAppointment(
        appRef: appRef,
        appDate: appDate,
        apTime: apTime,
        doctorId: doctorId,
        locationId: locationId,
        specialtyKey: specialtyKey,
        remark: remark);
    res.fold((l) => null, (r) {
      // upon successfull reschedule, refresh the schedule data
      getSchedules();
    });
    return res;
  }

  void getCanceledApp() async {
    try {
      loadingCanceledSch = true;
      errorLoadingCanceledSch = false;
      notifyListeners();

      await scheduleServices.getCancelledSchedules().then(
            (value) => value.fold((l) {
              errorLoadingCanceledSch = true;
              loadingCanceledSch = false;
              notifyListeners();
            }, (r) {
              canceledSchedule.value = r;
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
      errorLoadingCompletedSch = false;
      notifyListeners();

      await scheduleServices.getCompletedSchedules().then(
            (value) => value.fold((l) {
              errorLoadingCompletedSch = true;
              loadingCompletedSch = false;
              notifyListeners();
            }, (r) {
              completedSchedule.value = r;
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
    errorLoadingCompletedSch = false;
    notifyListeners();
    try {
      await scheduleServices.getUpcomingSchedules().then(
            (value) => value.fold((l) {
              errorLoadingUpcomingSch = true;
              loadingUpcomingSch = false;
              notifyListeners();
            }, (r) {
              upcomingSchedule.value = r;
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
