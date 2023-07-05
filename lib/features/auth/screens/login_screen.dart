import 'package:a_to_z_shop/constants/global_variables.dart';
import 'package:a_to_z_shop/features/auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/custom_textformfield.dart';
import '../services/auth_services.dart';

class LogInScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _existingAccountKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signIntheUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void signuptheUser(bool isGoogleSignIn) {
    authService.signUpUser(
      context: context,
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      isGoogle: isGoogleSignIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: GlobalVariables.greyBackgroundColor,
        body: ListView(
          children: <Widget>[
            const SizedBox(
              height: 150,
            ),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  width: deviceSize.width * 0.9,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                      key: _existingAccountKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            mycontroller: _emailController,
                            hinttxt: "Email",
                            icon: const Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            isForm: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            mycontroller: _passwordController,
                            hinttxt: "Password",
                            icon:
                                const Icon(Icons.password, color: Colors.white),
                            isForm: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )),
                ),
                Positioned(
                  bottom: -20,
                  child: Container(
                    height: 40,
                    width: 110,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (_existingAccountKey.currentState!.validate()) {
                          signIntheUser();
                        }
                      },
                      child: const SizedBox(
                        child: Text(
                          "LOG IN",
                          style: TextStyle(
                            color: Color(0XFFFEF2E0),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 25,
                bottom: 8,
              ),
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: const Text(
                "OR",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              child: Container(
                height: 60,
                width: 200,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0XFFFEF2E0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton.icon(
                  onPressed: () => signuptheUser(true),
                  icon: Image.asset(
                    'assets/images/googleLogo.png',
                    height: 20,
                  ),
                  label: const Text(
                    'Sign in with Google',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    // backgroundColor: GlobalVariables.secondaryColor,
                    minimumSize: const Size(150, 50),
                  ),
                ),
              ),
            ),
            Align(
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    const Text(
                      "New to Fitness App?",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                      ),
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          color: GlobalVariables.secondaryColor,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, SignUpScreen.routeName);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
