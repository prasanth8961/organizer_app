import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organizer_app/PageRouter/page_routes.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:organizer_app/Provider/auth_provider.dart';
import 'package:organizer_app/Provider/image_picker_provider.dart';
import 'package:organizer_app/Screens/Auth/HelperWidget/custom_text_field.dart';
import 'package:organizer_app/Screens/Auth/HelperWidget/document_picker.dart';
import 'package:organizer_app/Screens/Auth/HelperWidget/image_picker.dart';
import 'package:organizer_app/Utils/const_color.dart';
import 'package:organizer_app/Utils/scaffold_messenger.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _collegeNameController = TextEditingController();
  final _collegeCodeController = TextEditingController();
  final _locationController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPassword = true;
  bool _showConfirmPassword = true;

  void _togglePasswordVisibility(String field) {
    setState(() {
      switch (field) {
        case 'Password':
          _showPassword = !_showPassword;
          break;
        case 'Confirm Password':
          _showConfirmPassword = !_showConfirmPassword;
          break;
      }
    });
  }

  String phoneNumber = '';
  String cCode = '';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final filePickerProvider = Provider.of<ImagePickerProvider>(context);
    final selectedFile = filePickerProvider.selectedFile;

    void handleSubmit(dynamic filePickerProvider) async {
      if (_formKey.currentState!.validate()) {
        final random = Random();
        final orgID = 100000 + random.nextInt(900000);

        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        final formData = {
          "org_id": orgID,
          "full_name": _fullNameController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
          "country_code": cCode,
          "mobile": phoneNumber,
          "college_code": _collegeCodeController.text,
          "college_name": _collegeNameController.text,
          "location": _locationController.text,
          "longitude": _longitudeController.text,
          "latitude": _latitudeController.text,
        };

        List<dynamic> imagePaths =
            filePickerProvider.images.map((e) => e?.path).toList();
        final fileData = filePickerProvider.selectedFile?.path;

        final message =
            await authProvider.signUp(formData, imagePaths, fileData);

        if (context.mounted) {
          showCustomSnackBar(context, message);
        }
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.08),
              Text(
                "Sign Up!",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: screenWidth * 0.1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Welcome Aboard!",
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Form(
                key: _formKey,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CustomTextFieldWidget(
                          controller: _fullNameController,
                          label: 'Full Name',
                          screenWidth: screenWidth,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          }),
                      SizedBox(height: screenHeight * 0.02),
                      CustomTextFieldWidget(
                          controller: _emailController,
                          label: 'E-mail',
                          screenWidth: screenWidth,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          }),
                      SizedBox(height: screenHeight * 0.02),
                      CustomTextFieldWidget(
                          controller: _collegeNameController,
                          label: 'College Name',
                          screenWidth: screenWidth,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your college name';
                            }
                            return null;
                          }),
                      SizedBox(height: screenHeight * 0.02),
                      CustomTextFieldWidget(
                          controller: _collegeCodeController,
                          label: 'College Code',
                          screenWidth: screenWidth,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your college code';
                            }
                            return null;
                          }),
                      SizedBox(height: screenHeight * 0.02),
                      IntlPhoneField(
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: primaryColor, width: 1.5),
                          ),
                        ),
                        initialCountryCode: 'IN',
                        onChanged: (phone) {
                          cCode = phone.countryCode.toString();
                          phoneNumber = phone.number.toString();
                        },
                        validator: (value) {
                          if (value == null || value.number.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CustomTextFieldWidget(
                          controller: _latitudeController,
                          label: 'Latitude',
                          screenWidth: screenWidth,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter latitude';
                            }
                            return null;
                          }),
                      SizedBox(height: screenHeight * 0.02),
                      CustomTextFieldWidget(
                          controller: _longitudeController,
                          label: 'Longitude',
                          screenWidth: screenWidth,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter longitude';
                            }
                            return null;
                          }),
                      SizedBox(height: screenHeight * 0.02),
                      CustomTextFieldWidget(
                          controller: _locationController,
                          label: 'Location',
                          screenWidth: screenWidth,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter location';
                            }
                            return null;
                          }),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _showPassword,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: primaryColor, width: 1.5),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () =>
                                _togglePasswordVisibility('Password'),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _showConfirmPassword,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: primaryColor, width: 1.5),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () =>
                                _togglePasswordVisibility('Confirm Password'),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      DocumentPickerWidget(
                          filePickerProvider: filePickerProvider,
                          selectedFile: selectedFile),
                      SizedBox(height: screenHeight * 0.02),
                      ImagePickerWidget(filePickerProvider: filePickerProvider),
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Already have an account? "),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(PageRoutes.loginscreen);
                              },
                              child: const Text(
                                "Log in",
                                style: TextStyle(color: Color(0xFF46BCC3)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF46BCC3),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => handleSubmit(filePickerProvider),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
