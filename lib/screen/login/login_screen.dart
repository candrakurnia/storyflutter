import 'package:flutter/material.dart';
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
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Please Login First",
                        style: TextStyle(
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
                        label: const Text("Email"),
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
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        label: const Text("Password"),
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _handleSignIn(context);
                      },
                      child: const Text("Login"),
                    ),
                    // context.watch<AuthProvider>().isLoadingLogin
                    //     ? const Center(
                    //         child: CircularProgressIndicator(),
                    //       )
                    //     : ElevatedButton(
                    //         onPressed: () async {
                    //           LoginProvider loginProvider =
                    //               Provider.of<LoginProvider>(context,
                    //                   listen: false);
                    //           String textEmail =
                    //               emailController.text.toString();
                    //           String textPassword =
                    //               passwordController.text.toString();
                    //           if (formKey.currentState!.validate()) {
                    //             final scaffoldMessenger =
                    //                 ScaffoldMessenger.of(context);
                    //             // final User user = User(
                    //             //   email: textEmail,
                    //             //   password: textPassword,
                    //             // );
                    //             final Session session = Session(
                    //                 session: loginProvider
                    //                     .loginModel.loginResult.userId,
                    //                 token: loginProvider
                    //                     .loginModel.loginResult.token);
                    //             final authRead = context.read<AuthProvider>();
                    //             final result = await authRead.sessionLogin(session);
                    //             if (result) {
                    //               await loginProvider.postLogin(
                    //                   textEmail, textPassword);
                    //               if (loginProvider.state ==
                    //                   ResultState.hasData) {
                    //                 widget.onLogin();
                    //               } else if (loginProvider.state ==
                    //                   ResultState.noData) {
                    //                 scaffoldMessenger.showSnackBar(
                    //                   SnackBar(
                    //                     content: Text(loginProvider.message),
                    //                   ),
                    //                 );
                    //               }
                    //             } else {
                    //               scaffoldMessenger.showSnackBar(
                    //                 const SnackBar(
                    //                   content: Text(
                    //                       "Your email or password is invalid"),
                    //                 ),
                    //               );
                    //             }
                    //           }
                    //         },
                    //         child: const Text("Login"),
                    //       ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Don't have an account yet?",
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
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
                      child: const Text(
                        "Register Now",
                        style: TextStyle(color: Colors.white),
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

  void _handleSignIn(context) async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String textEmail = emailController.text.toString();
    String textPassword = passwordController.text.toString();

    if (formKey.currentState!.validate()) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      if (textEmail.isNotEmpty && textPassword.isNotEmpty) {
        await loginProvider.postLogin(textEmail, textPassword);
        if (loginProvider.state == ResultState.loading) {
          print("loading");
        }
        if (loginProvider.state == ResultState.hasData) {
          final Session session = Session(
              session: loginProvider.loginModel.loginResult.userId,
              token: loginProvider.loginModel.loginResult.token);
          final result = await authProvider.sessionLogin(session);
          if (result) {
            widget.onLogin();
          }
        } else if (loginProvider.state == ResultState.noData) {
          scaffoldMessenger
              .showSnackBar(SnackBar(content: Text(loginProvider.message)));
        }
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("Your email or password is invalid"),
          ),
        );
      }
    }
  }
}
