import 'package:flutter/cupertino.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  const GradientContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height, minWidth: MediaQuery.of(context).size.width),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffc8f2e3), Color(0xffb5eeda), Color(0xff53d9aa)],
            stops: [0, 0.1, 0.55],
            begin: Alignment(0.4, 1.0),
            end: Alignment.topCenter,
          )
      ),
      child: child,
    );
  }
}
