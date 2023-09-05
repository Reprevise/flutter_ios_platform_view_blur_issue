import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MainApp());
}

final class _AdWidget extends StatefulWidget {
  const _AdWidget();

  @override
  State<_AdWidget> createState() => _AdWidgetState();
}

class _AdWidgetState extends State<_AdWidget> {
  BannerAd? _ad;

  void _loadAd() {
    _ad = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (ad == null) {
      _loadAd();

      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 50,
      child: AdWidget(ad: ad),
    );
  }
}

final class _BackdropFilterDialog extends StatelessWidget {
  const _BackdropFilterDialog();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: const Text("BackdropFilter dialog"),
          actions: const [CloseButton()],
        ),
        body: const Center(
          child: Text("Hello world"),
        ),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  void _onOpenDialogTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _BackdropFilterDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _AdWidget(),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _onOpenDialogTap(context),
                child: const Text("Open BackdropFilter dialog"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
