import 'dart:io';
import 'package:flutter_finey/model/carteira.dart';
import 'package:dio/dio.dart';
import 'package:flutter_finey/util/hmacSha512.dart';

class GetAccountInfo {
  Future<Carteira> postAccountInfo() async {
    Dio _dio = Dio();
    _dio.options.baseUrl = "https://www.mercadobitcoin.net";
    var path = "/tapi/v3/";

    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    String queryParams = '/tapi/v3/?tapi_method=get_account_info&tapi_nonce=' +
        timeStamp.toString();
    String secret =
        '017130a8e5c400c13cb4785d07a64c3833bfad0b6971827bf17a4be0c78ba857';
    String signature = new HmacSha512().hmacSha512(queryParams, secret);

    Response response = await _dio.post(path,
        data: {
          "tapi_method": 'get_account_info',
          "tapi_nonce": timeStamp.toString()
        },
        options: Options(
            contentType: "application/x-www-form-urlencoded",
            headers: {
              'TAPI-ID': '58ba4016e6fd04a279540b4b406b79bb',
              'TAPI-MAC': signature
            }));

    if (response.statusCode == 200) {
      Carteira carteira = Carteira();
      carteira.brl = response.data["response_data"]["balance"]["brl"]["total"];
      carteira.btc = response.data["response_data"]["balance"]["btc"]["total"];

      return carteira;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
