import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as gt;
import 'package:intl/intl.dart';
import 'package:tradie_id/config/config.dart';
import 'package:tradie_id/home/ui/card_show.dart';
import 'package:tradie_id/model/company_list_model.dart';
import 'package:tradie_id/profile/profile_page.dart';
// Import the necessary model

// RxList? globleCardData = [].obs;

// class RListAdapter extends TypeAdapter<RList> {
//   @override
//   final typeId = 34; // Choose a unique typeId for RList

//   @override
//   RList read(BinaryReader reader) {
//     // Implement the deserialization logic
//     return RList.fromJson(reader.readMap());
//   }

//   @override
//   void write(BinaryWriter writer, RList obj) {
//     // Implement the serialization logic
//     writer.writeMap(obj.toJson());
//   }
// }

// Retrieves the cached image
// getCachedImage(String imageUrl) async {
//   final box = await Hive.openBox<List<int>>('imageBox');
//   return box.get(imageUrl);
// }

// // Caches the image using Hive
// cacheImage(String imageUrl) async {
//   final response = await Dio().get<List<int>>(
//     imageUrl,
//     options: Options(responseType: ResponseType.bytes),
//   );

//   final box = await Hive.openBox<List<int>>('imageBox');
//   await box.put(imageUrl, response.data!);
// }

class CardListScreen extends StatefulWidget {
  const CardListScreen({
    super.key,
  });

  @override
  State<CardListScreen> createState() => _CardListState();
}

bool ActiveConnection = false;

