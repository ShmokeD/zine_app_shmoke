import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:zineapp2023/models/temp_message.dart';
import 'package:zineapp2023/providers/user_info.dart';
import 'package:zineapp2023/screens/chat/chat_screen/view_model/chat_room_view_model.dart';
import 'package:zineapp2023/utilities/string_formatters.dart';

import '../../../models/message.dart';
import '../../../theme/color.dart';
import '../../../utilities/date_time.dart';

Widget chatV(BuildContext context, Stream<List<TempMessageModel>> messageStream,
    dashVm, dynamic reply) {
  ChatRoomViewModel chatRoomViewModel =
      Provider.of<ChatRoomViewModel>(context, listen: true);

  UserProv userVm = Provider.of<UserProv>(context, listen: true);

  return StreamBuilder<List<TempMessageModel>>(
    stream: messageStream,
    builder: (context, snapshot) {
      // print("chat reply to :${chatRoomViewModel.replyTo}");
      if(snapshot.connectionState==ConnectionState.waiting)
      {
        return Center(child: CircularProgressIndicator(),);
      }
      else if(snapshot.hasError)
      {
        return Center(child: Text('Error:${snapshot.error}'),);
      }
      else if(!snapshot.hasData || snapshot.data!.isEmpty)
      {
        return Center(child: Text('No messages'),);
      }
      else if (snapshot.hasData) {
        List<TempMessageModel> chats=snapshot.data!;
            // .map((doc) {
        //   MessageModel message = MessageModel.store(doc);
        //   if (message.replyTo == null) {
        //     // Assuming you have access to the document reference
        //     updateMessage(doc.reference);
        //   }
        //   return message;
        // }).toList();



        return Flexible(
          // Flexible prevents overflow error when keyboard is opened

          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              // physics: NeverScrollableScrollPhysics(),
              dragStartBehavior: DragStartBehavior.down,
              shrinkWrap: true,
              key: UniqueKey(),
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                var currIndx = chats.length - index - 1;
                var showDate = index == chats.length - 1 ||
                    (chats.length - index >= 2 &&
                        getChatDate(chats[currIndx].timestamp!) !=
                            getChatDate(
                                chats[chats.length - index - 2].timestamp! ));

                bool group = index > 0 &&
                    chats[currIndx].sentFrom?.name.toString() ==
                        chats[chats.length - index].sentFrom?.name.toString() &&
                    getChatDate(chats[currIndx].timestamp! ) ==
                        getChatDate(chats[chats.length - index].timestamp! );
                dynamic repliedMessage = null;
                print("reply to:${chats[currIndx].replyTo?.id}");
                if (chats[currIndx].replyTo?.id.toString() != null) {
                  repliedMessage = chatRoomViewModel.userGetMessageById(
                      chats, chats[currIndx].replyTo!.id.toString());
                  // print("checking reply content:${chats[currIndx].content}");
                }

                return chats[currIndx].content!.isEmpty
                    ? Container()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            repliedMessage != null
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 5),
                                    child: Padding(
                                      padding: userVm.getUserInfo.name !=
                                              chats[currIndx]
                                                  .sentFrom
                                                  ?.name //currUser.name != chats[currIndx].from
                                          ? EdgeInsets.symmetric(
                                              horizontal: 35.0)
                                          : EdgeInsets.all(0),
                                      child: Text(
                                        "${userVm.getUserInfo.name == chats[currIndx].sentFrom?.name.toString() ? "You" : chats[currIndx].sentFrom?.name.toString()} replied to ${chats[currIndx].replyTo?.sentFrom?.name} ",
                                        textAlign: userVm.getUserInfo.name ==
                                                chats[currIndx].sentFrom?.name
                                            ? TextAlign.right
                                            : TextAlign.left,
                                        style: TextStyle(
                                            color: greyText, fontSize: 11),
                                      ),
                                    ),
                                  )
                                : Container(),
                            repliedMessage != null
                                ? Row(
                                    // direction: Axis.horizontal,
                                    mainAxisAlignment:
                                        userVm.getUserInfo.name ==
                                                chats[currIndx].sentFrom?.name
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        userVm.getUserInfo.name ==
                                                chats[currIndx].sentFrom?.name
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                    children: [
                                      userVm.getUserInfo.name ==
                                              chats[currIndx].sentFrom?.name
                                          ? Container()
                                          : CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                // child: Image.asset(
                                                //     "assets/images/zine_logo.png"),
                                              ),
                                            ),
                                      userVm.getUserInfo.name ==
                                              chats[currIndx].sentFrom?.name
                                          ? IntrinsicHeight(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: backgroundGrey,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                                10.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                20.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                20.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10.0),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Text(
                                                        repliedMessage != null
                                                            ? repliedMessage
                                                                .message
                                                                .toString()
                                                            : " ",
                                                        // softWrap: true,
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : IntrinsicHeight(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4),
                                                    child: Container(
                                                      color: const Color(
                                                          0xff68a5ca),
                                                      width: 4,
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 12.0),
                                                        child: Text(
                                                          "",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      userVm.getUserInfo.name ==
                                              chats[currIndx].sentFrom?.name
                                          ? IntrinsicHeight(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4),
                                                    child: Container(
                                                      color: const Color(
                                                          0xff0C72B0),
                                                      width: 4,
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 12.0),
                                                        child: Text(
                                                          "       ",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : IntrinsicHeight(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: backgroundGrey,
                                                        borderRadius: userVm
                                                                    .getUserInfo
                                                                    .name !=
                                                                chats[currIndx]
                                                                    .sentFrom
                                                                    ?.name
                                                            ? const BorderRadius.only(
                                                                topRight:
                                                                    Radius.circular(
                                                                        15.0),
                                                                topLeft:
                                                                    Radius.circular(
                                                                        5.0),
                                                                bottomLeft:
                                                                    Radius.circular(
                                                                        5.0),
                                                                bottomRight:
                                                                    Radius.circular(
                                                                        15.0))
                                                            : const BorderRadius.only(
                                                                topRight:
                                                                    Radius.circular(5.0),
                                                                topLeft: Radius.circular(15.0),
                                                                bottomLeft: Radius.circular(15.0),
                                                                bottomRight: Radius.circular(5.0))),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Text(
                                                        repliedMessage.message
                                                                    .toString()
                                                                    .length >
                                                                20
                                                            ? repliedMessage
                                                                    .message
                                                                    .toString()
                                                                    .substring(
                                                                        0, 20) +
                                                                " . . ."
                                                            : repliedMessage
                                                                .message
                                                                .toString(),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5),
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                    ],
                                  )
                                : Container(),
                            if (showDate)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  DateFormat.yMMMMd()
                                      .format(convertTimestamp(
                                          chats[currIndx].timestamp!))
                                      .toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: greyText),
                                ),
                              ),
                            Container(
                              alignment: userVm.getUserInfo.name ==
                                      chats[currIndx].sentFrom?.name
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: SwipeTo(
                                onRightSwipe: (details) {
                                  // print(details);
                                  chatRoomViewModel
                                      .userReplyText(chats[currIndx]);
                                  chatRoomViewModel.userReplyfocus
                                      .requestFocus();
                                },
                                onLeftSwipe: (details) {
                                  // print(details);
                                  chatRoomViewModel
                                      .userReplyText(chats[currIndx]);
                                  chatRoomViewModel.userReplyfocus
                                      .requestFocus();
                                },
                                child: ListTile(
                                  horizontalTitleGap: 6,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  leading: userVm.getUserInfo.name ==
                                          chats[currIndx].sentFrom?.name
                                      ? null
                                      : CircleAvatar(
                                          backgroundColor:
                                              const Color(0x0f2F80ED),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Image.asset(
                                                "assets/images/dp/${userVm.getUserInfo.dp}.png"),
                                          ),
                                        ),

                                  // * Because Priyansh Said So :) *

                                  // trailing: currUser.name !=
                                  //         chats[currIndx].from
                                  //     ? null
                                  //     : group
                                  //         ? const CircleAvatar(
                                  //             backgroundColor: Colors.transparent,
                                  //           )
                                  //         : CircleAvatar(
                                  //             backgroundColor:
                                  //                 const Color(0x0f2F80ED),
                                  //             child: Padding(
                                  //               padding: const EdgeInsets.all(3.0),
                                  //               child: Image.asset(
                                  //                   "assets/images/zine_logo.png"),
                                  //             ),
                                  //           ),

                                  subtitle: group
                                      ? null
                                      : Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Align(
                                            alignment:
                                                userVm.getUserInfo.name !=
                                                        chats[chats.length -
                                                                index -
                                                                1]
                                                            .sentFrom
                                                            ?.name
                                                    ? Alignment.bottomLeft
                                                    : Alignment.bottomRight,
                                            child: group
                                                ? const Text("")
                                                : Text(
                                                    "${chats[currIndx].sentFrom?.name}     ${getChatTime(chats[currIndx].timestamp!)}",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 10.0,
                                                      color: Color.fromARGB(
                                                          255, 92, 20, 20),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                  title: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.end,
                                    alignment: userVm.getUserInfo.name ==
                                            chats[currIndx].sentFrom?.name
                                        ? WrapAlignment.end
                                        : WrapAlignment.start,
                                    direction: Axis.horizontal,
                                    children: [
                                      // Text("Something"),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: userVm.getUserInfo.name ==
                                                  chats[chats.length -
                                                          index -
                                                          1]
                                                      .sentFrom
                                                      ?.name
                                              ? const Color(0xff68a5ca)
                                              : const Color(0xff0C72B0),
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(15.0),
                                              topRight:
                                                  const Radius.circular(15.0),
                                              bottomRight: userVm
                                                          .getUserInfo.name ==
                                                      chats[chats.length -
                                                              index -
                                                              1]
                                                          .sentFrom
                                                          ?.name
                                                  ? const Radius.circular(0.0)
                                                  : const Radius.circular(15.0),
                                              bottomLeft: userVm
                                                          .getUserInfo.name ==
                                                      chats[chats.length -
                                                              index -
                                                              1]
                                                          .sentFrom
                                                          ?.name
                                                  ? const Radius.circular(15.0)
                                                  : const Radius.circular(0.0)),
                                          // border: Border.all(color: greyText, width: 2.0),
                                        ),
                                        // margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.all(4),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SelectableLinkify(
                                            text: chats[currIndx]
                                                .content
                                                .toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18.0,
                                              color: Colors.white,
                                            ),
                                            onOpen: (link) =>
                                                dashVm.launchUrl(link.url),
                                            linkStyle: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18.0,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]);
              },
            ),
          ),
        );
      } else if (snapshot.hasError) {
        return Center(child: Text('$snapshot.error'));
      } else {
        return const SizedBox();
      }

      // print(chats);
      // print(MessageModel.store());
    },
  );
}
