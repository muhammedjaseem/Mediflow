import 'package:MediFlow/screens/home/symptoms_assesment.dart';
import 'package:MediFlow/screens/other/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  final String userName;
  const HomeBody({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.event_note_sharp)),
          IconButton(onPressed: (){
            Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>Settings()));

          }, icon: const Icon(Icons.settings)),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Scrollbar(
        thickness: 4,
        trackVisibility: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: const BoxDecoration(color: Colors.blue,shape: BoxShape.circle),
                  ),

                   Expanded(child: Text("Hi $userName, I'm MediFlow. I can help you to learn more about your health",style: TextStyle(fontFamily: 'BebasNeue',fontSize: 25,color: Colors.black,fontWeight: FontWeight.w600 ),))
                ],
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(onPressed: (){

                  Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>SymptomsAssesment()));

                },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800,elevation: 0),
                    child: const Row(
                      children: [
                        Icon(Icons.ac_unit_outlined,color: Colors.white,size: 15,),
                        SizedBox(width: 5,),
                        Text('Start symptom assessment',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                      ],
                    )),
              ),

              const SizedBox(height: 30,),
              Text('Featured',style: TextStyle(fontFamily: 'Poppins-Bold',fontSize: 15,color: Colors.black.withOpacity(0.8)),),


              Padding(
                padding: const EdgeInsets.only(top: 15,bottom: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('asset/images/img_1.png',height: 170,width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
                ),
              ),
              Text('Track your symptoms',style: TextStyle(fontFamily: 'Poppins-Bold',fontSize: 15,color: Colors.black.withOpacity(0.8)),),
              Padding(
                padding: const EdgeInsets.only(top: 5,bottom: 40),
                child: Text('Understand your symptoms and spot patterns',style: TextStyle(fontFamily: 'Poppins-regular',fontSize: 12,color: Colors.black.withOpacity(0.8)),),
              ),

              Text('Take care of your health',style: TextStyle(fontFamily: 'Poppins-Bold',fontSize: 15,color: Colors.black.withOpacity(0.8)),),


              Padding(
                  padding: const EdgeInsets.only(top: 15,bottom: 15),
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: PageView(
                      padEnds: false,
                      controller: PageController(viewportFraction: 0.8),
                      allowImplicitScrolling: true,
                      children: List.generate(5, (index) => Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(

                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('asset/images/marcelo-leal-k7ll1hpdhFA-unsplash.jpg',fit: BoxFit.fill,width:MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/8),),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('Do you have the Flu or Covid -19')
                          ],
                        ),
                      )),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
