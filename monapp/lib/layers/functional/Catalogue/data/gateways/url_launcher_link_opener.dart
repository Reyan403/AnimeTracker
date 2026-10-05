import 'package:url_launcher/url_launcher.dart';

import '../../domain/gateways/link_opener_gateway.dart';

class UrlLauncherLinkOpener implements LinkOpenerGateway {
  const UrlLauncherLinkOpener();

  @override
  Future<bool> open(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
