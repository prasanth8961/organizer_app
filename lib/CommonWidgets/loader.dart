import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget showLoadingIndicator() {
  return Container(
    color: Colors.black.withOpacity(0.9),
    child: const Center(
      child: SpinKitRipple(
        color: Colors.white,
        size: 100.0,
        borderWidth: 6,
      ),
    ),
  );
}

Widget showAuthBtnLoader() {
  return const SpinKitThreeBounce(
    color: Colors.white,
    size: 20.0,
  );
}

Widget showHomeScreenLoader() {
  return const SpinKitFadingCircle(
    color: Colors.blue,
    size: 50.0,
  );
}

Widget showAPILoader() {
  return const SpinKitDualRing(
    color: Colors.green,
    size: 40.0,
  );
}

Widget showFullScreenLoader() {
  return const SpinKitCubeGrid(
    color: Colors.redAccent,
    size: 60.0,
  );
}

Widget showSmallInineLoader() {
  return const SpinKitWave(
    color: Colors.yellow,
    size: 30.0,
  );
}

Widget showProfilePictureLoader() {
  return const SpinKitRipple(
    color: Colors.purple,
    size: 70.0,
  );
}

Widget showWaitingStateLoader() {
  return const SpinKitCircle(
    color: Colors.orange,
    size: 50.0,
  );
}
