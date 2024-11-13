import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openWeb(String? url) async {
  if(url == null){
    return;
  }
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    debugPrint('Could not launch $uri');
  }
}