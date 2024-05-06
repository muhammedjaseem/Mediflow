import 'package:MediFlow/screens/home/home_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../profiles/profiles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

String? userName ='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{

      userName =  FirebaseAuth.instance.currentUser?.displayName??"";

    });
  }

  int selectedPage =0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        gradient: LinearGradient(
          begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror,
            colors: [
          Colors.blue.shade300,
          Colors.white,
        ])
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(
          builder: (context){


            if(selectedPage ==0){
              return  HomeBody(userName:userName.toString());
            }else if(selectedPage ==1){

              return const Profiles();
            }else{
              return const SizedBox();
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey.shade200,

          currentIndex: selectedPage,
          onTap: (v){
            setState(() {
              selectedPage =v;
            });

          },
          type: BottomNavigationBarType.shifting,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(fontSize: 11,fontFamily: 'Poppins-SemiBold'),
          unselectedLabelStyle: const TextStyle(fontSize: 11,fontFamily: 'Poppins-SemiBold'),
          selectedFontSize: 12,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined,),
            label: 'Home',),
            BottomNavigationBarItem(icon: Icon(Icons.person),
            label: 'Profiles'),
            BottomNavigationBarItem(icon: Icon(Icons.person),
            label: 'Conditions'),
          ],
        ),
      ),
    );
  }
}

