import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zineapp2023/screens/chat/chat_screen/view_model/chat_room_view_model.dart';
import '../../../../providers/user_info.dart';
import '../chat_room.dart';
import 'chat_group_tile.dart';

class ChatGroups extends StatelessWidget {
  const ChatGroups({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatRoomViewModel, UserProv>(
      builder: (context, chatVm, userProv, _) {
        var currUser = userProv.currUser;
        // var listOfuser = currUser.roomIDs;
        var roomDetails = currUser.roomDetails;
        var listOfRoomID = roomDetails["group"].keys.toList();
        List listOfRoomDetails = roomDetails["group"].values.toList();

        // chatVm.getLastMessages(roomName!);

        // String? roomName = listOfRoomName[index];

        // Map<dynamic,dynamic> lastChatList = {};
        // for(var item in listOfRoomID){
        //   String? roomName = roomDetails["group"][item];
        //   var lastChat = chatVm.lastChatRoom(roomName);
        //   bool unSeen = chatVm.unread(roomName!, userProv.currUser);
        //   chatVm.listenChanges(roomName);
        //   lastChatList[item] = [lastChat,unSeen];
        // }

        // print(lastChatList);
        // var name = chatVm.getData(roomName);

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.18,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: listOfRoomDetails.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // chatVm.setRoomId(roomId);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatRoom(
                              roomName: listOfRoomDetails[index]['name'],
                              roomDetails: listOfRoomDetails[index])));
                },
                child: ChatGroupTile(
                  // roomId: listOfRoomID?[index],
                  name: listOfRoomDetails[index]['name'],
                  chatVm: chatVm,
                  userProv: userProv,
                  groupId: listOfRoomID[index],
                  roomDetails: listOfRoomDetails[index],
                  //lastSeen: lastChatList[listOfRoomName[index]][0],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
