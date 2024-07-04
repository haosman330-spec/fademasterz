/*
import 'dart:convert' as convert;
import 'dart:io';

import 'package:fademasterz/Dashboard/dashboard.dart';
import 'package:fademasterz/Utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class WebViewPage extends StatefulWidget {
  final String? url;
  const WebViewPage({super.key, this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewXController webViewController;
  var urls;
  var initialContent = "";

  String jsonData = "";
  String message = "";
  String status = "";

  @override
  void initState() {
    super.initState();
    urls = widget.url;
    initialContent = urls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColor.bg,
      // appBar: MyAppBar.myAppbar(
      //   centerTile: true,
      //   title: Text(
      //     AppStrings.paymentDirection,
      //     style: AppFonts.appText,
      //   ),
      //   leading: IconButton(
      //     icon: SvgPicture.asset(
      //       AppIcon.backIcon,
      //       height: 12,
      //       width: 15,
      //       //     color: Theme.of(context).appBarTheme.foregroundColor,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //       setState(() {});
      //     },
      //   ),
      // ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.2),
          ),
          child: _buildWebViewX(),
        ),
      ),
    );
  }

  Size get screenSize => MediaQuery.of(context).size;
  Widget _buildWebViewX() {
    return WebViewX(
      key: const ValueKey('webviewx'),
      initialContent: initialContent,
      initialSourceType: SourceType.url,
      // height: screenSize.height / 2,
      // width: min(screenSize.width * 0.8, 1024),
      height: screenSize.height,
      width: screenSize.width,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) => webViewController = controller,
      onPageStarted: (src) {
        debugPrint('A new page has started loading: $src\n');
        if (src.toString() ==
            "https://sandbox.web.squarecdn.com/v1/square.js") {}
        if (src.toString() ==
            "https://checkout.stripe.com/c/pay/cs_test_a1oZhGAhe6iBMJlTAJo6TICrH2juanD5QYtrfvbCvIehdMZQqiy33"
                "MOQ#fidkdWxOYHwnPyd1blp xYHZxWjA0TmBNMzVPS1dUZGE8NVxzNmxDX0JENkR1Rl9uPGFKYnEzVW90cDZ3TFFrPUxcc0tMQFJ"
                "qf2N2SX9nT0lha3V2STB3UjB2bVBkUWxHf2ozVVdLbE92cGJ9NTVgfzVkbUI8RCcpJ2N3amhWYHdz"
                "YHcnP3F3cGApJ2lkfGpwcVF8dWAnPyd2bGtiaWBabHFgaCcpJ2BrZGdpYFVpZGZgbWppYWB3dic%2FcXdwYHgl") {}
      },
      onPageFinished: (src) {
        debugPrint('The page has finished loading: $src\n');
        if (src.toString() ==
            "https://checkout.stripe.com/c/pay/cs_test_a1oZhGAhe6iBMJlTAJo6TICrH2juanD5QYtrfvbCvIehdMZQqiy33"
                "Moqgr#fidkdWxOYHwnPyd1blpxYHZxWjA0TmBNMzVPS1dUZGE8NVxzNmxDX0JENkR1Rl9uPGFKYnEzVW90cDZ3TFFrPUxcc0tMQFJ"
                "qf2N2SX9nT0lha3V2STB3UjB2bVBkUWxHf2ozVVdLbE92cGJ9NTVgfzVkbUI8RCcpJ2N3amhWYHdz"
                "YHcnP3F3cGApJ2lkfGpwcVF8dWAnPyd2bGtiaWBabHFgaCcpJ2BrZGdpYFVpZGZgbWppYWB3dic%2FcXdwYHgl") {}
        readJS();
      },
      jsContent: const {
        EmbeddedJsContent(
          js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
        ),
        EmbeddedJsContent(
          webJs:
              "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
          mobileJs:
              "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
        ),
      },
      dartCallBacks: {
        DartCallback(
          name: 'TestDartCallback',
          callBack: (msg) => Helper().showToast(
            msg.toString(),
          ),
        )
      },
      webSpecificParams: const WebSpecificParams(
        printDebugInfo: true,
      ),
      mobileSpecificParams: const MobileSpecificParams(
        androidEnableHybridComposition: true,
      ),
      navigationDelegate: (navigation) {
        debugPrint(navigation.content.sourceType.toString());
        debugPrint(
            "-------content.sourceType------->${navigation.content.sourceType.toString()}");
        debugPrint("-------content.source------->${navigation.content.source}");
        return NavigationDecision.navigate;
      },
    );
  }

  urlload() {
    return _setUrl();
  }

  void _setUrl() {
    webViewController.loadContent(
      SourceType.url.toString(),
    );
  }

  void readJS() async {
    String html = await webViewController.evalRawJavascript(
        "window.document.getElementsByTagName('body')[0].innerHTML;");
    print("html......${html}");
    print(
        "htmlData.. ${html.substring(1, html.toString().length - 1).replaceAll("\\", "")}");
    jsonData =
        "${html.substring(1, html.toString().length - 1).replaceAll("\\", "")}";
    print("object?????????????????????  ${jsonData}");

    settingsFromJson(jsonData);
    print("map...${jsonData}");
    print("{" + jsonData + "}");
    parse(html);
    print("data ${jsonData.toString()}");
  }

  Future<WebViewModel> settingsFromJson(String str) async {
    print("jsonData{"{" + jsonData + "}"}");
    var jsonData;
    if (Platform.isAndroid) {
      jsonData = convert.jsonDecode(str);
    } else {
      jsonData = convert.jsonDecode("{" + str + "}");
    }
    // var jsonData = convert.jsonDecode("{"+str+"}");
    print("jsonData ${jsonData['status']}");
    if (jsonData['status'] == true) {
      Helper().showToast(jsonData['message']);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashBoardScreen(
            selectIndex: 0,
          ),
        ),
      );
    } else {
      if (jsonData['message'] == "Payment failed done") {
        Helper().showToast(jsonData['message']);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewPage(),
            ),
            (route) => false);
      } else if (jsonData['message'] == "Payment failed") {
        Helper().showToast(jsonData['message']);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewPage(),
            ),
            (route) => false);
      } else {
        Helper().showToast(jsonData['message']);
      }
    }

    return WebViewModel.fromJson(jsonData);
  }
}

class WebViewModel {
  bool? status;
  String? message;

  WebViewModel({this.status, this.message});

  WebViewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;

    return data;
  }
}
*/

