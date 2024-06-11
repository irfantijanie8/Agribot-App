import 'package:agribot_two/Class/Query.dart';
import 'package:agribot_two/Presentation/Screens/HomePage/homepage.dart';
import 'package:agribot_two/Presentation/Screens/MachineOverview/MachineOverview.dart';
import 'package:agribot_two/Presentation/Screens/SiteManagement/SiteManagement.dart';

import '../Screens/Confirmation/Confirmation.dart';
import '../Screens/Login/UI/login_page.dart';
import 'package:flutter/material.dart';

import '../Screens/MachineOverview/HistoricalGraph/HistoricalGraph.dart';
import '../Screens/MachineOverview/InspectionDetails/InspectionDetails.dart';
import '../Screens/Register/UI/register_page.dart';

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case LoginPage.routeName:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case RegisterPage.routeName:
        return MaterialPageRoute(builder: (context) => const RegisterPage());
      case OTPScreen.routeName:
        final args = settings.arguments as List<String>;
        return MaterialPageRoute(
            builder: (context) => OTPScreen(emailPassword: args));
      case HomePage.routeName:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case SiteManagement.routeName:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => SiteManagement(
                  siteInfo: args["SiteInfo"],
                  userEmail: args["UserEmail"],
                  reloadSiteList: args["ReloadSiteList"],
                ));
      case MachineOverview.routeName:
        final args = settings.arguments as List<String>;
        return MaterialPageRoute(
            builder: (context) => MachineOverview(machine_info: args));
      case HistoricalGraph.routeName:
        final args = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => HistoricalGraph(machine_id: args));
      case InspectionDetails.routeName:
        final args = settings.arguments as List<String>;
        return MaterialPageRoute(
            builder: (context) => InspectionDetails(machine_info: args));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
