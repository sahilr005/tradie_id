import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as gt;
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tradie_id/config/config.dart';
import 'package:tradie_id/home/ui/card_show.dart';
import 'package:tradie_id/home/ui/home_page.dart';
import 'package:tradie_id/model/company_list_model.dart';

import 'package:hive/hive.dart';
// Import the necessary model

RxList? globleCardData = [].obs;

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
getCachedImage(String imageUrl) async {
  final box = await Hive.openBox<List<int>>('imageBox');
  return box.get(imageUrl);
}

// Caches the image using Hive
cacheImage(String imageUrl) async {
  final response = await Dio().get<List<int>>(
    imageUrl,
    options: Options(responseType: ResponseType.bytes),
  );

  final box = await Hive.openBox<List<int>>('imageBox');
  await box.put(imageUrl, response.data!);
}

class CardListScreen extends StatefulWidget {
  const CardListScreen({
    super.key,
  });

  @override
  State<CardListScreen> createState() => _CardListState();
}

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
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(20.0),
          child: globleCardData == null
              ? const Center(child: CircularProgressIndicator())
              : globleCardData!.value.isEmpty
                  ? const Center(child: Text("No Data Found"))
                  : RefreshIndicator(
                      onRefresh: () => apiCall(),
                      child: ListView.builder(
                        itemCount: globleCardData!.value.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var cardData = globleCardData!.value[index];
                          return cardData.status.toString() == "1"
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: InkWell(
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
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8,
                                                          horizontal: 16),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
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
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                "Phone : ${cardData.phoneNo}",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              const SizedBox(
                                                                  height: 5),
                                                              Text(
                                                                "license No. ${cardData.license}",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      child: FutureBuilder(
                                                        future: getCachedImage(
                                                            cardData.companyLogo
                                                                .toString()),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const CircularProgressIndicator();
                                                          } else if (snapshot
                                                                  .hasData &&
                                                              snapshot.data !=
                                                                  null) {
                                                            dynamic d =
                                                                snapshot.data!;
                                                            return Image.memory(
                                                              Uint8List
                                                                  .fromList(d),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.3,
                                                              fit: BoxFit.cover,
                                                            );
                                                          } else {
                                                            return const Text(
                                                                "Image not available");
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                const Divider(
                                                    height: 14,
                                                    color: Colors.blueGrey,
                                                    thickness: .1),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    cardData.name ?? "",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        },
                      ),
                    ),
        ),
      ),
    );
  }
}
