import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proj/views/login_view.dart';
import 'package:proj/views/register_view.dart';
import 'package:proj/views/notes_view.dart';
import 'package:proj/views/verify_email_view.dart';
import 'package:proj/constants/routes.dart';
import 'dart:developer' as devtools show log;

import 'firebase_options.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState){
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                if (user != null){
                  if (user.emailVerified){
                    return const NotesView();
                  }else{
                    return const VerifyEmailView();
                  }
                }else{
                  return const LoginView();
                }
              default:
                return const CircularProgressIndicator();
            }
          }
      ),
    );
  }
}

enum MenuAction{ logout }

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out? '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              }, child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              }, child: const Text('Log Out'),
            ),
          ],
        );
      },
  ).then((value) => value ?? false);
}


