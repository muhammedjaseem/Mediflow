import 'package:MediFlow/helper/helper.dart';
import 'package:MediFlow/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupWithEmail extends StatefulWidget {
  const SignupWithEmail({super.key});

  @override
  State<SignupWithEmail> createState() => _SignupWithEmailState();
}

class _SignupWithEmailState extends State<SignupWithEmail> {
  bool showPass =false;
  final helper =Helper();
  final GlobalKey<FormState>_formKey =GlobalKey<FormState>();
  TextEditingController emailController =TextEditingController();
  TextEditingController passController =TextEditingController();
  GlobalKey<FormState>formKey =GlobalKey<FormState>();
  bool isLoading =false;
  Future<String>login()async{
    String returnMessage ='';
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passController.text
      ).then((credential) async{
        returnMessage =credential.user?.uid !=null?'success':'error';
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', credential.user?.uid??'');
        prefs.setString('email', credential.user?.email??'');
        
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        returnMessage =('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        returnMessage =('Wrong password provided for that user.');
      }
      else {
        returnMessage ='Email or Password is incorrect';//e.message??'';
      }
    }
    return returnMessage;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
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

              Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 5),
                child: Text('Email',style: TextStyle(fontSize: textTheme.bodyLarge?.fontSize,fontFamily: 'Poppins-Bold'),),
              ),
              TextFormField(
                controller: emailController,
                validator: (v)=>helper.emailValidation(v.toString()),

                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 15),
                  hintText: 'Type your email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black,)
                  ),
                  enabledBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black,)
                  ),
                  focusedBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black,)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 5),
                child: Text('Password',style: TextStyle(fontSize: textTheme.bodyLarge?.fontSize,fontFamily: 'Poppins-Bold'),),
              ),
              TextFormField(
                controller: passController,
                obscureText: !showPass,

                validator: helper.passwordValidation,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 15),
                  hintText: 'Type your password',
                  suffixIcon: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: (){
                      setState(() {

                        showPass=!showPass;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14,right: 5),
                      child: Text(showPass?'hide':'show'),
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black,)
                  ),
                  enabledBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black,)
                  ),
                  focusedBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black,)
                  ),
                ),
              ),
              SizedBox(height: 50,),
              AnimatedCrossFade(
                duration: Duration(seconds: 2),
                crossFadeState: isLoading?CrossFadeState.showSecond:CrossFadeState.showFirst,
                secondChild: Center(child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator())),
                firstChild:  ElevatedButton(onPressed: ()async{


                  if(_formKey.currentState!.validate()){
                    setState(() {
                      isLoading =true;
                    });
                    await login().then((value) {
                      setState(() {
                        isLoading =false;
                      });
                      if(value !='success') {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            content: Text(value.toString()),
                          );
                        });
                      }else{


                        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder:(context)=>HomeScreen() ), (route) => false);

                      }
                    });



                  //  Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder:(context)=>HomeScreen() ), (route) => false);

                  }
                }, child: Text('Log in',style: TextStyle(color: Colors.white,fontSize: textTheme.bodyMedium?.fontSize,fontFamily: 'Poppins-SemiBold'),),

                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      elevation: 0,
                      fixedSize: Size(size.width, 50)
                  ),),
              ),
              SizedBox(height: 10,),
              Center(
                  child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("We will update it soon")));

                      },
                      child: const Text(
                        'I forgot my password',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 13,
                            fontFamily: 'Poppins-SemiBold'),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
