import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_circle/layout/screens/tasks_screen.dart';
import 'package:flutter_app_circle/layout/tools/app_localizer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc_observer.dart';
import 'layout/screens/authScreen/auth_screen.dart';

late SharedPreferences pref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  pref = await SharedPreferences.getInstance();
  String? savedLgnCode = pref.getString("lgnCode");
  Widget? widget;

  if(savedLgnCode  !=null){
    widget = TasksScreen();
  }else{
    widget = SignInScreen();
  }

  BlocOverrides.runZoned(
        () {
          runApp(MyApp( startWidget: widget,));
    },
    blocObserver: MyBlocObserver(),
  );


}

class MyApp extends StatelessWidget {
  const MyApp( {Key? key,  this.startWidget, }) : super(key: key);
  final Widget? startWidget;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // to tell the app what the components should follow the determined language
      localizationsDelegates: const [
        AppLocale.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // to tell the app what the language should support
      supportedLocales: const [
        //for English "en"
        Locale("en", ""),
        //for Arabic "ar"
        Locale("ar", ""),
      ],

      // this line is just for testing
      // locale: const Locale("ar", ""),

      // this is a callback, it's executed when the user open the app or change the localaization of the mobile
      // what is it's jop?
      // : it cheks if what is the current language of the mobile and return it for the app to follow it
      // : it cheks too if the user specified any language he need even if it's not same as the mobile language is

      localeResolutionCallback: (currentLgn, supportedLgn) {
        // if (widget.savedLgnCode != null) {
        //   for (Locale locale in supportedLgn) {
        //     if (widget.savedLgnCode == locale.languageCode) {
        //       return locale;
        //     }
        //   }
        // } else
        if (currentLgn != null) {
          for (Locale locale in supportedLgn) {
            if (currentLgn.languageCode == locale.languageCode) {
              pref.setString("lgnCode", currentLgn.languageCode);
              return locale;
            }
          }
        }
        print(supportedLgn.first.languageCode);
        return supportedLgn.first;
      },
      home: startWidget,
    );
  }
}
