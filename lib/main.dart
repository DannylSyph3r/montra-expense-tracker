import 'package:expense_tracker_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:expense_tracker_app/features/onboarding/views/onboarding_view.dart';
import 'package:expense_tracker_app/shared/app_texts.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await RegisterAdapters.initializeBDAndRegisterAdapters();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (value) {
      runApp(
        const MontraApp(),
      );
    },
  );
}

class MontraApp extends StatelessWidget {
  const MontraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnboardingBloc>(
          create: (context) => OnboardingBloc(),
        ),
      ],
      child: ScreenUtilInit(
          useInheritedMediaQuery: true,
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: false,
          builder: (BuildContext context, Widget? child) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: AppTexts.appName,
                theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Palette.montraPurple),
                  useMaterial3: true,
                ),
                home: const OnboardingView());
          }),
    );
  }
}
