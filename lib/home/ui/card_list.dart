import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tradie_id/config/config.dart';
import 'package:tradie_id/home/ui/card_show.dart';
import 'package:tradie_id/model/company_list_model.dart';

import 'package:hive/hive.dart';
// Import the necessary model

class RListAdapter extends TypeAdapter<RList> {
  @override
  final typeId = 33; // Choose a unique typeId for RList

  @override
  RList read(BinaryReader reader) {
    // Implement the deserialization logic
    return RList.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, RList obj) {
    // Implement the serialization logic
    writer.writeMap(obj.toJson());
  }
}

// Retrieves the cached image
Future<List<int>?> getCachedImage(String imageUrl) async {
  final box = await Hive.openBox<List<int>>('imageBox');
  return box.get(imageUrl);
}

// Caches the image using Hive
Future<void> cacheImage(String imageUrl) async {
  final response = await Dio().get<List<int>>(
    imageUrl,
    options: Options(responseType: ResponseType.bytes),
  );

  final box = await Hive.openBox<List<int>>('imageBox');
  await box.put(imageUrl, response.data!);
}

class CardListScreen extends StatefulWidget {
  const CardListScreen({super.key});

  @override
  State<CardListScreen> createState() => _CardListState();
}

class _CardListState extends State<CardListScreen> {
  List? r;
  apiCall() async {
    try {
      Response res = await Dio().post(
          "http://68.178.163.90:4500/api/employe/companyList",
          data: {"phone_no": box!.get("phone")});
      // log(box!.get("phone").toString());
      // log(res.data.toString());

      CompanyListModel data = CompanyListModel.fromJson(res.data);

      // Cache image data for each company
      try {
        for (var i = 0; i < data.result!.list!.length; i++) {
          final companyLogoUrl = data.result!.list![i].companyLogo.toString();
          final profileImageUrl = data.result!.list![i].profileImage.toString();
          if (companyLogoUrl.isNotEmpty || companyLogoUrl != "") {
            await cacheImage(companyLogoUrl);
          }
          if (profileImageUrl.isNotEmpty || profileImageUrl != "") {
            await cacheImage(profileImageUrl);
          }
        }
      } catch (e) {
        log(e.toString());
      }

      box!.put("cardList", data.result!.list!);
      box!.put("lastTime", DateTime.now());
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("You are offline")));
    }
    r = box!.get("cardList");
    // log(data.result!.list.toString());
    setState(() {});
  }

  @override
  void initState() {
    apiCall();
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
          child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                "assets/idlogo.png",
              )),
        ),
        title: const Text("Tradie Id"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: InkWell(
                onTap: () {
                  apiCall();
                },
                child: const Row(
                  children: [
                    Icon(Icons.sync),
                    SizedBox(width: 2),
                    Text("Sync")
                  ],
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: r == null
            ? const Center(child: CircularProgressIndicator())
            : r!.isEmpty
                ? const Center(child: Text("No Data Found"))
                : ListView.builder(
                    itemCount: r!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var cardData = r![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () {
                            try {
                              var lastSync = box!.get("lastTime");
                              if (DateTime.now().difference(lastSync).inDays <=
                                  10) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (a) => CardShow(
                                      cardData: cardData,
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
                                  ),
                                ),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Card(
                                elevation: 9.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9),
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder<List<int>?>(
                                            future: getCachedImage(cardData
                                                .companyLogo
                                                .toString()),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else if (snapshot.hasData &&
                                                  snapshot.data != null) {
                                                return Image.memory(
                                                  Uint8List.fromList(
                                                      snapshot.data!),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  fit: BoxFit.cover,
                                                );
                                              } else {
                                                return const Text(
                                                    "Image not available");
                                              }
                                            },
                                          ),

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
                                                "#${cardData.companyId}",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                "Expiry: ${cardData.expiryDate}",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      const Divider(
                                          height: 14,
                                          color: Colors.blueGrey,
                                          thickness: .1),
                                      const SizedBox(height: 5),
                                      Text(
                                        cardData.name ?? "",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
