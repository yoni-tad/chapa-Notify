import 'package:chapanotify/config/graphql_config.dart';
import 'package:chapanotify/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GraphQLProvider(
          client: GraphqlConfig.initClient(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chapa Notify',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff7DC400)),
            ),
            home: SplashScreen(),
          ),
        );
      },
    );
  }
}
