import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translation/translation.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //controller for chat text
  TextEditingController chatText = TextEditingController();

  //controller for scrolling chats
  ScrollController controller = ScrollController();
  bool _sendingMessage = false;

  @override
  void initState() {
    getCurrentMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Material(
        // rtl and ltr
        child: Directionality(
          textDirection: (languageDirection == 'rtl')
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Scaffold(
            body: ValueListenableBuilder(
                valueListenable: valueNotifierHome.value,
                builder: (context, value, child) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.animateTo(controller.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  });
                  //api call for message seen
                  messageSeen();

                  return SafeArea(
                    child: Stack(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: media.height * 0.1,
                              color: blueColor,
                              width: media.width * 1,
                              alignment: Alignment.center,
                              child: Text(
                                languages[choosenLanguage]['text_chatwithuser'],
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twenty,
                                    fontWeight: FontWeight.w600,
                                    color: white),
                              ),
                            ),
                            Positioned(
                              top: media.height * 0.03,
                              left: media.width * 0.03,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: white,
                                  size: media.height * 0.04,
                                ),
                              ),
                            ),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: Image.asset(
                                  height: media.height * 0.1,
                                  'assets/images/app_bar_left_arrow.png',
                                  fit: BoxFit.cover,
                                ))
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              media.width * 0.05,
                              MediaQuery.of(context).padding.top +
                                  media.width * 0.05,
                              media.width * 0.05,
                              media.width * 0.05),
                          height: media.height * 1,
                          width: media.width * 1,
                          child: Column(
                            children: [
                              SizedBox(
                                height: media.height * 0.05,
                              ),
                              Expanded(
                                  child: SingleChildScrollView(
                                controller: controller,
                                child: Column(
                                  children: chatList
                                      .asMap()
                                      .map((i, value) {
                                        return MapEntry(
                                            i,
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: media.width * 0.025),
                                              width: media.width * 0.9,
                                              alignment: (chatList[i]
                                                          ['from_type'] ==
                                                      2)
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment: (chatList[
                                                                    i]
                                                                ['from_type'] ==
                                                            2)
                                                        ? MainAxisAlignment.end
                                                        : MainAxisAlignment
                                                            .start,
                                                    children: [
                                                      (chatList[i][
                                                                  'from_type'] !=
                                                              2)
                                                          ? Container(
                                                              height:
                                                                  media.height *
                                                                      0.07,
                                                              width:
                                                                  media.height *
                                                                      0.07,
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(
                                                                          chatList[i]
                                                                              [
                                                                              'user_profile_picuture'])),
                                                                  color: Colors
                                                                      .red,
                                                                  shape: BoxShape
                                                                      .circle),
                                                            )
                                                          : SizedBox(),
                                                      Bubble(
                                                        showNip: true,
                                                        nip: (chatList[i][
                                                                    'from_type'] ==
                                                                2)
                                                            ? BubbleNip
                                                                .rightBottom
                                                            : BubbleNip
                                                                .leftBottom,
                                                        color: (chatList[i][
                                                                    'from_type'] ==
                                                                2)
                                                            ? blueColor
                                                            : white,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .all(media
                                                                          .width *
                                                                      0.04),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: (chatList[
                                                                                i]
                                                                            [
                                                                            'from_type'] ==
                                                                        2)
                                                                    ? const BorderRadius
                                                                        .only(
                                                                        topLeft:
                                                                            Radius.circular(10),
                                                                        topRight:
                                                                            Radius.circular(10),
                                                                        bottomLeft:
                                                                            Radius.circular(10),
                                                                      )
                                                                    : const BorderRadius
                                                                            .only(
                                                                        topRight:
                                                                            Radius.circular(
                                                                                10),
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                10),
                                                                        bottomLeft:
                                                                            Radius.circular(
                                                                                0),
                                                                        bottomRight:
                                                                            Radius.circular(10)),
                                                              ),
                                                              child: Text(
                                                                chatList[i]
                                                                    ['message'],
                                                                style: GoogleFonts.roboto(
                                                                    fontSize: media
                                                                            .width *
                                                                        fourteen,
                                                                    color: (chatList[i]['from_type'] ==
                                                                            2)
                                                                        ? white
                                                                        : black),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: media.width * 0.015,
                                                  ),
                                                  Text(
                                                    chatList[i][
                                                        'converted_created_at'],
                                                    style: TextStyle(
                                                        color: light_grey,
                                                        fontSize: 12),
                                                  )
                                                ],
                                              ),
                                            ));
                                      })
                                      .values
                                      .toList(),
                                ),
                              )),
                              Container(
                                margin:
                                    EdgeInsets.only(top: media.width * 0.025),
                                padding: EdgeInsets.fromLTRB(
                                    media.width * 0.05,
                                    media.width * 0.01,
                                    media.width * 0.025,
                                    media.width * 0.01),
                                width: media.width * 0.9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36),
                                    border: Border.all(
                                        color: borderLines, width: 1.2),
                                    color: bgContainerColor),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      'assets/images/mic.png',
                                      height: 23,
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: media.width * 0.6,
                                      child: TextField(
                                        controller: chatText,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: languages[choosenLanguage]
                                                ['text_type_something'],
                                            hintStyle: GoogleFonts.roboto(
                                                fontSize: media.width * twelve,
                                                color: hintColor)),
                                        minLines: 1,
                                        onChanged: (val) {},
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        setState(() {
                                          _sendingMessage = true;
                                        });

                                        //api call for send message
                                        await sendMessage(chatText.text);
                                        chatText.clear();
                                        setState(() {
                                          _sendingMessage = false;
                                        });
                                      },
                                      child: SizedBox(
                                        child: RotatedBox(
                                            quarterTurns:
                                                (languageDirection == 'rtl')
                                                    ? 2
                                                    : 0,
                                            child: Image.asset(
                                              'assets/images/send_message_icon.png',
                                              fit: BoxFit.contain,
                                              width: media.width * 0.075,
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        // loader
                        (_sendingMessage == true)
                            ? const Positioned(top: 0, child: Loading())
                            : Container()
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
