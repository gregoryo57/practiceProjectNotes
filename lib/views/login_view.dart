
import 'package:flutter/material.dart';
import 'package:proj/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;
import 'package:proj/services/auth/auth_exceptions.dart';
import '../constants/routes.dart';
import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}
class _LoginViewState extends State<LoginView>{
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login')
      ),
      body: Column(
        children:
        [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
                hintText: 'Enter your email here'
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
                hintText: 'Enter your password here'
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false){
                  //user's email is verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false
                  );
                }else{
                  //user email not verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (route) => false
                  );
                }
                devtools.log('login successful');
              } on UserNotFoundAuthException{
                await showErrorDialog(
                  context,
                  'User Not Found',
                );
              } on WrongPasswordAuthException{
                await showErrorDialog(
                  context,
                  'Password is Incorrect',
                );
              } on GenericAuthException{
                await showErrorDialog(
                    context,
                    'Authentication error'
                );
              }
            },
            child: Text('Login'),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route)=> false,
              );
            },
            child: const Text('Not registered yet? Register here!')
          ),
        ]
      ),
    );
  }
}