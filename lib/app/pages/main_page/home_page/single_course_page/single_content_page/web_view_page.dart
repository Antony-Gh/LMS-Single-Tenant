import 'package:esoi/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:esoi/app/services/user_service/user_service.dart';
import 'package:esoi/common/common.dart';
import 'package:esoi/common/components.dart';
import 'package:esoi/common/data/app_data.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../../common/data/app_language.dart';
import '../../../../../../common/utils/constants.dart';
import '../../../../../../locator.dart';

class WebViewPage extends StatefulWidget {
  static const String pageName = '/web-view';
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    cacheEnabled: true,
    javaScriptEnabled: true,
    useHybridComposition: false,
    sharedCookiesEnabled: true,
    useShouldOverrideUrlLoading: true,
    useOnLoadResource: false,
  );

  CookieManager cookieManager = CookieManager.instance();

  String? url;
  String? title;

  bool isShow = false;

  bool isSendTokenInHeader = true;
  LoadRequestMethod method = LoadRequestMethod.post;

  String token = '';
  String csrfToken = '';

  bool isPageLoaded = false;

  // ─── CSS + MutationObserver injection ────────────────────────────────────────
  static const String _hideHeadersScript = """
    (function() {
      var styleId = 'injected-css-hider';
      var style = document.getElementById(styleId);
      if (!style) {
        style = document.createElement('style');
        style.id = styleId;
        (document.head || document.documentElement).appendChild(style);
      }
      style.innerHTML = `
        header, footer,
        .header, .footer,
        .main-header, .top-navbar,
        .header-search, .search-inline,
        .navbar, .menu-bar,
        .logo, .cart-icon, .search-box,
        .header-bottom, .header-middle, .header-top,
        nav, .nav, .navigation,
        .site-header, .page-header,
        .sticky-header, .fixed-header,
        [class*="header"], [class*="navbar"],
        [id*="header"], [id*="navbar"] {
          display: none !important;
          visibility: hidden !important;
          height: 0 !important;
          max-height: 0 !important;
          overflow: hidden !important;
          pointer-events: none !important;
        }
        body, html {
          padding-top: 0 !important;
          margin-top: 0 !important;
        }
      `;

      // MutationObserver to catch dynamically added/modified elements
      if (!window.__headerObserverAttached) {
        window.__headerObserverAttached = true;

        var hideSelectors = [
          'header', 'footer', '.header', '.footer',
          '.main-header', '.top-navbar', 'nav', '.nav',
          '.navbar', '.site-header', '.page-header',
          '.sticky-header', '.fixed-header',
          '[class*="header"]', '[class*="navbar"]',
          '[id*="header"]', '[id*="navbar"]'
        ];

        function hideElements() {
          hideSelectors.forEach(function(selector) {
            try {
              document.querySelectorAll(selector).forEach(function(el) {
                el.style.setProperty('display',        'none',   'important');
                el.style.setProperty('visibility',     'hidden', 'important');
                el.style.setProperty('height',         '0',      'important');
                el.style.setProperty('max-height',     '0',      'important');
                el.style.setProperty('overflow',       'hidden', 'important');
                el.style.setProperty('pointer-events', 'none',   'important');
              });
            } catch(e) {}
          });
          document.body && document.body.style.setProperty('padding-top', '0', 'important');
          document.body && document.body.style.setProperty('margin-top',  '0', 'important');
        }

        hideElements();

        var observer = new MutationObserver(function(mutations) {
          hideElements();
        });

        observer.observe(document.documentElement, {
          childList: true,
          subtree: true,
          attributes: true,
          attributeFilter: ['style', 'class']
        });
      }
    })();
  """;
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      url = (ModalRoute.of(context)!.settings.arguments as List)[0];
      title = (ModalRoute.of(context)!.settings.arguments as List)[1] ?? '';

      try {
        isSendTokenInHeader =
            (ModalRoute.of(context)!.settings.arguments as List)[2] ?? true;
      } catch (_) {}

      try {
        method = (ModalRoute.of(context)!.settings.arguments as List)[3] ??
            LoadRequestMethod.post;
      } catch (_) {}

      token = await AppData.getAccessToken();

      isShow = true;
      setState(() {});

      await [
        Permission.camera,
        Permission.microphone,
      ].request();

      setState(() {});
    });
  }

  load() async {
    if (isSendTokenInHeader) {
      if (csrfToken.isEmpty) {
        csrfToken = await locator<UserService>().csrfToken();
      }
    }

    var header = {
      if (isSendTokenInHeader) ...{
        "Authorization": "Bearer $token",
        'X-CSRF-TOKEN': csrfToken,
      },
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'x-api-key': Constants.apiKey,
      'x-locale': locator<AppLanguage>().currentLanguage.toLowerCase(),
      'User-Agent': getCustomUserAgent(),
    };

    if (!(url?.startsWith('http') ?? false)) {
      await webViewController?.loadData(
        data: url ?? '',
        baseUrl: null,
        historyUrl: null,
      );
    } else {
      await webViewController?.loadUrl(
        urlRequest: URLRequest(
          method: method == LoadRequestMethod.post ? "POST" : "GET",
          url: WebUri(url ?? ''),
          headers: header,
        ),
      );
    }
  }

  String getCustomUserAgent() {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1";
    }
    return "Mozilla/5.0 (Linux; Android 12; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Mobile Safari/537.36";
  }

  @override
  Widget build(BuildContext context) {
    return directionality(
      child: OrientationBuilder(builder: (context, orientation) {
        return Scaffold(
          appBar: appbar(title: title ?? ''),
          body: isShow
              ? Stack(
                  children: [
                    InAppWebView(
                      onJsBeforeUnload:
                          (nAppWebViewController, jsBeforeUnloadRequest) async {
                        return JsBeforeUnloadResponse();
                      },
                      key: webViewKey,
                      initialSettings: settings,
                      onReceivedHttpError: (inAppWebViewController,
                          webResourceRequest, webResourceResponse) {},
                      onWebViewCreated: (controller) async {
                        webViewController = controller;

                        load();
                      },
                      onPermissionRequest: (controller, request) async {
                        return PermissionResponse(
                            resources: request.resources,
                            action: PermissionResponseAction.GRANT);
                      },
                      onLoadResource:
                          (inAppWebViewController, loadedResource) {},
                      shouldOverrideUrlLoading:
                          (controller, navigationAction) async {
                        // If the request is a POST (like a form submission), let it proceed directly
                        // to avoid losing the request body and causing a 419 error on iOS.
                        if (navigationAction.request.method != 'GET') {
                          return NavigationActionPolicy.ALLOW;
                        }

                        if (isSendTokenInHeader &&
                            (navigationAction.request.url
                                    ?.toString()
                                    .startsWith(Constants.dommain) ??
                                false)) {
                          if (!(navigationAction.request.headers
                                  ?.containsKey('Authorization') ??
                              false)) {
                            var header = {
                              "Authorization": "Bearer $token",
                              'X-CSRF-TOKEN': csrfToken,
                              "Content-Type": "application/json",
                              'Accept': 'application/json',
                              'x-api-key': Constants.apiKey,
                              'x-locale': locator<AppLanguage>()
                                  .currentLanguage
                                  .toLowerCase(),
                              'User-Agent': getCustomUserAgent(),
                            };

                            if (navigationAction.request.headers != null) {
                              navigationAction.request.headers?.addAll(header);
                            } else {
                              navigationAction.request.headers = header;
                            }

                            controller.loadUrl(
                                urlRequest: navigationAction.request);
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        // ── Hide headers/footers after page finishes loading ──
                        await controller.evaluateJavascript(
                            source: _hideHeadersScript);
                        // ── Show the page now that everything is ready ──
                        if (!isPageLoaded) {
                          setState(() => isPageLoaded = true);
                        }
                      },
                      onLoadStart: (controller, url_) {
                        // ── Inject CSS as early as possible ──
                        controller.evaluateJavascript(
                            source: _hideHeadersScript);

                        if (url_?.uriValue != null) {
                          if (url_?.uriValue
                                  .toString()
                                  .startsWith(Constants.scheme) ??
                              false) {
                            backRoute(arguments: true);
                          }
                        }
                      },
                      onReceivedError: (controller, request, error) {},
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          setState(() {});
                        }
                      },
                      onUpdateVisitedHistory: (controller, uri, isReload) {},
                      onConsoleMessage: (controller, consoleMessage) {},
                      onNavigationResponse: (cntr, n) async {
                        return NavigationResponseAction.ALLOW;
                      },
                    ),
                    // ── Loading overlay — hides the webview until onLoadStop ──
                    if (!isPageLoaded)
                      Positioned.fill(
                        child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: loading(),
                        ),
                      ),
                  ],
                )
              : loading(),
        );
      }),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    webViewController?.dispose();
    super.dispose();
  }
}
