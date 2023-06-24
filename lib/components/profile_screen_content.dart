import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/Utils/util_functions.dart';
import 'package:binge_read/db/user_data_query.dart';
import 'package:flutter/material.dart';

class LoginUserProfileScreen extends StatefulWidget {
  const LoginUserProfileScreen({super.key});

  @override
  State<LoginUserProfileScreen> createState() => _LoginUserProfileScreenState();
}

class _LoginUserProfileScreenState extends State<LoginUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.backgroundColor,
        child: FutureBuilder(
          future: getUserByEmail(Globals.userEmail), // Replace `fetchData()` with your asynchronous function call
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show a loading indicator while waiting for data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Show an error message if an error occurs
            } else {
              final Map<String, dynamic> userData = snapshot.data.data();
              final String userName = userData['name'];
              final String profilePicUrl = userData['photo-url'];
              final String email = userData['email'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: Container(
                      width: 100, // Adjust the width and height according to your preference
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(profilePicUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      capitalizeWords(userName),
                      style: const TextStyle(
                          fontFamily: 'Lexend', color: AppColors.whiteColor, fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      email,
                      style: const TextStyle(
                          fontFamily: 'Lexend', color: AppColors.greyColor, fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ),
                ],
              );
            }
          },
        ));
  }
}
