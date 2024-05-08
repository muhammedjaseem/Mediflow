
import 'package:MediFlow/screens/auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../auth/register_screen.dart';


class OnBoardingModel{
  final String title,des,imageUrl;
  OnBoardingModel({required this.imageUrl,required this.title,required this.des});
}
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  final List<OnBoardingModel> items=[OnBoardingModel(title: "Let's get started",des: 'Personalise your health profile and manage your medical data with free account',imageUrl: 'asset/images/8629258.jpg'),OnBoardingModel(title: 'check your symptoms', des: 'Take a few moments to complete your assessment',imageUrl: 'asset/images/check_your_symptoms.jpeg'),OnBoardingModel(title: 'Review possible causes', des: 'Uncover what may be causing your symptoms',imageUrl: 'asset/images/WhatsApp Image 2024-05-06 at 1.26.47 PM.jpeg'),OnBoardingModel(title: 'Choose what to do next', des: 'Get trusted advice about your care options',imageUrl: 'asset/images/img.png'),];
  int selectedIndex =0;
  void change(int index){

    setState(() {
      selectedIndex =index;
    });

  }
  PageController pageController =PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final textTheme =Theme.of(context).textTheme;



    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
                flex: 4,
                child:PageView.builder(
                  controller: pageController,
                  itemCount: items.length,
                  itemBuilder: (context,index){
                    return PageItems(onBoardingModel: items[index],);
                  },
                  onPageChanged: change,
                )),

            Expanded(flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 5,bottom: 5),
                          margin: EdgeInsets.only(bottom: 50),
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(items.length, (index) => InkWell(
                              onTap: (){
                                pageController.animateToPage(index, duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                HapticFeedback.lightImpact();
                              },
                              child: Container(height:7,width: 7,decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index ==selectedIndex?Colors.black:Colors.grey
                              ),),
                            )),
                          ),
                        ),
                        ElevatedButton(onPressed: (){

                          Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>RegisterScreen()));

                        }, child: Text('Create your account',style: TextStyle(color: Colors.white,fontSize: textTheme.bodyMedium?.fontSize),),

                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              elevation: 0,
                              fixedSize: Size(size.width, 50)
                          ),),

                        SizedBox(height: 20,),
                        ElevatedButton(onPressed: (){
                          Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>LoginScreen()));

                        }, child: Text('Log in',style: TextStyle(color: Colors.blue,fontSize: textTheme.bodyMedium?.fontSize),),

                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              surfaceTintColor: Colors.white,
                              elevation: 0,
                              side: BorderSide(color: Colors.blue),
                              fixedSize: Size(size.width, 50)
                          ),),
                        SizedBox(height: 20,),

                      ],
                    ),
                  )


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class PageItems extends StatelessWidget {
  final OnBoardingModel onBoardingModel;
  const PageItems({super.key,required this.onBoardingModel});

  @override
  Widget build(BuildContext context) {

    final textTheme =Theme.of(context).textTheme;
    return  Column(
      children: [

        Expanded(child: Image.asset(onBoardingModel.imageUrl,fit: BoxFit.fill,)),
        Column(
          children: [
            SizedBox(height: 20,),
            Text(onBoardingModel.title,style: textTheme.titleLarge,),
            SizedBox(height: 5,),
            Text(onBoardingModel.des,style:TextStyle(color: Colors.grey.shade600,fontSize:  textTheme.titleSmall?.fontSize),textAlign: TextAlign.center,),
          ],
        ),
      ],
    );
  }
}
