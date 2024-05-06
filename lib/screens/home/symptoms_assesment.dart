import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
        title: Text(
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
        if (loading) Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: const CircularProgressIndicator(),
        ),
        ChatInputBox(
          controller: controller,
          onSend: () {


            if (controller.text.isNotEmpty) {
              final searchedText = controller.text;
              chats.add(
                  Content(role: userName, parts: [Parts(text: searchedText)]));
              controller.clear();
              loading = true;

              gemini.streamChat(chats,).listen((value) {

                loading = false;
                setState(() {
                  if (chats.isNotEmpty &&
                      chats.last.role == value.content?.role) {
                    chats.last.parts!.last.text =
                    '${chats.last.parts!.last.text}${value.output}';
                  } else {
                    chats.add(Content(
                        role: 'AI', parts: [Parts(text: value.output)]));
                  }
                });
              })
                  .onError((e){

                    print(e.toString());
                loading = false;
                setState(() {
                  chats.add(Content(
                      role: 'AI', parts: [Parts(text: 'something went wrong ${e.toString()}')]));
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

    return Card(
      elevation: 0,
      color:
      content.role == 'AI' ? Colors.white : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(content.role ?? 'role'),
            Markdown(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                data:
                content.parts?.lastOrNull?.text ?? 'cannot generate data!'
            ),
          ],
        ),
      ),
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
                   hintText: 'Type ur symptoms',
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
