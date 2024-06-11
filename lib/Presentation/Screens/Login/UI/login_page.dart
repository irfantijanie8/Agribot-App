
import 'package:agribot_two/Presentation/Screens/Register/UI/register_page.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../../Data/Services/AWS/aws_cognito.dart';
import '../../../../Declarations/Constants/Images/image_files.dart';
import '../../../../Declarations/Constants/constants.dart';
import '../../../../main.dart';
import '../../../Components/GradientContainer.dart';
import '../../../Components/spacer.dart';
import '../../Confirmation/Confirmation.dart';
import '../Widgets/input_field.dart';


class LoginPage extends StatefulWidget {
  static const routeName = 'login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isConfirmed = true;
  bool hasAccess = true;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GradientContainer(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            const HeightSpacer(myHeight: 110),
            Image.asset(
              loginImages,
              width: 317,
              height: 100,
            ),
            const HeightSpacer(myHeight: 30),
            Text("Login here",
                style: TextStyle(
                  color: Color(0xFF1F41BB),
                  fontWeight: FontWeight.w700,
                  fontSize: 35,
                )),
            const HeightSpacer(myHeight: 30),
            InputField(
                controller: emailController,
                isPassword: false,
                labelTxt: 'Email',
                icon: Icons.person),
            HeightSpacer(myHeight: 20.00),
            InputField(
                controller: passwordController,
                isPassword: true,
                labelTxt: 'Password',
                icon: Icons.lock),
            HeightSpacer(myHeight: 10.00),
            HeightSpacer(myHeight: 10.00),
            ElevatedButton(
              onPressed: () async {
                final _userService = new UserService(userPool);
                User? user = await _userService.login(
                    emailController.text, passwordController.text);

                setState(() {
                  if (user == null) {
                    isConfirmed = true;
                    hasAccess = false;
                  } else {
                    isConfirmed = user!.confirmed;
                    hasAccess = user!.hasAccess;
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: "Incorrect Email or Password. Please Try Again!",
                    );
                  }
                });

                if (user!.confirmed == false) {
                  Navigator.pushNamed(
                    context,
                    OTPScreen.routeName,
                    arguments: [emailController.text, passwordController.text],
                  );
                }

                print(user!.confirmed);
                print(user!.hasAccess);

                if (user!.hasAccess) {
                  print("login go go");

                  Navigator.pushReplacementNamed(context, 'homepage');
                } else
                  print("login no no");
              },
              style: getBtnStyle(context),
              child: Text("Login"),
            ),
            const HeightSpacer(myHeight: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RegisterPage.routeName);
              },
              child: Text("Create new account?",
                  style: TextStyle(
                    color: Color(0xFF1F41BB),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  )),
            ),
            // isConfirmed ? Container(height: 0) : Text("not confirmed"),
          ]),
        ),
      ),
    );
  }

  //
  // Future<bool> login(String email, String password) async {
  //   return AWSServices().createInitialRecord(email, password);
  // }
}
