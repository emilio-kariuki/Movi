// ignore_for_file: file_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:movistar/Repository/AuthRepository.dart';
import 'package:movistar/UI/Auth/LoginPage.dart';
import 'package:movistar/UI/Home/HomePage.dart';
import 'package:movistar/UI/Widget/AuthButton.dart';
import 'package:movistar/UI/Widget/InputField.dart';
import 'package:movistar/UI/Widget/SvgButton.dart';
import 'package:movistar/UI/Widget/SvgContainer.dart';
import 'package:movistar/Util/SharedPreferencesManager.dart';
import 'package:movistar/blocs/Auth/auth_bloc.dart';
import 'package:movistar/blocs/Authentication/authentication_bloc.dart';

class Register extends StatefulWidget {
  final route = '/register';
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final FocusNode emailfocusNode = FocusNode();
  final passwordController = TextEditingController();
  final FocusNode passwordfocusNode = FocusNode();
  final nameController = TextEditingController();
  final FocusNode namefocusNode = FocusNode();

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => AuthBloc(
        authenticationBloc: AuthenticationBloc(),
        authRepo: AuthRepo(),
        sharedPreferenceManager: SharedPreferenceManager(),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.01,
                  ),
                  const Center(
                    child: SvgContainer(
                      svgPath: 'lib/assets/relax.svg',
                      height: 200,
                      width: 200,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff666666),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InputField(
                    focusNode: namefocusNode,
                    controller: nameController,
                    label: "Name",
                    hint: "Name",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InputField(
                    focusNode: emailfocusNode,
                    controller: emailController,
                    label: "Email",
                    hint: "email",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InputField(
                    focusNode: passwordfocusNode,
                    controller: passwordController,
                    label: "Password",
                    hint: "password",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoginSuccess) {
                        _onWidgetDidBuild(() async {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Home()));
                        });
                      }
                      return state is AuthLoginLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ))
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: AuthButton(
                                text: "Register",
                                onPressed: () {
                                  emailfocusNode.unfocus();
                                  passwordfocusNode.unfocus();
                                  if (emailController.text.isEmpty ||
                                      passwordController.text.isEmpty) {
                                    _onWidgetDidBuild(() {
                                      Fluttertoast.showToast(
                                          msg: "please fill all fields",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    });
                                  } else {
                                    BlocProvider.of<AuthBloc>(context).add(
                                        RegisterButtonPressed(
                                            email: emailController.text,
                                            password: passwordController.text));
                                  }
                                },
                                color: const Color.fromARGB(255, 0, 71, 59),
                                borderRadius: 20,
                                height: 50,
                                width: double.infinity,
                              ),
                            );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text.rich(TextSpan(
                      children: [
                        const TextSpan(
                          text: "Aleady have an account? ",
                          style:
                              TextStyle(color: Color(0xff666666), fontSize: 14),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                            },
                          text: "Login",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 30, 136, 229),
                          ),
                        ),
                      ],
                    )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: const [
                      Expanded(
                        child: Divider(
                          color: Color(0xff666666),
                          thickness: 0.3,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "OR",
                        style: TextStyle(
                          color: Color(0xff666666),
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Divider(
                          color: Color(0xff666666),
                          thickness: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Google Sign In Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgButton(
                          svgPath: "lib/assets/google.svg",
                          onPressed: () {},
                          color: const Color.fromARGB(255, 246, 246, 246),
                          borderRadius: 15,
                          height: 55,
                          elevation: 0,
                          width: width * 0.3),
                      SvgButton(
                          svgPath: "lib/assets/twitter.svg",
                          onPressed: () {},
                          color: const Color.fromARGB(255, 246, 246, 246),
                          borderRadius: 15,
                          elevation: 0,
                          height: 55,
                          width: width * 0.3),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
