import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:flutter/material.dart';
import 'package:tradie_id/config/config.dart';
import 'package:intl/intl.dart';
import 'package:tradie_id/home/ui/card_list.dart';
import 'package:photo_view/photo_view.dart';

class CardShow extends StatefulWidget {
  final cardData;
  const CardShow({super.key, this.cardData});

  @override
  State<CardShow> createState() => _CardShowState();
}

class _CardShowState extends State<CardShow> {
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? _imageFile;

  // Function to check if expiry date is less than 60 days in the future
  bool isExpiryDateWarning(DateTime expiryDate) {
    final currentDate = DateTime.now();
    final daysDifference = expiryDate.difference(currentDate).inDays;
    return daysDifference < 60;
  }

  @override
  Widget build(BuildContext context) {
    final expiryDate =
        DateFormat('yyyy-MM-dd').parse(widget.cardData.expiryDate);
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.cardData.name + " - ID Card" ?? " ID Card")),
      body: SingleChildScrollView(
        child: Padding(
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
                Screenshot(
                  controller: screenshotController,
                  child: InkWell(
                    onTap: () {
                      screenshotController.capture().then((Uint8List? image) {
                        //Capture Done
                        setState(() {
                          _imageFile = image;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (a) => PhotoV(image: image!),
                          ),
                        );
                      }).catchError((onError) {
                        print(onError);
                      });
                    },
                    child: Stack(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 164,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Row(
                                            children: [
                                              // Image.network(
                                              //   cardData.companyLogo.toString(),
                                              //   height: 30,
                                              // ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Text(
                                            widget.cardData.employeName
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            widget.cardData.employeRole
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Ph:${widget.cardData.phoneNo}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "Lic No:${widget.cardData.license}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Card No: ${widget.cardData.cardNo}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // Text(
                                        //   "Expiry: ${widget.cardData.expiryDate}",
                                        //   style: const TextStyle(
                                        //       color: Colors.black),
                                        // ),
                                        const SizedBox(height: 4),
                                        FutureBuilder(
                                          future: getCachedImage(widget
                                              .cardData.profileImage
                                              .toString()),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else if (snapshot.hasData) {
                                              dynamic d = snapshot.data!;
                                              return ConstrainedBox(
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 50,
                                                  maxWidth: 160,
                                                  maxHeight: 135,
                                                  minHeight: 50
                                                ),
                                                child: Image.memory(
                                                  Uint8List.fromList(d),
                                                  fit: BoxFit.contain,
                                                ),
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
                                const Divider(
                                    height: 14,
                                    color: Colors.blueGrey,
                                    thickness: .1),
                                Text(
                                  "Contractor/Employee on behalf of ${widget.cardData.name}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 4,
                          top: 4,
                          child: FutureBuilder(
                            future: getCachedImage(
                                widget.cardData.companyLogo.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasData) {
                                dynamic d = snapshot.data!;
                                return Image.memory(
                                  Uint8List.fromList(d),
                                  height: 70,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return const Text("Image not available");
                              }
                            },
                          ),
                        ),
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
                  showSecondsDigit: true,
                ),
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
                            Image.asset("assets/sgch-logo.png", width: 100),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/women.png", width: 100),
                            const SizedBox(width: 20),
                            Image.asset("assets/logo.jpeg", width: 90),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/link-wentworth-logo.png",
                                width: 90),
                            const SizedBox(width: 20),
                            Image.asset(
                              "assets/NSW-LAHC-1024x289.png",
                              width: 110,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                if (isExpiryDateWarning(expiryDate))
                  Text(
                    "Your card will expire soon, please contact the Compliance Department at ${widget.cardData.name}.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PhotoV extends StatefulWidget {
  final Uint8List image;
  const PhotoV({super.key, required this.image});

  @override
  State<PhotoV> createState() => _PhotoVState();
}

class _PhotoVState extends State<PhotoV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: PhotoView(
        imageProvider: MemoryImage(widget.image),
      ),
    );
  }
}
