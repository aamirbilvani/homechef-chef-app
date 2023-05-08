import '../utils/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../constants.dart';

class PercentDialog extends StatelessWidget {
  final ProgressValueNotifier progressValueNotifier;

  PercentDialog(this.progressValueNotifier);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<DownloadUploadProgress>(
                valueListenable: progressValueNotifier.valueNotifier,
                builder: (context, progressValueNotifier, _) {
                  double percent = (progressValueNotifier.receivedOrSent /
                      progressValueNotifier.total);
                  return CircularPercentIndicator(
                    onAnimationEnd: () {
                      if (percent == 1.0) {
                        Navigator.pop(context);
                      }
                    },
                    radius: 200,
                    backgroundColor: kDefaultProgressColor,
                    percent: percent,
                    animation: true,
                    lineWidth: 10,
                    animateFromLastPercent: true,
                    //startAngle: 4,
                    progressColor: kPrimaryColor,
                    circularStrokeCap: CircularStrokeCap.round,
                    footer: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Uploading ...',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5), fontSize: 14),
                      ),
                    ),
                    center: Text(
                      (percent * 100).toStringAsFixed(1) + '%',
                      style: TextStyle(fontSize: 30),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
