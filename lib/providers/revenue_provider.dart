import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hyella/services/revenue_service.dart';

import '../models/revenue_model.dart';

class RevenueProvider extends ChangeNotifier {
  RevenueService revenueService = RevenueService();
  Future<Either<String, RevenueModel>> getRevenue() async {
    return revenueService.getRevenue();
  }
}
