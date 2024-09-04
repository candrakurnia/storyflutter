import 'package:flutter/material.dart';
import 'package:storyflutter/constant/result_state.dart';
import 'package:storyflutter/model/user.dart';
import 'package:storyflutter/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:storyflutter/provider/register_provider.dart';

class RegisterPage extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const RegisterPage({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
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
                        "Please Register First",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        label: const Text("Username"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
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
                    ),
                    const SizedBox(
                      height: 8,
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
                    ),
                    const SizedBox(height: 16),
                    context.watch<AuthProvider>().isLoadingRegister
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              RegisterProvider registerProvider =
                                  Provider.of<RegisterProvider>(context,
                                      listen: false);
                              String email = emailController.text.toString();
                              String password =
                                  passwordController.text.toString();
                              String username = nameController.text.toString();
                              if (formKey.currentState!.validate()) {
                                final scaffoldMessenger =
                                    ScaffoldMessenger.of(context);
                                final User user = User(
                                  email: email,
                                  password: password,
                                );
                                final authRead = context.read<AuthProvider>();
                                final result = await authRead.saveUser(user);

                                if (result) {
                                  await registerProvider.postRegister(
                                      username, email, password);
                                  if (registerProvider.state ==
                                      ResultState.hasData) {
                                    widget.onRegister();
                                  } else if (registerProvider.state == ResultState.noData){
                                     scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "There's some trouble, try again"),
                                    ),
                                  );
                                  }
                                } else {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Your email or password is invalid"),
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text("Register"),
                          ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    OutlinedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.redAccent)),
                      onPressed: () {
                        widget.onLogin();
                      },
                      child: const Text(
                        "Login",
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
}
