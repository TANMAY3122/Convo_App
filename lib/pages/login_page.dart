import 'package:carousel_slider/carousel_slider.dart';
import 'package:convo/components/my_button.dart';
import 'package:convo/components/my_text_field.dart';
import 'package:convo/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in user
  void signIn() async {
    // get the auth service

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Convos",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 40,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    CarouselSlider(
                        items: [
                          "Let's start your Convos now",
                          "Secured 1 on 1 Convos",
                          "Aesthetic UI/UX",
                          "What are you waiting for ? ",
                          "Sign In/Up Now"
                        ].map((i) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Center(
                                child: Text(
                                  "$i",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(height: 200)),
                    // const SizedBox(
                    //   height: 50.0,
                    // ),
                    //logo
                    // const Icon(
                    //   Icons.forum_sharp,
                    //   size: 100,
                    // ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    //welcome back message
                    const Text(
                      "Welcome back you have been missed!",
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    //email textfield
                    MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false),

                    const SizedBox(
                      height: 10.0,
                    ),
                    //password textfield
                    MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true),

                    const SizedBox(
                      height: 25.0,
                    ),
                    //sign in button
                    MyButton(onTap: signIn, text: 'Sign in'),

                    const SizedBox(
                      height: 50.0,
                    ),
                    //not a user?register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Not a user?"),
                        const SizedBox(
                          width: 5.0,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Register Now",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