import 'dart:convert' as convert;
import 'dart:io';
import 'dart:math';

import 'package:fademasterz/Utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewXController webViewController;
  var urls;

  var initialContent = "";

  String jsondata = "";
  String message = "";
  String status = "";

  bool loader = false;

  Size get screenSize => MediaQuery.of(context).size;

  @override
  void dispose() {
    webViewController.dispose();
    super.dispose();
  }

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    urls = widget.url;
    initialContent = urls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(),
          child: Stack(
            children: [
              _buildWebViewX(),
              loader
                  ? Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                          color: AppColor.yellow),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebViewX() {
    return WebViewX(
      key: const ValueKey('webviewx'),
      initialContent: initialContent,
      initialSourceType: SourceType.url,
      height: screenSize.height,
      width: min(screenSize.width * 10, 1024),
      onWebViewCreated: (controller) => webViewController = controller,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (src) {
        loader = true;
        setState(() {});
        debugPrint('A new page has started loading: $src\n');

        if (src.toString() ==
            "https://checkout.stripe.com/c/pay/cs_test_a1MUKiG8A4VjLkxVYcDKQCcznHhaFGjDvhy4eMKwPia5PdrDay7K0LFin8#fidkdWxOYHwnPyd1blpxYHZxWjA0TmBNMzVPS1dUZGE8NVxzNmxDX0JENkR1Rl9uPGFKYnEzVW90cDZ3TFFrPUxcc0tMQFJqf2N2SX9nT0lha3V2STB3UjB2bVBkUWxHf2ozVVdLbE92cGJ9NTVgfzVkbUI8RCcpJ2N3amhWYHdzYHcnP3F3cGApJ2lkfGpwcVF8dWAnPyd2bGtiaWBabHFgaCcpJ2BrZGdpYFVpZGZgbWppYWB3dic%2FcXdwYHgl") {}
      },
      onPageFinished: (src) async {
        loader = false;
        setState(() {});
        debugPrint('The page has finished loading: $src\n');

        if (src.toString() ==
            "https://checkout.stripe.com/c/pay/cs_test_a1MUKiG8A4VjLkxVYcDKQCcznHhaFGjDvhy4eMKwPia5PdrDay7K0LFin8#fidkdWxOYHwnPyd1blpxYHZxWjA0TmBNMzVPS1dUZGE8NVxzNmxDX0JENkR1Rl9uPGFKYnEzVW90cDZ3TFFrPUxcc0tMQFJqf2N2SX9nT0lha3V2STB3UjB2bVBkUWxHf2ozVVdLbE92cGJ9NTVgfzVkbUI8RCcpJ2N3amhWYHdzYHcnP3F3cGApJ2lkfGpwcVF8dWAnPyd2bGtiaWBabHFgaCcpJ2BrZGdpYFVpZGZgbWppYWB3dic%2FcXdwYHgl") {}
        readJS();
      },
      jsContent: const {
        EmbeddedJsContent(
          js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
        ),
        EmbeddedJsContent(
          webJs:
              "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
          mobileJs:
              "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
        ),
      },
      dartCallBacks: {
        DartCallback(
          name: 'TestDartCallback',
          callBack: (msg) => showSnackBar(msg.toString(), context),
        )
      },
      webSpecificParams: const WebSpecificParams(
        printDebugInfo: true,
      ),
      mobileSpecificParams: const MobileSpecificParams(
        androidEnableHybridComposition: true,
      ),
      navigationDelegate: (navigation) {
        // return NavigationDecision.prevent;
        debugPrint(navigation.content.sourceType.toString());
        return NavigationDecision.navigate;
      },
    );
  }

  urlload() {
    return _setUrl();
  }

  void _setUrl() {
    webViewController.loadContent(
      SourceType.url.toString(),
    );
  }

  void readJS() async {
    String html = await webViewController.evalRawJavascript(
        "window.document.getElementsByTagName('body')[0].innerHTML;");
    debugPrint('>>>html>>>>>>>>>>>$html<<<<<<<<<<<<<<');
    debugPrint(
        '>>>>>>html data..>>>>>>>>${html.substring(1, html.toString().length - 1).replaceAll("\\", "")}<<<<<<<<<<<<<<');

    jsondata =
        html.substring(1, html.toString().length - 1).replaceAll("\\", "");

    debugPrint('>>>>>object?????>>>>>>>>>$jsondata<<<<<<<<<<<<<<');
    settingsFromJson(jsondata);
    debugPrint('>>>>>>>map>>>>>>>$jsondata<<<<<<<<<<<<<<');

    // parse(html);
    debugPrint('>>>>data>>>>>>>>>>${jsondata.toString()}<<<<<<<<<<<<<<');
  }

  Future<WebViewModel> settingsFromJson(String str) async {
    debugPrint('>>>>>>>>fnjgjkh>>>>>>$jsondata<<<<<<<<<<<<<<');
    var jsonData;
    if (Platform.isAndroid) {
      jsonData = convert.jsonDecode(str);
    } else {
      jsonData = convert.jsonDecode("{$str}");
    }
    // var jsonData = convert.jsonDecode("{"+str+"}");

    debugPrint('>>>>>>>jsonData>>>>>>>${jsonData['status']}<<<<<<<<<<<<<<');
    // Helper().showToast(jsonData['message']);
    Navigator.of(context).pop(jsonData['status']);

    /*
    if (jsonData['status'] == true) {
      Helper().showToast(jsonData['message']);
      showDialog(
        //   barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                17,
              ),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppIcon.paymentIcon),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Text(
                      textAlign: TextAlign.center,
                      AppStrings.paymentSuccessful,
                      style: AppFonts.blackFont.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      textAlign: TextAlign.center,
                      AppStrings.successfulDone,
                      style: AppFonts.blackFont
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  MyAppButton(
                    onPress: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const DashBoardScreen(selectIndex: 1),
                        ),
                      );
                    },
                    height: 48,
                    title: AppStrings.viewBookingSummary,
                    style: AppFonts.blackFont
                        .copyWith(fontWeight: FontWeight.w500),
                    radius: 39,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyAppButton(
                    onPress: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashBoardScreen(
                            selectIndex: 0,
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    height: 48,
                    title: AppStrings.backToHome,
                    style: AppFonts.blackFont
                        .copyWith(fontWeight: FontWeight.w500),
                    radius: 39,
                    color: const Color(0xffFFFBF0),
                  ),
                ],
              ),
            ),
          );
        },
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const DashBoardScreen(
      //       selectIndex: 0,
      //     ),
      //   ),
      // );
    } else {
      if (jsonData['message'] == "Your booking has been failed.") {
        Helper().showToast(jsonData['message']);
        Navigator.of(context).pop();
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => BookingSummaryScreen(
        //
        //       ),
        //     ),
        //     (route) => false);
      }
      // else if(jsonData['message']=="Payment failed"){
      //   ToastShowAll.showToastMethod(jsonData['message']);
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>DashboardScreen(indexFrom: 0, openScreenFrom: '',)), (route) => false);
      //
      // }

      else {
        Helper().showToast(jsonData['message']);
      }
    }

     */

    return WebViewModel.fromJson(jsonData);
  }
}

class WebViewModel {
  bool? status;
  String? message;

  WebViewModel({this.status, this.message});

  WebViewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;

    return data;
  }
}

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(seconds: 1),
      ),
    );
}
