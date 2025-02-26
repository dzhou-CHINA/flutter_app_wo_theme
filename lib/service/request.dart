// ignore_for_file: avoid_print, constant_identifier_names
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_demo_app/common/constant.dart';
import 'package:flutter_demo_app/service/api_constant.dart';

// 枚举类型 - 请求类型
enum HttpType { HttpTypeGet, HttpTypePost }

class MyResponse {
  final int? code;
  final int? time;
  final String? msg;
  final bool? success;
  final dynamic data;

  MyResponse({this.code, this.time, this.msg, this.success, this.data});
}

class SSJRequestManager {
  // 单例方法
  static Dio? _dioInstance;
  static Dio getSSJRequestManager() {
    var options = BaseOptions(
        connectTimeout: const Duration(seconds: 15000),
        receiveTimeout: const Duration(seconds: 15000),
        responseType: ResponseType.json,
        receiveDataWhenStatusError: true,
        baseUrl: MyAPI.baseUrl,
        headers: {
          "Access-Control-Allow-Origin": true,
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": SpUtil.getString('token'),
          "TENANT-ID": MyContants.tenantId,
          "APP-ID": MyContants.appId,
        });
    _dioInstance ??= Dio(options);
    
    return _dioInstance!;
  }

  // 对外抛出方法 - get请求
  static Future<MyResponse> get(String requestUrl) async {
    return await _sendHttpRequest(HttpType.HttpTypeGet, requestUrl);
  }

  // 对外抛出方法 - post请求
  static Future<MyResponse> post(
    String requestUrl, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    dynamic headers,
  }) async {
    dynamic res = await _sendHttpRequest(
      HttpType.HttpTypePost,
      requestUrl,
      queryParameters: queryParameters,
      data: data,
      headers: headers,
    );
    print(res);
    return res;
  }

  // 私有方法 - 处理get请求、post请求
  static Future _sendHttpRequest(
    HttpType type,
    String requestUrl, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    dynamic headers,
  }) async {
    try {
      Dio dio = getSSJRequestManager();
      dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) =>  {
          print(111),
          print(response)
        },
        onError: (error, handler) => {
          print(22),
          print(error),
          handler.next(error)
        },
      ),
    );

      if (headers != null) {
        dio.options.headers.addAll(Map<String, String>.from(headers));
      }

      switch (type) {
        case HttpType.HttpTypeGet:
          return await dio.get(requestUrl);
        case HttpType.HttpTypePost:
          return await dio.post(requestUrl, data: data);
        default:
          throw Exception('报错了：请求只支持get和post');
      }
    } on DioException catch (e) {
      print("报错:$e");
    }
  }

  // 对外抛出方法 - 下载文件
  static void downloadFile(String downLoadUrl, String savePath,
      void Function(bool result) func) async {
    DateTime timeStart = DateTime.now();
    print('开始下载～当前时间：$timeStart');
    try {
      Dio dio = getSSJRequestManager();
      dio.download(downLoadUrl, savePath,
          onReceiveProgress: (int count, int total) {
        String progressValue = (count / total * 100).toStringAsFixed(1);
        print('当前下载进度:$progressValue%');
      }).whenComplete(() {
        DateTime timeEnd = DateTime.now();
        //用时多少秒
        int secondUse = timeEnd.difference(timeStart).inSeconds;
        print('下载文件耗时$secondUse秒');
        func(true);
      });
    } catch (e) {
      print("downloadFile报错：$e");
    }
  }
}