class _CardListState extends State<CardListScreen> {
  // RxList? r = box!.get("cardList").obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Padding(
            padding:
                const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (box!.get("phone").toString() == "8905671058")
                  InkWell(
                      onTap: () {
                        gt.Get.back();
                      },
                      child: const Icon(Icons.arrow_back_ios)),
                if (box!.get("phone").toString() != "8905671058")
                  ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        "assets/idlogo.png",
                      )),
              ],
            ),
          ),
          title: const Text("Tradie Id"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: GestureDetector(
                  onTap: () {
                    // apiCall();
                    gt.Get.to(() => const ProfilePage());
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 2),
                      // Text("Sync")
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.sync),
                      SizedBox(width: 2),
                      // Text("Sync")
                    ],
                  )),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Employes")
                .where("phone_no", isEqualTo: box!.get("phone").toString())
                .where("status", isEqualTo: 1)
                .where("company_assigned", isEqualTo: 1)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }

              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                // Map Firestore data to your CompanyListModel
                CompanyListModel data = CompanyListModel.fromJson({
                  'cardList': snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList(),
                });
                if (ActiveConnection) {
                  box!.put("lastTime", DateTime.now());
                }
                // for (var company in data.cardList!) {
                // if (company.companyLogo != null &&
                //     company.companyLogo!.isNotEmpty) {
                // }
                // if (company.profileImage != null &&
                //     company.profileImage!.isNotEmpty) {

                // }
                // }

                return ListView.builder(
                  itemCount: data.cardList!.length,
                  itemBuilder: (context, index) {
                    var cardData = data.cardList![index];
                    // cacheImage(cardData.companyLogo!);
                    // cacheImage(cardData.profileImage!);
                    // setState(() {});
                    // Customize the UI to display cardData as needed.
                    return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("Users")
                            .doc(cardData.companyId)
                            .get(),
                        builder: (context, snapshotUser) {
                          if (snapshotUser.connectionState ==
                              ConnectionState.waiting) {
                            // return const Center(
                            //     child: CircularProgressIndicator());
                          }
                          if (snapshotUser.hasError) {
                            return Text("Error: ${snapshotUser.error}");
                          }
                          if (snapshotUser.data != null &&
                              !isExpiry(DateFormat('yyyy-MM-dd')
                                  .parse(cardData.expiryDate.toString()))) {
                            DocumentSnapshot d = snapshotUser.data!;

                            // cacheImage(d.get("companyLogo"));
                            return InkWell(
                              onTap: () {
                                try {
                                  var lastSync = box!.get("lastTime");
                                  if (DateTime.now()
                                          .difference(lastSync)
                                          .inDays <=
                                      10) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (a) => CardShow(
                                          cardData: cardData,
                                          userData: d,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Since Last 10 days you data not synced\n connect your device with network & sync");
                                  }
                                } catch (e) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (a) => CardShow(
                                        cardData: cardData,
                                        userData: d,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Card(
                                elevation: 9.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Image.network(
                                                //   cardData.companyLogo.toString(),
                                                //   width:
                                                //       MediaQuery.of(context).size.width *
                                                //           .2,
                                                //   fit: BoxFit.cover,
                                                // ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "Phone : ${d.get("phone_no") ?? ""}",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      "license No. ${d.get("license") ?? ""}",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            child: CachedNetworkImage(
                                              imageUrl: d.get("companyLogo"),
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              fit: BoxFit.cover,
                                            ),
                                            //  FutureBuilder(
                                            //   future: getCachedImage(
                                            //       d.get("companyLogo")),
                                            //   builder: (context, snapshot) {
                                            //     if (snapshot.connectionState ==
                                            //         ConnectionState.waiting) {
                                            //       return const Center(
                                            //           child:
                                            //               CircularProgressIndicator());
                                            //     } else if (snapshot.hasData &&
                                            //         snapshot.data != null) {
                                            //       dynamic d = snapshot.data!;
                                            //       return Image.memory(
                                            //         Uint8List.fromList(d),
                                            //         width:
                                            //             MediaQuery.of(context)
                                            //                     .size
                                            //                     .width *
                                            //                 0.3,
                                            //         fit: BoxFit.cover,
                                            //       );
                                            //     } else {
                                            //       return
                                            //       //  Image.network(
                                            //       //   d.get("companyLogo"),
                                            //       //   width:
                                            //       //       MediaQuery.of(context)
                                            //       //               .size
                                            //       //               .width *
                                            //       //           0.3,
                                            //       //   fit: BoxFit.cover,
                                            //       // );
                                            //       // const Text(
                                            //       //     "Image not available");
                                            //     }
                                            //   },
                                            // ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      const Divider(
                                          height: 14,
                                          color: Colors.blueGrey,
                                          thickness: .1),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          d.get("name") ?? "",
                                          // cardData.name ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else if (data.cardList!.length.isEqual(1) &&
                              snapshotUser.data != null &&
                              isExpiry(DateFormat('yyyy-MM-dd')
                                  .parse(cardData.expiryDate.toString()))) {
                            return Container(
                              height: gt.Get.height * .8,
                              alignment: Alignment.center,
                              child: const Text(
                                "You are currently not registered with any Multi-Trades or Deactivated, please contact the Multi-Trade or Principal Contractor that you are providing services to.",
                                style: TextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const SizedBox();
                        });
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    "You are currently not registered with any Multi-Trades or Deactivated, please contact the Multi-Trade or Principal Contractor that you are providing services to.",
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            },
          ),
        )

        //  Obx(
        //   () => Padding(
        //     padding: const EdgeInsets.all(20.0),
        //     child: globleCardData == null
        //         ? const Center(child: CircularProgressIndicator())
        //         : globleCardData!.value.isEmpty
        //             ? const Center(
        //                 child: Text(
        //                   "You are currently not registered with any Multi-Trades, please contact the Multi-Trade or Principal Contractor that you are providing services to.",
        //                   style: TextStyle(),
        //                   textAlign: TextAlign.center,
        //                 ),
        //               )
        //             : RefreshIndicator(
        //                 onRefresh: () async {
        //                   apiCall();
        //                 },
        //                 child: ListView.builder(
        //                   itemCount: globleCardData!.value.length,
        //                   shrinkWrap: true,
        //                   itemBuilder: (context, index) {
        //                     var cardData = globleCardData!.value[index];
        //                     return cardData.status.toString() == "1"
        // ? Padding(
        //     padding: const EdgeInsets.only(bottom: 10),
        //     child: InkWell(
        // onTap: () {
        //   try {
        //     var lastSync = box!.get("lastTime");
        //     if (DateTime.now()
        //             .difference(lastSync)
        //             .inDays <=
        //         10) {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (a) => CardShow(
        //             cardData: cardData,
        //           ),
        //         ),
        //       );
        //     } else {
        //       Fluttertoast.showToast(
        //           msg:
        //               "Since Last 10 days you data not synced\n connect your device with network & sync");
        //     }
        //   } catch (e) {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (a) => CardShow(
        //           cardData: cardData,
        //         ),
        //       ),
        //     );
        //   }
        // },
        //       child: Column(
        //         children: [
        //           Card(
        //             elevation: 9.0,
        //             child: Container(
        //               decoration: BoxDecoration(
        //                 borderRadius:
        //                     BorderRadius.circular(9),
        //                 color: Colors.white,
        //               ),
        //               child: Column(
        //                 crossAxisAlignment:
        //                     CrossAxisAlignment.start,
        //                 children: [
        //                   Stack(
        //                     children: [
        //                       Padding(
        //                         padding: const EdgeInsets
        //                                 .symmetric(
        //                             vertical: 8,
        //                             horizontal: 16),
        //                         child: Row(
        //                           mainAxisAlignment:
        //                               MainAxisAlignment
        //                                   .end,
        //                           crossAxisAlignment:
        //                               CrossAxisAlignment
        //                                   .start,
        //                           children: [
        //                             // Image.network(
        //                             //   cardData.companyLogo.toString(),
        //                             //   width:
        //                             //       MediaQuery.of(context).size.width *
        //                             //           .2,
        //                             //   fit: BoxFit.cover,
        //                             // ),
        //                             Column(
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment
        //                                       .end,
        //                               children: [
        //                                 Text(
        //                                   "Phone : ${cardData.phoneNo}",
        //                                   style: const TextStyle(
        //                                       fontSize:
        //                                           14,
        //                                       color: Colors
        //                                           .black),
        //                                 ),
        //                                 const SizedBox(
        //                                     height: 5),
        //                                 Text(
        //                                   "license No. ${cardData.license}",
        //                                   style:
        //                                       const TextStyle(
        //                                     color: Colors
        //                                         .black,
        //                                     fontSize: 16,
        //                                   ),
        //                                 ),
        //                               ],
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                       Positioned(
        //                         child: FutureBuilder(
        //                           future: getCachedImage(
        //                               cardData.companyLogo
        //                                   .toString()),
        //                           builder: (context,
        //                               snapshot) {
        //                             if (snapshot
        //                                     .connectionState ==
        //                                 ConnectionState
        //                                     .waiting) {
        //                               return const CircularProgressIndicator();
        //                             } else if (snapshot
        //                                     .hasData &&
        //                                 snapshot.data !=
        //                                     null) {
        //                               dynamic d =
        //                                   snapshot.data!;
        //                               return Image.memory(
        //                                 Uint8List
        //                                     .fromList(d),
        //                                 width: MediaQuery.of(
        //                                             context)
        //                                         .size
        //                                         .width *
        //                                     0.3,
        //                                 fit: BoxFit.cover,
        //                               );
        //                             } else {
        //                               return const Text(
        //                                   "Image not available");
        //                             }
        //                           },
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                   const SizedBox(height: 5),
        //                   const Divider(
        //                       height: 14,
        //                       color: Colors.blueGrey,
        //                       thickness: .1),
        //                   Padding(
        //                     padding:
        //                         const EdgeInsets.all(8.0),
        //                     child: Text(
        //                       cardData.name ?? "",
        //                       style: const TextStyle(
        //                         fontWeight:
        //                             FontWeight.w600,
        //                       ),
        //                     ),
        //                   )
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   )
        //                         : const SizedBox();
        //                   },
        //                 ),
        //               ),
        //   ),
        // ),

        );
  }
}
