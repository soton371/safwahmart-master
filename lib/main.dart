import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocery/views/splash/splash_screen.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   //print("Handling a background message: ${message.messageId}");
// }

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);


  ///FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  Builder(
        builder: (BuildContext context){
          return GetMaterialApp(
            title: 'Grocery',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
            ),
            home:  AnimatedSplashScreen(),
            // home: const Testing(),
          );
        }
    );
  }
}


