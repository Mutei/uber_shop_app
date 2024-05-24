import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uber_shop_app/resources/auth_methods.dart';
import 'package:uber_shop_app/constants/styles.dart';
import 'package:uber_shop_app/extension/sized_box_extension.dart';
import 'package:uber_shop_app/localization/language_constants.dart';
import 'package:uber_shop_app/screens/login_screen.dart';

import '../constants/colors.dart';
import '../textFormField/text_form_style.dart';
import '../utils/image_picker_file.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool validateEmail = true;
  bool validatePassword = true;
  bool check = false;
  late String email;
  late String fullName;
  late String password;
  Uint8List? _image;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthMethods authMethods = AuthMethods();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTranslated(
                      context,
                      "Sign up Page",
                    ),
                    style: kGoogleFontsStyle,
                  ),
                  10.kH,
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: AssetImage('images/default.jpg'),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ],
                  ),
                  TextFormFieldStyle(
                    onChanged: (value) {
                      fullName = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(
                          context,
                          'Name must be Entered',
                        );
                      }
                      return null;
                    },
                    context: context,
                    hint: getTranslated(
                      context,
                      "Enter your Name",
                    ),
                    icon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                    control: _fullNameController,
                    isObsecured: false,
                    validate: validateEmail,
                    textInputType: TextInputType.emailAddress,
                    showVisibilityToggle: false,
                  ),
                  TextFormFieldStyle(
                    onChanged: (value) {
                      email = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(
                          context,
                          'Enter your Email',
                        );
                      }
                      return null;
                    },
                    context: context,
                    hint: getTranslated(
                      context,
                      "Enter your Email",
                    ),
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
                        return getTranslated(
                          context,
                          'Password must be Entered',
                        );
                      }
                      return null;
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
                          print(fullName);
                          authMethods.signUpUser(
                            email: _emailController.text,
                            password: _passwordController.text,
                            userName: _fullNameController.text,
                            profilePicture: _image!,
                          );
                          print("Users details is: ...>");
                          authMethods.getUserDetails();
                        } else {
                          print(
                            getTranslated(
                              context,
                              "Not Valid",
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 36),
                        backgroundColor: kPrimaryColor,
                      ),
                      child: Text(
                        getTranslated(
                          context,
                          'Register',
                        ),
                        style: TextStyle(
                          color: kTypeUserTextColor,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      getTranslated(
                        context,
                        "Already have an Account?",
                      ),
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
