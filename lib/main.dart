import 'package:flutter/material.dart';
import 'package:proj/services/auth/auth_service.dart';
import 'package:proj/views/login_view.dart';
import 'package:proj/views/register_view.dart';
import 'package:proj/views/notes_view.dart';
import 'package:proj/views/verify_email_view.dart';
import 'package:proj/constants/routes.dart';
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
        verifyEmailRoute: (context) => const VerifyEmailView(),
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
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState){
              case ConnectionState.done:
                final user = AuthService.firebase().currentUser;
                if (user != null){
                  if (user.isEmailVerified){
                    return const NotesView();
                  }else{
                    return const VerifyEmailView();
                  }
                }else{
                  return const RegisterView();
                }
              default:
                return const CircularProgressIndicator();
            }
          }
      ),
    );
  }
}

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