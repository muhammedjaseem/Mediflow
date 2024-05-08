import 'dart:convert';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../model/profile_model.dart';
import 'create_profile.dart';
class Profiles extends StatefulWidget {
  const Profiles({super.key});

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {

  List<ProfileModel> profiles =[];
  bool isLoading =true;


  Future<void> getData()async{

    setState(() {
      isLoading =true;
      profiles.clear();
    });
      final QuerySnapshot<Map<String, dynamic>> snapshot =await FirebaseFirestore.instance.collection('Profiles') // Assuming 'users' is your collection name
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();


      for (var element in snapshot.docs) {


        profiles.add(ProfileModel.fromJson(element.data()));
      }
      if(mounted) {
        setState(() {
        isLoading =false;
      });
      }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      await getData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:   AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title:const Text('Health profiles',style: TextStyle(fontFamily: 'Poppins-Bold',fontSize: 18),),
        actions: [
          IconButton(onPressed: ()async{
          await  Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>const CreateProfile())).then((value) async{

              if(value ==true){
                await getData();
              }
            });

          }, icon: const Icon(Icons.add)),
        ],
        bottom: const PreferredSize(preferredSize: Size.fromHeight(10), child: Divider(thickness: 0.5,)),

      ),
      body: Builder(
        builder: (context) {
          if(isLoading){
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: CircularProgressIndicator(),
                    )),
              ],
            );
          }
          if(profiles.isNotEmpty){

            return ListView.builder(
              itemCount: profiles.length,
                itemBuilder: (context,index){
              return ListTile(
                onTap: (){
                  final item =profiles[index];
                  showModalBottomSheet(context: context,

                      constraints: BoxConstraints(maxHeight:MediaQuery.of(context).size.height/2 ),
                      builder: (context)=>Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Details',style: Theme.of(context).textTheme.titleLarge,),
                            Divider(),
                            SizedBox(height: 10,),
                            Text('Name: ${item.name}'),
                            SizedBox(height: 2,),
                            Text('Email: ${item.email}'),
                            SizedBox(height: 2,),
                            Text('Date Of Birth: ${item.dob}'),
                            SizedBox(height: 2,),
                            Text('Phone Number: ${item.phoneNumber}'),
                            SizedBox(height: 5,),
                          ],
                        ),
                      ));


                },
                  title: Text(profiles[index].name.toString()),
                subtitle: Text(profiles[index].email.toString(),style: Theme.of(context).textTheme.bodySmall,),
              trailing: const Icon(Icons.keyboard_arrow_right_outlined),);
            });
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('No Profiles yet',style: TextStyle(fontSize: 17,color: Colors.black,fontFamily: 'Poppins-Bold'),),
              const SizedBox(height: 8),
              const Text('Add your helth profile by tapping the plus button or by startig an assesment',textAlign: TextAlign.center,),

              const SizedBox(height: 15,),
              ElevatedButton(onPressed: (){
                Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>const CreateProfile())).then((value) async{

                  if(value ==true){
                    await getData();
                  }
                });

              },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Create your profile',style: TextStyle(color: Colors.white),))
            ],
          );
        }
      ),
    );
  }
}
