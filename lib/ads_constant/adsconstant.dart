import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ketodiet/ads_constant/ads_ids.dart';
import 'package:ketodiet/api/api.dart';
import 'package:ketodiet/screens/homemain/homemain.dart';
import 'package:ketodiet/screens/subscription/subscription_screen.dart';
import 'package:ketodiet/utils/payment.dart';

class AdsConstant {
  InterstitialAd? _interstitialAd;
  Function? onAdDismissed;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 4;
  bool _isShowingAd = false;
  AppOpenAd? _appOpenAd;
  late BannerAd bannerAd;
  bool isLoaded = false;
  BannerAd? _bannerAd;

  static void navigationPage(BuildContext context,
      {Map<String, dynamic>? firstPageResp, String isSubscribed = 'inactive'}) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                isSubscribed == 'inactive' || isSubscribed == 'Error'
                    ? SubscriptionScreen(
                        pageResponse: firstPageResp,
                      )
                    : HomeMain(
                        pageResponse: firstPageResp,
                        subScribed: isSubscribed)));
  }

  void loadAppOpenAd(BuildContext context) async {
    print('loading>>>');
    String? deviceID = await getDeviceID(context);
    String isSubscribed =
        await Api().fetchSubscriptionStatus(deviceID?.replaceAll('.', '_'));

    List<dynamic>? firstPageResponse = await Api().fetchFirstPage();
    AppOpenAd.load(
      adUnitId: AdsIDs.adUnitIdSplash,
      // orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('AppOpenAd loaded');
          _appOpenAd = ad;
          _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowingAd = true;
              print('appopen $ad onAdShowedFullScreenContent');
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('appopen $ad onAdFailedToShowFullScreenContent: $error');
              _isShowingAd = false;
              ad.dispose();
              _appOpenAd = null;
            },
            onAdDismissedFullScreenContent: (ad) {
              print('appopen $ad onAdDismissedFullScreenContent');
              _isShowingAd = false;
              ad.dispose();
              _appOpenAd = null;
              navigationPage(context,
                  firstPageResp:
                      (firstPageResponse ?? [])[0] as Map<String, dynamic>,
                  isSubscribed: isSubscribed);
            },
          );

          _appOpenAd!.show();
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
          navigationPage(context,
              firstPageResp:
                  (firstPageResponse ?? [])[0] as Map<String, dynamic>,
              isSubscribed: isSubscribed);
          // Handle the error.
        },
      ),
    );
  }

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void createInterstitialAd() {
    if (_interstitialAd != null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }

    InterstitialAd.load(
      adUnitId: AdsIDs.adUnitIdInterstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          // showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            createInterstitialAd();
          } else {
            // gotoNext(index);
          }
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      createInterstitialAd();
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        // gotoNext(index);
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;

    createInterstitialAd();
  }

  /* initBannerAd(){
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdsIDs.adUnitIdBanner,
      listener: BannerAdListener(
          onAdLoaded: (ad){
              isLoaded=true;
          },
          onAdFailedToLoad: (ad,error){
            ad.dispose();
          }
      ),
      request: const AdRequest(),
    );
  }*/

  void loadBannerAd() {
    const adSize = AdSize.banner;

    _bannerAd = BannerAd(
      size: adSize,
      adUnitId: AdsIDs.adUnitIdBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Banner ad loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }

  Widget getBannerAdWidget() {
    if (_bannerAd != null) {
      return SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    } else {
      return Container(); // Placeholder widget when ad is not loaded
    }
  }
}
