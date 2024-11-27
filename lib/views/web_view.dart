import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  PullToRefreshController? refreshController;
  InAppWebViewController? webViewController;
  // ignore: prefer_typing_uninitialized_variables
  late var url;
  var initialUrl = 'https://www.google.com';
  final TextEditingController urlController = TextEditingController();
  double progress = 0;
  final FocusNode urlFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    refreshController = PullToRefreshController(
      onRefresh: () async {
        await webViewController!.reload();
      },
      // ignore: deprecated_member_use
      options: PullToRefreshOptions(
        color: Colors.white,
        backgroundColor: Colors.black,
      ),
    );
    urlFocusNode.addListener(() {
      if (urlFocusNode.hasFocus) {
        // Select all text when the TextField gains focus
        urlController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: urlController.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    urlFocusNode.dispose(); // Dispose the FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          onPressed: () async {
            if (await webViewController!.canGoBack()) {
              webViewController!.goBack();
            }
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            focusNode: urlFocusNode,
            controller: urlController,
            style: const TextStyle(color: Colors.white),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: "e.g. www.google.com",
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, color: Colors.white),
            ),
            onSubmitted: (value) {
              url = WebUri(value);
              if (url.scheme.isEmpty) {
                url = WebUri("${initialUrl}/search?q=$value");
              }
              webViewController!.loadUrl(urlRequest: URLRequest(url: url));
            },
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              webViewController?.reload();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: InAppWebView(
        onLoadStart: (controller, url) {
          var u = url.toString();
          setState(() {
            urlController.text = u;
          });
        },
        onLoadStop: (controller, url) {
          refreshController!.endRefreshing();
        },
        pullToRefreshController: refreshController,
        onWebViewCreated: (controller) => webViewController = controller,
        initialUrlRequest: URLRequest(url: WebUri(initialUrl)),
      ),
    );
  }
}
