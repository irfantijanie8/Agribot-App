import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

import 'Data/Services/AWS/aws_cognito.dart';
import 'Presentation/Route/generated.routes.dart';

final userPool = CognitoUserPool(
  '${(dotenv.env['POOL_ID'])}',
  '${(dotenv.env['CLIENT_ID'])}',
);

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _currentRoute;
  _getCurrentRoute() async {
    try {
      final _userService = new UserService(userPool);
      await _userService.init();

      final user = await userPool.getCurrentUser();
      final session = await user?.getSession();
      print(session?.isValid());

      setState(() {
        if (user == null) {
          _currentRoute = 'login';
        } else {
          _currentRoute = 'homepage';
        }
      });
    } catch (e) {
      print("shared = empty");
      _getCurrentRoute();
    }
  }

  @override
  initState() {
    super.initState();
    _getCurrentRoute();
  }

  Widget build(BuildContext context) {
    return (_currentRoute == null)
        ? Container()
        : MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AWS Cognito',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'ATCArquette'),
      initialRoute: _currentRoute,
      onGenerateRoute: RouteGenerator().generateRoute,
    );
  }
}