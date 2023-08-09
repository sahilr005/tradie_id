import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:tradie_id/config/config.dart';
import 'package:intl/intl.dart';

class CardShow extends StatelessWidget {
  final cardData;
  const CardShow({super.key, this.cardData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Card")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              if (box!.get("lastTime") != null)
                Text(
                    "Last Sync Time :- ${DateFormat('yyyy-MM-dd – kk:mm a').format(box!.get("lastTime"))}"),
              Card(
                elevation: 9.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 164,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                        height: 50,
                                        width: 40,
                                        child: AnalogClock()),
                                    const SizedBox(width: 10),
                                    Image.network(
                                      cardData.companyLogo.toString(),
                                      height: 30,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  box!.get("name").toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  cardData.role.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Ph:${cardData.phoneNo}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Lic No:${cardData.license}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Card No: ${cardData.companyId}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Expiry: ${cardData.expiryDate}",
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              box!.get("imagePath") != null
                                  ? Image.file(
                                      File(box!.get("imagePath")),
                                      height: 130,
                                      width: 90,
                                    )
                                  : box!.get("image") == null ||
                                          box!.get("image").toString().isEmpty
                                      ? const SizedBox()
                                      : Image.network(
                                          box!.get("image").toString(),
                                          height: 130,
                                          width: 90,
                                        ),

                              // Image.network(
                              //   cardData.companyLogo!,
                              //   fit: BoxFit.cover,
                              //   height: 130,
                              //   width: 90,
                              // ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                          height: 14, color: Colors.blueGrey, thickness: .1),
                      Text(
                        cardData.description ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 9.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    children: [
                      const Text(
                        "Authorized Contractor for",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset("assets/logo.png", width: 90),
                          Image.network(
                              "https://afrbestplacestowork.com/wp-content/uploads/2021/07/sgch-logo.png",
                              width: 90),
                          // Image.network(
                          //     "https://afrbestplacestowork.com/wp-content/uploads/2021/07/sgch-logo.png",
                          //     width: 90),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                              "https://www.humehousing.com.au/template/img/logo.jpg",
                              width: 90),
                          const SizedBox(width: 20),
                          Image.network(
                              "https://www.linkwentworth.org.au/wp-content/uploads/2022/06/link-wentworth-logo.png",
                              width: 90),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Image.network(
                        "https://credconsulting.com.au/wp-content/uploads/2021/11/NSW-LAHC-1024x289.png",
                        width: 170,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
