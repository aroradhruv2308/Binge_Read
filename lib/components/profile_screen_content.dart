import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/Utils/util_functions.dart';
import 'package:binge_read/bloc/authentication_bloc/bloc/google_authentication_bloc.dart';
import 'package:binge_read/components/ui_elements.dart';
import 'package:binge_read/db/query.dart';
import 'package:flutter/material.dart';

class LoginUserProfileScreen extends StatefulWidget {
  final GoogleAuthenticationBloc googleAuthBloc;
  LoginUserProfileScreen({super.key, required this.googleAuthBloc});

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
              return const CircularProgressIndicator(); // Show a loading indicator while waiting for data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Show an error message if an error occurs
            } else {
              final Map<String, dynamic> userData = snapshot.data.data();
              final String userName = userData['name'];
              final String profilePicUrl = userData['photo-url'];
              final String email = userData['email'];

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(children: [
                      Container(
                        height: 70,
                      ),
                      Positioned(
                        right: 14,
                        bottom: 0,
                        child: TextButton(
                          onPressed: () {
                            widget.googleAuthBloc.add(const SignOutEvent());
                          },
                          child: const Text(
                            "Log Out",
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              color: AppColors.glowGreen,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Align(
                      alignment: Alignment.center,
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
                            fontFamily: 'Lexend',
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        email,
                        style: const TextStyle(
                            fontFamily: 'Lexend',
                            color: AppColors.greyColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ExpansionTile(
                        backgroundColor: AppColors.backgroundColor,
                        collapsedBackgroundColor: AppColors.backgroundColor,
                        expandedAlignment: Alignment.topCenter,
                        textColor: AppColors.glowGreen,
                        collapsedIconColor: AppColors.greyColor,
                        iconColor: AppColors.glowGreen,
                        collapsedTextColor: AppColors.whiteColor,
                        trailing: IconButton(
                          iconSize: 16,
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: () {},
                        ),
                        title: const Text(
                          "Recently Viewed",
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Lexend',
                          ),
                        ),
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                customListTile(id: 4),
                                customListTile(id: 1),
                                customListTile(id: 2),
                                customListTile(id: 3),
                                customListTile(id: 4),
                                customListTile(id: 1),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ExpansionTile(
                      backgroundColor: AppColors.backgroundColor,
                      collapsedBackgroundColor: AppColors.backgroundColor,
                      expandedAlignment: Alignment.topCenter,
                      textColor: AppColors.glowGreen,
                      collapsedIconColor: AppColors.greyColor,
                      iconColor: AppColors.glowGreen,
                      collapsedTextColor: AppColors.whiteColor,
                      trailing: IconButton(
                        iconSize: 16,
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {},
                      ),
                      childrenPadding: EdgeInsets.zero,
                      title: const Text(
                        "Most Viewed",
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Lexend',
                        ),
                      ),
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              customListTile(id: 4),
                              customListTile(id: 1),
                              customListTile(id: 2),
                              customListTile(id: 3),
                              customListTile(id: 4),
                              customListTile(id: 1),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}
