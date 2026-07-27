import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'home_screen.dart';
import 'signin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final occupationController = TextEditingController();

  bool isEditing = false;
  bool isLoading = true;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    occupationController.dispose();
    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// LOAD USER DATA
  ////////////////////////////////////////////////////////////
  Future<void> loadUserData() async {
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    final doc = await firestore.collection("users").doc(user!.uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      nameController.text = data["name"] ?? "";
      emailController.text = user!.email ?? "";
      phoneController.text = data["phone"] ?? "";
      occupationController.text = data["occupation"] ?? "";
      imageUrl = data["profileImage"];
    } else {
      emailController.text = user!.email ?? "";
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  ////////////////////////////////////////////////////////////
  /// UPDATE PROFILE
  ////////////////////////////////////////////////////////////
  Future<void> updateProfile() async {
    if (user == null) return;

    await firestore.collection("users").doc(user!.uid).set({
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "occupation": occupationController.text.trim(),
    }, SetOptions(merge: true));

    await user!.updateDisplayName(nameController.text.trim());

    if (mounted) {
      setState(() => isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated ✅")),
      );
    }
  }

  ////////////////////////////////////////////////////////////
  /// IMAGE PICK
  ////////////////////////////////////////////////////////////
  Future<void> pickImage(ImageSource source) async {
    if (user == null) return;

    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null) return;

    File imageFile = File(picked.path);

    var uri =
        Uri.parse("https://api.cloudinary.com/v1_1/dyuuqon2o/image/upload");

    var request = http.MultipartRequest("POST", uri);
    request.fields['upload_preset'] = "toass5ln";
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var data = json.decode(respStr);
      String url = data['secure_url'];

      await firestore.collection("users").doc(user!.uid).set(
        {"profileImage": url},
        SetOptions(merge: true),
      );

      if (mounted) {
        setState(() => imageUrl = url);
      }
    }
  }

  void showImageSourceSelector() {
    if (!isEditing) return;

    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Gallery"),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// UI
  ////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/bg.png", fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.2)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ////////////////////////////////////////////////////////////
                  /// TOP BAR (FIXED)
                  ////////////////////////////////////////////////////////////
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()),
                          );
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Profile",
                            style: const TextStyle(
                              fontFamily: "Cinzel",
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: Color.fromARGB(255, 10, 10, 10),
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black54,
                                  offset: Offset(1, 1),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(isEditing ? Icons.check : Icons.edit),
                        onPressed: () {
                          if (isEditing) {
                            updateProfile();
                          } else {
                            setState(() => isEditing = true);
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ////////////////////////////////////////////////////////////
                  /// PROFILE IMAGE
                  ////////////////////////////////////////////////////////////
                  GestureDetector(
                    onTap: showImageSourceSelector,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          imageUrl != null ? NetworkImage(imageUrl!) : null,
                      child: imageUrl == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ////////////////////////////////////////////////////////////
                  /// NAME + EMAIL
                  ////////////////////////////////////////////////////////////
                  Text(
                    nameController.text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    emailController.text,
                    style:
                        const TextStyle(color: Color.fromARGB(179, 10, 10, 10)),
                  ),

                  const SizedBox(height: 20),

                  ////////////////////////////////////////////////////////////
                  /// CARD
                  ////////////////////////////////////////////////////////////
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildField(nameController, "Full Name"),
                        _buildField(emailController, "Email", enabled: false),
                        _buildField(phoneController, "Phone"),
                        _buildField(occupationController, "Occupation"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  ////////////////////////////////////////////////////////////
                  /// LOGOUT BUTTON
                  ////////////////////////////////////////////////////////////
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const SignInScreen()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// FIELD
  ////////////////////////////////////////////////////////////
  Widget _buildField(TextEditingController controller, String label,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        enabled: enabled && isEditing,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
