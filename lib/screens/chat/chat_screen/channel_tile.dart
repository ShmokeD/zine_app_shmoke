import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zineapp2023/models/events.dart';
import 'package:zineapp2023/providers/user_info.dart';
import 'package:zineapp2023/screens/chat/chat_screen/view_model/chat_room_view_model.dart';


import '../../../models/rooms.dart';
import '../../../models/user.dart';
import '../../../utilities/date_time.dart';
import 'chat_room.dart';


class Channel extends StatelessWidget {
  Rooms? roomDetail;

  Channel({super.key,this.roomDetail});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatRoomViewModel, UserProv>(
        builder: (context, chatVm, userProv, _) {
          UserModel currUser = userProv.getUserInfo;
          String? lastChatTimestamp=roomDetail?.lastMessageTimestamp !=null? DateFormat("d MMM").format(convertTimestamp(roomDetail!.lastMessageTimestamp!)):" ";
          print("inside the channel tile:${lastChatTimestamp}");
          print("unseen message:${roomDetail!.unreadMessages.toString()}");


      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: () {
            // chatVm.setRoomId(roomId);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatRoom(
                          // roomName: roomDetail?.name,
                          // roomId: roomDetail!.id.toString(),
                          email:currUser.email,
                          roomDetail: roomDetail,
                        )));
          },
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              color: Color.fromRGBO(170, 170, 170, 0.1),
              // : const Color.fromRGBO(47, 128, 237, 0.1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.asset("assets/images/zine_logo.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        roomDetail!.name.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  // -------------------modification for new unseen and lastseen--------------//

                  Row(
                    children: [
                      Row(
                        children: [
                          roomDetail?.unreadMessages !=null
                              ?
                          roomDetail!.unreadMessages! > 0 ?
                          Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromRGBO(47, 128, 237, 1),
                                  ),
                                  height: 15,
                                  width: 15,
                                  child:  Center(
                                    child: Text(
                                      '',
                                      // lashChatTimestamp!.toString(),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                )
                              :Container(): const SizedBox(),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      roomDetail?.lastMessageTimestamp !=null
                          ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // color:
                          //     const Color.fromRGBO(47, 128, 237, 1),
                        ),
                        height: 30,
                        width: 30,
                        child:  Center(
                          child: Text(
                            // '',
                            lastChatTimestamp!.toString(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ) : Container()
                            ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
