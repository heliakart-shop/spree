import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_config.dart';

class ContentScreen extends StatefulWidget {
  final String resourcePath;
  final String? initialURL;
  final bool hasNavigatedAwayFromInitial;
  final VoidCallback onClose;
  final Function(String) onNavigationChanged;

  const ContentScreen({
    super.key,
    required this.resourcePath,
    required this.initialURL,
    required this.hasNavigatedAwayFromInitial,
    required this.onClose,
    required this.onNavigationChanged,
  });

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  WebViewController? webViewController;
  bool _canGoBack = false;

  @override
  void initState() {
    super.initState();
    _enableRotation();
    _createWebView();
  }

  @override
  void dispose() {
    _resetRotation();
    super.dispose();
  }

  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _resetRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Future<void> _createWebView() async {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    webViewController = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(_setupNavigation())
      ..enableZoom(true)
      ..loadRequest(Uri.parse(widget.resourcePath));

    // Налаштування для Android - підтримка спливаючих вікон та медіа
    if (webViewController!.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (webViewController!.platform as AndroidWebViewController)
        ..setMediaPlaybackRequiresUserGesture(false)
        ..setGeolocationPermissionsPromptCallbacks(
          onShowPrompt: (request) async {
            return GeolocationPermissionsResponse(
              allow: true,
              retain: true,
            );
          },
        );
    }
  }

  NavigationDelegate _setupNavigation() {
    return NavigationDelegate(
      onPageStarted: _onPageStart,
      onPageFinished: _onPageFinish,
      onWebResourceError: _onPageError,
      onNavigationRequest: _onNavigationRequest,
    );
  }

  Future<void> _onPageStart(String url) async {
    widget.onNavigationChanged(url);
    await _checkNavigation(url);
  }

  Future<void> _checkNavigation(String pageUrl) async {
    if (_shouldBlockNavigation(pageUrl)) {
      return;
    }
  }

  bool _shouldBlockNavigation(String pageUrl) {
    return widget.hasNavigatedAwayFromInitial &&
           ("$pageUrl/" == widget.initialURL || pageUrl == widget.initialURL);
  }

  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    if (_shouldBlockNavigation(request.url)) {
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  Future<void> _onPageFinish(String pageUrl) async {
    await _handlePageComplete(pageUrl);
    _updateNavigationState();
  }

  Future<void> _handlePageComplete(String pageUrl) async {
    if (_shouldSaveUrl(pageUrl)) {
      await _saveUrl(pageUrl);
    }
  }

  bool _shouldSaveUrl(String pageUrl) {
    return pageUrl.isNotEmpty &&
           ("$pageUrl/" != widget.initialURL && pageUrl != widget.initialURL);
  }

  Future<void> _saveUrl(String pageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("SavedLink")) {
      await prefs.setString("SavedLink", pageUrl);
    }
  }

  void _onPageError(WebResourceError error) {
    if (_is404Error(error)) {
      widget.onClose();
      return;
    }

    _reloadWebView();
  }

  bool _is404Error(WebResourceError error) {
    return error.description.contains("404");
  }

  void _reloadWebView() {
    webViewController?.reload();
  }

  Future<void> _goBack() async {
    if (await _canGoBackCheck()) {
      await webViewController!.goBack();
    }
  }

  Future<bool> _canGoBackCheck() async {
    return webViewController != null &&
           await webViewController!.canGoBack();
  }

  Future<void> _updateNavigationState() async {
    final canGoBack = await _canGoBackCheck();
    if (canGoBack != _canGoBack) {
      setState(() {
        _canGoBack = canGoBack;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && await _canGoBackCheck()) {
          await _goBack();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFF1A1A1A),
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _canGoBack ? _goBack : null,
          tooltip: 'Back',
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () => webViewController?.reload(),
          tooltip: 'Refresh',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    return webViewController != null
        ? WebViewWidget(controller: webViewController!)
        : const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
  }
}
