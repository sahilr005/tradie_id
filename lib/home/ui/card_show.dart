import 'dart:typed_data';

import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:flutter/material.dart';
import 'package:tradie_id/config/config.dart';
import 'package:intl/intl.dart';
import 'package:tradie_id/home/ui/card_list.dart';

class CardShow extends StatelessWidget {
  final cardData;
  const CardShow({super.key, this.cardData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cardData.name + " - ID Card" ?? " ID Card")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              if (box!.get("lastTime") != null)
                Row(
                  children: [
                    Text(
                      "Last Sync Time :- ",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent.shade700),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd – kk:mm a')
                          .format(box!.get("lastTime")),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent.shade700,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 5),
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
                                    FutureBuilder<List<int>?>(
                                      future: getCachedImage(
                                          cardData.companyLogo.toString()),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasData) {
                                          return Image.memory(
                                            Uint8List.fromList(snapshot.data!),
                                            height: 30,
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
                                    //   height: 30,
                                    // ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  cardData.employeName.toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  cardData.employeRole.toString(),
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
                              FutureBuilder<List<int>?>(
                                future: getCachedImage(
                                    cardData.profileImage.toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasData) {
                                    return Image.memory(
                                      Uint8List.fromList(snapshot.data!),
                                      height: 130,
                                      width: 90,
                                      fit: BoxFit.cover,
                                    );
                                  } else {
                                    return Image.asset(
                                      "assets/no_user.jpg",
                                      height: 130,
                                      width: 90,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },
                              ),
                              // Image.network(
                              //   cardData.profileImage.toString(),
                              //   height: 130,
                              //   width: 90,
                              // ),

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
                      if (cardData.description != null)
                        const Divider(
                            height: 14, color: Colors.blueGrey, thickness: .1),
                      if (cardData.description != null)
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
              DigitalClock(
                hourMinuteDigitTextStyle: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.greenAccent.shade700),
                digitAnimationStyle: Curves.easeInQuart,
                is24HourTimeFormat: false,
                secondDigitTextStyle: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.greenAccent.shade700),
                colon: Text(
                  ":",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black),
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
                          Image.asset("assets/sgch-logo.png", width: 90),
                          Image.asset("assets/women.png", width: 90),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/logo.jpeg", width: 100),
                          const SizedBox(width: 20),
                          Image.asset("assets/link-wentworth-logo.png",
                              width: 100),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Image.asset(
                        "assets/NSW-LAHC-1024x289.png",
                        width: 170,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
