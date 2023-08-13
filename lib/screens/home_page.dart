import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:binge_read/components/custom_appbar.dart';
import 'package:binge_read/components/home_page_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeScreenBloc homeScreenBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    homeScreenBloc = HomeScreenBloc();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        bloc: homeScreenBloc,
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 40, 0, 0),
                child: CustomAppBar(
                  trailingElement: "notification",
                  middleElement: Globals.userName,
                  leadingElement: "hambarOpenIcon",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greyColor),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.search, color: Colors.grey),
                      ),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            hintText: 'Search Your Series',
                            hintStyle: TextStyle(fontFamily: 'Lexend'),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: HomePageContent(
                homeScreenBloc: homeScreenBloc,
              ))
            ],
          );
        },
      ),
    );
  }
}
