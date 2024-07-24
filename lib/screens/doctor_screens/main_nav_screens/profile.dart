import 'package:flutter/material.dart';
import 'package:hyella/providers/auth_provider.dart';
import 'package:hyella/screens/doctor_screens/other_screens/revenues.dart';
import 'package:provider/provider.dart';
import '../../../providers/nav_index_provider.dart';
import '../../patient_screens/auth/signin.dart';
import '../../patient_screens/card_details/card_details_webview.dart';
import '../../patient_screens/profile/change_password.dart';
import '../other_screens/profile_settings.dart';

class ProviderProfile extends StatelessWidget {
  const ProviderProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "More",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Provider.of<NavIndexProvider>(context, listen: false).setIndex(0);
          return false;
        },
        child: Consumer<AuthProvider>(
            builder: (context, AuthProvider authProvider, wid) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        margin: EdgeInsets.only(bottom: 20),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfileSetting(),
                              ),
                            );
                          },
                          leading: authProvider.userDetails.user!.dp == null
                              ? CircleAvatar(
                                  backgroundColor: Color(0xffC6C6C6),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: NetworkImage(
                                    authProvider.userDetails.user!.dp!,
                                  ),
                                ),
                          title: Text(
                            authProvider.userDetails.user!.fullName!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          subtitle: Text(
                            authProvider.userDetails.user!.userNameSubtitle ??
                                "",
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.only(bottom: 20),
                        shadowColor: Colors.grey[100],
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RevenuesView(),
                              ),
                            );
                          },
                          leading: Icon(Icons.account_balance_wallet),
                          minVerticalPadding: 5,
                          minLeadingWidth: 20,
                          title: Text("Revenue History"),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.only(bottom: 20),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChangePassword(
                                  isDoctor: true,
                                ),
                              ),
                            );
                          },
                          minVerticalPadding: 5,
                          minLeadingWidth: 20,
                          leading: Icon(Icons.lock),
                          title: Text("Change Password"),
                        ),
                      ),
                      Column(
                        children: authProvider.userDetails.menu!.more!.data!
                            .map(
                              (e) => Card(
                                margin: EdgeInsets.only(bottom: 20),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CardDetailWebView(
                                            url: e.menuKey!,
                                            title: e.title ?? ""),
                                      ),
                                    );
                                  },
                                  minLeadingWidth: 20,
                                  leading: Image.network(
                                    e.icon!,
                                    width: 22,
                                    height: 22,
                                  ),
                                  title: Text(e.title!),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      Card(
                        margin: EdgeInsets.only(bottom: 20),
                        child: ListTile(
                          onTap: () async {
                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .logout();

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => SignIn(),
                              ),
                            );
                          },
                          minLeadingWidth: 20,
                          leading: const Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          title: Text("Logout"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
