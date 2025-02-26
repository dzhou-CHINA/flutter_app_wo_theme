// ignore_for_file: avoid_print
// flutter run -d chrome --web-browser-flag "--disable-web-security"

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_proxy/shelf_proxy.dart';

// 前端页面访问本地域名
const String localhost = 'localhost';

// 前端页面访问本地端口号
const String localhostPort = '8080';

// 目标域名
const String targetUrl = 'https://dynamicsys.sipac.gov.cn';

Future main() async {
  var server = await shelf_io.serve(
    proxyHandler(targetUrl),
    localhost,
    int.parse(localhostPort),
  );

  // 添加上跨域的Headers
  server.defaultResponseHeaders.add('Access-Control-Allow-Origin', '*');
  server.defaultResponseHeaders.add('Access-Control-Allow-Credentials', true);

  print('Serving at http://${server.address.host}:${server.port}');
}