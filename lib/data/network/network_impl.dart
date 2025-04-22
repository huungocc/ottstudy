import 'package:dio/dio.dart';
import '../../util/constants.dart';
import '../../util/navigator.dart';
import '../../util/shared_preference.dart';
import 'api_response.dart';
import 'network.dart';
import 'requests/base_request.dart';

class Network {
  static final instanceNetworkAuth = "instanceNetworkAuth";
  late final String? baseUrl;
  final int? timeOut;
  static BaseOptions options = BaseOptions(
      connectTimeout: Constants.TIMEOUT_API, receiveTimeout: Constants.TIMEOUT_API, baseUrl: ApiConstant.apiHost);
  static Dio _dio = Dio(options);

  Network._internal({this.baseUrl, this.timeOut}) {
    _dio.options.baseUrl = baseUrl ?? ApiConstant.apiHost;
    _dio.options.connectTimeout = timeOut ?? Constants.TIMEOUT_API;
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestHeader: true));
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions myOption, RequestInterceptorHandler handler) async {
      String token = await SharedPreferenceUtil.getToken();
      if (token.isNotEmpty) {
        myOption.headers["Authorization"] = "Bearer " + token;
      }
      return handler.next(myOption);
    }));
  }

  Network({
    this.baseUrl,
    this.timeOut,
  }) {
    Network._internal(baseUrl: baseUrl ?? ApiConstant.apiHost, timeOut: timeOut ?? Constants.TIMEOUT_API);
  }

  Future<ApiResponse> get({required String url, Map<String, dynamic>? params}) async {
    try {
      Response response = await _dio.get(
        url,
        queryParameters: await BaseParamRequest.request(params),
        options: Options(responseType: ResponseType.json),
      );
      return getApiResponse(response);
    } on DioError catch (e) {
      //handle error
      print("DioError: ${e.toString()}");
      return getError(e);
    }
  }

  Future<ApiResponse> post(
      {required String url,
        dynamic body,
        Map<String, dynamic> params = const {},
        String contentType = Headers.jsonContentType,
        int? timeOut, bool isOriginData = false}) async {
    try {
      if (timeOut != null) {
        _dio.options.connectTimeout = timeOut;
      }
      Response response = await _dio.post(
        url,
        data: isOriginData ? body : await BaseParamRequest.request(body),
        queryParameters: params,
        options: Options(responseType: ResponseType.json, contentType: contentType),
      );
      return getApiResponse(response);
    } catch (e) {
      print("===post =====${e}");
      return getError(e as DioError);
    }
  }

  ApiResponse getError(DioError e) {
    if (e.response?.statusCode == 401) {
      handleTokenExpired();
    }
    switch (e.type) {
      case DioErrorType.cancel:
      case DioErrorType.connectTimeout:
      case DioErrorType.receiveTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.other:
        return ApiResponse.error(
          "error_api.connect",
        );
      default:
        return ApiResponse.error(e.response?.data["ErrMsg"],
            data: e.response?.data, code: e.response?.statusCode);
    }
  }

  ApiResponse getApiResponse(Response response) {
    return ApiResponse.success(
      data: response.data["Data"],
      code: response.statusCode,
      // message: response.statusMessage,
      message: response.data is Map<String, dynamic> ? response.data["Message"] ?? response.statusMessage : response.statusMessage,
      status: response.data is Map<String, dynamic> ? response.data["Status"] : null,
      // errMessage: response.data is Map<String, dynamic> ? response.data["ErrMsg"] : null,
      // errCode: response.data is Map<String, dynamic> ? response.data["ErrCode"] : null,
    );
  }

  void handleTokenExpired() async {
    NavigationService.instance.showDialogTokenExpired();
    await SharedPreferenceUtil.clearData();
  }

  getDataReplace(data) {
    if (data is String) {
      return data.replaceAll("loi:", "").replaceAll(":loi", "").trim();
    }
    return data;
  }

  getDataMessage(data, message) {
    if (data is String) {
      return data.replaceAll("loi:", "").replaceAll(":loi", "").trim();
    }

    return message;
  }
}
