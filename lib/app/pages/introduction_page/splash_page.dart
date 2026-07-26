import 'dart:async';
import 'dart:math' as math;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:esoi/app/pages/introduction_page/intro_page.dart';
import 'package:esoi/app/pages/main_page/main_page.dart';
import 'package:esoi/app/pages/offline_page/internet_connection_page.dart';
import 'package:esoi/app/services/guest_service/guest_service.dart';
import 'package:esoi/common/common.dart';
import 'package:esoi/common/data/app_data.dart';
import 'package:esoi/common/utils/app_text.dart';
import 'package:esoi/config/assets.dart';
import 'package:esoi/config/colors.dart';
import 'package:esoi/config/styles.dart';

class SplashPage extends StatefulWidget {
  static const String pageName = '/splash';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    FlutterNativeSplash.remove();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.forward();

      Timer(const Duration(seconds: 3), () async {
        final List<ConnectivityResult> connectivityResult =
            await (Connectivity().checkConnectivity());

        if (connectivityResult.contains(ConnectivityResult.none)) {
          nextRoute(InternetConnectionPage.pageName, isClearBackRoutes: true);
        } else {
          String token = await AppData.getAccessToken();

          if (mounted) {
            if (token.isEmpty) {
              bool isFirst = await AppData.getIsFirst();

              if (isFirst) {
                nextRoute(IntroPage.pageName, isClearBackRoutes: true);
              } else {
                nextRoute(MainPage.pageName, isClearBackRoutes: true);
              }
            } else {
              nextRoute(MainPage.pageName, isClearBackRoutes: true);
            }
          }
        }
      });
    });

    GuestService.config();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: green63,
      body: Container(
        width: getSize().width,
        height: getSize().height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(AppAssets.splashPng),
          fit: BoxFit.cover,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Spacer(),
            space(150),
            Stack(
              alignment: Alignment.center,
              children: [
                // دائرة منقطة تتحرك
                AnimatedBuilder(
                  animation: animationController,
                  builder: (_, __) {
                    return Transform.rotate(
                      angle: animationController.value * 2 * 3.14,
                      child: CustomPaint(
                        size: const Size(150, 150),
                        painter: DottedCirclePainter(),
                      ),
                    );
                  },
                ),
                // صورة داخل دائرة
                // صورة داخل دائرة بالكامل
                ClipOval(
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.transparent, // سيبها شفافة
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.asset(
                        "assets/image/jpg/icon_app.jpg",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            space(40),
            Text(
              appText.webinar,
              style: style24Bold().copyWith(color: Colors.white),
            ),
            space(10),
            Text(
              appText.splashDesc,
              style: style16Regular().copyWith(color: Colors.white),
            ),
            const Spacer(),
            const Spacer(),
            const SizedBox(
              width: 35,
              child: LoadingIndicator(
                indicatorType: Indicator.ballBeat,
                colors: [Colors.white],
                strokeWidth: 100,
                backgroundColor: Colors.transparent,
                pathBackgroundColor: Colors.transparent,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class DottedCirclePainter extends CustomPainter {
  final int dotCount;
  final double dotRadius;
  final double circleRadius;

  DottedCirclePainter({
    this.dotCount = 50,
    this.dotRadius = 1.5,
    this.circleRadius = 90.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // مركز الـ canvas
    final Offset center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < dotCount; i++) {
      final double angle = (2 * math.pi * i) / dotCount;
      final double dx = center.dx + circleRadius * math.cos(angle);
      final double dy = center.dy + circleRadius * math.sin(angle);
      canvas.drawCircle(Offset(dx, dy), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DottedCirclePainter oldDelegate) {
    return oldDelegate.dotCount != dotCount ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.circleRadius != circleRadius;
  }
}
