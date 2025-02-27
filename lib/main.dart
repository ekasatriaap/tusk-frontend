import 'package:d_session/d_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/common/app_color.dart';
import 'package:frontend/common/app_route.dart';
import 'package:frontend/data/models/user.dart';
import 'package:frontend/presentation/bloc/login/login_cubit.dart';
import 'package:frontend/presentation/bloc/need_review/need_review_bloc.dart';
import 'package:frontend/presentation/bloc/user/user_cubit.dart';
import 'package:frontend/presentation/pages/add_employee_page.dart';
import 'package:frontend/presentation/pages/home_admin_page.dart';
import 'package:frontend/presentation/pages/login_page.dart';
import 'package:frontend/presentation/pages/profile_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => UserCubit()),
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => NeedReviewBloc()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(useMaterial3: true).copyWith(
                primaryColor: AppColor.primary,
                colorScheme: ColorScheme.light(
                    primary: AppColor.primary, secondary: AppColor.secondary),
                scaffoldBackgroundColor: AppColor.scaffold,
                textTheme: GoogleFonts.poppinsTextTheme(),
                appBarTheme: AppBarTheme(
                    surfaceTintColor: AppColor.primary,
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                    titleTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
                popupMenuTheme: const PopupMenuThemeData(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                ),
                dialogTheme: const DialogTheme(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                )),
            initialRoute: AppRoute.home,
            routes: {
              AppRoute.home: (context) {
                return FutureBuilder(
                    future: DSession.getUser(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null)
                        return const LoginPage(); // login
                      User user = User.fromJson(Map.from(snapshot.data!));
                      context.read<UserCubit>().update(user);
                      if (user.role == 'Admin') return const HomeAdminPage();
                      return const Scaffold(); // employee home
                    });
              },
              AppRoute.addEmployee: (context) => const AddEmployeePage(),
              AppRoute.addTask: (context) => const Scaffold(),
              AppRoute.detailTask: (context) => const Scaffold(),
              AppRoute.listTask: (context) => const Scaffold(),
              AppRoute.login: (context) => const LoginPage(),
              AppRoute.monitorEmployee: (context) => const Scaffold(),
              AppRoute.profile: (context) => const ProfilePage(),
            }));
  }
}
