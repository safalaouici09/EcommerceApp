import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:proximity_commercant/domain/authentication/authentication.dart';
import 'package:proximity_commercant/domain/store_repository/src/store_service.dart';
import 'package:proximity_commercant/main.dart';
import 'package:proximity_commercant/ui/pages/authentication_pages/view/login_screen.dart';
import 'package:proximity_commercant/ui/pages/home_pages/home_pages.dart';
import 'package:proximity_commercant/domain/data_persistence/data_persistence.dart';

class OnBoard extends StatelessWidget {
  const OnBoard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final loginValidation = Provider.of<LoginValidation>(context);

    var welcomeBox = Boxes.getWecome();
    final welcome = welcomeBox.get('welcome');

    return loginValidation.isLogged
        ? welcome == null
            ? const WelcomeScreen()
            : const HomeScreen()
        : const LoginScreen();
  }
}
