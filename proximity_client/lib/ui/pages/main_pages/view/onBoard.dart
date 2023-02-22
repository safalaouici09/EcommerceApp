import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:proximity_client/domain/data_persistence/src/boxes.dart';
import 'package:proximity_client/ui/pages/main_pages/view/main_screen.dart';
import 'package:proximity_client/ui/pages/main_pages/view/welcomeScreen.dart';

class OnBoard extends StatelessWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var credentialsBox = Boxes.getCredentials();
    final is_firstTime = credentialsBox.get('first_time');

    return is_firstTime == null ? const WelcomeScreen() : const MainScreen();
  }
}
