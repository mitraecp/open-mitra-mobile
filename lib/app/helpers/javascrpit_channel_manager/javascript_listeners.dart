import 'package:open_mitra_mobile/app/helpers/javascrpit_channel_manager/1.0/java_1_dot_0_listeners.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JavaScriptChannelManager {
  setup1Dot0ListenerChannels(WebViewController webViewController) {
    // NOTE: Calls com 1.0
    JavaFront1Dot0Listeners().setupListenerChannels(webViewController);
  }
}