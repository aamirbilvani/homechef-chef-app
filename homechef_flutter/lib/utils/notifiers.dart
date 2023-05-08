import 'package:flutter/material.dart';

class DownloadUploadProgress {
  int receivedOrSent, total;

  DownloadUploadProgress(this.receivedOrSent, this.total);
}

class ProgressValueNotifier {
  ValueNotifier<DownloadUploadProgress> valueNotifier =
      ValueNotifier<DownloadUploadProgress>(DownloadUploadProgress(0, 1));

  void updateProgress(DownloadUploadProgress downloadUploadProgress) {
    valueNotifier.value = downloadUploadProgress;
  }
}
