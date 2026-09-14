import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;

void registerIframeViews({
  required String termsUrl,
  required String privacyUrl,
  required String termsViewType,
  required String privacyViewType,
  required void Function() onTermsLoaded,
  required void Function() onPrivacyLoaded,
}) {
  ui_web.platformViewRegistry.registerViewFactory(termsViewType, (int viewId) {
    final iframe = web.HTMLIFrameElement()
      ..src = termsUrl
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';

    iframe.onLoad.listen((_) {
      onTermsLoaded();
    });
    return iframe;
  });

  ui_web.platformViewRegistry.registerViewFactory(privacyViewType, (int viewId) {
    final iframe = web.HTMLIFrameElement()
      ..src = privacyUrl
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';

    iframe.onLoad.listen((_) {
      onPrivacyLoaded();
    });
    return iframe;
  });
}
