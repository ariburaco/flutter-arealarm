import 'package:Arealarm/core/base/extension/context_extension.dart';
import 'package:Arealarm/core/constants/application/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsManager {
  static AdsManager? _instace;
  static AdsManager get instance {
    if (_instace == null) _instace = AdsManager._init();
    return _instace!;
  }

  AdsManager._init();

  Container createaBannerAd(BuildContext context) {
    final AdSize adSize = AdSize(width: context.width.toInt(), height: 60);

    final BannerAd myBanner = BannerAd(
      adUnitId: ApplicationConstants.ADMOB_BANNER_ID,
      size: adSize,
      request: AdRequest(),
      listener: AdListener(),
    );

    myBanner.load();

    final AdWidget adWidget = AdWidget(ad: myBanner);

    final Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );

    return adContainer;
  }

  // Future<void> showWholeScreen() async {
  //   final InterstitialAd interstitialAd = InterstitialAd(
  //     adUnitId: ApplicationConstants.ADMOB_INTERSTITIAL_ID,
  //     request: AdRequest(),
  //     listener: AdListener(onAdClosed: (ad) {
  //       print(
  //           "AD CLOSED: *****************************************************");
  //     }, onAdOpened: (ad) {
  //       print(
  //           "AD OPENED: *****************************************************");
  //     }, onAdFailedToLoad: (ad, loadError) {
  //       print(
  //           "COULD NOT LOAD: *****************************************************");
  //       print(loadError.message);
  //       print(
  //           "COULD NOT LOAD: *****************************************************");
  //     }, onAdLoaded: (ad) {
  //       print(
  //           "AD LOADED: *****************************************************");
  //     }),
  //   );

  //   await interstitialAd.load();
  //   await interstitialAd.show();
  // }
}
