import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5115082725145746/8935729003';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5115082725145746/3811750057';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerAddUserAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5115082725145746/5950035642';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5115082725145746/3811750057';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerHoroscopeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5115082725145746/2578956217';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5115082725145746/3811750057';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerBioritmoAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5115082725145746/5644103256';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5115082725145746/3811750057';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }


  //
  // static String get interstitialAdUnitId {
  //   if (Platform.isAndroid) {
  //     return "ca-app-pub-5115082725145746/1635119213";
  //   } else if (Platform.isIOS) {
  //     return "ca-app-pub-3940256099942544/4411468910";
  //   } else {
  //     throw new UnsupportedError("Unsupported platform");
  //   }
  // }
  //
  // static String get rewardedAdUnitId {
  //   if (Platform.isAndroid) {
  //     return "ca-app-pub-3940256099942544/5224354917";
  //   } else if (Platform.isIOS) {
  //     return "ca-app-pub-3940256099942544/1712485313";
  //   } else {
  //     throw new UnsupportedError("Unsupported platform");
  //   }
  // }
}