//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MediFlow/helper/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {

  TextEditingController nameController =TextEditingController();
  TextEditingController dobController =TextEditingController();
  TextEditingController emailController =TextEditingController();
  TextEditingController phoneController =TextEditingController();
  bool isLoading =false;
  String? selectedGender;
  final formKey =GlobalKey<FormState>();
  InputDecoration getInputDecoration (hint) =>InputDecoration(
    contentPadding: const EdgeInsets.only(left: 15,right: 15),
    labelText: hint,
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
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Profile"),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(10), child: Divider(thickness: 0.5,)),

      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller:nameController,
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (v){
                  if(v?.isEmpty ==true)
                  {
                    return 'Name is Required';
                  }
                  return null;
                },
                decoration: getInputDecoration('Name')
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: DropdownButtonFormField<String>(
                  alignment: Alignment.bottomCenter,

                    validator: (v){

                      if(v?.isEmpty ==true ||selectedGender ==null){
                        return 'Gender is Required';
                      }
                      return null;
                    },
                  decoration:getInputDecoration('Gender'),
                    value: selectedGender,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    items: const [
                      DropdownMenuItem(
                        value: 'Male',
                        child: Text('Male'),
                      ),
                      DropdownMenuItem(
                        value: 'FeMale',
                        child: Text('FeMale'),
                      ),
                      DropdownMenuItem(
                        value: 'Other',
                        child: Text('Other'),
                      ),
                    ], onChanged: (v){
                      selectedGender =v;
                }),
              ),
              TextFormField(
                controller: dobController,
                keyboardType: TextInputType.datetime,
                readOnly: true,
                onTap:(){
                 DateTime currentDate =DateTime.now();

                 showDialog(context: context, builder: (context){
                   return  DatePickerDialog(
                       helpText: 'Select Date Of Birth',
                       firstDate: DateTime(currentDate.year-100,currentDate.month,currentDate.day),
                       initialEntryMode:DatePickerEntryMode.calendarOnly,
                       lastDate: currentDate);
                 }).then((value) {
                   DateFormat format = DateFormat("dd-MM-yyyy");
                   dobController.text =format.format(value??currentDate);

                 });
                 },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: getInputDecoration('Date of Birth'),
                validator: (v){
                  if(v?.isEmpty ==true){
                    return 'Date of birth required';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: getInputDecoration('Email'),
                validator: (v)=>Helper().emailValidation(v.toString(),isRequired: false),),
              ),
                TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: getInputDecoration('Mobile number'),
                  validator: (v){

                    return null;
                  },
              ),

            ],
          ),
        ),
      ),


      floatingActionButton:isLoading ==false? FloatingActionButton(onPressed: (){

        if(formKey.currentState!.validate()){
          setState(() {
            isLoading =true;
          });
          var data ={
            'userId':"${ FirebaseAuth.instance.currentUser?.uid}",
            'name':nameController.text,
            'gender':selectedGender,
            'dob':dobController.text,
            'email':emailController.text,
            'phoneNumber':phoneController.text,
          };
          var db = FirebaseFirestore.instance.collection('Profiles');
          db.add(data).then((value) {
            setState(() {
              isLoading =false;
            });
            Navigator.pop(context,true);
          });

        }
      },
      child: const Text("Add"),):const CircularProgressIndicator(),
    );
  }
}
