import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hyella/helper/route_generator.dart';
import 'package:hyella/models/signup_result_model.dart';
import 'package:hyella/providers/nav_index_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../helper/styles.dart';
import '../../../providers/messaging_provider.dart';

class DoctorMessages extends StatelessWidget {
  DoctorMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "Chats",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Provider.of<ChatHeadsProvider>(context, listen: false)
                  .getContacts(true);
            },
            icon: Icon(
              Icons.refresh_rounded,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Consumer<ChatHeadsProvider>(
          builder: (context, ChatHeadsProvider messagingProvider, wid) {
        return WillPopScope(
          onWillPop: () async {
            Provider.of<NavIndexProvider>(context, listen: false).setIndex(0);
            return false;
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _width * .05),
            child: Column(
              children: [
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
                    ? Expanded(child: shimmerEffect())
                    : messagingProvider.errorLoadingData
                        ? Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Styles.regular(messagingProvider.errorMessage,
                                    fontSize: 14, align: TextAlign.center),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () =>
                                        messagingProvider.getContacts(true),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .primaryColor)),
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
                                        fontSize: 14, align: TextAlign.center),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    Provider.of<ChatHeadsProvider>(context,
                                            listen: false)
                                        .getContacts(true);
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
                                          Navigator.of(context)
                                              .pushNamed(CHAT, arguments: {
                                            'pid': GetIt.I<UserDetails>()
                                                .user!
                                                .pid!,
                                            'receiver_name': messagingProvider
                                                    .contacts[index].title ??
                                                "",
                                            'channel_id': messagingProvider
                                                .contacts[index].channelName!,
                                            'receiver_id': messagingProvider
                                                .contacts[index].receiverId!,
                                            'is_doctor': true,
                                            'key': messagingProvider
                                                .contacts[index].key
                                          });
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
    );
  }

  Widget _buildSearchTextField(
      ChatHeadsProvider provider, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: (value) {
          provider.filterContact(value);
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

  Widget shimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: 40.0,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        itemCount: 8,
      ),
    );
  }
}
