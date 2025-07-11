import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk_trip/core/utils/metrics_manager.dart';
import 'package:talk_trip/data/models/user.dart';
import 'package:talk_trip/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  final User? user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final metrics = MetricsManager();
    final requestTokens =
        metrics.allMetrics.fold(0, (sum, m) => sum + m.inputTokens);
    final responseTokens =
        metrics.allMetrics.fold(0, (sum, m) => sum + m.outputTokens);
    final totalCost = metrics.totalCost;
    final displayUser = user ??
        (User()
          ..name = 'Traveler'
          ..email = 'traveler@example.com');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28.r,
                      backgroundColor: Color(0xFF3BAB8C),
                      child: Text(
                        displayUser.name.isNotEmpty
                            ? displayUser.name[0].toUpperCase()
                            : 'U',
                        style: TextStyle(color: Colors.white, fontSize: 24.sp),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(displayUser.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.sp)),
                    SizedBox(height: 4.h),
                    Text(displayUser.email,
                        style: TextStyle(
                            color: Colors.grey[700], fontSize: 14.sp)),
                    SizedBox(height: 20.h),
                    _TokenBar(
                        label: 'Request Tokens',
                        value: requestTokens,
                        max: 1000,
                        color: Colors.green),
                    SizedBox(height: 8.h),
                    _TokenBar(
                        label: 'Response Tokens',
                        value: responseTokens,
                        max: 1000,
                        color: Colors.red),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Total Cost: ', style: TextStyle(fontSize: 15.sp)),
                        Text('[32m[1m[0m',
                            style: TextStyle(fontSize: 15.sp)),
                        Text(
                          ' 24${totalCost.toStringAsFixed(2)} USD',
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOut());
                    Navigator.of(context).pushReplacementNamed('/signin');
                  },
                  icon: Icon(Icons.logout, color: Colors.red),
                  label: Text('Log Out', style: TextStyle(color: Colors.red)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    elevation: 0,
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TokenBar extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final Color color;
  const _TokenBar(
      {required this.label,
      required this.value,
      required this.max,
      required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 13.sp)),
            Text('$value/$max', style: TextStyle(fontSize: 13.sp)),
          ],
        ),
        SizedBox(height: 4.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: value / max,
            minHeight: 8.h,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
