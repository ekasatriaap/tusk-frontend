import 'package:d_input/d_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/common/app_color.dart';
import 'package:frontend/common/app_info.dart';
import 'package:frontend/common/app_route.dart';
import 'package:frontend/common/enums.dart';
import 'package:frontend/presentation/bloc/login/login_cubit.dart';
import 'package:frontend/presentation/bloc/user/user_cubit.dart';
import 'package:frontend/presentation/widgets/app_button.dart';
import 'package:gap/gap.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final edtEmail = TextEditingController();
    final edtPassword = TextEditingController();
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          buildHeader(),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                DInput(
                  controller: edtEmail,
                  fillColor: Colors.white,
                  radius: BorderRadius.circular(12),
                  hint: 'email',
                ),
                const Gap(20),
                DInputPassword(
                  controller: edtPassword,
                  fillColor: Colors.white,
                  radius: BorderRadius.circular(12),
                  hint: 'password',
                ),
                const Gap(20),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state.requestStatus == RequestStatus.failed) {
                      AppInfo.failed(context, "Login failed!");
                    }
                    if (state.requestStatus == RequestStatus.success) {
                      AppInfo.success(context, "Login success!");
                      Navigator.pushNamed(context, AppRoute.home);
                    }
                  },
                  builder: (context, state) {
                    if (state.requestStatus == RequestStatus.loading) {
                      return const CircularProgressIndicator();
                    }
                    return AppButton.primary("LOGIN", () {
                      context
                          .read<LoginCubit>()
                          .clickLogin(edtEmail.text, edtPassword.text);
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  AspectRatio buildHeader() {
    return AspectRatio(
      aspectRatio: 0.8,
      child: Stack(
        children: [
          loginBg(),
          loginBgDecoration(),
          loginHeader(),
        ],
      ),
    );
  }

  Positioned loginHeader() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(
            "assets/logo.png",
            height: 120,
            width: 120,
          ),
          Gap(20),
          RichText(
            text: TextSpan(
              text: "Monitoring \n",
              style: TextStyle(
                color: AppColor.defaultText,
                fontSize: 30,
                height: 1.4,
              ),
              children: [
                TextSpan(text: "with "),
                TextSpan(
                    text: "Tusk",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Positioned loginBgDecoration() {
    return Positioned.fill(
      top: 200,
      bottom: 80,
      child: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: AlignmentDirectional.bottomCenter,
                end: AlignmentDirectional.topCenter,
                colors: [AppColor.scaffold, Colors.transparent])),
      ),
    );
  }

  Positioned loginBg() {
    return Positioned.fill(
      bottom: 80,
      child: Image.asset(
        'assets/login_bg.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
