import 'package:flutter/material.dart';
import 'package:storyflutter/common/common.dart';
import 'package:storyflutter/constant/result_state.dart';
import 'package:storyflutter/model/session.dart';
import 'package:provider/provider.dart';
import 'package:storyflutter/provider/auth_provider.dart';
import 'package:storyflutter/provider/login_provider.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;
  const LoginScreen(
      {super.key, required this.onLogin, required this.onRegister});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/ic_background.png'),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/ic_splash.png',
                      height: 200,
                      alignment: Alignment.center,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.login_title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        label: Text(AppLocalizations.of(context)!.email_text),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email tidak boleh kosong";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        label:
                            Text(AppLocalizations.of(context)!.password_text),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password tidak boleh kosong";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    context.watch<LoginProvider>().isLoadingLogin
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              _handleSignIn(context);
                            },
                            child: Text(AppLocalizations.of(context)!
                                .register_buttonLogin),
                          ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      AppLocalizations.of(context)!.sub_text,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    OutlinedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.redAccent)),
                      onPressed: () {
                        widget.onRegister();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.register_btn,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignIn(BuildContext context) async {
    String textEmail = emailController.text.toString();
    String textPassword = passwordController.text.toString();
    if (formKey.currentState!.validate()) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      if (textEmail.isNotEmpty && textPassword.isNotEmpty) {
        final authRead = context.read<AuthProvider>();
        final goLogin = context.read<LoginProvider>();
        await goLogin.postLogin(textEmail, textPassword);
        if (goLogin.state == ResultState.hasData) {
          final Session session = Session(
              session: goLogin.loginModel.loginResult!.userId,
              token: goLogin.loginModel.loginResult!.token);
          await authRead.sessionLogin(session);
          widget.onLogin();
        } else if (goLogin.state == ResultState.noData) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(goLogin.message),
            ),
          );
        }
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("goLogin.message"),
          ),
        );
      }
    }
  }
}
