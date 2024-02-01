import 'package:chat_app/screens/alternate_chat.dart';
import 'package:chat_app/screens/alternate_chat2.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/sign_up.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

final theme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 32, 69, 163),
    ),
    textTheme: GoogleFonts.ubuntuTextTheme().copyWith(),
    scaffoldBackgroundColor: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 32, 69, 163),
    ).primaryContainer,
    appBarTheme: AppBarTheme(
      color: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 17, 132, 234),
      ).primary.withOpacity(0.7),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 17, 132, 234),
      ).primary.withOpacity(0.4),
    ));

final darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(176, 208, 4, 4),
        brightness: Brightness.dark,
        onBackground: Colors.white),
    textTheme: GoogleFonts.ubuntuTextTheme(),
    scaffoldBackgroundColor: Colors.black);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: theme,
      darkTheme: darkTheme,
      home: FirebaseAuth.instance.currentUser == null
          ? const SignUpScreen()
          : const StreamChat(),
    );
  }
}
