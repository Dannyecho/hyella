import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ScheduleShimmer extends StatelessWidget {
  const ScheduleShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemBuilder: (context, index) => Container(
          height: 100,
          margin: EdgeInsets.symmetric(vertical: 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        itemCount: 8,
      ),
    );
  }
}
