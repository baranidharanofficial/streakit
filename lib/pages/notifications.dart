import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:streakit/constants.dart';
import 'package:streakit/models/habit.dart';
import 'package:streakit/service/admob_service.dart';
import 'package:streakit/service/utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationMessage> messages = [];
  BannerAd? _bannerAd;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchNotifications();
      _createBannerAd();
    });
    super.initState();
  }

  Future<void> fetchNotifications() async {
    try {
      CollectionReference notificationCollection =
          FirebaseFirestore.instance.collection('notifications');
      QuerySnapshot snapshot = await notificationCollection.get();

      if (snapshot.docs.isNotEmpty) {
        var messagesData = snapshot.docs[0]['messages'] as List<dynamic>;
        List<NotificationMessage> data = messagesData
            .map((messageData) {
              return NotificationMessage.fromMap(
                  messageData as Map<String, dynamic>);
            })
            .toList()
            .reversed
            .toList();

        messages = data;
      }

      setState(() {});
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
    }
  }

  _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: textConfig.whiteTitle.copyWith(
            fontSize: sizeConfig.xxl,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: sizeConfig.xl,
          ),
        ),
      ),
      body: messages.isNotEmpty
          ? Padding(
              padding: EdgeInsets.all(
                sizeConfig.large,
              ),
              child: ListView.separated(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizeConfig.xl,
                      vertical: sizeConfig.medium,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF262626),
                      borderRadius: BorderRadius.circular(
                        sizeConfig.small,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          index == (messages.length - 1)
                              ? Icons.rocket_launch_rounded
                              : Icons.update_rounded,
                          color: Colors.white,
                          size: sizeConfig.xxxxxl * 1.2,
                        ),
                        SizedBox(
                          width: sizeConfig.xs,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              messages[index].message,
                              style: textConfig.whiteLarge,
                            ),
                            Text(
                              formatDate(messages[index].createdAt),
                              style: textConfig.greySmall,
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: sizeConfig.large,
                  );
                },
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: sizeConfig.xxxxxl * 3,
                    color: const Color(0xFFD0D0D0),
                  ),
                  SizedBox(
                    height: sizeConfig.xxxxxl,
                  ),
                  Text(
                    "Important App Updates",
                    style: textConfig.whiteLarge,
                  ),
                  SizedBox(
                    height: sizeConfig.xs,
                  ),
                  Text(
                    "will come here",
                    style: textConfig.whiteLarge,
                  )
                ],
              ),
            ),
      bottomNavigationBar: _bannerAd != null
          ? Container(
              padding: EdgeInsets.only(
                bottom: sizeConfig.small,
              ),
              height: 52,
              child: AdWidget(ad: _bannerAd!),
            )
          : const SizedBox(),
    );
  }
}
