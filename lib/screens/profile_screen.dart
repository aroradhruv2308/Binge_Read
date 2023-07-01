import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/bloc/authentication_bloc/bloc/google_authentication_bloc.dart';
import 'package:binge_read/components/profile_screen_content.dart';
import 'package:binge_read/db/query.dart';
import 'package:binge_read/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                  width: 100, // Adjust the width and height according to your preference
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.cyan,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('images/anime_avatar2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                "Not Signed in Yet",
                style: TextStyle(
                    color: AppColors.greyColor, fontSize: 24, fontFamily: 'Lexend', fontWeight: FontWeight.bold),
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
            return CircularProgressIndicator();
          }
          if (state is GoogleAuthenticationFaliure) {
            return const Center(
              child: Text(
                "Opps some error occured try sigin again",
                style: TextStyle(color: AppColors.whiteColor),
              ),
            );
          }
          if (state is GoogleAuthenticationSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Show your dialog here
              showNameDilogue(context);
            });
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

  Future<dynamic> showNameDilogue(BuildContext context) {
    return showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        String userInput = ''; // Variable to store user input

        return AlertDialog(
          backgroundColor: AppColors.dilogueBoxColor,
          shadowColor: AppColors.backgroundColor,
          surfaceTintColor: AppColors.backgroundColor, // Set the desired background color
          title: const Text(
            'What should we call you?',
            style: TextStyle(
              color: AppColors.whiteColor,
              fontFamily: 'Lexend',
              fontSize: 18,
            ),
          ),
          content: TextField(
            style: const TextStyle(color: AppColors.greyColor, fontFamily: 'Lexend'),
            cursorColor: AppColors.glowGreen,
            maxLength: 15, // Set the desired maximum length
            onChanged: (value) {
              userInput = value; // Update the userInput variable as the user types
            },
            decoration: const InputDecoration(
                focusColor: AppColors.glowGreen,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.glowGreen), // Set the desired underline color
                ),
                hintText: 'Type Here',
                hintStyle:
                    TextStyle(color: AppColors.darkGreyColor), // Text to display when character limit is exceeded
                counterStyle: TextStyle(color: Colors.green, fontFamily: 'Lexend', fontSize: 16),
                semanticCounterText: "word limit exeeded" // Set the desired color for the word counter
                ),
          ),

          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(userInput);
                Globals.userDisplayName = userInput;
                Globals.userName = userInput;
                User userDetails = User(Globals.userEmail, userInput);
                await Globals.userLoginService!.updateUserDetails(Globals.userEmail, userDetails);
                updateUserNameByEmail(Globals.userEmail, userInput);
                googleAuthBloc.add(const ChangeDisplayName());

                // Return the userInput when dialog is closed
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: AppColors.glowGreen, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
