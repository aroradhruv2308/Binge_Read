import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:binge_read/components/custom_appbar.dart';
import 'package:binge_read/components/home_page_content.dart';
import 'package:binge_read/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
    Future.delayed(Duration(seconds: 2), () {
      homeScreenBloc.add(RemoveSplashScreenEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        bloc: homeScreenBloc,
        builder: (context, state) {
          if (state is HomeScreenInitial) {
            return SplashScreen();
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 30, 8, 0),
                child: CustomAppBar(
                  trailingElement: "notification",
                  middleElement: "nameOfAPP",
                  leadingElement: "hambarOpenIcon",
                ),
              ),
              SizedBox(
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
                          decoration: InputDecoration(
                            hintText: 'Search Your Series..',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              HomePageContent()
            ],
          );
        },
      ),
    );
  }
}
