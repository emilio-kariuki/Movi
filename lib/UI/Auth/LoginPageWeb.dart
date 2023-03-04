import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movistar/UI/Home/HomePage.dart';

import 'package:movistar/UI/Widget/InputField.dart';
import 'package:movistar/Util/Responsive.dart';
import 'package:movistar/Util/SharedPreferencesManager.dart';
import 'package:movistar/blocs/Auth/auth_bloc.dart';
import 'package:movistar/blocs/Authentication/authentication_bloc.dart';

import '../../Repository/AuthRepository.dart';

class LoginPageWeb extends StatefulWidget {
  const LoginPageWeb({super.key});

  @override
  State<LoginPageWeb> createState() => _LoginPageWebState();
}

class _LoginPageWebState extends State<LoginPageWeb>
    with SingleTickerProviderStateMixin {
  var tweenLeft =
      Tween<Offset>(begin: const Offset(2, 0), end: const Offset(0, 0))
          .chain(CurveTween(curve: Curves.ease));
  var tweenRight =
      Tween<Offset>(begin: const Offset(0, 0), end: const Offset(2, 0))
          .chain(CurveTween(curve: Curves.ease));

  AnimationController? _animationController;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final resetPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
          authRepo: AuthRepo(),
          sharedPreferenceManager: SharedPreferenceManager(),
          authenticationBloc:AuthenticationBloc()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.loose,
          children: [
            Responsive.isDesktop(context) || Responsive.isTablet(context)
                ? Row(
                    children: [
                      //slider widget
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                image: AssetImage("lib/Assets/marker.jpg"),
                                fit: BoxFit.cover)),
                      ),

                      //authentication widgets
                      Responsive.isDesktop(context) ||
                              Responsive.isTablet(context)
                          ? Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width / 2,
                              color: const Color(0xff666666),
                              child: Center(
                                child: Container(
                                  color: const Color(0xff666666),
                                  padding: const EdgeInsets.all(42),
                                  width:
                                      MediaQuery.of(context).size.width / 3.6,
                                  height:
                                      MediaQuery.of(context).size.height / 1.2,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 60,
                                      ),
                                      Image.asset(
                                        "lib/Assets/jobsy.jpeg",
                                        height: 100,
                                        width: 100,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Flexible(
                                        child: Stack(
                                          children: [
                                            SlideTransition(
                                              position: _animationController!
                                                  .drive(tweenRight),
                                              child: Stack(
                                                  fit: StackFit.loose,
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    _loginScreen(context),
                                                  ]),
                                            ),
                                            SlideTransition(
                                              position: _animationController!
                                                  .drive(tweenLeft),
                                              child: Stack(
                                                  fit: StackFit.loose,
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    _registerScreen(context),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width,
                              color: const Color(0xff666666),
                              child: Center(
                                child: Container(
                                  color: const Color(0xff666666),
                                  padding: Responsive.isDesktop(context) ||
                                          Responsive.isTablet(context)
                                      ? const EdgeInsets.all(42)
                                      : const EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 60,
                                      ),
                                      Image.asset(
                                        "lib/Assets/jobsy.jpeg",
                                        height: 100,
                                        width: 100,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Flexible(
                                        child: Stack(
                                          children: [
                                            SlideTransition(
                                              position: _animationController!
                                                  .drive(tweenRight),
                                              child: Stack(
                                                  fit: StackFit.loose,
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    _loginScreen(context),
                                                  ]),
                                            ),
                                            SlideTransition(
                                              position: _animationController!
                                                  .drive(tweenLeft),
                                              child: Stack(
                                                  fit: StackFit.loose,
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    _registerScreen(context),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                    ],
                  )
                : Column(
                    children: [
                      //slider widget
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                image: AssetImage("lib/Assets/marker.jpg"),
                                fit: BoxFit.cover)),
                      ),

                      //authentication widgets
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        color: const Color(0xff666666),
                        child: Center(
                          child: Container(
                            color: const Color(0xff666666),
                            padding: const EdgeInsets.all(42),
                            width: MediaQuery.of(context).size.width / 3.6,
                            height: MediaQuery.of(context).size.height / 1.2,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 60,
                                ),
                                Image.asset(
                                  "lib/Assets/jobsy.jpeg",
                                  height: 100,
                                  width: 100,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Flexible(
                                  child: Stack(
                                    children: [
                                      SlideTransition(
                                        position: _animationController!
                                            .drive(tweenRight),
                                        child: Stack(
                                            fit: StackFit.loose,
                                            clipBehavior: Clip.none,
                                            children: [
                                              _loginScreen(context),
                                            ]),
                                      ),
                                      SlideTransition(
                                        position: _animationController!
                                            .drive(tweenLeft),
                                        child: Stack(
                                            fit: StackFit.loose,
                                            clipBehavior: Clip.none,
                                            children: [
                                              _registerScreen(context),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  Widget _registerScreen(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthRegisterError) {
          _onWidgetDidBuild(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                width: MediaQuery.of(context).size.width * 0.2,
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        if (state is AuthRegisterSuccess) {
          _onWidgetDidBuild(() async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                width: MediaQuery.of(context).size.width * 0.2,
                content: const Text("Registration Success"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>  Home(),
              ),
            );
          });
        }

        return Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 0.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InputField(
                  controller: nameController,
                  label: "Name",
                  hint: "name",
                  focusNode: FocusNode(),
                ),
                const SizedBox(height: 5),
                InputField(
                  controller: emailController,
                  label: "Email",
                  hint: "email",
                  focusNode: FocusNode(),
                ),
                const SizedBox(height: 5),
                InputField(
                  controller: passwordController,
                  label: "Password",
                  hint: "password",
                  focusNode: FocusNode(),
                ),
                const SizedBox(
                  height: 15,
                ),
                state is AuthRegisterLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      )
                    : clickButton(
                        label: "Register",
                        onPressed: () {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty ||
                              nameController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                width: MediaQuery.of(context).size.width * 0.2,
                                content:
                                    const Text("Please fill all the fields"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            BlocProvider.of<AuthBloc>(context).add(
                              RegisterButtonPressed(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                          }
                        },
                      ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Wrap(
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          _animationController!.reverse();
                        },
                        child: Text(
                          "Login",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.blue[600],
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }

  Widget _loginScreen(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoginError) {
            _onWidgetDidBuild(() {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  width: MediaQuery.of(context).size.width * 0.2,
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            });
          }

          if (state is AuthLoginSuccess) {
            _onWidgetDidBuild(() {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  width: MediaQuery.of(context).size.width * 0.2,
                  content: const Text("Login Success"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>  Home(),
                ),
              );
            });
          }

          return Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 0.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InputField(
                    controller: emailController,
                    label: "Email",
                    hint: "email",
                    focusNode: FocusNode(),
                  ),
                  const SizedBox(height: 5),
                  InputField(
                    controller: passwordController,
                    label: "Password",
                    hint: "password",
                    focusNode: FocusNode(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor:const Color(0xff666666),

                                  title: const Text(
                                    "Reset Password",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: SizedBox(
                                      height: 200,
                                      width: 250,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // ignore: prefer_const_constructors
                                          Text(
                                              "Enter a valid email to reset your password",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400)),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          InputField(
                                            controller: resetPasswordController,
                                            label: "Email",
                                            hint: "email",
                                           focusNode: FocusNode(),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Center(
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                  width: 200,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Colors.blue[600],
                                                      // padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      AuthRepo().resetPassword(
                                                          email:
                                                              resetPasswordController
                                                                  .text);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      "Send",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              });
                        },
                        child: Text(
                          "Forgot Password?",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color:Colors.blue[600],
                                  ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  state is AuthLoginLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        )
                      : clickButton(
                          label: "Login",
                          onPressed: () {
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              _onWidgetDidBuild(() {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    content: const Text(
                                        "Please fill all the fields"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              });
                            } else {
                              BlocProvider.of<AuthBloc>(context).add(
                                LoginButtonPressed(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );
                            }
                          },
                        ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Wrap(
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        TextButton(
                          onPressed: () {
                            _animationController!.forward();
                          },
                          child: Text(
                            "Register",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.blue[600],
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }

  Widget clickButton({required String label, required Function() onPressed}) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          // padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
