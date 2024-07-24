import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/custom_widgets/shimmer_effects.dart';
import 'package:hyella/helper/route_generator.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/providers/messaging_provider.dart';
import 'package:hyella/screens/custom_web_view.dart';
import 'package:provider/provider.dart';
import '../../../helper/styles.dart';
import '../../../providers/nav_index_provider.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Provider.of<NavIndexProvider>(context, listen: false).setIndex(0);
          return false;
        },
        child: Consumer2<AuthProvider, ChatHeadsProvider>(builder: (context,
            AuthProvider authProvider,
            ChatHeadsProvider messagingProvider,
            wid) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _width * .05),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Chats",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Provider.of<ChatHeadsProvider>(context, listen: false)
                              .getContacts(false);
                        },
                        icon: Icon(
                          Icons.refresh_rounded,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildSearchTextField(messagingProvider, context),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(),
                  SizedBox(
                    height: 5,
                  ),
                  messagingProvider.loading
                      ? Expanded(child: ShimmerEffect())
                      : messagingProvider.errorLoadingData
                          ? Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Styles.bold(messagingProvider.errorMessage,
                                      fontSize: 14, align: TextAlign.center),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                      onPressed: () =>
                                          messagingProvider.getContacts(false),
                                      child: const Text("Tap to retry"))
                                ],
                              ),
                            )
                          : messagingProvider.contacts.isEmpty
                              ? Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Styles.bold("No results found!",
                                          fontSize: 14,
                                          align: TextAlign.center),
                                    ],
                                  ),
                                )
                              : Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      Provider.of<ChatHeadsProvider>(context,
                                              listen: false)
                                          .getContacts(false);
                                    },
                                    child: ListView.separated(
                                      itemCount:
                                          messagingProvider.contacts.length,
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                        thickness: 1,
                                      ),
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          onTap: () {
                                            var userDetails =
                                                GetIt.I<UserDetails>();
                                            if (userDetails.webViews?.chatMsg
                                                    ?.webview ==
                                                1) {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GeneralWebview(
                                                    url: userDetails.webViews!
                                                        .chatMsg!.endpoint!,
                                                    nwpRequest: userDetails
                                                        .webViews!
                                                        .chatMsg!
                                                        .params!
                                                        .nwpWebiew!,
                                                  ),
                                                ),
                                              );
                                              return;
                                            }

                                            Navigator.of(context).pushNamed(
                                              CHAT,
                                              arguments: {
                                                'pid': authProvider
                                                    .userDetails.user!.pid!,
                                                'receiver_name':
                                                    messagingProvider
                                                            .contacts[index]
                                                            .title ??
                                                        "",
                                                'channel_id': messagingProvider
                                                    .contacts[index]
                                                    .channelName!,
                                                'receiver_id': messagingProvider
                                                    .contacts[index]
                                                    .receiverId!,
                                                'is_doctor': false,
                                                'key': messagingProvider
                                                    .contacts[index].key
                                              },
                                            );
                                          },
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            radius: 20,
                                            backgroundImage: NetworkImage(
                                                messagingProvider
                                                    .contacts[index].picture!),
                                          ),
                                          title: Text(
                                            messagingProvider
                                                    .contacts[index].title ??
                                                "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16),
                                          ),
                                          subtitle: Text(
                                            messagingProvider
                                                    .contacts[index].subTitle ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          trailing: messagingProvider
                                                      .contacts[index]
                                                      .unreadMessages! >
                                                  0
                                              ? CircleAvatar(
                                                  backgroundColor: Colors.blue,
                                                  radius: 10,
                                                  child: Text(
                                                    messagingProvider
                                                        .contacts[index]
                                                        .unreadMessages
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                        );
                                      },
                                    ),
                                  ),
                                )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSearchTextField(
      ChatHeadsProvider messagingProvider, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: (value) {
          messagingProvider.filterContact(value);
        },
        cursorColor: Color(0XF757575),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          fillColor: Colors.white,
          labelText: "Search",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide:
                BorderSide(width: 1.5, color: Theme.of(context).primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}
