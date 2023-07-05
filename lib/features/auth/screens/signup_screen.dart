import 'package:a_to_z_shop/constants/global_variables.dart';
import 'package:a_to_z_shop/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';

// import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_textformfield.dart';
import '../services/auth_services.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup-screen';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _newAccountKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                      key: _newAccountKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            mycontroller: _nameController,
                            hinttxt: "Name",
                            icon: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            isForm: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                    width: 120,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (_newAccountKey.currentState!.validate()) {
                          signuptheUser(false);
                        }
                      },
                      child: const SizedBox(
                        child: Text(
                          "SIGN UP",
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
                style: TextStyle(
                    // color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
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
                // child: const Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: <Widget>[
                //     Text(
                //       "Sign up using",
                //       style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 16,
                //       ),
                //     ),
                //     // FaIcon(
                //     //   FontAwesomeIcons.google,
                //     //   color: Colors.black,
                //     // ),
                //   ],
                // ),
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
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                      ),
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          color: GlobalVariables.secondaryColor,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, LogInScreen.routeName);
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
