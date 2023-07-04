import 'package:flutter/material.dart';

import '../services/auth_services.dart';
import '../../../common/widgets/custom_textformfield.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../constants/global_variables.dart';

enum AuthFunction {
  //There can be two types of user one has an account and want to logs in and another which wants to create a new account ie sign up, so creating a enup for that
  login,
  signup,
}

class AuthScreen extends StatefulWidget {
  static const String routeName =
      '/auth-screen'; //This is the route name , ie whenever we use the pushNamed then the screen we want to push to should have a name so specifying the name here ,(rest things about the route for the flutter can be seen in the router.dart file)
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthFunction _auth = AuthFunction.signup;

  final _newAccountKey =
      GlobalKey<FormState>(); //creating a key for the sign up form (signup)
  final _existingAccountKey =
      GlobalKey<FormState>(); //creating a key for existing account (login)
  final AuthService authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  //Method to invoke the sinup method in the authservice
  void signuptheUser(bool isGoogleSignIn) {
    authService.signUpUser(
      context: context,
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      isGoogle: isGoogleSignIn,
    );
  }

  //Method to invoke the sinin method in the authservice
  void signIntheUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: GlobalVariables.greyBackgroundColor,
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              "Welcome to the AtoZShop",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
            child: const Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
          ListTile(
              tileColor: _auth == AuthFunction.signup
                  ? Colors.white38
                  : GlobalVariables.greyBackgroundColor,
              title: const Text(
                "Create Account",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Radio(
                value: AuthFunction.signup, //Value of this auth is signup
                activeColor: GlobalVariables.secondaryColor,
                onChanged: (AuthFunction? val) {
                  setState(() {
                    _auth =
                        val!; //changing the value of the variable passed to the group value and set state is run
                  });
                },
                groupValue:
                    _auth, //This takes in the selected value out of all the group values , so the type should be of the group values and since this is a variable we have to keep track of so we will have to make a variable of this , and this value whenever changed will change which radio button will be active , because its vaulue is compared with the value of value parameter and if it matches then we will get that radio as active
              )),
          if (_auth == AuthFunction.signup)
            Container(
              color: Colors.white38,
              padding: const EdgeInsets.all(20),
              child: Form(
                  key: _newAccountKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        mycontroller: _nameController,
                        hinttxt: "Name",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        mycontroller: _emailController,
                        hinttxt: "Email",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        mycontroller: _passwordController,
                        hinttxt: "Password",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                          toShow: "Register",
                          onTap: () {
                            if (_newAccountKey.currentState!.validate()) {
                              //if validation is successful then sugn up the user else the error will be shown (which we had retunred from the validate() in the text form field)
                              signuptheUser(false);
                            }
                          }),
                    ],
                  )),
            ),
          ListTile(
              tileColor: _auth == AuthFunction.login
                  ? Colors.white38
                  : GlobalVariables.greyBackgroundColor,
              title: const Text(
                "Already Have An Account?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Radio(
                value: AuthFunction.login,
                activeColor: GlobalVariables.secondaryColor,
                onChanged: (AuthFunction? val) {
                  setState(() {
                    _auth = val!;
                  });
                },
                groupValue: _auth,
              )),
          if (_auth == AuthFunction.login)
            //For login the form is similar with no name field
            Container(
              color: Colors.white38,
              padding: const EdgeInsets.all(20),
              child: Form(
                  key: _existingAccountKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        mycontroller: _emailController,
                        hinttxt: "Email",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        mycontroller: _passwordController,
                        hinttxt: "Password",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                          toShow: "Log In",
                          onTap: () {
                            if (_existingAccountKey.currentState!.validate()) {
                              signIntheUser();
                            }
                          })
                    ],
                  )),
            ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            onPressed: () => signuptheUser(true),
            icon: Image.asset(
              'assets/images/googleLogo.png',
              height: 20,
            ),
            label: const Text(
              'Sign in with Google',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(150, 50),
            ),
          ),
        ],
      )),
    );
  }
}
