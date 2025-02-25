import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionCard extends StatelessWidget {
  final String botName;
  final int amount;
  final String timeStamp; 


  const TransactionCard({super.key, required this.botName, required this.amount, required this.timeStamp});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.donut_large),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      botName,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      timeStamp,
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+ ${amount.toDouble()}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                    color: Colors.green[400],
                  ),
                ),
                Text('Deposit', style: TextStyle(fontSize: 10.sp)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
