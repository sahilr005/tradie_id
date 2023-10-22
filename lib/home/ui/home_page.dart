import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tradie_id/config/config.dart';
import 'package:tradie_id/home/ui/card_list.dart';
import 'package:tradie_id/home/ui/inquiry.dart';
import 'package:tradie_id/home/ui/job_appiaction.dart';
import 'package:tradie_id/home/ui/job_list.dart';
import 'package:tradie_id/home/ui/my_review.dart';
import 'package:tradie_id/home/ui/settings.dart';
import 'package:tradie_id/main.dart';

// apiCall() async {
//   try {
//     Response res = await Dio()
//         .post("http://68.178.163.90:4500/api/employe/companyList", data: {
//       "phone_no": box!.get("phone").toString().contains("+")
//           ? box!.get("phone").toString().replaceRange(0, 3, "")
//           : box!.get("phone").toString()
//     });
//     // log(box!.get("phone").toString());
//     // log(res.data.toString());

//     CompanyListModel data = CompanyListModel.fromJson(res.data);

//     // Cache image data for each company
//     try {
//       for (var i = 0; i < data.result!.list!.length; i++) {
//         final companyLogoUrl = data.result!.list![i].companyLogo.toString();
//         final profileImageUrl = data.result!.list![i].profileImage.toString();
//         if (companyLogoUrl.isNotEmpty || companyLogoUrl != "") {
//           await cacheImage(companyLogoUrl);
//         }
//         if (profileImageUrl.isNotEmpty || profileImageUrl != "") {
//           await cacheImage(profileImageUrl);
//         }
//       }
//     } catch (e) {
//       log(e.toString());
//     }

//     box!.put("cardList", data.result!.list!);
//     box!.put("lastTime", DateTime.now());
//     globleCardData!.value = box!.get("cardList");
//     log("Api Call  ");
//   } catch (e) {
//     Fluttertoast.showToast(msg: "You are offline");
//   }
//   // log(data.result!.list.toString());
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RxInt _currentIndex = 0.obs;
  final List<Widget> _tabs = box!.get("phone").toString() != "8905671058"
      ? [const CardListScreen(), const SettingsScreen()]
      : [
          const HomeCard(),
          const InquiryScreen(),
          const SettingsScreen(),
        ];
  Rx<PageController> pageController = PageController(initialPage: 0).obs;
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
      });
    }
  }

  @override
  void initState() {
    CheckUserConnection();
    versionCheck();
    super.initState();
  }

  versionCheck() async {
    DocumentSnapshot appConfig = await FirebaseFirestore.instance
        .collection("AppConfig")
        .doc("v1Bjv4AI7GgWui1jFJQm")
        .get();

    if (packageInfo != null) {
      if (packageInfo!.version.toString() !=await appConfig.get("version")) {
        Future.delayed(Duration.zero, () {
          showUpgradeDialog(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: PageView(
            controller: pageController.value,
            allowImplicitScrolling:
                box!.get("phone").toString() == "8905671058",
            physics: box!.get("phone").toString() == "8905671058"
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              _currentIndex.value = index;
            },
            children: _tabs,
          ),
          // _tabs[_currentIndex.value],
          bottomNavigationBar: box!.get("phone").toString() == "8905671058"
              ? BottomNavigationBar(
                  currentIndex: _currentIndex.value,
                  onTap: (index) {
                    pageController.value.jumpToPage(index);
                  },
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    if (box!.get("phone").toString() == "8905671058")
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.info),
                        label: 'Inquiry',
                      ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                )
              : null,
        ));
  }
}

class LogoutDialog extends StatefulWidget {
  final bool delete;
  const LogoutDialog({super.key, required this.delete});

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.delete ? 'Delete' : 'Logout'),
      content: Text(widget.delete
          ? 'Are you sure you want to Delete?'
          : 'Are you sure you want to log out?'),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Return false when cancel is pressed
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: OutlinedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pop(true); // Return true when logout is pressed
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class HomeCard extends StatefulWidget {
  const HomeCard({super.key});

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tradie Id"),
        centerTitle: true,
      ),
      body: cardListScreen(context),
    );
  }

  Padding cardListScreen(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (a) => const CardListScreen()));
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "My Cards",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (a) => const CardListScreen()));
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "My Company",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (box!.get("phone").toString() == "8905671058")
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (a) => const JobListingPage()));
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.brown.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Applied For Job",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Fluttertoast.showToast(
                            msg: "You don't have any schedule interview");
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.indigoAccent.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "My Interview",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            if (box!.get("phone").toString() == "8905671058")
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReviewPage(reviews: dummyReviews),
                          ),
                        );
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "My Reviews",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (a) => const JobApplicationForm()));
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "My Application",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ));
  }
}
