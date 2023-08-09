import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

class CardListScreen extends StatefulWidget {
  const CardListScreen({super.key});

  @override
  State<CardListScreen> createState() => _CardListState();
}

class _CardListState extends State<CardListScreen> {
  List<RList>? r;
  apiCall() async {
    try {
      Response res = await Dio().post(
          "http://68.178.163.90:4500/api/employe/companyList",
          data: {"phone_no": box!.get("phone")});

      CompanyListModel data = CompanyListModel.fromJson(res.data);

      box!.put("cardList", data.result!.list!);
      box!.put("lastTime", DateTime.now());
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("You are offline")));
    }
    r = box!.get("cardList");
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
        title: const Text("My Cards"),
        actions: [
          InkWell(
              onTap: () {
                apiCall();
              },
              child: const Icon(Icons.abc))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: r == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: r!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var cardData = r![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (a) => CardShow(
                              cardData: cardData,
                            ),
                          ),
                        );
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        cardData.companyLogo.toString(),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .2,
                                        fit: BoxFit.cover,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Company Id: ${cardData.companyId}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Expiry: ${cardData.expiryDate}",
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                      height: 14,
                                      color: Colors.blueGrey,
                                      thickness: .1),
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
