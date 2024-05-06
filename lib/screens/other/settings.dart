import 'package:MediFlow/screens/other/on_boarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        bottom: PreferredSize(preferredSize: Size.fromHeight(10), child: Divider(thickness: 0.5,)),
      ),
      body: Column(
        children: [


          ListTile(
            onTap: ()async{
              await FirebaseAuth.instance.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder:(context)=>OnBoardingScreen() ), (route) => false);


            },
            title: Text('Logout',style: TextStyle(color: Colors.blue),),
            trailing: Icon(Icons.keyboard_arrow_right_sharp),
          )
        ],
      ),
    );
  }
}
