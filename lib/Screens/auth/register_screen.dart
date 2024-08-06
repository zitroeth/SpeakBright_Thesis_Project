// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:speakbright_mobile/Widgets/constants.dart';
import '../../Widgets/waiting_dialog.dart';
import 'login_screen.dart';
import 'package:date_field/date_field.dart';

class RegistrationScreen extends StatefulWidget {
  static const String route = "/register";
  static const String name = "Registration Screen";
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController username, password, password2, name, birthday;
  late FocusNode usernameFn, passwordFn, password2Fn, nameFn, birthdayFn;
  DateTime? selectedBirthday;
  String? userType;

  bool obfuscate = true;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    username = TextEditingController();
    usernameFn = FocusNode();
    password = TextEditingController();
    passwordFn = FocusNode();
    password2 = TextEditingController();
    password2Fn = FocusNode();
    name = TextEditingController();
    nameFn = FocusNode();
    birthday = TextEditingController();
    birthdayFn = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    usernameFn.dispose();
    password.dispose();
    passwordFn.dispose();
    password2.dispose();
    password2Fn.dispose();
    name.dispose();
    nameFn.dispose();
    birthday.dispose();
    birthdayFn.dispose();
  }

  Widget buildUserTypeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: decoration.copyWith(
        labelText: "User Type",
        prefixIcon: const Icon(Icons.person_outline),
      ),
      value: userType,
      items: ["Student", "Guardian"].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          userType = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a user type' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kwhite,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          height: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    onSubmit();
                  },
                  child: const Text("Register"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainpurple,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 18),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Flexible(
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _isHovering = true),
                    onExit: (_) => setState(() => _isHovering = false),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      ),
                      child: Text(
                        "Already have an account? Login here",
                        style: TextStyle(
                            color: _isHovering ? mainpurple : dullpurple),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset('assets/SpeakBright_P.png',
                    width: 300, height: 180),
                Center(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 12,
                        child: Image.asset('assets/v_line.png'),
                      ),
                      Image.asset(
                        'assets/v_line.png',
                        width: 70,
                      ),
                      const SizedBox(
                        width: 21,
                      ),
                      const Text(
                        "Registration",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w100,
                          color: dullpurple,
                        ),
                      ),
                      const SizedBox(
                        width: 21,
                      ),
                      Image.asset('assets/v_line.png', width: 70),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Flexible(
                  child: TextFormField(
                    decoration: decoration.copyWith(
                        labelText: "Name",
                        prefixIcon: const Icon(Icons.person)),
                    focusNode: nameFn,
                    controller: name,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Please enter your name'),
                    ]).call,
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: buildUserTypeDropdown(),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: DateTimeFormField(
                    decoration: const InputDecoration(labelText: 'Birthday'),
                    mode: DateTimeFieldPickerMode.date,
                    onChanged: (DateTime? value) {
                      print(value);
                      setState(() {
                        selectedBirthday = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Flexible(
                  child: TextFormField(
                    decoration: decoration.copyWith(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.person)),
                    focusNode: usernameFn,
                    controller: username,
                    onEditingComplete: () {
                      passwordFn.requestFocus();
                    },
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: 'Please fill out the username'),
                      EmailValidator(errorText: "Please select a valid email"),
                    ]).call,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: obfuscate,
                    decoration: decoration.copyWith(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obfuscate = !obfuscate;
                              });
                            },
                            icon: Icon(obfuscate
                                ? Icons.remove_red_eye_rounded
                                : CupertinoIcons.eye_slash))),
                    focusNode: passwordFn,
                    controller: password,
                    onEditingComplete: () {
                      password2Fn.requestFocus();
                    },
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Password is required"),
                      MinLengthValidator(12,
                          errorText:
                              "Password must be at least 12 characters long"),
                      MaxLengthValidator(128,
                          errorText: "Password cannot exceed 72 characters"),
                      PatternValidator(
                          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+?\-=[\]{};':,.<>]).*$",
                          errorText:
                              'Password must contain at least one symbol, one uppercase letter, one lowercase letter, and one number.')
                    ]).call,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Flexible(
                  child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obfuscate,
                      decoration: decoration.copyWith(
                          labelText: "Confirm Password",
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obfuscate = !obfuscate;
                                });
                              },
                              icon: Icon(obfuscate
                                  ? Icons.remove_red_eye_rounded
                                  : CupertinoIcons.eye_slash))),
                      focusNode: password2Fn,
                      controller: password2,
                      onEditingComplete: () {
                        password2Fn.unfocus();
                      },
                      validator: (v) {
                        String? doesMatchPasswords =
                            password.text == password2.text
                                ? null
                                : "Passwords doesn't match";
                        if (doesMatchPasswords != null) {
                          return doesMatchPasswords;
                        } else {
                          return MultiValidator([
                            RequiredValidator(
                                errorText: "Password is required"),
                            MinLengthValidator(12,
                                errorText:
                                    "Password must be at least 12 characters long"),
                            MaxLengthValidator(128,
                                errorText:
                                    "Password cannot exceed 72 characters"),
                            PatternValidator(
                                r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+?\-=[\]{};':,.<>]).*$",
                                errorText:
                                    'Password must contain at least one symbol, one uppercase letter, one lowercase letter, and one number.'),
                          ]).call(v);
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        UserCredential? userCredential = await WaitingDialog.show(
          context,
          future: FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: username.text.trim(),
            password: password.text.trim(),
          ),
        );

        if (userCredential?.user != null) {
          await _storeUserData(userCredential!.user!.uid);
          // Navigate to next screen or show success message
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _storeUserData(String userId) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    String userId = user.uid;

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    DateTime birthdayDate = selectedBirthday ?? DateTime.now();
    Timestamp birthdayTimestamp = Timestamp.fromDate(DateTime(
        birthdayDate.year, birthdayDate.month, birthdayDate.day, 0, 0, 0));

    await users.doc(userId).set({
      'name': name.text.trim(),
      'email': username.text.trim(),
      'birthday': birthdayTimestamp,
      'userID': userId,
      'userType': userType,
    });
  }

  final OutlineInputBorder _baseBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: kLightPruple),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  InputDecoration get decoration => InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      errorMaxLines: 3,
      disabledBorder: _baseBorder,
      enabledBorder: _baseBorder.copyWith(
        borderSide: const BorderSide(color: kLightPruple, width: 1),
      ),
      focusedBorder: _baseBorder.copyWith(
        borderSide: const BorderSide(color: mainpurple, width: 1),
      ),
      errorBorder: _baseBorder.copyWith(
        borderSide:
            const BorderSide(color: Color.fromARGB(255, 255, 64, 64), width: 1),
      ));
}
