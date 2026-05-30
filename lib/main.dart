import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LekhokMeApp());
}

class LekhokMeApp extends StatelessWidget {
  const LekhokMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lekhok.me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green, // আপনার ওয়েবসাইটের থিম অনুযায়ী পরিবর্তন করতে পারেন
        useMaterial3: true,
      ),
      home: const MainWebViewScreen(),
    );
  }
}

class MainWebViewScreen extends StatefulWidget {
  const MainWebViewScreen({super.key});

  @override
  State<MainWebViewScreen> createState() => _MainWebViewScreenState();
}

class _MainWebViewScreenState extends State<MainWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void college() {
    super.initState();
    
    // ওয়েবভিউ কন্ট্রোলার সেটআপ
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // জাভাস্ক্রিপ্ট এনাবল করা হলো (ক্যালকুলেটর বা উইজেটের জন্য জরুরি)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // পেজ লোড হওয়ার প্রোগ্রেস ট্র্যাক করা যাবে এখানে
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            // কোনো এরর হলে হ্যান্ডেল করার জায়গা
          },
        ),
      )
      ..loadRequest(Uri.parse('https://lekhok.me')); // আপনার ওয়েবসাইটের লিঙ্ক
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ব্যাক বাটন চাপলে অ্যাপ সরাসরি বন্ধ না হয়ে ওয়েবসাইটের পেজ পেছনে যাবে
      body: WillPopScope(
        onWillPop: () async {
          if (await _controller.canGoBack()) {
            await _controller.goBack();
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              // পেজ লোড হওয়ার সময় একটি লোডিং ইন্ডিকেটর দেখাবে
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
