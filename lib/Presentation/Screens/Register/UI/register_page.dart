import 'dart:convert';

import 'package:agribot_two/Presentation/Components/GradientContainer.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../../Data/Services/AWS/aws_cognito.dart';
import '../../../../Declarations/Constants/Images/image_files.dart';
import '../../../../Declarations/Constants/constants.dart';
import '../../../../main.dart';
import '../../../Components/app_bar.dart';
import '../../../Components/primary_btn.dart';
import '../../../Components/spacer.dart';
import '../../Confirmation/Confirmation.dart';
import '../Widgets/input_field.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = 'register';
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

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
  // String uni_selection = 'Admin';

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GradientContainer(
        child: Padding(
          padding: EdgeInsets.all(20.00),
          child: Column(children: [
            const HeightSpacer(myHeight: 110),
            Image.asset(
              loginImages,
              width: 317,
              height: 100,
              fit: BoxFit.cover,
            ),
            const HeightSpacer(myHeight: 30),
            Text("Register here",
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
            HeightSpacer(myHeight: 20),
            InputField(
                controller: passwordController,
                isPassword: true,
                labelTxt: 'Password',
                icon: Icons.lock),
            HeightSpacer(myHeight: 20),
            ElevatedButton(
                onPressed: () async {
                  try {
                    await Register(
                        emailController.text, passwordController.text);
                    Navigator.pushNamed(
                      context,
                      OTPScreen.routeName,
                      arguments: [
                        emailController.text,
                        passwordController.text
                      ],
                    );
                  } on Exception catch (e) {
                    // Anything else that is an exception
                    print('Unknown exception: $e');
                    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

                    if (emailController.text.length < 1 ||
                        passwordController.text.length < 1) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: "Email and Password cannot be Blank!",
                      );
                    } else if (!regex.hasMatch(passwordController.text)) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text:
                            "Password Must Have Minimum Eight Characters, At Least One Letter, One Number and One Special Character",
                      );
                    } else if (e.toString().substring(46, 69) ==
                        "UsernameExistsException") {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: "An account with the given email already exists",
                      );
                    } else {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: "Invalid Email or Password. Please Try Again!",
                      );
                    }
                  }
                },
                style: getBtnStyle(context),
                child: Text("Register")),
            const HeightSpacer(myHeight: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Already have an account?",
                  style: TextStyle(
                    color: Color(0xFF1F41BB),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  )),
            ),
            // Register(emailController.text, passwordController.text, uni_selection)),
          ]),
        ),
      ),
    );
  }

  Register(String email, String password) =>
      UserService(userPool).signUp(email, password);

  // Register(String email, String password, String uni) =>
  //     UserService(userPool).signUp(email, password, uni);
}
