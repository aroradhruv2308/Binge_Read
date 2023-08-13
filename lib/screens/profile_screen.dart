import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/bloc/authentication_bloc/bloc/google_authentication_bloc.dart';
import 'package:binge_read/components/profile_screen_content.dart';
import 'package:binge_read/db/query.dart';
import 'package:binge_read/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_button/sign_in_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late GoogleAuthenticationBloc googleAuthBloc;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    googleAuthBloc = GoogleAuthenticationBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<GoogleAuthenticationBloc, GoogleAuthenticationState>(
        bloc: googleAuthBloc,
        builder: (context, state) {
          if (state is GoogleAuthenticationInitial && Globals.isLogin == false) {
            return Column(children: [
              const SizedBox(
                height: 60,
              ),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.cyan,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('images/default-profile-pic.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Not Signed in Yet",
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontSize: 24,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SignInButton(
                Buttons.google,
                onPressed: () {
                  googleAuthBloc.add(const SignInWithGoogleEvent());
                },
              ),
            ]);
          }
          if (state is GoogleAuthenticationLoading) {
            return const CircularProgressIndicator();
          }
          if (state is GoogleAuthenticationFaliure) {
            return const Center(
              child: Text(
                "Opps some error occured try sigin again",
                style: TextStyle(color: AppColors.whiteColor),
              ),
            );
          }
          if (state is GoogleAuthenticationSuccess || Globals.isLogin == true) {
            return LoginUserProfileScreen(
              googleAuthBloc: googleAuthBloc,
            );
          }
          return Container();
        },
      ),
    );
  }
}
