import 'package:agribot_two/Data/Services/AWS/aws_cognito.dart';
import 'package:agribot_two/main.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class OTPScreen extends StatefulWidget {
  static const routeName = '/ConfirmationPage';
  final List<String> emailPassword;
  const OTPScreen({super.key, required this.emailPassword});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    /// Optionally you can use form to validate the Pinput
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Email Verification",
              style: TextStyle(
                  fontSize: 22,
                  color: focusedBorderColor,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 40),
            TextButton(onPressed: (){
              final _userService = new UserService(userPool);
              print("send email to " + widget.emailPassword[0]);
              _userService.resendConfirmationCode(widget.emailPassword[0]);

            }, child: Text(
              "Send Verification Code"
            )),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: Directionality(
                // Specify direction if desired
                textDirection: TextDirection.ltr,
                child: Pinput(
                  length: 6,
                  controller: pinController,
                  focusNode: focusNode,
                  androidSmsAutofillMethod:
                  AndroidSmsAutofillMethod.smsUserConsentApi,
                  listenForMultipleSmsOnAndroid: true,
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (String verificationCode) {
                    // debugPrint('onCompleted: $pin');
                  },
                  onChanged: (code) {
                    // debugPrint('onChanged: $value');
                  },
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        width: 22,
                        height: 1,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: InkWell(
                onTap: () async {
                  formKey.currentState!.validate();
                  final _userService = new UserService(userPool);
                  try{
                    await _userService.confirmAccount(widget.emailPassword[0], pinController.text);
                    User? user = await _userService.login(
                        widget.emailPassword[0], widget.emailPassword[1]);
                    if (user!.hasAccess) {
                      print("login go go");

                      final _userService = new UserService(userPool);
                      await _userService.init();
                      User? _user = await _userService.getCurrentUser();

                      final user = await userPool.getCurrentUser();
                      final session = await user?.getSession();
                      print(session?.isValid());

                      final attributes = await user?.getUserAttributes();
                      attributes?.forEach((attribute) async {
                        if (attribute.getName() == "email") {
                          print("email = " + attribute.getValue().toString());
                        }
                      });

                      // final String? email = _user?.email;
                      // final String? uni = _user?.uni;
                      // print("email = " + email.toString() );
                      // print("uni = " + uni.toString() );
                      Navigator.pushReplacementNamed(context, 'homepage');
                    } else
                      print("login no no");
                  }
                  catch (e){
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text:
                      "Verification Code is Invalid",
                    );
                    print("wrong code");
                  }
                },
                child: Container(
                  color: focusedBorderColor,
                  width: double.infinity,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Verify',
                        style: TextStyle(
                            color: Colors.white,
                            wordSpacing: 1,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
