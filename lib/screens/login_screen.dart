import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uber_shop_app/auth/auth_methods.dart';
import 'package:uber_shop_app/constants/styles.dart';
import 'package:uber_shop_app/extension/sized_box_extension.dart';
import 'package:uber_shop_app/localization/language_constants.dart';
import 'package:uber_shop_app/screens/sign_up_screen.dart';
import '../constants/colors.dart';
import '../textFormField/text_form_style.dart';
import '../main.dart'; // Import the main.dart file where MyApp is defined
import '../widgets/language_selector.dart'; // Import the LanguageSelector widget

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool validateEmail = true;
  bool validatePassword = true;
  bool check = false;
  String _selectedLanguage = 'en';
  late String email;
  late String password; // Default language

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _changeLanguage(String languageCode) async {
    Locale locale = await setLocale(languageCode);
    MyApp.setLocale(context, locale);
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthMethods authMethods = AuthMethods();
    return Scaffold(
      appBar: AppBar(
        actions: [
          LanguageSelector(
            selectedLanguage: _selectedLanguage,
            onLanguageChanged: _changeLanguage,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTranslated(context, "Login Account"),
                    style: kGoogleFontsStyle,
                  ),
                  10.kH,
                  TextFormFieldStyle(
                    onChanged: (value) {
                      email = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(context, 'Enter your Email');
                      }
                      return null; // Return null when the input is valid
                    },
                    context: context,
                    hint: getTranslated(context, "Enter your Email"),
                    icon: Icon(
                      Icons.email,
                      color: kPrimaryColor,
                    ),
                    control: _emailController,
                    isObsecured: false,
                    validate: validateEmail,
                    textInputType: TextInputType.emailAddress,
                    showVisibilityToggle: false,
                  ),
                  TextFormFieldStyle(
                    onChanged: (value) {
                      password = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(context, 'Enter your Password');
                      }
                      return null; // Return null when the input is valid
                    },
                    context: context,
                    hint: getTranslated(context, "Password"),
                    icon: Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                    control: _passwordController,
                    isObsecured: true,
                    validate: validatePassword,
                    textInputType: TextInputType.text,
                    showVisibilityToggle: true,
                  ),
                  10.kH,
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print(email);
                          print(password);
                          authMethods.loginUser(
                              email: _emailController.text,
                              password: _passwordController.text);
                        } else {
                          print(
                            getTranslated(context, "Not Valid"),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 36),
                        backgroundColor: kPrimaryColor,
                      ),
                      child: Text(
                        getTranslated(context, 'Login'),
                        style: const TextStyle(
                          color: kTypeUserTextColor,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      getTranslated(context, "Need an Account?"),
                    ),
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
