import 'package:MediFlow/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


  final helper =Helper();
  bool showPass =false;

  TextEditingController emailController =TextEditingController();
  TextEditingController passController =TextEditingController();
  GlobalKey<FormState>formKey =GlobalKey<FormState>();
  bool isLoading =false;
  Future<String?> registerWithEmail()async{
    String returnMessage ="";
    try {
      setState(() {
        isLoading =true;
      });
       await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passController.text
      ).then((value) {

        returnMessage =value.user?.uid !=null?'success':"error";
      });
    } on FirebaseAuthException catch (e) {


      if (e.code == 'weak-password') {
        returnMessage ='The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        returnMessage ='The account already exists for that email.';
      }
      else{
        returnMessage =e.message??'';
      }
    } catch (e) {
      returnMessage =e.toString();
    }


   return returnMessage;
  }

  @override
  Widget build(BuildContext context) {
      final size =MediaQuery.of(context).size;
    final textTheme =Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(

          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text('Create your account',style: textTheme.bodyLarge,),
              const SizedBox(height: 20,),
              const Text('Sign up with an email and password, or with your Apple, Facebook or Google account'),
              Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 5),
                child: Text('Email',style: TextStyle(fontSize: textTheme.bodyLarge?.fontSize,fontFamily: 'Poppins-Bold'),),
              ),
              TextFormField(
                validator: (v)=>helper.emailValidation(v.toString()),
                controller: emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
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
                validator: helper.passwordValidation,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: passController,
                obscureText: !showPass,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 15),
                  hintText: 'Type your Password',
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
              Padding(
                  padding: const EdgeInsets.only(top: 15,bottom: 50),
                  child: Text('Password must be at least 8 charecters.',style: textTheme.bodySmall,)),

              AnimatedCrossFade(
                duration: const Duration(seconds: 2),
                crossFadeState: isLoading?CrossFadeState.showSecond:CrossFadeState.showFirst,
                secondChild: const Center(child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator())),
                firstChild: ElevatedButton(onPressed: ()async{
                  if(formKey.currentState!.validate()){
                    await registerWithEmail().then((value) async{

                      if(value =='success'){

                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passController.text
                            ).then((credential) async{

                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString('userId', credential.user?.uid??'');
                              prefs.setString('email', credential.user?.email??'');
                              Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder:(context)=>const HomeScreen() ), (route) => false);
                            });


                      }else {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            content: Text(value.toString()),
                          );
                        });
                      }
                      setState(() {
                        isLoading =false;
                      });
                    });
                  }
                }, child: Text('Sign up ',style: TextStyle(color: Colors.white,fontSize: textTheme.bodyMedium?.fontSize,fontFamily: 'Poppins-SemiBold'),),

                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      elevation: 0,
                      fixedSize: Size(size.width, 50)
                  ),),
              ),

           /*   const Padding(padding: EdgeInsets.only(top: 20,bottom: 20),child: Center(child: Text('Or:',)),),
              ElevatedButton(onPressed: ()async{


              }, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('asset/svg/google.svg',height: 20,width: 20,),
                  const SizedBox(width: 10,),
                  Text('Sign up with google',style: TextStyle(color: Colors.black,fontSize: textTheme.bodyMedium?.fontSize,fontFamily: 'Poppins-SemiBold'),),
                ],
              ),

                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 0,
                    side: const BorderSide(color: Colors.black),
                    fixedSize: Size(size.width, 50)
                ),),
              Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 20),
                child:  ElevatedButton(onPressed: (){


                }, child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('asset/svg/apple.svg',height: 20,width: 20,colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                    const SizedBox(width: 10,),
                    Text('Sign up with apple',style: TextStyle(color: Colors.white,fontSize: textTheme.bodyMedium?.fontSize,fontFamily: 'Poppins-SemiBold'),),
                  ],
                ),

                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 0,
                      fixedSize: Size(size.width, 50)
                  ),),
              ),
              ElevatedButton(onPressed: (){

              }, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('asset/svg/facebook.svg',height: 20,width: 20,),
                  const SizedBox(width: 10,),
                  Text('Sign up with facebook',style: TextStyle(color: Colors.white,fontSize: textTheme.bodyMedium?.fontSize,fontFamily: 'Poppins-SemiBold'),),
                ],
              ),

                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade700,
                    elevation: 0,
                    fixedSize: Size(size.width, 50)
                ),),*/
            ],

          ),
        ),
      ),
    );
  }
}
