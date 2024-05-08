import 'package:MediFlow/screens/auth/register_screen.dart';
import 'package:MediFlow/screens/auth/signup_with_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back',
              style: TextStyle(
                  fontFamily: 'poppins-SemiBold',
                  fontSize: textTheme.bodyLarge?.fontSize),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
                'Please log in with the option you originally signed up with.'),
            const SizedBox(
              height: 80,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>SignupWithEmail()));

              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade200,
                  elevation: 0,
                  fixedSize: Size(size.width, 50)),
              child: Text(
                'Sign in with email',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: textTheme.bodyMedium?.fontSize,
                    fontFamily: 'Poppins-SemiBold'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("We will update it soon")));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 0,
                  side: const BorderSide(color: Colors.black),
                  fixedSize: Size(size.width, 50)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'asset/svg/google.svg',
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Sign up with google',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: textTheme.bodyMedium?.fontSize,
                        fontFamily: 'Poppins-SemiBold'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("We will update it soon")));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade700,
                  elevation: 0,
                  fixedSize: Size(size.width, 50)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'asset/svg/facebook.svg',
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Sign up with facebook',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: textTheme.bodyMedium?.fontSize,
                        fontFamily: 'Poppins-SemiBold'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(CupertinoPageRoute(
                          builder: (context) => const RegisterScreen()));
                    },
                    child: const Text(
                      'Create a new account',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 15,
                          fontFamily: 'Poppins-Bold'),
                    )))
          ],
        ),
      ),
    );
  }
}
