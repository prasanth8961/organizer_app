import 'package:flutter/material.dart';
import 'package:organizer_app/Helper/api_service.dart';
import 'package:organizer_app/Model/user_model.dart';
import 'package:organizer_app/Provider/image_picker_provider.dart';
import 'package:organizer_app/Provider/user_data_provider.dart';
import 'package:organizer_app/Screens/Auth/login_screen.dart';
import 'package:organizer_app/CommonWidgets/text_style.dart';
import 'package:organizer_app/Screens/Profile/HelperWidget/custom_profile_image.dart';
import 'package:organizer_app/Screens/Profile/HelperWidget/custom_text_filed.dart';
import 'package:organizer_app/Screens/Profile/HelperWidget/profile_page_shimmer.dart';
import 'package:organizer_app/Utils/scaffold_messenger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/const_color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'email': TextEditingController(),
    'contact': TextEditingController(),
    'city': TextEditingController(),
    'orgCode': TextEditingController(),
    'orgName': TextEditingController(),
  };

  final Map<String, bool> _isEditable = {
    'name': false,
    'email': false,
    'contact': false,
    'city': false,
    'orgCode': false,
    'orgName': false,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserDataProvider>(context, listen: false).fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          InkWell(
            onTap: () => _showLogoutDialog(context),
            child: const Row(
              children: [
                Text(
                  "Logout",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5),
                Icon(Icons.exit_to_app_outlined, color: Colors.white),
                SizedBox(width: 5),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<UserDataProvider>(
        builder: (context, userDataProvider, child) {
          if (userDataProvider.userData.isEmpty) {
            return const ProfilePageShimmer();
          }

          final user = userDataProvider.userData.first;

          _initializeControllers(user);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomeProfileImageWidget(
                    photoUrl:
                        "${imageBaseUrl}organizer_profile/${user.profile}",
                    user: user),
                const SizedBox(height: 20),
                _buildReadOnlyField(
                    "ID : ${user.orgId}", user.orgId.toString()),
                const SizedBox(height: 10),
                CustomTextFiled(
                    controllers: _controllers,
                    isEditable: _isEditable,
                    onPressed: () {
                      setState(() {
                        _isEditable["name"] = !_isEditable["name"]!;
                      });
                    },
                    label: "Name",
                    labelKey: "name"),
                const SizedBox(height: 10),
                CustomTextFiled(
                    controllers: _controllers,
                    isEditable: _isEditable,
                    onPressed: () {
                      setState(() {
                        _isEditable["email"] = !_isEditable["email"]!;
                      });
                    },
                    label: "Email",
                    labelKey: 'email'),
                const SizedBox(height: 10),
                CustomTextFiled(
                    controllers: _controllers,
                    isEditable: _isEditable,
                    onPressed: () {
                      setState(() {
                        _isEditable["contact"] = !_isEditable["contact"]!;
                      });
                    },
                    label: "Contact",
                    labelKey: 'contact'),
                const SizedBox(height: 10),
                CustomTextFiled(
                    controllers: _controllers,
                    isEditable: _isEditable,
                    onPressed: () {
                      setState(() {
                        _isEditable["email"] = !_isEditable["email"]!;
                      });
                    },
                    label: "City",
                    labelKey: 'city'),
                const SizedBox(height: 10),
                CustomTextFiled(
                    controllers: _controllers,
                    isEditable: _isEditable,
                    onPressed: () {
                      setState(() {
                        _isEditable["orgCode"] = !_isEditable["orgCode"]!;
                      });
                    },
                    label: "Organization Code",
                    labelKey: "orgCode"),
                const SizedBox(height: 10),
                CustomTextFiled(
                    controllers: _controllers,
                    isEditable: _isEditable,
                    onPressed: () {
                      setState(() {
                        _isEditable["orgName"] = !_isEditable["orgName"]!;
                      });
                    },
                    label: "Organization Name",
                    labelKey: "orgName"),
                const SizedBox(height: 20),
                _buildUpdateButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _initializeControllers(UserModel user) {
    _controllers['name']?.text = user.fullName;
    _controllers['email']?.text = user.email;
    _controllers['contact']?.text = '${user.countryCode} ${user.mobile}';
    _controllers['city']?.text = user.location;
    _controllers['orgCode']?.text = user.collegeCode;
    _controllers['orgName']?.text = user.collegeName;
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Do you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No",
                style: TextStyle(
                    color: secondaryColor, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove("accessToken");

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Yes",
                style: TextStyle(
                    color: primaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: false,
              maxLines: 1,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        final imgFile = Provider.of<ImagePickerProvider>(context, listen: false)
            .profileImage;

        if (imgFile != null) {
          final message =
              await Provider.of<UserDataProvider>(context, listen: false)
                  .updateProfileImage(imgFile);
          showCustomSnackBar(context, message);
        } else {
          showCustomSnackBar(context, "Image not found");
        }

        _isEditable.updateAll((key, value) => false);
      },
      icon: const Icon(Icons.upload_file, color: Colors.white),
      label: Text('Update Profile',
          style: textStyle(15, Colors.white, FontWeight.w500)),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      ),
    );
  }
}
