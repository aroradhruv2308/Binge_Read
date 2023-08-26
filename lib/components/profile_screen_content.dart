import 'package:binge_read/Utils/animations.dart';
import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/Utils/util_functions.dart';
import 'package:binge_read/bloc/authentication_bloc/bloc/google_authentication_bloc.dart';
import 'package:binge_read/components/ui_elements.dart';
import 'package:binge_read/db/query.dart';
import 'package:binge_read/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LoginUserProfileScreen extends StatefulWidget {
  final GoogleAuthenticationBloc googleAuthBloc;
  GoogleAuthenticationBloc localGoogleAuthBloc = GoogleAuthenticationBloc();
  LoginUserProfileScreen({super.key, required this.googleAuthBloc});

  @override
  State<LoginUserProfileScreen> createState() => _LoginUserProfileScreenState();
}

class _LoginUserProfileScreenState extends State<LoginUserProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: FutureBuilder(
        future: getUserData(Globals.userEmail),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: lottieLoader());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final Map<String, dynamic> userData = snapshot.data;
            final String userName = userData['name'];
            final String profilePicUrl = userData['photo-url'] ??
                "https://firebasestorage.googleapis.com/v0/b/binge-read-2326.appspot.com/o/AppData%2FProfilePictures%2FProfile-Pic-2.jpg?alt=media&token=eac6fad0-2b6f-4211-b1f3-c68af9c1b7ff";
            final String email = userData['email'];

            // Set username and profile picture in Globals for using it in entire app.
            Globals.profilePictureUrl = profilePicUrl;
            Globals.userName = userName;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(children: [
                    Container(
                      height: 90,
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
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(Globals.profilePictureUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.only(left: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BlocBuilder<GoogleAuthenticationBloc, GoogleAuthenticationState>(
                            bloc: widget.localGoogleAuthBloc,
                            builder: (context, state) {
                              if (state is LoadingState) {
                                widget.localGoogleAuthBloc.add(const ChangeDisplayName());
                                return Center(child: lottieLoader()); // default loader
                              }
                              // if (state is DisplayNameChange) {
                              //   return Text(
                              //     capitalizeWords(Globals.userName),
                              //     style: const TextStyle(
                              //       fontFamily: 'Lexend',
                              //       color: AppColors.whiteColor,
                              //       fontWeight: FontWeight.w400,
                              //       fontSize: 18,
                              //     ),
                              //   );
                              // }

                              return Text(
                                capitalizeWords(Globals.userName),
                                style: const TextStyle(
                                  fontFamily: 'Lexend',
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              showNameChangeDialogue(context);
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 18,
                              color: AppColors.glowGreen,
                            ),
                          )
                        ],
                      ),
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
                        Container(
                            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                            child: FutureBuilder<List<dynamic>>(
                              future: fetchIDsFromFirestore("recently_viewed_series"),
                              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Container(); // Show a loading indicator while fetching data
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  List<dynamic> ids =
                                      snapshot.data ?? []; // Get the fetched IDs (or empty list if null)
                                  return buildListView(ids);
                                }
                              },
                            )),
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
                      Container(
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                        child: FutureBuilder<List<dynamic>>(
                          future: fetchIDsFromFirestore("most_viewed_series"),
                          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Container(); // Show a loading indicator while fetching data
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<dynamic> ids = snapshot.data ?? []; // Get the fetched IDs (or empty list if null)
                              return buildListView(ids);
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<dynamic> showNameChangeDialogue(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    void _handleSubmit(String value) async {
      if (value.isNotEmpty) {
        Navigator.of(context).pop(value);

        // Set Global userName to updated value.
        Globals.userName = value;

        // Update local data in hive with updated username.
        User userDetails = User(Globals.userEmail, value, Globals.profilePictureUrl);
        await Globals.userLoginService!.updateUserDetails(Globals.userEmail, userDetails);

        updateUserNameByEmail(Globals.userEmail, value);

        // Before calling changeDisplayName event, call the Loading
        // event to allow bloc builder to build properly.
        widget.localGoogleAuthBloc.add(const LoadingEvent());
      }
    }

    return showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        // Variable to store user input.
        String userInput = '';

        return AlertDialog(
          backgroundColor: AppColors.dilogueBoxColor,
          shadowColor: AppColors.backgroundColor,
          surfaceTintColor: AppColors.backgroundColor,
          title: const Text(
            'What should we call you?',
            style: TextStyle(
              color: AppColors.whiteColor,
              fontFamily: 'Lexend',
              fontSize: 18,
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: TextEditingController(),
                  style: const TextStyle(color: AppColors.greyColor, fontFamily: 'Lexend'),
                  cursorColor: AppColors.glowGreen,
                  maxLength: 15, // Maximum 15 characters allowed.
                  onChanged: (value) {
                    userInput = value;
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
                    semanticCounterText: "Word limit exceeded", // Set the desired color for the word counter
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'username cannot be empty.';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    if (_formKey.currentState!.validate()) {
                      _handleSubmit(userInput);
                    }
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _handleSubmit(userInput);
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: AppColors.glowGreen,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
