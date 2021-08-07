import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_cook/pages/addFood_page/addFood.dart';
import 'package:easy_cook/pages/addFood_page/addImage.dart';
import 'package:easy_cook/pages/login&register_page/register_page/register.dart';
import 'package:easy_cook/pages/login&register_page/register_page/register2.dart';
import 'package:easy_cook/pages/login&register_page/register_page/register3.dart';
import 'package:easy_cook/slidepage.dart';
import 'package:easy_cook/pages/feed_page/feed.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easy_cook/pages/search_page/xxx_search.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:easy_cook/slidepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    'This channel is used for important notifications.',
    importance: Importance.high);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      home: SlidePage(flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,channel: channel, ),
      routes: {
        '/register-page': (context) => RegisterPage(),
        '/register2-page': (context) => RegisterPage2(),
        '/register3-page': (context) => RegisterPage3(),
        // '/login-page': (context) => LoginPage(),
        // '/feedFollow-page': (context) => FeedFollowPage(),
        // '/search-page': (context) => SearchPage(),
        // '/searchRecipeName' : (context) => SearchRecipeName(),
        '/slide-page': (context) => SlidePage(),
        // '/addFood-page': (context) => AddFoodPage(),
        '/AddFoodPage': (context) => AddFoodPage(),
        // '/AddImagePage': (context) => AddImagePage(),
        // '/showfood-page': (context) => ShowFood(),
      },
    );
  }
}
