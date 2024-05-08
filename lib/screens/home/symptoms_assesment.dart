import 'dart:convert';

import 'package:MediFlow/model/ai_res_model.dart' as Ai;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart'as http;
/*
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
*/

class SymptomsAssesment extends StatefulWidget {
  const SymptomsAssesment({super.key});

  @override
  State<SymptomsAssesment> createState() => _SymptomsAssesmentState();
}

class _SymptomsAssesmentState extends State<SymptomsAssesment> {
   int _selectedItem = 0;

  final _sections = <SectionItem>[
     SectionItem(3, 'Stream chat', const SectionStreamChat()),
   ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
            'Chat with AI'),
      ),
     body: IndexedStack(
        index: _selectedItem,
        children: _sections.map((e) => e.widget).toList(),
      ),
    );
  }
}
class SectionItem {
  final int index;
  final String title;
  final Widget widget;

  SectionItem(this.index, this.title, this.widget);
}

////
class SectionStreamChat extends StatefulWidget {
  const SectionStreamChat({super.key});

  @override
  State<SectionStreamChat> createState() => _SectionStreamChatState();
}

class _SectionStreamChatState extends State<SectionStreamChat> {
  String? userName;
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool set) => setState(() => _loading = set);
  final List<Content> chats = [];




  Future<Ai.AiModel>getMessage(String message)async{


    try{
      final String url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyCVceLhU5DiT9Tq-A4JBRiOFcUaYFANRcY';

      Map<String, dynamic> requestBody = {
        "contents": [
          {
            "parts": [
              {"text": "$message"}
            ]
          }
        ]
      };

      String requestBodyJson = json.encode(requestBody);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      try {
        final http.Response response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: requestBodyJson,
        );

        if (response.statusCode == 200) {
          // Handle successful response
         return Ai.aiModelFromJson(response.body);
        } else {
          // Handle error response
          return Ai.AiModel(candidates: [Ai.Candidate(content: Ai.Content(parts: [Ai.Part(text: 'Error')]))]);
        }
      } catch (e) {
        // Handle network error
        return Ai.AiModel(candidates: [Ai.Candidate(content: Ai.Content(parts: [Ai.Part(text: 'Error')]))]);

      }
    }catch(E){
      return Ai.AiModel(candidates: [Ai.Candidate(content: Ai.Content(parts: [Ai.Part(text: 'Error')]))]);

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userName =  FirebaseAuth.instance.currentUser?.displayName??"ME";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: chats.isNotEmpty
                ? Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                reverse: true,
                child: ListView.builder(
                  itemBuilder: chatItem,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chats.length,
                  reverse: false,
                ),
              ),
            )
                : const Center(child: Text(''))),
        if (loading) const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: CircularProgressIndicator(),
        ),
        ChatInputBox(
          controller: controller,
          onSend: () async{


            if (controller.text.isNotEmpty) {
              final searchedText = controller.text;
              chats.add(
                  Content(role: 'Me', parts: [Parts(text: searchedText)]));
              controller.clear();
              loading = true;
              await getMessage(searchedText).then((value) {
                setState(() {
                  if (value.candidates!.isNotEmpty &&
                      chats.last.role == value.candidates?.first.content?.role) {
                    chats.last.parts!.last.text =
                    '${chats.last.parts!.last.text}${value.candidates?.first.content?.parts?.first.text}';
                  } else {
                    chats.add(Content(
                        role: 'AI', parts: [Parts(text: '${value.candidates?.first.content?.parts?.first.text}')]));
                  }
                  loading = false;
                });
              });
            }
          },
        ),
      ],
    );
  }

  Widget chatItem(BuildContext context, int index) {
    final Content content = chats[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10,bottom: 5,top: 5),
          child: Text(content.role ?? 'role',style: TextStyle(color: Colors.black,fontSize: 16,fontFamily: 'Poppins-SemiBold'),),
        ),

        Card(
          elevation: 0,
          color:
          content.role == 'Me' ? Colors.blue .shade300: Colors.green.shade300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Markdown(
                    shrinkWrap: true,
                    styleSheet: MarkdownStyleSheet(
                      a: TextStyle(color: Colors.white),
                      h1: TextStyle(color: Colors.white),
                      h2: TextStyle(color: Colors.white),
                      h3: TextStyle(color: Colors.white),
                      h4: TextStyle(color: Colors.white)
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    data: content.parts?.lastOrNull?.text ?? 'cannot generate data!'
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
////


class ChatInputBox extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSend, onClickCamera;

  const ChatInputBox({
    super.key,
    this.controller,
    this.onSend,
    this.onClickCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: SafeArea(
        child: Row(
         crossAxisAlignment: CrossAxisAlignment.end,
         children: [

           Expanded(
               child: TextField(
                 controller: controller,
                 minLines: 1,
                 maxLines: 6,
                 cursorColor: Theme.of(context).colorScheme.inversePrimary,
                 textInputAction: TextInputAction.newline,
                 keyboardType: TextInputType.multiline,
                 decoration: const InputDecoration(

                   contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                   hintText: 'Type your symptoms',
                   border: InputBorder.none,
                 ),
                 onTapOutside: (event) =>
                     FocusManager.instance.primaryFocus?.unfocus(),
               )),
           Padding(
             padding: const EdgeInsets.all(4),
             child: FloatingActionButton.small(
               onPressed: onSend,
               child: const Icon(Icons.send_rounded),
             ),
           )
         ],
        ),
      ),
    );
  }
}
